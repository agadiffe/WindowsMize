#=================================================================================================================
#                                System > Notifications > Show Welcome Experience
#=================================================================================================================

# Show the Windows welcome experience after updates and when signed in to show what's new and suggested

<#
.SYNTAX
    Set-NotificationsShowWelcomeExperience
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NotificationsShowWelcomeExperience
{
    <#
    .EXAMPLE
        PS> Set-NotificationsShowWelcomeExperience -State 'Disabled' -GPO 'NotConfigured'
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
        $NotificationsWelcomeExperienceMsg = 'Notifications - Show Welcome Experience'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                # on: 1 (default) | off: 0
                $NotificationsWelcomeExperience = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
                    Entries = @(
                        @{
                            Name  = 'SubscribedContent-310093Enabled'
                            Value = $State -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsWelcomeExperienceMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $NotificationsWelcomeExperience
            }
            'GPO'
            {
                # gpo\ user config > administrative tpl > windows components > cloud content
                #   turn off the Windows welcome experience
                # not configured: delete (default) | on: 1
                $NotificationsWelcomeExperienceGpo = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableWindowsSpotlightWindowsWelcomeExperience'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsWelcomeExperienceMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NotificationsWelcomeExperienceGpo
            }
        }
    }
}
