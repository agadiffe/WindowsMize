#=================================================================================================================
#                                   MSOffice - Privacy > Connected Experiences
#=================================================================================================================

# Only the "Optional Connected Experiences" is configurable via the GUI:
#   Options > General > Privacy Settings > Optional Connected Experiences

<#
.SYNTAX
    Set-MSOfficeConnectedExperiences
        [-AllConnectedExperiencesGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatAnalyzeContentGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatDownloadContentGPO {Disabled | NotConfigured}]
        [-OptionalConnectedExperiences {Disabled | Enabled}]
        [-OptionalConnectedExperiencesGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MSOfficeConnectedExperiences
{
    <#
    .EXAMPLE
        PS> Set-MSOfficeConnectedExperiences -AllConnectedExperiencesGPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoStateWithoutEnabled] $AllConnectedExperiencesGPO,

        [GpoStateWithoutEnabled] $ConnectedExperiencesThatAnalyzeContentGPO,

        [GpoStateWithoutEnabled] $ConnectedExperiencesThatDownloadContentGPO,

        [state] $OptionalConnectedExperiences,

        [GpoStateWithoutEnabled] $OptionalConnectedExperiencesGPO
    )

    process
    {
        switch ($PSBoundParameters.Keys)
        {
            'AllConnectedExperiencesGPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
                #   allow the use of connected experiences in Office
                # not configured: delete (default) | off: 2
                $MSOfficeAllConnectedExperiencesGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                    Entries = @(
                        @{
                            RemoveEntry = $AllConnectedExperiencesGPO -eq 'NotConfigured'
                            Name  = 'DisconnectedState'
                            Value = '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'MSOffice - All Connected Experiences (GPO)' to '$AllConnectedExperiencesGPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeAllConnectedExperiencesGpo
            }
            'ConnectedExperiencesThatAnalyzeContentGPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
                #   allow the use of connected experiences in Office that analyze content
                # not configured: delete (default) | off: 2
                $MSOfficeConnectedExperiencesThatAnalyzeContentGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                    Entries = @(
                        @{
                            RemoveEntry = $ConnectedExperiencesThatAnalyzeContentGPO -eq 'NotConfigured'
                            Name  = 'UserContentDisabled'
                            Value = '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'MSOffice - Connected Experiences That Analyze Content (GPO)' to '$ConnectedExperiencesThatAnalyzeContentGPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeConnectedExperiencesThatAnalyzeContentGpo
            }
            'ConnectedExperiencesThatDownloadContentGPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
                #   allow the use of connected experiences in Office that download online content
                # not configured: delete (default) | off: 2
                $MSOfficeConnectedExperiencesThatDownloadContentGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                    Entries = @(
                        @{
                            RemoveEntry = $ConnectedExperiencesThatDownloadContentGPO -eq 'NotConfigured'
                            Name  = 'DownloadContentDisabled'
                            Value = '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'MSOffice - Connected Experiences That Download Content (GPO)' to '$ConnectedExperiencesThatDownloadContentGPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeConnectedExperiencesThatDownloadContentGpo
            }
            'OptionalConnectedExperiences'
            {
                # on: 1 (default) | off: 2
                $MSOfficeOptionalConnectedExperiences = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Office\16.0\Common\Privacy\SettingsStore\Anonymous'
                    Entries = @(
                        @{
                            Name  = 'ControllerConnectedServicesState'
                            Value = $OptionalConnectedExperiences -eq 'Enabled' ? '1' : '2'
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'ControllerConnectedServicesStateTime'
                            Value = Get-Date -AsUTC -Format 'yyyy-MM-ddTHH:mm:ssK'
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'MSOffice - Optional Connected Experiences' to '$OptionalConnectedExperiences' ..."
                Set-RegistryEntry -InputObject $MSOfficeOptionalConnectedExperiences
            }
            'OptionalConnectedExperiencesGPO'
            {
                # gpo\ user config > administrative tpl > microsoft office > privacy > trust center
                #   allow the use of additional optional connected experiences in Office
                # not configured: delete (default) | off: 2
                $MSOfficeOptionalConnectedExperiencesGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Office\16.0\Common\Privacy'
                    Entries = @(
                        @{
                            RemoveEntry = $OptionalConnectedExperiencesGPO -eq 'NotConfigured'
                            Name  = 'ControllerConnectedServicesEnabled'
                            Value = '2'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'MSOffice - Optional Connected Experiences (GPO)' to '$OptionalConnectedExperiencesGPO' ..."
                Set-RegistryEntry -InputObject $MSOfficeOptionalConnectedExperiencesGpo
            }
        }
    }
}
