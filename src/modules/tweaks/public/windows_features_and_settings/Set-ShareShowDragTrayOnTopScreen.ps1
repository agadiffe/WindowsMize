#=================================================================================================================
#                                    Share - Show Drag Tray To The Top Screen
#=================================================================================================================

<#
.SYNTAX
    Set-ShareShowDragTrayOnTopScreen
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ShareShowDragTrayOnTopScreen
{
    <#
    .EXAMPLE
        PS> Set-ShareShowDragTrayOnTopScreen -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete key (default) | off: 1 0
        $ShareShowDragTrayOnTopScreen = @{
            RemoveKey = $State -eq 'Enabled'
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\ControlSet001\Control\FeatureManagement\Overrides\14\3895955085'
            Entries = @(
                @{
                    Name  = 'EnabledState'
                    Value = '1'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'EnabledStateOptions'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Share - Show Drag Tray To The Top Screen' to '$State' ..."
        Set-RegistryEntry -InputObject $ShareShowDragTrayOnTopScreen
    }
}
