#=================================================================================================================
#                                 Accessibility > Mouse Pointer > Mouse indicator
#=================================================================================================================

<#
.SYNTAX
    Set-MousePointerIndicatorOnCtrl
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MousePointerIndicatorOnCtrl
{
    <#
    .EXAMPLE
        PS> Set-MousePointerIndicatorOnCtrl -State 'Disabled'
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

        $MousePointerIndicatorOnCtrl = @{
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

        Write-Verbose -Message "Setting 'Mouse Pointer - Mouse indicator (On Ctrl Key)' to '$State' ..."
        Set-RegistryEntry -InputObject $MousePointerIndicatorOnCtrl
    }
}
