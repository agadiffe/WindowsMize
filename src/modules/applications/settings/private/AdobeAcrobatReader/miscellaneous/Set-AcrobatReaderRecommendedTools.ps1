#=================================================================================================================
#                           Acrobat Reader - Miscellaneous > Recommended Tools For You
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderRecommendedTools
        [-Value] {Expand | Collapse}
        [<CommonParameters>]
#>

function Set-AcrobatReaderRecommendedTools
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderRecommendedTools -Value 'Collapse'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ExpandCollapse] $Value
    )

    process
    {
        # expand: 0 (default) | collapse: 1
        $AcrobatReaderRecommendedTools = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\HomeWelcomeFirstMile'
            Entries = @(
                @{
                    Name  = 'bFirstMileMinimized'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Recommended Tools For You' to '$Value' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderRecommendedTools
    }
}
