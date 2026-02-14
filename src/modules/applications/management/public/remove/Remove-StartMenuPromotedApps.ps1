#=================================================================================================================
#                                       Start Menu Promoted/Sponsored Apps
#=================================================================================================================

# Windows 11 only (there is probably a similar registry key for Windows 10).

# Remove unwanted pinned shortcuts from the Start Menu (e.g. Disney+, Netflix, TikTok, ...).
# It does only remove the quick installer shorcuts that install the app if we click on it.
#   i.e. It will not remove an already installed app (e.g. manufacturer app).

<#
.SYNTAX
    Remove-StartMenuPromotedApps [<CommonParameters>]
#>

function Remove-StartMenuPromotedApps
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Removing ''Start Menu Promoted Apps (e.g. Spotify, LinkedIn)'' ...'

        $StartMenuPromotedApps = @{
            RemoveKey = $true
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\$de${*}$$windows.data.placeholdertilecollection'
            Entries = @()
        }

        Set-RegistryEntry -InputObject $StartMenuPromotedApps
        Stop-Process -Name 'StartMenuExperienceHost' -Force -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.3 # delay to let the process respawn
    }
}
