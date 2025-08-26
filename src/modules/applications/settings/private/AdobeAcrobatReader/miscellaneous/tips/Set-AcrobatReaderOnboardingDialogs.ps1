#=================================================================================================================
#                               Acrobat Reader - Miscellaneous > Onboarding Dialogs
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderOnboardingDialogs
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderOnboardingDialogs
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOnboardingDialogs -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'NotConfigured'

        # gpo\ FTEDialog (First Time Experience (onboarding))
        #   specifies whether to invoke the home onboarding tour when the modern viewer is invoked the first time
        #   specifies whether to invoke the new viewer onboarding tour when a PDF opens in the modern viewer the first time
        # not configured: delete (default) | off: 1
        #
        # gpo\ AVGeneral (General Preferences) > Onboarding Dialogs
        #   specifies whether to show the skipped onboarding coachmark
        # not configured: delete (default) | off: 0
        #
        # gpo\ AVGeneral (General Preferences) > Onboarding Dialogs
        #   specifies whether to show the onboarding coachmark when the user invokes the Create Form panel
        #   specifies whether to show the onboarding coachmark when the user invokes the Edit panel
        #   specifies whether to show the onboarding coachmark when the user invokes the Fill & Sign panel
        #   specifies whether to show the onboarding coachmark when the user invokes the Organize panel
        #   specifies whether to show the skipped onboarding coachmark.
        # not configured: delete (default) | off: 1
        $AcrobatReaderOnboardingDialogsGpo = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\FTEDialog'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bShownHomeOnboarding'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bShownViewerOnboarding'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bShowedSkipCard'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral\cAV2ToolDiscoveryWalkthrough'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bCreateFormDiscoveryShown'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bEditDiscoveryShown'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bFillSignDiscoveryShown'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bOrganizeDiscoveryShown'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bRedactDiscoveryShown'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - Onboarding Dialogs (GPO)' to '$GPO' ..."
        $AcrobatReaderOnboardingDialogsGpo | Set-RegistryEntry
    }
}
