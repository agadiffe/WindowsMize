#=================================================================================================================
#                                   Remove Capability Consent Storage Database
#=================================================================================================================

<#
.SYNTAX
    Remove-CapabilityConsentStorageDatabase [<CommonParameters>]
#>

function Remove-CapabilityConsentStorageDatabase
{
    <#
    .EXAMPLE
        PS> Remove-CapabilityConsentStorageDatabase
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $CamDatabaseFilePath = "$env:ProgramData\Microsoft\Windows\CapabilityAccessManager\CapabilityConsentStorage.db*"
        $Command = "
            `$ServicesToStop = @(
                'lfsvc'  # Geolocation Service
                'camsvc' # Capability Access Manager Service
            )
            `$Services = Stop-Service -Name `$ServicesToStop -Force -PassThru -ErrorAction 'SilentlyContinue'
            `$Services.WaitForStatus('Stopped', [TimeSpan]::FromSeconds(3))

            `$TimeoutSeconds = 3
            `$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()

            while ((Test-Path -Path '$CamDatabaseFilePath') -and `$Stopwatch.Elapsed.TotalSeconds -lt `$TimeoutSeconds)
            {
                Remove-Item -Path '$CamDatabaseFilePath' -ErrorAction 'SilentlyContinue'
                Start-Sleep -Seconds 0.1
            }
        "

        Write-Verbose -Message "Removing 'Capability Consent Storage' Database ($CamDatabaseFilePath) ..."
        Invoke-CommandAsSystem -Command $Command -Verbose:$false
    }
}
