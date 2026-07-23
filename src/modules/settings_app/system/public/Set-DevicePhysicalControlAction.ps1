#=================================================================================================================
#                   System > Power & Battery > Power Mode > Lid, Power & Sleep Button Controls
#=================================================================================================================

# Choose what happens when you interact with your device's physical controls
#   Pressing the power button will make my PC
#   Pressing the sleep button will make my PC
#   Closing the lid will make my PC

<#
.SYNTAX
    Set-DevicePhysicalControlAction
        [-Control] {PowerButton | SleepButton | LidClose}
        [-PowerSource] {PluggedIn | OnBattery}
        [-Action] {DoNothing | Sleep | Hibernate | ShutDown | DisplayOff}
        [<CommonParameters>]
#>

function Set-DevicePhysicalControlAction
{
    <#
    .DESCRIPTION
        'LidClose' does not support 'DisplayOff'.

    .EXAMPLE
        PS> Set-DevicePhysicalControlAction -Control 'LidClose' -PowerSource 'PluggedIn' -Action 'Sleep'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PhysicalControl] $Control,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PowerSource] $PowerSource,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [PhysicalControlAction] $Action
    )

    process
    {
        if ($Control -eq 'LidClose' -and $Action -eq 'DisplayOff')
        {
            $ValidValues = [PhysicalControlAction].GetEnumNames().Where({ $_ -ne 'DisplayOff' }) -join ', '
            Write-Error -Message "'LidClose' does not support 'DisplayOff'. Valid values are: $ValidValues."
            return
        }

        $SettingGUID = switch ($Control)
        {
            'PowerButton' { 'PBUTTONACTION' }
            'SleepButton' { 'SBUTTONACTION' }
            'LidClose'    { 'LIDACTION' }
        }

        Write-Verbose -Message "Setting 'Power - $Control Action Control ($PowerSource)' to '$Action' ..."

        # DoNothing: 0 | Sleep: 1 (default) | Hibernate: 2 | ShutDown: 3 | DisplayOff: 4
        $SetValueIndex = $PowerSource -eq 'PluggedIn' ? '-SetACValueIndex' : '-SetDCValueIndex'
        powercfg.exe $SetValueIndex SCHEME_CURRENT SUB_BUTTONS $SettingGUID ([int]$Action)
    }
}
