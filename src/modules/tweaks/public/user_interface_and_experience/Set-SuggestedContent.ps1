#=================================================================================================================
#                                                Suggested Content
#=================================================================================================================

<#
.SYNTAX
    Set-SuggestedContent
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SuggestedContent
{
    <#
    .EXAMPLE
        PS> Set-SuggestedContent -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $SuggestedContent = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'
            Entries = @(
                @{
                    Name  = 'ContentDeliveryAllowed'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'FeatureManagementEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'OemPreInstalledAppsEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'PreInstalledAppsEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'PreInstalledAppsEverEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SubscribedContentEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SilentInstalledAppsEnabled'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SubscribedContent-338388Enabled' # Win10
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SubscribedContent-353698Enabled' # Win10
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SystemPaneSuggestionsEnabled' # old | Win10
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Suggested Content' to '$State' ..."
        Set-RegistryEntry -InputObject $SuggestedContent
    }
}
