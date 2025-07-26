#=================================================================================================================
#                                        Start Menu - All Apps View Mode
#=================================================================================================================

<#
.SYNTAX
    Set-StartMenuAllAppsViewMode
        [-Value] {Category | Grid | List}
        [<CommonParameters>]
#>

function Set-StartMenuAllAppsViewMode
{
    <#
    .EXAMPLE
        PS> Set-StartMenuAllAppsViewMode -Value 'Category'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Category', 'Grid', 'List')]
        [string] $Value
    )

    process
    {
        $SettingValue = switch ($Value)
        {
            'Category' { '0' }
            'Grid'     { '1' }
            'List'     { '2' }
        }

        # Category: 0 (default) | Grid: 1 | List: 2
        $AllAppsViewMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'AllAppsViewMode'
                    Value = $SettingValue
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start Menu - All Apps View Mode' to '$Value' ..."
        Set-RegistryEntry -InputObject $AllAppsViewMode
    }
}
