#=================================================================================================================
#                                  Personnalization > Start > All Apps View Mode
#=================================================================================================================

# Start menu categories
# HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start\TileProperties

# (none)	             0
# Accessibility	         1
# Creativity	         6, 7, 22, 23
# Developer Tools	     15
# Entertainment	         3, 16, 17, 26
# Information & Reading  14, 21, 24, 25
# Other	                 2, 4, 8, 10
# Productivity	         5, 13
# Utilities & Tools	     9

<#
.SYNTAX
    Set-StartAllAppsViewMode
        [-Mode] {Category | Grid | List}
        [<CommonParameters>]
#>

function Set-StartAllAppsViewMode
{
    <#
    .EXAMPLE
        PS> Set-StartAllAppsViewMode -Mode 'Category'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [StartAllAppsViewMode] $Mode
    )

    process
    {
        # Category: 0 (default) | Grid: 1 | List: 2
        $AllAppsViewMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'AllAppsViewMode'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - All Apps View Mode' to '$Mode' ..."
        Set-RegistryEntry -InputObject $AllAppsViewMode
    }
}
