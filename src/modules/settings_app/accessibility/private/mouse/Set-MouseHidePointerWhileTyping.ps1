#=================================================================================================================
#                                Accessibility > Mouse > Hide Pointer While Typing
#=================================================================================================================

<#
.SYNTAX
    Set-MouseHidePointerWhileTyping
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseHidePointerWhileTyping
{
    <#
    .EXAMPLE
        PS> Set-MouseHidePointerWhileTyping -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 3rd byte, 1st bit\ on: 1 (default) | off: 0

        $SettingRegPath = 'Control Panel\Desktop'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'UserPreferencesMask'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 2 -BitPos 1 -State ($State -eq 'Enabled')

        $HidePointerWhileTyping = @{
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

        Write-Verbose -Message "Setting 'Mouse - Hide Pointer While Typing' to '$State' ..."
        Set-RegistryEntry -InputObject $HidePointerWhileTyping
    }
}
