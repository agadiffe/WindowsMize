#=================================================================================================================
#                                        Personnalization > Start > Layout
#=================================================================================================================

# old

<#
.SYNTAX
    Set-StartLayoutMode
        [-Value] {Default | MorePins | MoreRecommendations}
        [<CommonParameters>]
#>

function Set-StartLayoutMode
{
    <#
    .EXAMPLE
        PS> Set-StartLayoutMode -Value 'Default'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [StartLayoutMode] $Value
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
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Layout Mode' to '$Value' ..."
        Set-RegistryEntry -InputObject $StartLayout
    }
}
