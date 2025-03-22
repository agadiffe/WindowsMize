#=================================================================================================================
#                                          Network & Internet - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-NetworkSetting
        [-ConnectedNetworkProfile {Public | Private | DomainAuthenticated}]
        [-ProxyAutoDetectSettings {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-NetworkSetting
{
    <#
    .EXAMPLE
        PS> Set-NetworkSetting -ConnectedNetworkProfile 'Private' -ProxyAutoDetectSettings 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [ValidateSet('Public', 'Private', 'DomainAuthenticated')]
        [string] $ConnectedNetworkProfile,

        [state] $ProxyAutoDetectSettings
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'ConnectedNetworkProfile'
            {
                # Public (default) | Private | DomainAuthenticated
                Write-Verbose -Message "Setting 'Connected Network' To '$ConnectedNetworkProfile' ..."
                Set-NetConnectionProfile -NetworkCategory $ConnectedNetworkProfile
            }
            'ProxyAutoDetectSettings' { Set-ProxyAutoDetectSettings -State $ProxyAutoDetectSettings }
        }
    }
}
