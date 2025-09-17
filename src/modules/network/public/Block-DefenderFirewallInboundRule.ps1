#=================================================================================================================
#                                 Network - Block Defender Firewall Inbound Rule
#=================================================================================================================

# Firewall rules are defined in 'private\NetFirewallRules.ps1'
# Block these ports/programs/services from external access (Internet) while maintaining local functionality.

<#
.SYNTAX
    Block-DefenderFirewallInboundRule
        [-Name] {CDP | DCOM | NetBiosTcpIP | SMB | MiscProgSrv}
        [-Reset]
        [<CommonParameters>]
#>

function Block-DefenderFirewallInboundRule
{
    <#
    .DESCRIPTION
        Specifying a group to the firewall rule will add the following info banner to the GUI properties:
          This is a predefined rule and some of its properties cannot be modified.

        i.e. The GUI properties 'Protocols and Ports' and 'Programs and Services' will be grayed out.
        Use Set-NetFirewallRule to modify these properties.

    .EXAMPLE
        PS> Block-DefenderFirewallInboundRule -Name 'CDP', 'NetBiosTcpIP'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('CDP', 'DCOM', 'NetBiosTcpIP', 'SMB', 'MiscProgSrv')]
        [string[]] $Name,

        [switch] $Reset
    )

    process
    {
        foreach ($Item in $Name)
        {
            $ItemData = $NetFirewallRules.$Item
            Remove-NetFirewallRule -Group $ItemData.Group -ErrorAction 'SilentlyContinue'

            if (-not $Reset)
            {
                $RulesDisplayName = $ItemData.Rules.DisplayName -join "`n             "

                Write-Verbose -Message 'Adding Firewall rules:'
                Write-Verbose -Message "    $RulesDisplayName"

                $RuleProperties = @{
                    Action    = 'Block'
                    Direction = 'Inbound'
                    Group     = $ItemData.Group
                }
                foreach ($Rule in $ItemData.Rules)
                {
                    New-NetFirewallRule @RuleProperties @Rule | Out-Null
                }
            }
        }
    }
}
