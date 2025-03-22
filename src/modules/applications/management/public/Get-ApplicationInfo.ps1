#=================================================================================================================
#                                                Application Info
#=================================================================================================================

<#
.SYNTAX
    Get-ApplicationInfo
        [-Name] <string>
        [<CommonParameters>]
#>

function Get-ApplicationInfo
{
    <#
    .DESCRIPTION
        Doesn't handle UWP apps (e.g. Modern Notepad, Windows Photos, ...).

    .EXAMPLE
        PS> Get-ApplicationInfo -Name '*vlc*'
        DisplayName     : VLC media player
        UninstallString : "C:\Program Files\VideoLAN\VLC\uninstall.exe"
        InstallLocation : C:\Program Files\VideoLAN\VLC
        DisplayIcon     : C:\Program Files\VideoLAN\VLC\vlc.exe
        DisplayVersion  : X.X.X
        [...]
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name
    )

    process
    {
        $UserSID = Get-LoggedOnUserSID
        $UninstallRegPath = 'Microsoft\Windows\CurrentVersion\Uninstall'
        $RegistryUninstallPath = @(
            "Registry::HKEY_USERS\$UserSID\Software\$UninstallRegPath"
            "Registry::HKEY_USERS\$UserSID\Software\Wow6432Node\$UninstallRegPath"
            "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\$UninstallRegPath"
            "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\$UninstallRegPath"
        )

        $AppInfo = $RegistryUninstallPath |
            Get-ChildItem -ErrorAction 'SilentlyContinue' |
            Get-ItemProperty |
            Where-Object -Property 'DisplayName' -Like -Value $Name |
            Select-Object -Property '*' -Exclude 'PS*'
        $AppInfo
    }
}
