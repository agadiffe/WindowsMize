#=================================================================================================================
#                                                Windows Spotlight
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsSpotlight
        [[-GPO] {Disabled | NotConfigured}]
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
        [Parameter(Position = 0)]
        [GpoStateWithoutEnabled] $GPO,

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
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ user config > administrative tpl > windows components > cloud content
                #
                #   configure Windows spotlight on lock screen (only available for Enterprise SKUs)
                # not configured: delete (default) | off: 2 0
                #
                #   do not suggest third-party content in Windows spotlight
                # not configured: delete (default) | on: 1
                #
                #   turn off all Windows spotlight features
                #     personalization > background > windows spotlight
                #     personalization > lockscreen > windows spotlight
                #     personalization > lockscreen > get fun facts, tips, tricks, and more
                #     system > notifications > show the Windows welcome experience [...]
                #     system > notifications > get tips and suggestions when using Windows
                #     privacy & security > general > show me suggested content in the setting app
                # not configured: delete (default) | on: 1
                #
                #   turn off spotlight collection on Desktop
                #     personalization > background > windows spotlight
                # not configured: delete (default) | on: 1
                #
                #   turn off Windows spotlight on Action Center
                #     do not display suggested content (apps or features) in Action Center
                # not configured: delete (default) | on: 1
                $WindowsSpotlightGpo = @(
                    @{
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
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableThirdPartySuggestions'
                                Value = '1'
                                Type  = 'DWord'
                            }
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableWindowsSpotlightFeatures'
                                Value = '1'
                                Type  = 'DWord'
                            }
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableSpotlightCollectionOnDesktop'
                                Value = '1'
                                Type  = 'DWord'
                            }
                            @{
                                RemoveEntry = $IsNotConfigured
                                Name  = 'DisableWindowsSpotlightOnActionCenter'
                                Value = '1'
                                Type  = 'DWord'
                            }
                        )
                    }
                )

                Write-Verbose -Message "Setting 'Windows Spotlight (GPO)' to '$GPO' ..."
                $WindowsSpotlightGpo | Set-RegistryEntry
            }
            'LearnAboutPictureDesktopIcon'
            {
                # on: delete (or 0) (default) | off: 1
                $LearnAboutPicture = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
                    Entries = @(
                        @{
                            RemoveEntry = $LearnAboutPictureDesktopIcon -eq 'Disabled'
                            Name  = '{2cc5ca98-6485-489a-920e-b3e88a6ccce3}'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                $LearnAboutPictureState = "Learn About This Picture Desktop Icon' to '$LearnAboutPictureDesktopIcon'"
                Write-Verbose -Message "Setting 'Windows Spotlight - $LearnAboutPictureState ..."
                Set-RegistryEntry -InputObject $LearnAboutPicture
            }
        }
    }
}
