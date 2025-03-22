#=================================================================================================================
#                       System > Multitasking > Desktops > Show All Open Windows (Alt+Tab)
#=================================================================================================================

<#
.SYNTAX
    Set-VirtualDesktopShowAllWindowsOnAltTab
        [-Value] {AllDesktops | CurrentDesktop}
        [<CommonParameters>]
#>

function Set-VirtualDesktopShowAllWindowsOnAltTab
{
    <#
    .EXAMPLE
        PS> Set-VirtualDesktopShowAllWindowsOnAltTab -Value 'CurrentDesktop'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [WindowVisibilty] $Value
    )

    process
    {
        # on all desktops: 0 | only on the desktop I'm using: 1 (default)
        $ShowAllWindowsOnAltTab = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'VirtualDesktopAltTabFilter'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Multitasking - Show All Open Windows When I Press Alt+Tab' to '$Value' ..."
        Set-RegistryEntry -InputObject $ShowAllWindowsOnAltTab
    }
}
