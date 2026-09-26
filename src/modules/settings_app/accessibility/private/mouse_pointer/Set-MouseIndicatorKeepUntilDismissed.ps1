#=================================================================================================================
#       Accessibility > Mouse Pointer > Mouse indicator > Keep The Indicator On Until I Click Or Press Esc
#=================================================================================================================

<#
.SYNTAX
    Set-MouseIndicatorKeepUntilDismissed
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseIndicatorKeepUntilDismissed
{
    <#
    .EXAMPLE
        PS> Set-MouseIndicatorKeepUntilDismissed -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 1st bit\ on: 1 | off: 0 (default)

        $Flag = 0x00000001
        $SettingRegPath = 'Control Panel\Cursors'
        $SettingValue = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'FindMyMousePersistent'
        $SettingValue = Get-UpdatedIntegerBitFlag -Flags $SettingValue -BitFlag $Flag -State ($State -eq 'Enabled')

        $MouseIndicatorKeepUntilDismissed = @{
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

        $MouseIndicatorsMsg = 'Mouse indicator (On Ctrl Key): Keep The Indicator On Until I Click Or Press Esc'

        Write-Verbose -Message "Setting 'Mouse Pointer - $MouseIndicatorsMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseIndicatorKeepUntilDismissed
    }
}
