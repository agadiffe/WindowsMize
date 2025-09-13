#=================================================================================================================
#                   Network & Internet > Advanced Network Settings > Advanced Sharing Settings
#=================================================================================================================

<#
.SYNTAX
    Set-NetworkSharingSetting
        [-Name] {NetworkDiscovery | FileAndPrinterSharing}
        [-NetProfile] {Private | Public | Domain}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NetworkSharingSetting
{
    <#
    .EXAMPLE
        PS> Set-NetworkSharingSetting -Name 'FileAndPrinterSharing' -NetProfile 'Private' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('NetworkDiscovery', 'FileAndPrinterSharing')]
        [string] $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Private', 'Public', 'Domain')]
        [string] $NetProfile,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Network Sharing Settings - $Name ($NetProfile networks)' to '$State' ..."

        $NetFirewallGroupID = switch ($Name)
        {
            'NetworkDiscovery'      { '-32752' }
            'FileAndPrinterSharing' { '-28502' }
        }

        Get-NetFirewallRule -Group "*$NetFirewallGroupID*" |
            Where-Object -Property 'Profile' -Match -Value $NetProfile |
            Set-NetFirewallRule -Enabled ($State -eq 'Enabled' ? 'True' : 'False')
    }
}
