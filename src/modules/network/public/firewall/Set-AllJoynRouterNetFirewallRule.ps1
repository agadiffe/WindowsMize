#=================================================================================================================
#                                     Network - AllJoyn Router Firewall Rule
#=================================================================================================================

# Internet of Things related (see also Windows services).

<#
.SYNTAX
    Set-AllJoynRouterNetFirewallRule
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AllJoynRouterNetFirewallRule
{
    <#
    .EXAMPLE
        PS> Set-AllJoynRouterNetFirewallRule -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Network - AllJoyn Router Firewall Rule (group: @FirewallAPI.dll,-37002)' to '$State' ..."
        Set-NetFirewallRule -Group '@FirewallAPI.dll,-37002' -Enabled ($State -eq 'Enabled' ? 'True' : 'False')
    }
}
