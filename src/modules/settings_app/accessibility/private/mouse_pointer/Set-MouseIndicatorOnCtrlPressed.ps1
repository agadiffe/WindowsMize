#=================================================================================================================
#                                 Accessibility > Mouse Pointer > Mouse Indicator
#=================================================================================================================

<#
.SYNTAX
    Set-MouseIndicatorOnCtrlPressed
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseIndicatorOnCtrlPressed
{
    <#
    .EXAMPLE
        PS> Set-MouseIndicatorOnCtrlPressed -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 2nd byte, 7th bit\ on: 1 (default) | off: 0

        $SettingRegPath = 'Control Panel\Desktop'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'UserPreferencesMask'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 1 -BitPos 7 -State ($State -eq 'Enabled')

        $MouseIndicator = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'UserPreferencesMask'
                    Value = $SettingBytes
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse Pointer - Mouse Indicator (On Ctrl Key Pressed)' to '$State' ..."
        Set-RegistryEntry -InputObject $MouseIndicator
    }
}
