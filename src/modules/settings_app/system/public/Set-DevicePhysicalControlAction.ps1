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
        [[-Action] {DoNothing | Sleep | Hibernate | ShutDown | DisplayOff}]
        [[-ActionGPO] {DoNothing | Sleep | Hibernate | ShutDown | NotConfigured}]
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

        [Parameter(ValueFromPipelineByPropertyName)]
        [PhysicalControlAction] $Action,

        [Parameter(ValueFromPipelineByPropertyName)]
        [PhysicalControlActionGpo] $ActionGPO
    )

    process
    {
        if (-not $PSBoundParameters.ContainsKey('Action') -and -not $PSBoundParameters.ContainsKey('ActionGPO'))
        {
            Write-Error -Message ((Write-InsufficientParameterCount) +
                                 ' Specify at least the ''Action'' or ''ActionGPO'' parameter.')
            return
        }

        $SettingGUID = switch ($Control)
        {
            'PowerButton' { '7648efa3-dd9c-4e3e-b566-50f929386280' } # PBUTTONACTION
            'SleepButton' { '96996bc0-ad50-47ec-923b-6f41874dd9eb' } # SBUTTONACTION
            'LidClose'    { '5ca83367-6e45-459f-a27b-476b1d01c936' } # LIDACTION
        }

        $ActionControlMsg = "Power - $Control Action Control ($PowerSource)"

        switch ($PSBoundParameters.Keys)
        {
            'Action'
            {
                Write-Verbose -Message "Setting '$ActionControlMsg' to '$Action' ..."

                if ($Action -eq 'DisplayOff' -and $Control -eq 'LidClose')
                {
                    $ValidValues = [PhysicalControlAction].GetEnumNames().Where({ $_ -ne 'DisplayOff' }) -join ', '
                    Write-Error -Message "  'LidClose' does not support 'DisplayOff'. Valid values are: $ValidValues."
                    continue # skip the 'Action' case
                }

                $SubGroupGUID = '4f971e89-eebd-4455-a8de-9e59040e7347' # SUB_BUTTONS
                $PowerPlanGUID = Get-PowerPlanGUID

                foreach ($GUID in $PowerPlanGUID)
                {
                    # If GPO is defined, powercfg cannot change the user setting. Use registry editing.

                    # DoNothing: 0 | Sleep: 1 (default) | Hibernate: 2 | ShutDown: 3 | DisplayOff: 4
                    $ActionControl = @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = "SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes\$GUID\$SubGroupGUID\$SettingGUID"
                        Entries = [System.Collections.ArrayList]@(
                            @{
                                Name  = 'ACSettingIndex'
                                Value = [int]$Action
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'DCSettingIndex'
                                Value = [int]$Action
                                Type  = 'DWord'
                            }
                        )
                    }

                    switch ($PowerSource)
                    {
                        'PluggedIn' { $ActionControl['Entries'].RemoveAt(1) }
                        'OnBattery' { $ActionControl['Entries'].RemoveAt(0) }
                    }

                    Set-RegistryEntrySystemProtected -InputObject $ActionControl
                }

                powercfg.exe -SetActive SCHEME_CURRENT
            }
            'ActionGPO'
            {
                $IsNotConfigured = $ActionGPO -eq 'NotConfigured'

                # Group Policy Editor does not allow to choose 'DisplayOff'.
                # It does work if we manually edit the registry and set the value to 4,
                # but it will not be reflected into the GUI, so it's not implemented.

                # gpo\ computer config > administrative tpl > system > power management > button settings
                #   Select the lid switch action (on battery)
                #   Select the lid switch action (plugged in)
                #   Select the Power button action (on battery)
                #   Select the Power button action (plugged in)
                #   Select the Sleep button action (on battery)
                #   Select the Sleep button action (plugged in)
                # not configured: delete (default) | on: Take no action (0), Sleep (1), Hibernate (2), Shut down (3)
                $ActionControlGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = "SOFTWARE\Policies\Microsoft\Power\PowerSettings\$SettingGUID"
                    Entries = [System.Collections.ArrayList]@(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ACSettingIndex'
                            Value = [int]$ActionGPO
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'DCSettingIndex'
                            Value = [int]$ActionGPO
                            Type  = 'DWord'
                        }
                    )
                }

                switch ($PowerSource)
                {
                    'PluggedIn' { $ActionControlGpo['Entries'].RemoveAt(1) }
                    'OnBattery' { $ActionControlGpo['Entries'].RemoveAt(0) }
                }

                Write-Verbose -Message "Setting '$ActionControlMsg (GPO)' to '$ActionGPO' ..."
                Set-RegistryEntry -InputObject $ActionControlGpo
            }
        }
    }
}
