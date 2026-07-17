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

        # Give the log files time to be created (e.g. slow drive). This shouldn't normally be necessary.
        $TimeoutSeconds = 3
        $Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

        while (-not (Test-Path -Path $VerboseLogPath) -or -not (Test-Path -Path $ErrorLogPath))
        {
            if ($Stopwatch.Elapsed.TotalSeconds -ge $TimeoutSeconds)
            {
                Write-Warning '  Timed out waiting for log files.'
                break
            }

            Start-Sleep -Seconds 0.1
        }

        if (Test-Path -Path $VerboseLogPath)
        {
            Get-Content -Path $VerboseLogPath | ForEach-Object -Process { Write-Verbose -Message $_ }
        }

        if (Test-Path -Path $ErrorLogPath)
        {
            Get-Content -Path $ErrorLogPath | ForEach-Object -Process { Write-Error -Message $_ }
        }

        Remove-Item -Path $TempJsonFilePath, $VerboseLogPath, $ErrorLogPath -ErrorAction 'SilentlyContinue'
    }
}
