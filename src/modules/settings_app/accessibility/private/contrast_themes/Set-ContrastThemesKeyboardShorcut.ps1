#=================================================================================================================
#                     Accessibility > Contrast Themes > Keyboard Shorcut For Contrast Themes
#=================================================================================================================

# control panel (icons view) > ease of access center > make the computer easier to see
# (control.exe /name Microsoft.EaseOfAccessCenter /page pageEasierToSee)
#   turn on or off High Contrast when left ALT + left SHIFT + PRINT SCREEN is pressed

<#
.SYNTAX
    Set-ContrastThemesKeyboardShorcut
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContrastThemesKeyboardShorcut
{
    <#
    .EXAMPLE
        PS> Set-ContrastThemesKeyboardShorcut -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # 3rd bit\ on: 1 (default) | off: 0
        $HCF_HOTKEYACTIVE = 0x00000004

        $SettingRegPath = 'Registry::HKEY_CURRENT_USER\Control Panel\Accessibility\HighContrast'
        $CurrentFlags = Get-ItemPropertyValue -Path $SettingRegPath -Name 'Flags'
        $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag $HCF_HOTKEYACTIVE -State ($State -eq 'Enabled')

        $ContrastThemesKeyboardShorcut = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\HighContrast'
            Entries = @(
                @{
                    Name  = 'Flags'
                    Value = $NewFlags
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Contrast Themes - Keyboard Shorcut' to '$State' ..."
        Set-RegistryEntry -InputObject $ContrastThemesKeyboardShorcut
    }
}
