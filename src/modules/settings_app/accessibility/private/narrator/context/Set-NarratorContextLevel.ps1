#=================================================================================================================
#                        Accessibility > Narrator > Context Level For Buttons And Controls
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorContextLevel
        [-Mode] {NoContext | ImmediateContext | ImmediateContextNameAndType |
                 FullContextOfNewControl | FullContextOfOldAndNewControls}
        [<CommonParameters>]
#>

function Set-NarratorContextLevel
{
    <#
    .EXAMPLE
        PS> Set-NarratorContextLevel -Mode 'ImmediateContextNameAndType'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorContextLevel] $Mode
    )

    process
    {
        # NoContext: 1 | ImmediateContext: 2 | ImmediateContextNameAndType: 3 (default)
        # FullContextOfNewControl: 4 | FullContextOfOldAndNewControls: 5
        $NarratorContextLevel = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'ContextVerbosityLevelV2'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Context Level For Buttons And Controls' to '$Mode' ..."
        Set-RegistryEntry -InputObject $NarratorContextLevel
    }
}
