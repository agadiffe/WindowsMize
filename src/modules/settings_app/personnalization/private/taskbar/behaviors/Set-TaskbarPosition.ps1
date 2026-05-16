#=================================================================================================================
#                        Personnalization > Taskbar > Taskbar Behaviors > Taskbar Position
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarPosition
        [-Mode] {Left | Top | Right | Bottom}
        [<CommonParameters>]
#>

function Set-TaskbarPosition
{
    <#
    .EXAMPLE
        PS> Set-TaskbarPosition -Mode 'Bottom'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarPosition] $Mode
    )

    process
    {
        # left: 0 | top: 1 | right: 2 | bottom: 3 (default)
        $TaskbarPosition = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarLocation'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Position' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TaskbarPosition
    }
}
