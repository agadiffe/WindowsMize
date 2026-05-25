#=================================================================================================================
#                   Accessibility > Mouse > Move Window To Top When Activating For Mouse Hover
#=================================================================================================================

<#
.SYNTAX
    Set-MouseActivateOnHoverRaiseWindow
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseActivateOnHoverRaiseWindow
{
    <#
    .EXAMPLE
        PS> Set-MouseActivateOnHoverRaiseWindow -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 1st byte, 7th bit\ on: 1 | off: 0 (default)

        $SettingRegPath = 'Control Panel\Desktop'
        $SettingBytes = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name 'UserPreferencesMask'
        Set-ByteBitFlag -Bytes $SettingBytes -ByteNum 0 -BitPos 7 -State ($State -eq 'Enabled')

        $ActivateOnHoverRaiseWindow = @{
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

        Write-Verbose -Message "Setting 'Mouse - Move Window To Top When Activating For Mouse Hover' to '$State' ..."
        Set-RegistryEntry -InputObject $ActivateOnHoverRaiseWindow
    }
}
