#=================================================================================================================
#             Personnalization > Start > Show Recommendations For Tips, Shortcuts, New Apps, And More
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowRecommendations
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowRecommendations
{
    <#
    .EXAMPLE
        PS> Set-StartShowRecommendations -State 'Disabled'
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
        $StartRecommendations = @{
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

        Write-Verbose -Message "Setting 'Start - Show Recommendations For Tips, Shortcuts, New Apps, And More' to '$State' ..."
        Set-RegistryEntry -InputObject $StartRecommendations
    }
}
