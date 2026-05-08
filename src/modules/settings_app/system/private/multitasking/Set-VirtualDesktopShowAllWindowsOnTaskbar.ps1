#=================================================================================================================
#                       System > Multitasking > Desktops > Show All Open Windows (Taskbar)
#=================================================================================================================

<#
.SYNTAX
    Set-VirtualDesktopShowAllWindowsOnTaskbar
        [-Scope] {AllDesktops | CurrentDesktop}
        [<CommonParameters>]
#>

function Set-VirtualDesktopShowAllWindowsOnTaskbar
{
    <#
    .EXAMPLE
        PS> Set-VirtualDesktopShowAllWindowsOnTaskbar -Scope 'CurrentDesktop'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [WindowVisibilty] $Scope
    )

    process
    {
        # on all desktops: 0 | only on the desktop I'm using: 1 (default)
        $ShowAllWindowsOnTaskbar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'VirtualDesktopTaskbarFilter'
                    Value = [int]$Scope
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Multitasking - On The Taskbar, Show All The Open Windows' to '$Scope' ..."
        Set-RegistryEntry -InputObject $ShowAllWindowsOnTaskbar
    }
}
