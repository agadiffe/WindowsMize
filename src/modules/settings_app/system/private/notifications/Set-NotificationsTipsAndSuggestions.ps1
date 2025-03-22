#=================================================================================================================
#                      System > Notifications > Get Tips And Suggestions When Using Windows
#=================================================================================================================

<#
.SYNTAX
    Set-NotificationsTipsAndSuggestions
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-NotificationsTipsAndSuggestions
{
    <#
    .EXAMPLE
        PS> Set-NotificationsTipsAndSuggestions -State 'Disabled' -GPO 'NotConfigured'
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
        $NotificationsTipsAndSuggestionsMsg = 'Notifications - Get Tips And Suggestions When Using Windows'

        switch ($PSBoundParameters.Keys)
        {
            'State'
            {
                $Value = $State -eq 'Enabled' ? '1' : '0'

                # on: 1 (default) | off: 0
                $NotificationsTipsAndSuggestions = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
                    Entries = @(
                        @{
                            Name  = 'SoftLandingEnabled' # Win10
                            Value = $Value
                            Type  = 'DWord'
                        }
                        @{
                            Name  = 'SubscribedContent-338389Enabled'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsTipsAndSuggestionsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $NotificationsTipsAndSuggestions
            }
            'GPO'
            {
                # gpo\ computer config > administrative tpl > windows components > cloud content
                #   do not show Windows tips (only applies to Enterprise and Education SKUs)
                # not configured: delete (default) | on: 1
                $NotificationsTipsAndSuggestionsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\CloudContent'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'DisableSoftLanding'
                            Value = '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$NotificationsTipsAndSuggestionsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $NotificationsTipsAndSuggestionsGpo
            }
        }
    }
}
