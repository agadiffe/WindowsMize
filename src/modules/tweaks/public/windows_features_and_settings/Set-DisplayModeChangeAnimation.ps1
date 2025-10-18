#=================================================================================================================
#                                          Display Mode Change Animation
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayModeChangeAnimation
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DisplayModeChangeAnimation
{
    <#
    .EXAMPLE
        PS> Set-DisplayModeChangeAnimation -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $DisplayModeChangeAnimation = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\Dwm'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Disabled'
                    Name  = 'ForceDisableModeChangeAnimation'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display Mode Change Animation' to '$State' ..."
        Set-RegistryEntry -InputObject $DisplayModeChangeAnimation
    }
}
