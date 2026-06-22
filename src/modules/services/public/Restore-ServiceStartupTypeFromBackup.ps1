#=================================================================================================================
#                                    Restore Service Startup Type From Backup
#=================================================================================================================

<#
.SYNTAX
    Restore-ServiceStartupTypeFromBackup
        [[-FilePath] <string>]
        [<CommonParameters>]
#>

function Restore-ServiceStartupTypeFromBackup
{
    <#
    .EXAMPLE
        PS> Restore-ServiceStartupTypeFromBackup

    .EXAMPLE
        PS> Restore-ServiceStartupTypeFromBackup -FilePath "X:\Backup\windows_services_default.json"
    #>

    [CmdletBinding()]
    param
    (
        [string] $FilePath = "$(Get-LogPath)\windows_default_services_winmize.json"
    )

    process
    {
        if (-not (Test-Path -Path $FilePath -PathType 'Leaf'))
        {
            Write-Error -Message 'The specified file does not exist or is not accessible.'
            return
        }

        $ServicesBackup = Get-Content -Raw -Path $FilePath | ConvertFrom-Json
        $ServicesBackup | Set-ServiceStartupType
    }
}
