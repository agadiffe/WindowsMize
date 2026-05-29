#=================================================================================================================
#                                  Personnalization > Start > All Apps View Mode
#=================================================================================================================

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
