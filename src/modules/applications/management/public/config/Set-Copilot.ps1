#=================================================================================================================
#                                                     Copilot
#=================================================================================================================

# old

# This policy is deprecated and may be removed in a future release.
# The 'TurnOffWindowsCopilot' policy isn't for the new Copilot experience.

<#
.SYNTAX
    Set-Copilot
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-Copilot
{
    <#
    .EXAMPLE
        PS> Set-Copilot -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > windows components > windows copilot​
        #   turn off Windows Copilot
        # not configured: delete (default) | on: 1

        $WindowsCopilotGpo = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Policies\Microsoft\Windows\WindowsCopilot'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'TurnOffWindowsCopilot'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Copilot (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsCopilotGpo
    }
}
