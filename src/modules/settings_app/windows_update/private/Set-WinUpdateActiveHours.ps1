#=================================================================================================================
#                                          Windows Update > Active Hours
#=================================================================================================================

# Values use 24H clock format (0 to 23).
# The max active hours range is 18 hours from the active hours start time.

# If GPO is defined, it will remove the setting from the GUI page and disable 'Get me up to date'.

<#
.SYNTAX
    Set-WinUpdateActiveHours
        [[-Mode] {Automatically | Manually}]
        [-GPO {Enabled | NotConfigured}]
        -Start <int>
        -End <int>
        [<CommonParameters>]
#>

function Set-WinUpdateActiveHours
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            -Start <int> & -End <int> : (range 0-23) available when 'Mode' is 'Manually' or 'GPO' is 'Enabled'.

    .EXAMPLE
        PS> Set-WinUpdateActiveHours -Mode 'Manually' -Start 7 -End 23
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [ActiveHoursMode] $Mode,

        [GpoStateWithoutDisabled] $GPO
    )

    dynamicparam
    {
        if ($Mode -eq 'Manually' -or $GPO -eq 'Enabled')
        {
            $DynParameter = 'Start', 'End'

            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynParameter | ForEach-Object -Process {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = $_
                    Type       = [int]
                    Attribute  = @{ Parameter = @{ Mandatory = $true }; ValidateRange = 0, 23 }
                }
                Add-DynamicParameter @DynamicParamProperties
            }
            $ParamDictionary
        }
    }

    process
    {
        if ($Mode -eq 'Manually' -or $GPO -eq 'Enabled')
        {
            $Diff = ($PSBoundParameters.End - $PSBoundParameters.Start + 24) % 24
            if ($Diff -notin 1..18)
            {
                Write-Error -Message 'Choose an end time that''s no more than 18 hours from the start time.'
                return
            }
        }

        $WinUpdateActiveHoursMsg = 'Windows Update - Active Hours'

        switch ($PSBoundParameters.Keys)
        {
            'Mode'
            {
                # automatically: 1 (default) | manually: 0
                $WinUpdateActiveHoursMode = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                    Entries = @(
                        @{
                            Name  = 'SmartActiveHoursState'
                            Value = $Mode -eq 'Automatically' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$WinUpdateActiveHoursMsg Mode' to '$Mode' ..."
                Set-RegistryEntry -InputObject $WinUpdateActiveHoursMode


                if ($Mode -eq 'Manually')
                {
                    $WinUpdateActiveHours = @{
                        Hive    = 'HKEY_LOCAL_MACHINE'
                        Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
                        Entries = @(
                            @{
                                Name  = 'ActiveHoursStart'
                                Value = $PSBoundParameters.Start
                                Type  = 'DWord'
                            }
                            @{
                                Name  = 'ActiveHoursEnd'
                                Value = $PSBoundParameters.End
                                Type  = 'DWord'
                            }
                        )
                    }

                    $ActiveHoursState = "Start: $($PSBoundParameters.Start), End: $($PSBoundParameters.End)"

                    Write-Verbose -Message "Setting '$WinUpdateActiveHoursMsg' to '$ActiveHoursState' ..."
                    Set-RegistryEntry -InputObject $WinUpdateActiveHours
                }
            }
            'GPO'
            {
                $IsNotConfigured = $GPO -eq 'NotConfigured'

                # gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
                #   turn off auto-restart for updates during active hours
                # not configured: delete (default) | manually: 1 + define ActiveHours
                $WinUpdateActiveHoursGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate'
                    Entries = @(
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'SetActiveHours'
                            Value = '1'
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ActiveHoursStart'
                            Value = $PSBoundParameters.Start
                            Type  = 'DWord'
                        }
                        @{
                            RemoveEntry = $IsNotConfigured
                            Name  = 'ActiveHoursEnd'
                            Value = $PSBoundParameters.End
                            Type  = 'DWord'
                        }
                    )
                }

                $ActiveHoursState = if ($GPO -eq 'Enabled') { ", Start: $($PSBoundParameters.Start), End: $($PSBoundParameters.End)" }

                Write-Verbose -Message "Setting '$WinUpdateActiveHoursMsg (GPO)' to '$GPO$ActiveHoursState' ..."
                Set-RegistryEntry -InputObject $WinUpdateActiveHoursGpo
            }
        }
    }
}
