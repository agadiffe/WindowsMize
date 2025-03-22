#=================================================================================================================
#          Personnalization > Taskbar Behaviors > Show Hover Cards For Inactive And Pinned Taskbar Apps
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowJumplistOnHover
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarShowJumplistOnHover
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowJumplistOnHover -State 'Disabled'
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
        $TaskbarJumplistOnHover = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'JumplistOnHover'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Hover Cards For Inactive And Pinned Taskbar Apps' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarJumplistOnHover
    }
}
