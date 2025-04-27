#=================================================================================================================
#                                     Accessibility > Keyboard > Sticky Keys
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardStickyKeys
        [-State {Disabled | Enabled}]
        [-KeyboardShorcut {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardStickyKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardStickyKeys -State 'Disabled' -KeyboardShorcut 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $State,

        [state] $KeyboardShorcut
    )

    process
    {
        $StickyKeysFlags = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\StickyKeys'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $null
                    Type  = 'String'
                }
            )
        }
        $SettingRegPath = $StickyKeysFlags.Path
        $SettingRegEntry = $StickyKeysFlags.Entries[0].Name
        $StickyKeysMsg = 'Keyboard Sticky Keys'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # 1st bit\ on: 1 | off: 0 (default)
                $SKF_STICKYKEYSON = 0x00000001

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $SKF_STICKYKEYSON -State ($State -eq 'Enabled')

                $StickyKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$StickyKeysMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $StickyKeysFlags
            }
            'KeyboardShorcut'
            {
                # 3rd bit\ on: 1 (default) | off: 0
                $SKF_HOTKEYACTIVE = 0x00000004

                $CurrentFlags = Get-LoggedOnUserItemPropertyValue -Path $SettingRegPath -Name $SettingRegEntry
                $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $SKF_HOTKEYACTIVE -State ($KeyboardShorcut -eq 'Enabled')

                $StickyKeysFlags.Entries[0].Value = $NewFlags

                Write-Verbose -Message "Setting '$StickyKeysMsg - Keyboard Shorcut' to '$KeyboardShorcut' ..."
                Set-RegistryEntry -InputObject $StickyKeysFlags
            }
        }
    }
}
