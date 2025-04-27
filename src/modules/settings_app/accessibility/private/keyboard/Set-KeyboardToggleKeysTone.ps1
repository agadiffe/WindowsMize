#=================================================================================================================
#                                     Accessibility > Keyboard > Toggle Keys
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardToggleKeysTone
        [-State {Disabled | Enabled}]
        [-KeyboardShorcut {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardToggleKeysTone
{
    <#
    .EXAMPLE
        PS> Set-KeyboardToggleKeysTone -State 'Disabled' -KeyboardShorcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShorcut
    )

    process
    {
        $ToggleKeysFlags = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\ToggleKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $null
                    Type  = 'String'
                }
            )
        }
        $SettingRegPath = $ToggleKeysFlags.Path
        $SettingRegEntry = $ToggleKeysFlags.Entries[0].Name
        $ToggleKeysMsg = 'Keyboard Toggle Keys Tone'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 1st bit\ on: 1 | off: 0 (default)
                $TKF_TOGGLEKEYSON = 0x00000001

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $TKF_TOGGLEKEYSON -State ($State -eq 'Enabled')

                $ToggleKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$ToggleKeysMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $ToggleKeysFlags
            }
            'KeyboardShorcut'
            {
                # 3rd bit\ on: 1 (default) | off: 0
                $TKF_HOTKEYACTIVE = 0x00000004

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $TKF_HOTKEYACTIVE -State ($KeyboardShorcut -eq 'Enabled')

                $ToggleKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$ToggleKeysMsg - Keyboard Shorcut' to '$KeyboardShorcut' ..."
                Set-RegistryEntry -InputObject $ToggleKeysFlags
            }
        }
    }
}
