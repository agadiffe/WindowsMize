#=================================================================================================================
#                                                Application Info
#=================================================================================================================

<#
.SYNTAX
    Get-ApplicationInfo
        [-Name] <string>
        [-System] <switch>
        [<CommonParameters>]
#>

function Get-ApplicationInfo
{
    <#
    .DESCRIPTION
        Doesn't handle UWP apps (e.g. Modern Notepad, Windows Photos, ...).
        Use -System parameter to search only for system-wide installed software.

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
        [string] $Name,

        [switch] $System
    )

    process
    {
        $RegistryUninstallPath = @(
            'Registry::HKEY_LOCAL_MACHINE\SOFTWARE'
            'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node'
        )

        if (-not $System)
        {
            $UserSid = (Get-LoggedOnUserInfo).Sid
            $RegistryUninstallPath += @(
                "Registry::HKEY_USERS\$UserSid\Software"
                "Registry::HKEY_USERS\$UserSid\Software\Wow6432Node"
            )
        }

        $RegistryUninstallPath = $RegistryUninstallPath.ForEach({ "$_\Microsoft\Windows\CurrentVersion\Uninstall" })

        $AppInfo = $RegistryUninstallPath |
            Get-ChildItem -ErrorAction 'SilentlyContinue' |
            Get-ItemProperty |
            Where-Object -Property 'DisplayName' -Like -Value $Name |
            Select-Object -Property '*' -Exclude 'PS*'
        $AppInfo
    }
}
