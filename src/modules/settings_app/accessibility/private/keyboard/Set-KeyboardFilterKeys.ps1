#=================================================================================================================
#                                     Accessibility > Keyboard > Filter Keys
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardFilterKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShorcut {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardFilterKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardFilterKeys -State 'Disabled' -KeyboardShorcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShorcut
    )

    process
    {
        $FilterKeysFlags = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\Keyboard Response'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $null
                    Type  = 'String'
                }
            )
        }
        $SettingRegPath = $FilterKeysFlags.Path
        $SettingRegEntry = $FilterKeysFlags.Entries[0].Name
        $FilterKeysMsg = 'Keyboard Filter Keys'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 1st bit\ on: 1 | off: 0 (default)
                $FKF_FILTERKEYSON = 0x00000001

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $FKF_FILTERKEYSON -State ($State -eq 'Enabled')

                $FilterKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$FilterKeysMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $FilterKeysFlags
            }
            'KeyboardShorcut'
            {
                # 3rd bit\ on: 1 (default) | off: 0
                $FKF_HOTKEYACTIVE = 0x00000004

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $FKF_HOTKEYACTIVE -State ($KeyboardShorcut -eq 'Enabled')

                $FilterKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$FilterKeysMsg - Keyboard Shorcut' to '$KeyboardShorcut' ..."
                Set-RegistryEntry -InputObject $FilterKeysFlags
            }
        }
    }
}
