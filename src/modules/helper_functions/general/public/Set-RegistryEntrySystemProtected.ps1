#=================================================================================================================
#                              Helper Function - Set Registry Entry System Protected
#=================================================================================================================

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
            `$Global:ProvidedUserName = '$((Get-LoggedOnUserInfo)['UserName'])'
            Import-Module -Name '$(Split-Path -Path $PSScriptRoot)'
            `$InputRegistryData = Get-Content -Raw -Path '$TempJsonFilePath' | ConvertFrom-Json -AsHashtable
            `$InputRegistryData | Set-RegistryEntry 4> '$VerboseLogPath' 2> '$ErrorLogPath'
        "

        $InputObject | ConvertTo-Json -Depth 100 | Out-File -FilePath $TempJsonFilePath

        Invoke-CommandAsSystem -Command $Command -Verbose:$false

        # let log files the time to be generated (e.g. slow drive)
        $MaxRetries = 30
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
