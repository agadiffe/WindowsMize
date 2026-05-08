#=================================================================================================================
#                                        Personnalization > Start > Layout
#=================================================================================================================

# old

<#
.SYNTAX
    Set-StartLayoutMode
        [-Layout] {Default | MorePins | MoreRecommendations}
        [<CommonParameters>]
#>

function Set-StartLayoutMode
{
    <#
    .EXAMPLE
        PS> Set-StartLayoutMode -Layout 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [StartLayoutMode] $Layout
    )

    process
    {
        # default: 0 (default) | more pins: 1 | more recommendations: 2
        $StartLayout = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'Start_Layout'
                    Value = [int]$Layout
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Layout Mode' to '$Layout' ..."
        Set-RegistryEntry -InputObject $StartLayout
    }
}
