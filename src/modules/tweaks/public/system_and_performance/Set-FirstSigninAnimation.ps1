#=================================================================================================================
#                                             First Sign-In Animation
#=================================================================================================================

<#
.SYNTAX
    Set-FirstSigninAnimation
        [-State] {Disabled | Enabled}
        -GPO {Disabled | Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-FirstSigninAnimation
{
    <#
    .EXAMPLE
        PS> Set-FirstSigninAnimation -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Mandatory, Position = 0)]
        [state] $State,

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
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'First Sign-In Animation' to '$State' ..."
        Set-RegistryEntry -InputObject $FirstSigninAnimation


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
        Set-RegistryEntry -InputObject $FirstSigninAnimationGpo
    }
}
