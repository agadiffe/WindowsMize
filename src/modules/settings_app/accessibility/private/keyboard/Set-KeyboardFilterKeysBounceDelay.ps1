#=================================================================================================================
#               Accessibility > Keyboard > Filter Keys > Ignore Unintended Keystrokes (Bounce Keys)
#=================================================================================================================

# Wait before accepting repeated keystrokes

<#
.SYNTAX
    Set-KeyboardFilterKeysBounceDelay
        [-Seconds] <double>
        [<CommonParameters>]
#>

function Set-KeyboardFilterKeysBounceDelay
{
    <#
    .EXAMPLE
        PS> Set-KeyboardFilterKeysBounceDelay -Seconds 0
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

        # off: 0 (default) | on: 0.3, 0.5 (default if on), 0.7, 1, 1.5, 2
        $FilterKeysBounceDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Osk'
            Entries = @(
                @{
                    Name  = 'BounceTime'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        $LastFilterKeysBounceDelay = @{
            SkipKey = $IsDisabled
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Osk'
            Entries = @(
                @{
                    Name  = 'LastBounceTime'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        $SettingMsg = $IsDisabled ? 'Disabled' : "$Seconds seconds"
        Write-Verbose -Message "Setting 'Keyboard Filter Keys - Ignore Unintended Keystrokes (Bounce Keys) - Delay' to '$SettingMsg' ..."
        $FilterKeysBounceDelay, $LastFilterKeysBounceDelay | Set-RegistryEntry
    }
}
