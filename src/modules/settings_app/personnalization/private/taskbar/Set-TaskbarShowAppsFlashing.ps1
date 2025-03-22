#=================================================================================================================
#                 Personnalization > Taskbar > Taskbar Behaviors > Show Flashing On Taskbar Apps
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowAppsFlashing
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarShowAppsFlashing
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowAppsFlashing -State 'Enabled'
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
        $TaskbarAppsFlashing = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarFlashing'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Flashing On Taskbar Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarAppsFlashing
    }
}
