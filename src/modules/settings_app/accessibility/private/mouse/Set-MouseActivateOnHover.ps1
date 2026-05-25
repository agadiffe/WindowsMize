#=================================================================================================================
#                                    Accessibility > Mouse > Activate On Hover
#=================================================================================================================

<#
.SYNTAX
    Set-MouseActivateOnHover
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseActivateOnHover
{
    <#
    .EXAMPLE
        PS> Set-MouseActivateOnHover -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 1st byte, 1st bit\ on: 1 | off: 0 (default)

        $SettingRegPath = 'Control Panel\Desktop'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'UserPreferencesMask'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 0 -BitPos 1 -State ($State -eq 'Enabled')

        $ActivateOnHover = @{
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

        Write-Verbose -Message "Setting 'Mouse - Activate (Window) On Hover' to '$State' ..."
        Set-RegistryEntry -InputObject $ActivateOnHover
    }
}
