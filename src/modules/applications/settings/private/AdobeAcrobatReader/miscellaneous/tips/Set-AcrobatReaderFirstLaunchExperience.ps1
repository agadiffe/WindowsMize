#=================================================================================================================
#                            Acrobat Reader - Miscellaneous > First Launch Experience
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderFirstLaunchExperience
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderFirstLaunchExperience
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderFirstLaunchExperience -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $IsNotConfigured = $GPO -eq 'Enabled'

        # user\ IsFirstLaunch & bAppFirstLaunchForNotifications
        # not configured: delete (default) | off: 0
        #
        # gpo\ AVGeneral (General Preferences) > Modern Viewer: A new Acrobat UI
        #   specifies whether to show the "Acrobat has a new look" coachmark after launching Acrobat the first time
        #   specifies whether to show the "Try the new Acrobat/Reader" coachmark after launching Acrobat the first time
        # not configured: delete (default) | off: 0
        #
        # gpo\ AVGeneral (General Preferences) > Home Screen and Help Menu
        #   specifies whether to load the Welcome PDF file
        # not configured: delete (default) | off: 0
        #
        # gpo\ AVPrivate (Application Startup, misc.) > Startup
        #   toggles whether the splash screen appears on startup
        # not configured: delete (default) | off: 0
        #
        # gpo\ HomeWelcome (SMS Messaging) > Show Getting Started
        #   specifies whether to show "Get Started with Acrobat" on startup
        # not configured: delete (default) | off: 0
        #
        # gpo\ FeatureLockDown (Lockable Settings) > What's New Experience
        #   specifies whether to disable the What's New experience
        # not configured: delete (default) | off: 1
        #
        # gpo\ FeatureLockDown (Lockable Settings) > Home Screen and Startup
        #   specifies whether to enable the First Time Experience (FTE) feature (Welcome tour/page)
        # not configured: delete (default) | off: 1
        #
        # user\ bIsAcrobatUpdateAvailableToShowWhatsNew & bShowInstallFTE
        # not configured: delete (default) | off: 0
        $AcrobatReaderFirstLaunchExperienceGpo = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bIsFirstLaunch'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bAppFirstLaunchForNotifications'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'iNumSwitcherContextualToolTipAV2Shown'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'iNumSwitcherContextualToolTipAVShown'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bAddCustomFile'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVPrivate'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bSplashDisplayedAtStartup'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\HomeWelcome'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bLastShowStatus'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bWhatsNewExp'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bToggleFTE'
                        Value = '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\FTEDialog'
                Entries = @(
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bIsAcrobatUpdateAvailableToShowWhatsNew'
                        Value = '0'
                        Type  = 'DWord'
                    }
                    @{
                        RemoveEntry = $IsNotConfigured
                        Name  = 'bShowInstallFTE'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - First Launch Experience' to '$GPO' ..."
        $AcrobatReaderFirstLaunchExperienceGpo | Set-RegistryEntry
    }
}
