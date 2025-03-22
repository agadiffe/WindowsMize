#=================================================================================================================
#                            Acrobat Reader - Miscellaneous > First Launch Experience
#=================================================================================================================

# First launch introduction and UI tutorial overlay

<#
.SYNTAX
    Set-AcrobatReaderFirstLaunchExperience
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderFirstLaunchExperience
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderFirstLaunchExperience -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'

        # on: 0 0 1 1 1 1 1 1 (default) | off: 1 1 0 0 0 0 0 0
        $AcrobatReaderFirstLaunchExperience = @(
            @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                Entries = @(
                    @{
                        Name  = 'bToggleFTE'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'bWhatsNewExp'
                        Value = $IsEnabled ? '0' : '1'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\AVGeneral'
                Entries = @(
                    @{
                        Name  = 'bisFirstLaunch'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'bappFirstLaunchForNotifications'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Adobe\Adobe Acrobat\DC\FTEDialog'
                Entries = @(
                    @{
                        Name  = 'bIsAcrobatUpdateAvailableToShowWhatsNew'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'bShowInstallFTE'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'bShownHomeOnboarding'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'bShownViewerOnboarding'
                        Value = $IsEnabled ? '1' : '0'
                        Type  = 'DWord'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Acrobat Reader - First Launch Experience' to '$State' ..."
        $AcrobatReaderFirstLaunchExperience | Set-RegistryEntry
    }
}
