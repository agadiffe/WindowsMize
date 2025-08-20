#=================================================================================================================
#                MSOffice - Options > General > Show The Start Screen When this Application Starts
#=================================================================================================================

<#
.SYNTAX
    Set-MSOfficeShowStartScreen
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MSOfficeShowStartScreen
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeShowStartScreen -State 'Disabled' -GPO 'NotConfigured
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
        $ShowStartScreenMsg = 'MSOffice - Show The Start Screen When this Application Starts'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '0' : '1'

                # on: 0 (default) | off: 1
                $MSOfficeShowStartScreen = @(
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Office\16.0\Excel\Options'
                        Entries = @(
                            @{
                                Name  = 'DisableBootToOfficeStart'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Office\16.0\PowerPoint\Options'
                        Entries = @(
                            @{
                                Name  = 'DisableBootToOfficeStart'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                    @{
                        Hive    = 'HKEY_CURRENT_USER'
                        Path    = 'Software\Microsoft\Office\16.0\Word\Options'
                        Entries = @(
                            @{
                                Name  = 'DisableBootToOfficeStart'
                                Value = $Value
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting '$ShowStartScreenMsg' to '$State' ..."
                $MSOfficeShowStartScreen | Set-RegistryEntry
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > miscellaneous
                #   disable the Office Start screen for all Office applications
                # not configured: delete (default) | on: 1
                $MSOfficeShowStartScreenGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common\General'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableBootToOfficeStart'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$ShowStartScreenMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeShowStartScreenGpo
            }
        }
    }
}
