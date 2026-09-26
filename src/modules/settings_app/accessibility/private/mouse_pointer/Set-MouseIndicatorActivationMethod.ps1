#=================================================================================================================
#                       Accessibility > Mouse Pointer > Mouse indicator > Activation Method
#=================================================================================================================

<#
.SYNTAX
    Set-MouseIndicatorActivationMethod
        [-Method] {SingleCtrlKeyPress | DoubleCtrlKeyPress}
        [<CommonParameters>]
#>

function Set-MouseIndicatorActivationMethod
{
    <#
    .EXAMPLE
        PS> Set-MouseIndicatorActivationMethod -Method 'SingleCtrlKeyPress'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MouseIndicatorActivationMethod] $Method
    )

    process
    {
        # 3rd bit\ SingleCtrlKeyPress: 0 (default) | DoubleCtrlKeyPress: 1

        $Flag = 0x00000004
        $SettingRegPath = 'Control Panel\Cursors'
        $SettingValue = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'FindMyMousePersistent'
        $SettingValue = Get-UpdatedIntegerBitFlag -Flags $SettingValue -BitFlag $Flag -State ($Method -eq 'DoubleCtrlKeyPress')

        $MouseIndicatorActivationMethod = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Cursors'
            Entries = @(
                @{
                    Name  = 'FindMyMousePersistent'
                    Value = $SettingValue
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse Pointer - Mouse Indicator (On Ctrl Key): Activation Method' to '$Method' ..."
        Set-RegistryEntry -InputObject $MouseIndicatorActivationMethod
    }
}
