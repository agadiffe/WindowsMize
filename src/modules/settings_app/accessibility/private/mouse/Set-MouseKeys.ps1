#=================================================================================================================
#                                       Accessibility > Mouse > Mouse Keys
#=================================================================================================================

<#
.SYNTAX
    Set-MouseKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShorcut {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MouseKeys
{
    <#
    .EXAMPLE
        PS> Set-MouseKeys -State 'Disabled' -KeyboardShorcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShorcut
    )

    process
    {
        $MouseKeysFlags = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\MouseKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $null
                    Type  = 'String'
                }
            )
        }
        $SettingRegPath = $MouseKeysFlags.Path
        $SettingRegEntry = $MouseKeysFlags.Entries[0].Name
        $MouseKeysMsg = 'Mouse Keys'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 1st bit\ on: 1 | off: 0 (default)
                $MKF_MOUSEKEYSON = 0x00000001

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $MKF_MOUSEKEYSON -State ($State -eq 'Enabled')

                $MouseKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$MouseKeysMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $MouseKeysFlags
            }
            'KeyboardShorcut'
            {
                # 3rd bit\ on: 1 (default) | off: 0
                $MKF_HOTKEYACTIVE = 0x00000004

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $MKF_HOTKEYACTIVE -State ($KeyboardShorcut -eq 'Enabled')

                $MouseKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$MouseKeysMsg - Keyboard Shorcut' to '$KeyboardShorcut' ..."
                Set-RegistryEntry -InputObject $MouseKeysFlags
            }
        }
    }
}
