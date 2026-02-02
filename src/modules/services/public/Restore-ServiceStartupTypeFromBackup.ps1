#=================================================================================================================
#                                    Restore Service Startup Type From Backup
#=================================================================================================================

<#
.SYNTAX
    Restore-ServiceStartupTypeFromBackup
        [-FilePath] <string>
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
        [ValidateScript(
            { Test-Path -Path $_ -PathType 'Leaf'},
            ErrorMessage = 'The specified file does not exist or is not accessible.')]
        [string] $FilePath
    )

    process
    {
        $ServicesBackupFile = "$(Get-LogPath)\windows_default_services_winmize.json"
        $ServicesBackup = Get-Content -Raw -Path $ServicesBackupFile | ConvertFrom-Json
        $ServicesBackup | Set-ServiceStartupType
    }
}
