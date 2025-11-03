#=================================================================================================================
#                  Personnalization > Taskbar > Taskbar Behaviors > Show Badges On Taskbar Apps
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowAppsBadges
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarShowAppsBadges
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowAppsBadges -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $TaskbarAppsBadges = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarBadges'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Badges On Taskbar Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarAppsBadges
    }
}
