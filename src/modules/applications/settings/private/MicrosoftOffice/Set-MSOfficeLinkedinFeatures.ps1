#=================================================================================================================
#                                MSOffice - Options > General > Linkedin Features
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeLinkedinFeatures
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MSOfficeLinkedinFeatures
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeLinkedinFeatures -State 'Disabled' -GPO 'NotConfigured'
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
        $LinkedinFeaturesMsg = 'MSOffice - Linkedin Features'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $MSOfficeLinkedinFeatures = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Office\16.0\Common\LinkedIn'
                    Entries = @(
                        @{
                            Name  = 'OfficeLinkedIn'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$LinkedinFeaturesMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $MSOfficeLinkedinFeatures
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > miscellaneous
                #   show LinkedIn features in Office applications
                # not configured: delete (default) | off: 0
                $MSOfficeLinkedinFeaturesGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'LinkedIn'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$LinkedinFeaturesMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeLinkedinFeaturesGpo
            }
        }
    }
}
