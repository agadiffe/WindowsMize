#=================================================================================================================
#             Acrobat Reader - Preferences > Generative AI > Show Suggested Prompts From AI Assistant
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderAIShowSuggestedPrompts
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderAIShowSuggestedPrompts
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderAIShowSuggestedPrompts -State 'Disabled'
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
        $AcrobatReaderAIShowSuggestedPrompts = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\Gentech'
            Entries = @(
                @{
                    Name  = 'bSummaryDMBEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Generative AI: Show Suggested Prompts From AI Assistant' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderAIShowSuggestedPrompts
    }
}
