#=================================================================================================================
#                           System Properties - Advanced > Performance > Visual Effects
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl).
# To open the "Performance Options" window directly: SystemPropertiesPerformance.exe

# Select the settings you want to use for the appearance and performance of Windows on this computer.

<#
.SYNTAX
    Set-VisualEffects
        -Mode {ManagedByWindows | BestAppearance | BestPerformance | Custom}
        [<CommonParameters>]

    Set-VisualEffects
        -Mode Custom
        -Setting <VisualEffectsCustomSetting>
        [<CommonParameters>]

    Set-VisualEffects
        -Animation {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffects
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            [-Setting <VisualEffectsCustomSetting>] : available when 'Mode' is defined to 'Custom'.

    .EXAMPLE
        PS> Set-VisualEffects -Mode 'ManagedByWindows'

    .EXAMPLE
        PS> Set-VisualEffects -Animation 'Enabled'

    .EXAMPLE
        PS> $VisualEffectsCustomSettings = @{
                'Animations in the taskbar'       = 'Enabled'
                'Enable Peek'                     = 'Enabled'
                'Save taskbar thumbnail previews' = 'Disabled'
            }
        PS> Set-VisualEffects -Mode 'Custom' -Setting $VisualEffectsCustomSettings
    #>

    [CmdletBinding(DefaultParameterSetName = 'Mode')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Mode')]
        [ValidateSet('ManagedByWindows', 'BestAppearance', 'BestPerformance', 'Custom')]
        [string] $Mode,

        [Parameter(Mandatory, ParameterSetName = 'Animation')]
        [state] $Animation
    )

    dynamicparam
    {
        if ($Mode -eq 'Custom')
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Name       = 'Setting'
                Type       = [VisualEffectsCustomSetting]
            }
            Add-DynamicParameter @DynamicParamProperties
            $ParamDictionary
        }
    }

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Animation')
        {
            # default: on | off: disable the following effects.
            # The GUI toggle is controlled only by the state of 'Animate controls and elements inside windows' ... (bug or bad design?)
            $VisualEffectsCustomSettings = @{
                'Animate controls and elements inside windows'   = $Animation
                'Animate windows when minimizing and maximizing' = $Animation
                'Fade or slide menus into view'                  = $Animation
                'Fade or slide ToolTips into view'               = $Animation
                'Fade out menu items after clicking'             = $Animation
                'Slide open combo boxes'                         = $Animation
                'Smooth-scroll list boxes'                       = $Animation
            }

            Set-VisualEffectsCustomSetting -Setting $VisualEffectsCustomSettings
        }
        else
        {
            $ModeValue = switch ($Mode)
            {
                'ManagedByWindows' { '0' }
                'BestAppearance'   { '1' }
                'BestPerformance'  { '2' }
                'Custom'           { '3' }
            }

            # let windows choose what's best for my computer: 0 (default)
            # adjust for best appearance: 1 | adjust for best performance: 2 | custom: 3
            $VisualEffectsReg = @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects'
                Entries = @(
                    @{
                        Name  = 'VisualFXSetting'
                        Value = $ModeValue
                        Type  = 'DWord'
                    }
                )
            }

            Write-Verbose -Message "Setting 'Visual Effects' to '$Mode' ..."
            Set-RegistryEntry -InputObject $VisualEffectsReg

            if ($PSBoundParameters.ContainsKey('Setting'))
            {
                Set-VisualEffectsCustomSetting -Setting $PSBoundParameters['Setting']
            }
        }
    }
}
