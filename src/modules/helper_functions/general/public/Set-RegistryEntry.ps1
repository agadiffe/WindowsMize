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
        $TempJsonFilePath = "$EnvTemp\TempJsonDataFile.json"
        $VerboseLogPath = "$EnvTemp\Set-RegistryEntrySystemProtected_verbose.log"
        $ErrorLogPath = "$EnvTemp\Set-RegistryEntrySystemProtected_error.log"

        # Get-LoggedOnUserInfo fails if executed as SYSTEM. Use $Global:ProvidedUserName as workaround.
        $Command = "
            `$Global:ProvidedUserName = '$((Get-LoggedOnUserInfo).UserName)'
            Import-Module -Name '$(Split-Path -Path $PSScriptRoot)'
            `$InputRegistryData = Get-Content -Raw -Path '$TempJsonFilePath' | ConvertFrom-Json -AsHashtable
            `$InputRegistryData | Set-RegistryEntry 4> '$VerboseLogPath' 2> '$ErrorLogPath'
        "

        $InputObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $TempJsonFilePath

        Invoke-CommandAsSystem -Command $Command -Verbose:$false

        # let log files the time to be generated (e.g. slow drive)
        $MaxRetries = 20
        $RetryCount = 0
        while ((-not (Test-Path -Path $VerboseLogPath) -or -not (Test-Path -Path $ErrorLogPath)) -and $RetryCount -lt $MaxRetries)
        {
            Start-Sleep -Seconds 0.1
            $RetryCount++
        }

        if ($RetryCount -ne $MaxRetries)
        {
            # display output to the interactive Terminal
            (Get-Content -Path $VerboseLogPath).ForEach({ Write-Verbose -Message $_ })
            (Get-Content -Path $ErrorLogPath).ForEach({ Write-Error -Message $_ })
        }

        Remove-Item -Path $TempJsonFilePath, $VerboseLogPath, $ErrorLogPath -ErrorAction 'SilentlyContinue'
    }
}
