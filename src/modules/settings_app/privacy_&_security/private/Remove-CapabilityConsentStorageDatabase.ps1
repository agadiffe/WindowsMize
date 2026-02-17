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
            Stop-Service -Name `$ServicesToStop -Force -ErrorAction 'SilentlyContinue'

            `$MaxRetries = 30
            `$RetryCount = 0
            while ((Test-Path -Path '$CamDatabaseFilePath') -and `$RetryCount -lt `$MaxRetries)
            {
                Remove-Item -Path '$CamDatabaseFilePath' -ErrorAction 'SilentlyContinue'
                Start-Sleep -Seconds 0.1
                `$RetryCount++
            }
        "

        Write-Verbose -Message "Removing 'Capability Consent Storage' Database ($CamDatabaseFilePath) ..."
        Invoke-CommandAsSystem -Command $Command -Verbose:$false
    }
}
