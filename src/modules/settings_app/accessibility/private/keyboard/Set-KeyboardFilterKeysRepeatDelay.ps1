#=================================================================================================================
#                Accessibility > Keyboard > Filter Keys > Ignore Repeated Keystrokes (Repeat Keys)
#=================================================================================================================

# Wait before accepting the first repeated keystroke
# Wait before accepting subsequent repeated keystrokes

<#
.SYNTAX
    Set-KeyboardFilterKeysRepeatDelay
        [-Seconds] <double>
        [<CommonParameters>]
#>

function Set-KeyboardFilterKeysRepeatDelay
{
    <#
    .EXAMPLE
        PS> Set-KeyboardFilterKeysRepeatDelay -Seconds 0
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(0, 0.3, 0.5, 0.7, 1, 1.5, 2)]
        [double] $Seconds
    )

    process
    {
        $IsDisabled = $Seconds -eq 0
        $Value = $Seconds * 1000

        # off: 0 (default) | on: 0.3 (default if on), 0.5, 0.7, 1, 1.5, 2
        $FilterKeysRepeatDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Osk'
            Entries = @(
                @{
                    Name  = 'FirstRepeatDelay'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'NextRepeatDelay'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        $LastFilterKeysRepeatDelay = @{
            SkipKey = $IsDisabled
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Osk'
            Entries = @(
                @{
                    Name  = 'LastFirstRepeatDelay'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'LastNextRepeatDelay'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        $SettingMsg = $IsDisabled ? 'Disabled' : "$Seconds seconds"
        Write-Verbose -Message "Setting 'Keyboard Filter Keys - Ignore Repeated Keystrokes (Repeat Keys) - Delay' to '$SettingMsg' ..."
        $FilterKeysRepeatDelay, $LastFilterKeysRepeatDelay | Set-RegistryEntry
    }
}
