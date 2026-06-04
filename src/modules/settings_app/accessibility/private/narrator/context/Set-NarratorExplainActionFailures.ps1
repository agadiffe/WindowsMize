#=================================================================================================================
#                Accessibility > Narrator > Context Level > Tell Me Why Actions Can't Be Performed
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorExplainActionFailures
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorExplainActionFailures
{
    <#
    .EXAMPLE
        PS> Set-NarratorExplainActionFailures -State 'Enabled'
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
        $NarratorExplainActionFailures = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'ErrorNotificationType'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Context Level: Tell Me Why Actions Can''t Be Performed' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorExplainActionFailures
    }
}
