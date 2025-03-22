#=================================================================================================================
#                   System > Power & Battery > Power Mode > Lid, Power & Sleep Button Controls
#=================================================================================================================

# Pressing the power button will make my PC
# Pressing the sleep button will make my PC
# Closing the lid will make my PC

<#
.SYNTAX
    Set-PowerButtonControls
        [-Name] {PowerButton | SleepButton | LidClose}
        [-Action] {DoNothing | Sleep | Hibernate | ShutDown | DisplayOff}
        [-PowerSource] {PluggedIn | OnBattery}
        [<CommonParameters>]
#>

function Set-PowerButtonControls
{
    <#
    .EXAMPLE
        PS> Set-PowerButtonControls -Name 'LidClose' -Action 'Sleep' -PowerSource 'PluggedIn'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ButtonControls] $Name,

        [Parameter(Mandatory)]
        [PowerAction] $Action,

        [Parameter(Mandatory)]
        [PowerSource] $PowerSource
    )

    process
    {
        # DoNothing: 0 | Sleep: 1 (default) | Hibernate: 2 | ShutDown: 3 | DisplayOff: 4

        $SettingGUID = switch ($Name)
        {
            'PowerButton' { 'PBUTTONACTION' }
            'SleepButton' { 'SBUTTONACTION' }
            'LidClose'    { 'LIDACTION' }
        }

        Write-Verbose -Message "Setting 'Power - $Name Action Control ($PowerSource)' to '$Action' ..."

        $SetValueIndex = $PowerSource -eq 'PluggedIn' ? '-SetACValueIndex' : '-SetDCValueIndex'
        powercfg.exe $SetValueIndex SCHEME_CURRENT SUB_BUTTONS $SettingGUID ([int]$Action)
    }
}
