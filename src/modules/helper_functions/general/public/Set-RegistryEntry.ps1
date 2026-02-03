#=================================================================================================================
#                                      Helper Function - Set Registry Entry
#=================================================================================================================

class RegistryEntry
{
    [bool] $SkipKey
    [bool] $RemoveKey
    [string] $Hive
    [string] $Path
    [RegistryKeyEntry[]] $Entries
}

class RegistryKeyEntry
{
    [bool] $RemoveEntry
    [string] $Name
    [string] $Value
    [string] $Type
}

<#
.SYNTAX
    Set-RegistryEntry
        [-InputObject] <RegistryEntry>
        [<CommonParameters>]
#>

function Set-RegistryEntry
{
    <#
    .EXAMPLE
        PS> $Foo = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\FooApp\Config'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $true
                        Name  = 'Autostart'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        PS> Set-RegistryEntry -InputObject $Foo

    .EXAMPLE
        PS> $Bar = '[
                {
                    "SkipKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\BarApp\\Config",
                    "Entries" : []
                },
                {
                    "RemoveKey" : true,
                    "Hive"    : "HKEY_LOCAL_MACHINE",
                    "Path"    : "SOFTWARE\\BarApp\\Config",
                    "Entries" : []
                }
            ]' | ConvertFrom-Json
        PS> $Bar | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [RegistryEntry] $InputObject
    )

    begin
    {
        $UserSid = (Get-LoggedOnUserInfo).Sid
    }

    process
    {
        if ($InputObject.SkipKey)
        {
            return
        }

        $RegistryPath = ($InputObject.Hive + '\' + $InputObject.Path) -replace '\\+', '\'
        $RegistryPathOriginal = $RegistryPath

        if ($RegistryPath -match '^(?:HKCU|HKEY_CURRENT_USER)')
        {
            $RegistryPath = $RegistryPath -ireplace '^(?:HKCU|HKEY_CURRENT_USER)', "HKEY_USERS\$UserSid"
        }

        $RegistryPath = "Registry::$RegistryPath"
        if ($InputObject.RemoveKey)
        {
            Write-Verbose -Message "  remove: $RegistryPathOriginal"
            Remove-Item -Recurse -Path $RegistryPath -ErrorAction 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "      key: $RegistryPathOriginal"

            if (-not (Test-Path -Path $RegistryPath))
            {
                New-Item -Path $RegistryPath -Force | Out-Null
            }

            foreach ($Entry in $InputObject.Entries)
            {
                if ($Entry.RemoveEntry)
                {
                    Write-Verbose -Message "   remove: '$($Entry.Name)'"
                    Remove-ItemProperty -Path $RegistryPath -Name $Entry.Name -ErrorAction 'SilentlyContinue'
                }
                else
                {
                    $RegistryEntryData = @{
                        Path  = $RegistryPath
                        Name  = $Entry.Name
                        Value = $Entry.Value
                        Type  = $Entry.Type
                    }
                    if ($Entry.Type -eq 'Binary')
                    {
                        $RegistryEntryData.Value = $Entry.Value -eq '' ? $null : $Entry.Value -split '\s+'
                    }
                    Write-Verbose -Message "      set: '$($Entry.Name)' to '$($Entry.Value)' ($($Entry.Type))"
                    Set-ItemProperty @RegistryEntryData | Out-Null
                }
            }
        }
    }
}


<#
.SYNTAX
    Set-RegistryEntrySystemProtected
        [-InputObject] <RegistryEntry>
        [<CommonParameters>]
#>

function Set-RegistryEntrySystemProtected
{
    <#
    .EXAMPLE
        PS> $Foo = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\FooApp\Config'
                Entries = @(
                    @{
                        Name  = 'Enabled'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        PS> Set-RegistryEntrySystemProtected -InputObject $Foo
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [RegistryEntry] $InputObject
    )

    process
    {
        $EnvTemp = [System.IO.Path]::GetTempPath()
        $ScriptContentFilePath = "$EnvTemp\TempScriptContent.ps1"
        $TempJsonFilePath = "$EnvTemp\TempJsonDataFile.json"
        $VerboseLogPath = "$EnvTemp\Set-RegistryEntrySystemProtected_verbose.log"
        $ErrorLogPath = "$EnvTemp\Set-RegistryEntrySystemProtected_error.log"

        # Get-LoggedOnUserInfo fails if executed as SYSTEM. Use $Global:ProvidedUserName as workaround.
        $ScriptContent = "
            `$Global:ProvidedUserName = '$((Get-LoggedOnUserInfo).UserName)'
            Import-Module -Name '$(Split-Path -Path $PSScriptRoot)'
            `$InputRegistryData = Get-Content -Raw -Path '$TempJsonFilePath' | ConvertFrom-Json -AsHashtable
            `$InputRegistryData | Set-RegistryEntry 4> '$VerboseLogPath' 2> '$ErrorLogPath'
        "

        $InputObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $TempJsonFilePath
        $ScriptContent | Out-File -FilePath $ScriptContentFilePath

        $TempTaskName = "TempScript46-$(New-Guid)"
        # at task creation/modification
        $TaskTrigger = Get-CimClass -ClassName 'MSFT_TaskRegistrationTrigger' -Namespace 'Root/Microsoft/Windows/TaskScheduler' -Verbose:$false
        New-ScheduledTaskScript -FilePath $ScriptContentFilePath -TaskName $TempTaskName -Trigger $TaskTrigger -Verbose:$false | Out-Null

        while ((Get-ScheduledTask -TaskPath '\' -TaskName $TempTaskName).State -eq 'Running')
        {
            Start-Sleep -Seconds 0.25
        }

        # let the task fully terminate
        Start-Sleep -Seconds 0.25

        # let log files the time to be generated
        $MaxRetries = 10
        $RetryCount = 0
        while ((-not (Test-Path -Path $VerboseLogPath) -or -not (Test-Path -Path $ErrorLogPath)) -and $RetryCount -lt $MaxRetries)
        {
            Start-Sleep -Seconds 0.25
            $RetryCount++
        }

        if ($RetryCount -ne $MaxRetries)
        {
            # display output to the interactive Terminal
            (Get-Content -Path $VerboseLogPath).ForEach({ Write-Verbose -Message $_ })
            (Get-Content -Path $ErrorLogPath).ForEach({ Write-Error -Message $_ })
        }

        Unregister-ScheduledTask -TaskPath '\' -TaskName $TempTaskName -Confirm:$false
        Remove-Item -Path $ScriptContentFilePath, $TempJsonFilePath, $VerboseLogPath, $ErrorLogPath -ErrorAction 'SilentlyContinue'
    }
}
