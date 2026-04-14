#=================================================================================================================
#                                  Bluetooth & Devices > Mouse > Haptic Signals
#=================================================================================================================

<#
.SYNTAX
    Set-MouseHapticFeedback
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseHapticFeedback
{
    <#
    .EXAMPLE
        PS> Set-MouseHapticFeedback -State 'Enabled'
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
        $MouseHapticFeedback = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Windows\EnhancedPenSupport'
            Entries = @(
                @{
                    Name  = 'MouseFeedbackEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Haptic Signals' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseHapticFeedback
    }
}
