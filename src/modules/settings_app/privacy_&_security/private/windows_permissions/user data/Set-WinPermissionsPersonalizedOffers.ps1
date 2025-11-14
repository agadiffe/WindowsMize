#=================================================================================================================
#                      Privacy & Security > Recommendations And Offers > Personalized Offers
#=================================================================================================================

# aka / old naming : Diagnostics & Feedback > Tailored Experiences

<#
.SYNTAX
    Set-WinPermissionsPersonalizedOffers
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-WinPermissionsPersonalizedOffers
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsPersonalizedOffers -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $WinPermissionsPersonalizedOffersMsg = 'Windows Permissions - Personalized Offers'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $WinPermissionsPersonalizedOffers = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Privacy'
                    Entries = @(
                        @{
                            Name  = 'TailoredExperiencesWithDiagnosticDataEnabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsPersonalizedOffersMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $WinPermissionsPersonalizedOffers
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   do not use diagnostic data for tailored experiences
                # not configured: delete (default) | on: 1
                $WinPermissionsPersonalizedOffersGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableTailoredExperiencesWithDiagnosticData'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinPermissionsPersonalizedOffersMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $WinPermissionsPersonalizedOffersGpo
            }
        }
    }
}
