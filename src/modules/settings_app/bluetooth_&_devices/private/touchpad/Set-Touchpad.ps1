#=================================================================================================================
#                                         Bluetooth & Devices > Touchpad
#=================================================================================================================

<#
.SYNTAX
    Set-Touchpad
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-Touchpad
{
    <#
    .EXAMPLE
        PS> Set-Touchpad -State 'Enabled'
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
        $Touchpad = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\PrecisionTouchPad\Status'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Touchpad' to '$State' ..."
        Set-RegistryEntry -InputObject $Touchpad
    }
}
