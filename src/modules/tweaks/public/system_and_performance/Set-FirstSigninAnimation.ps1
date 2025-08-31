#=================================================================================================================
#                                             First Sign-In Animation
#=================================================================================================================

<#
.SYNTAX
    Set-FirstSigninAnimation
        -GPO {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-FirstSigninAnimation
{
    <#
    .EXAMPLE
        PS> Set-FirstSigninAnimation -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoState] $GPO
    )

    process
    {
        # on: 1 (default) | off: 0
        $FirstSigninAnimation = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
            Entries = @(
                @{
                    Name  = 'EnableFirstLogonAnimation'
                    Value = $GPO -eq 'Disabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        # gpo\ computer config > administrative tpl > system > logon
        #   show first sign-in animation
        # not configured: delete (default) | on: 1 | off: 0
        $FirstSigninAnimationGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'EnableFirstLogonAnimation'
                    Value = $GPO -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'First Sign-In Animation (GPO)' to '$GPO' ..."
        $FirstSigninAnimation, $FirstSigninAnimationGpo | Set-RegistryEntry
    }
}
