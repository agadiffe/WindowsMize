#=================================================================================================================
#                                 Power Options - Network Connectivity in Standby
#=================================================================================================================

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
#   > change advanced power settings > network connectivity in Standby

# default: Enabled (PluggedIn), ManagedByWindows (OnBattery)

<#
.SYNTAX
    Set-ModernStandbyNetworkConnectivity
        [-PowerSource] {PluggedIn | OnBattery}
        [-State] {Disabled | Enabled | ManagedByWindows}
        [<CommonParameters>]
#>

function Set-ModernStandbyNetworkConnectivity
{
    <#
    .EXAMPLE
        PS> Set-ModernStandbyNetworkConnectivity -PowerSource 'PluggedIn' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PowerSourceMode] $PowerSource,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Disabled', 'Enabled', 'ManagedByWindows')]
        [string] $State
    )

    process
    {
        $SettingIndex = switch ($State)
        {
            'Disabled'         { 0 }
            'Enabled'          { 1 }
            'ManagedByWindows' { 2 }
        }

        Write-Verbose -Message "Setting 'Modern Standby Network Connectivity ($PowerSource)' to '$State' ..."

        $SetValueIndex = $PowerSource -eq 'PluggedIn' ? '-SetACValueIndex' : '-SetDCValueIndex'
        powercfg.exe $SetValueIndex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY $SettingIndex
    }
}
