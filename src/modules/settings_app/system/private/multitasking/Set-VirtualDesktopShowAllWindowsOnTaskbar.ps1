#=================================================================================================================
#                       System > Multitasking > Desktops > Show All Open Windows (Taskbar)
#=================================================================================================================

<#
.SYNTAX
    Set-VirtualDesktopShowAllWindowsOnTaskbar
        [-Value] {AllDesktops | CurrentDesktop}
        [<CommonParameters>]
#>

function Set-VirtualDesktopShowAllWindowsOnTaskbar
{
    <#
    .EXAMPLE
        PS> Set-VirtualDesktopShowAllWindowsOnTaskbar -Value 'CurrentDesktop'
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
        $ShowAllWindowsOnTaskbar = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'VirtualDesktopTaskbarFilter'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Multitasking - On The Taskbar, Show All The Open Windows' to '$Value' ..."
        Set-RegistryEntry -InputObject $ShowAllWindowsOnTaskbar
    }
}
