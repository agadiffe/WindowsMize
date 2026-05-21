#=================================================================================================================
#                          Personnalization > Start > Show Tips And App Recommendations
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowTipsAndAppRecommendations
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowTipsAndAppRecommendations
{
    <#
    .EXAMPLE
        PS> Set-StartShowTipsAndAppRecommendations -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $TipsAndAppRecommendations = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'Start_IrisRecommendations'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show Tips And App Recommendations' to '$State' ..."
        Set-RegistryEntry -InputObject $TipsAndAppRecommendations
    }
}
