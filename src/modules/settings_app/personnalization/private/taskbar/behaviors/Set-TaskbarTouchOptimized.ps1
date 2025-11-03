#=================================================================================================================
#            Personnalization > Taskbar > Taskbar Behaviors > Optimize Taskbar For Touch Interactions
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarTouchOptimized
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarTouchOptimized
{
    <#
    .EXAMPLE
        PS> Set-TaskbarTouchOptimized -State 'Disabled'
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
        $TaskbarTouchOptimized = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ExpandableTaskbar'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Optimize Taskbar For Touch Interactions' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarTouchOptimized
    }
}
