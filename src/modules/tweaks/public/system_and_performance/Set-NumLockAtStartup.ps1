#=================================================================================================================
#                                               NumLock At Startup
#=================================================================================================================

<#
.SYNTAX
    Set-NumLockAtStartup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NumLockAtStartup
{
    <#
    .EXAMPLE
        PS> Set-NumLockAtStartup -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '2' : '0'

        # on: 2147483650 (INT_MAX + 3) (or 2) | off: 2147483648 (INT_MAX + 1) (or 0) (default)
        $NumLockAtStartup = @(
            @{
                Hive    = 'HKEY_USERS'
                Path    = '.DEFAULT\Control Panel\Keyboard'
                Entries = @(
                    @{
                        Name  = 'InitialKeyboardIndicators'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Control Panel\Keyboard'
                Entries = @(
                    @{
                        Name  = 'InitialKeyboardIndicators'
                        Value = $Value
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'NumLock At Startup' to '$State' ..."
        $NumLockAtStartup | Set-RegistryEntry
    }
}
