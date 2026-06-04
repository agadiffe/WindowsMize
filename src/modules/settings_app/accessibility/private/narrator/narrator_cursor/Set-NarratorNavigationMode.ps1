#=================================================================================================================
#                                   Accessibility > Narrator > Navigation Mode
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorNavigationMode
        [-Mode] {Normal | Advanced}
        [<CommonParameters>]
#>

function Set-NarratorNavigationMode
{
    <#
    .EXAMPLE
        PS> Set-NarratorNavigationMode -Mode 'Normal'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorNavigationMode] $Mode
    )

    process
    {
        # Normal: 2 (default) | Advanced: 1
        $NarratorNavigationMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'NarratorCursorMode'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Navigation Mode' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorNavigationMode
    }
}
