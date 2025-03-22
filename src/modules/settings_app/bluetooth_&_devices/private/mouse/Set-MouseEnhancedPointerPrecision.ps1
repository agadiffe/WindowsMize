#=================================================================================================================
#                             Bluetooth & Devices > Mouse > Enhance Pointer Precision
#=================================================================================================================

<#
.SYNTAX
    Set-MouseEnhancedPointerPrecision
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseEnhancedPointerPrecision
{
    <#
    .EXAMPLE
        PS> Set-MouseEnhancedPointerPrecision -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: 1 6 10 (default) | off: 0 0 0
        $MouseEnhancedPointerPrecision = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'MouseSpeed'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'String'
                }
                @{
                    Name  = 'MouseThreshold1'
                    Value = $IsEnabled ? '6' : '0'
                    Type  = 'String'
                }
                @{
                    Name  = 'MouseThreshold2'
                    Value = $IsEnabled ? '10' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Enhanced Pointer Precision' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseEnhancedPointerPrecision
    }
}
