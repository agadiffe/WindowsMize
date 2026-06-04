#=================================================================================================================
#           Accessibility > Narrator > Context Level > Tell Me Details About Buttons And Other Controls
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorContextDetailsOrder
        [-Order] {AfterControls | BeforeControls}
        [<CommonParameters>]
#>

function Set-NarratorContextDetailsOrder
{
    <#
    .EXAMPLE
        PS> Set-NarratorContextDetailsOrder -Order 'BeforeControls'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorContextDetailsOrder] $Order
    )

    process
    {
        # AfterControls: 0 | BeforeControls: 1 (default)
        $NarratorContextDetailsOrder = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'RenderContextBeforeElement'
                    Value = [int]$Order
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Context Level: Tell Me Details About Buttons And Controls' to '$Order' ..."
        Set-RegistryEntry -InputObject $NarratorContextDetailsOrder
    }
}
