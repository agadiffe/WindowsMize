#=================================================================================================================
#                  Accessibility > Keyboard > Filter Keys > Ignore Quick Keystrokes (Slow Keys)
#=================================================================================================================

# Wait before accepting a keystroke

<#
.SYNTAX
    Set-KeyboardFilterKeysQuickDelay
        [-Seconds] <double>
        [<CommonParameters>]
#>

function Set-KeyboardFilterKeysQuickDelay
{
    <#
    .EXAMPLE
        PS> Set-KeyboardFilterKeysQuickDelay -Seconds 0
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(0, 0.3, 0.5, 0.7, 1, 1.4, 2, 5, 10, 20)]
        [double] $Seconds
    )

    process
    {
        $IsDisabled = $Seconds -eq 0
        $Value = $Seconds * 1000

        # off: 0 (default) | on: 0.3 (default if on), 0.5, 0.7, 1, 1.4, 2, 5, 10, 20
        $FilterKeysQuickDelay = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Osk'
                Entries = @(
                    @{
                        Name  = 'KeystrokeDelay'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                SkipKey = $IsDisabled
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Osk'
                Entries = @(
                    @{
                        Name  = 'LastKeystrokeDelay'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        $SettingMsg = $IsDisabled ? 'Disabled' : "$Seconds seconds"
        Write-Verbose -Message "Setting 'Keyboard Filter Keys - Ignore Quick Keystrokes (Slow Keys) - Delay' to '$SettingMsg' ..."
        $FilterKeysQuickDelay | Set-RegistryEntry
    }
}
