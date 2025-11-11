#=================================================================================================================
#                                                Windows Spotlight
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsSpotlight
        [-AllFeaturesGPO {Disabled | NotConfigured}]
        [-DesktopGPO {Disabled | NotConfigured}]
        [-LockScreenGPO {Disabled | NotConfigured}]
        [-AdsContentGPO {Disabled | NotConfigured}]
        [-LearnAboutPictureDesktopIcon {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-WindowsSpotlight
{
    <#
    .EXAMPLE
        PS> Set-WindowsSpotlight -LearnAboutPictureDesktopIcon 'Disabled'

    .EXAMPLE
        PS> Set-WindowsSpotlight -GPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [GpoStateWithoutEnabled] $AllFeaturesGPO,
        [GpoStateWithoutEnabled] $DesktopGPO,
        [GpoStateWithoutEnabled] $LockScreenGPO,
        [GpoStateWithoutEnabled] $AdsContentGPO,
        [state] $LearnAboutPictureDesktopIcon
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'AllFeaturesGPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   turn off all Windows spotlight features
                #     personalization > background > windows spotlight
                #     personalization > lockscreen > windows spotlight
                #     personalization > lockscreen > get fun facts, tips, tricks, and more
                #     system > notifications > show the Windows welcome experience [...]
                #     system > notifications > get tips and suggestions when using Windows
                #     privacy & security > general > show me suggested content in the setting app
                # not configured: delete (default) | on: 1
                $WindowsSpotlightGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $AllFeaturesGPO -eq 'NotConfigured'
                            Name  = 'DisableWindowsSpotlightFeatures'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Spotlight (all features) (GPO)' to '$AllFeaturesGPO' ..."
                Set-RegistryEntry -InputObject $WindowsSpotlightGpo
            }
            'DesktopGPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   turn off spotlight collection on Desktop
                # not configured: delete (default) | on: 1
                $DesktopRegGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $DesktopGPO -eq 'NotConfigured'
                            Name  = 'DisableSpotlightCollectionOnDesktop'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Spotlight - Desktop And Lock screen (GPO)' to '$DesktopGPO' ..."
                Set-RegistryEntry -InputObject $DesktopRegGpo
            }
            'LockScreenGPO'
            {
                $IsNotConfigured = $LockScreenGPO -eq 'NotConfigured'

                # gpo\ user config > administrative tpl > windows components > cloud content
                #   configure Windows spotlight on lock screen (only available for Enterprise SKUs)
                # not configured: delete (default) | off: 2 0
                $LockScreenRegGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ConfigureWindowsSpotlight'
                            Value = '2'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'IncludeEnterpriseSpotlight'
                            Value = '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Spotlight - Lock Screen (GPO)' to '$LockScreenGPO' ..."
                Set-RegistryEntry -InputObject $LockScreenRegGpo
            }
            'AdsContentGPO'
            {
                $IsNotConfigured = $AdsContentGPO -eq 'NotConfigured'

                # gpo\ user config > administrative tpl > windows components > cloud content
                #   turn off Windows spotlight on Action Center (do not display suggested content (apps or features))
                #   do not suggest third-party content in Windows spotlight
                # not configured: delete (default) | on: 1 1
                $AdsContentRegGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DisableWindowsSpotlightOnActionCenter'
                            Value = '1'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DisableThirdPartySuggestions'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Spotlight - Ads Content (GPO)' to '$AdsContentGPO' ..."
                Set-RegistryEntry -InputObject $AdsContentRegGpo
            }
            'LearnAboutPictureDesktopIcon'
            {
                # on: key present (default) | off: delete key
                $LearnAboutPicture = @{
                    RemoveKey = $LearnAboutPictureDesktopIcon -eq 'Disabled'
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{2cc5ca98-6485-489a-920e-b3e88a6ccce3}'
                    Entries = @(
                        @{
                            Name  = '(Default)'
                            Value = 'Windows Spotlight'
                            Type  = 'String'
                        }
                    )
                }

                $LearnAboutPictureState = "'Learn About This Picture' Desktop Icon to '$LearnAboutPictureDesktopIcon'"
                Write-Verbose -Message "Setting 'Windows Spotlight - $LearnAboutPictureState ..."
                Set-RegistryEntry -InputObject $LearnAboutPicture
            }
        }
    }
}
