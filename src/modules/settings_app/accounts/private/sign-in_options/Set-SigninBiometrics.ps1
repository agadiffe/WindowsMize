#=================================================================================================================
#                   Accounts > Sign-In Options > Facial/Fingerprint Recognition (Windows Hello)
#=================================================================================================================

# If disabled, the setting page will display this message: 'something went wrong. try again later.'

<#
.SYNTAX
    Set-SigninBiometrics
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-SigninBiometrics
{
    <#
    .EXAMPLE
        PS> Set-SigninBiometrics -GPO 'NotConfigured'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > biometrics
        #   allow the use of biometrics
        # not configured: delete (default) | off: 0
        $SigninBiometricsGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Biometrics'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'Enabled'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sign-In Options - Facial/Fingerprint Recognition (Windows Hello)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $SigninBiometricsGpo
    }
}
