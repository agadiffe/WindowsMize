#=================================================================================================================
#                    System > Advanced > Enable More Agent Connectors By Reducing Protections
#=================================================================================================================

<#
.SYNTAX
    Set-MoreAgentConnectors
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MoreAgentConnectors
{
    <#
    .EXAMPLE
        PS> Set-MoreAgentConnectors -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 2 | off: 1 (default)
        $MoreAgentConnectors = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Mcp\Agents'
            Entries = @(
                @{
                    Name  = 'ConnectorEnvironmentPolicy'
                    Value = $State -eq 'Enabled' ? '2' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Advanced - Enable More Agent Connectors By Reducing Protections' to '$State' ..."
        Set-RegistryEntry -InputObject $MoreAgentConnectors
    }
}
