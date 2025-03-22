#=================================================================================================================
#           Personnalization > Lock Screen > Get Fun Facts, Tips, Tricks, And More On Your Lock Screen
#=================================================================================================================

# If disabled, Windows Spotlight will be unset.

<#
.SYNTAX
    Set-LockScreenGetFunFactsTipsTricks
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-LockScreenGetFunFactsTipsTricks
{
    <#
    .EXAMPLE
        PS> Set-LockScreenGetFunFactsTipsTricks -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $LockScreenGetFunFactsTipsTricks = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
            Entries = @(
                @{
                    Name  = 'RotatingLockScreenEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'RotatingLockScreenOverlayEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SubscribedContent-338387Enabled'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Lock Screen - Get Fun Facts, Tips, Tricks, And More On Your Lock Screen' to '$State' ..."
        Set-RegistryEntry -InputObject $LockScreenGetFunFactsTipsTricks
    }
}
