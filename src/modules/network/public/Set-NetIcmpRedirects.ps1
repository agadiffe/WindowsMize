#=================================================================================================================
#                          Network - Internet Control Message Protocol (ICMP) Redirects
#=================================================================================================================

# Allowing ICMP redirect of routes can lead to traffic not being routed properly.
# When disabled, this forces ICMP to be routed via shortest path first.

# STIG recommendation: Disabled

<#
.SYNTAX
    Set-NetIcmpRedirects
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetIcmpRedirects
{
    <#
    .EXAMPLE
        PS> Set-NetIcmpRedirects -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Network Icmp Redirects' to '$State' ..."

        Set-NetIPv4Protocol -IcmpRedirects $State
        Set-NetIPv6Protocol -IcmpRedirects $State
    }
}
