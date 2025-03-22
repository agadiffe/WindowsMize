#=================================================================================================================
#                                       System > Remote Desktop - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-RemoteDesktopSetting
        [-RemoteDesktop {Disabled | Enabled}]
        [-RemoteDesktopGPO {Disabled | Enabled | NotConfigured}]
        [-NetworkLevelAuthentication {Disabled | Enabled}]
        [-PortNumber <int>]
        [<CommonParameters>]
#>

function Set-RemoteDesktopSetting
{
    <#
    .EXAMPLE
        PS> Set-StorageSenseSetting -RemoteDesktop 'Disabled' -RemoteDesktopGPO 'NotConfigured' -PortNumber 3390
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $RemoteDesktop,

        [GpoState] $RemoteDesktopGPO,

        [state] $NetworkLevelAuthentication,

        [ValidateRange(1, 65535)]
        [int] $PortNumber
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
            'RemoteDesktop'              { Set-RemoteDesktop -State $RemoteDesktop }
            'RemoteDesktopGPO'           { Set-RemoteDesktop -GPO $RemoteDesktopGPO }
            'NetworkLevelAuthentication' { Set-RemoteDesktopNetworkLevelAuthentication -State $NetworkLevelAuthentication }
            'PortNumber'                 { Set-RemoteDesktopPortNumber -Value $PortNumber }
        }
    }
}
