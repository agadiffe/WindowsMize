#=================================================================================================================
#                        Network - Connected User Experiences and Telemetry Firewall Rule
#=================================================================================================================

# See also Windows services.

<#
.SYNTAX
    Set-DiagTrackNetFirewallRule
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DiagTrackNetFirewallRule
{
    <#
    .EXAMPLE
        PS> Set-DiagTrackNetFirewallRule -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Network - Connected User Experiences and Telemetry Firewall Rule (group: DiagTrack)' to '$State' ..."
        Set-NetFirewallRule -Group 'DiagTrack' -Enabled ($State -eq 'Enabled' ? 'True' : 'False')
    }
}
