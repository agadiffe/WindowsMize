#=================================================================================================================
#                                 Power Options - Network Connectivity in Standby
#=================================================================================================================

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
#   > change advanced power settings > network connectivity in Standby

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
        # SUB_NONE: 'fea3413e-7e05-4911-9a71-700331f1c294'
        # CONNECTIVITYINSTANDBY: 'f15576e8-98b7-4186-b944-eafa664402d9'

        Write-Verbose -Message "Setting 'Modern Standby Network Connectivity ($PowerSource)' to '$State' ..."

        $SettingIndex = switch ($State)
        {
            'Disabled'         { 0 }
            'Enabled'          { 1 }
            'ManagedByWindows' { 2 }
        }

        $PowerPlanGUID = Get-PowerPlanGUID
        $SetValueIndex = $PowerSource -eq 'PluggedIn' ? '-SetACValueIndex' : '-SetDCValueIndex'

        foreach ($GUID in $PowerPlanGUID)
        {
            # default\ PluggedIn: Enabled (1), OnBattery: ManagedByWindows (2)
            powercfg.exe $SetValueIndex $GUID SUB_NONE CONNECTIVITYINSTANDBY $SettingIndex
        }
    }
}
