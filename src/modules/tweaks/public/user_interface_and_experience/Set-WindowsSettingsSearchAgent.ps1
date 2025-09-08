#=================================================================================================================
#                                   Windows Settings Agentic Search Experience
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsSettingsSearchAgent
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsSettingsSearchAgent
{
    <#
    .EXAMPLE
        PS> Set-WindowsSettingsSearchAgent -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > windows AI
        #   disable Settings agentic search experience
        # not configured: delete (default) | on: 1
        $SettingsSearchAgentGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsAI'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisableSettingsAgent'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Settings Agentic Search Experience (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $SettingsSearchAgentGpo
    }
}
