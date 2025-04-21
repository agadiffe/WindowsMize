#=================================================================================================================
#                           System Properties - Advanced > Performance > Visual Effects
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# Select the settings you want to use for the appearance and performance of Windows on this computer.

<#
.SYNTAX
    Set-VisualEffects
        [-Value] {ManagedByWindows | BestAppearance | BestPerformance | Custom | Animation}
        [[-Setting] <VisualEffectsCustomSetting>]
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffects
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            [[-Setting] <VisualEffectsCustomSetting>] : available when 'Value' is defined to 'Custom'.
            [-State] {Disabled | Enabled} : available when 'Value' is defined to 'Animation'.

    .EXAMPLE
        PS> Set-VisualEffects -Value 'ManagedByWindows'

    .EXAMPLE
        PS> Set-VisualEffects -Value 'Animation' -State 'Enabled'

    .EXAMPLE
        PS> $VisualEffectsCustomSettings = @{
                'Animations in the taskbar'       = 'Enabled'
                'Enable Peek'                     = 'Enabled'
                'Save taskbar thumbnail previews' = 'Disabled'
            }
        PS> Set-VisualEffects -Value 'Custom' -Setting $VisualEffectsCustomSettings
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('ManagedByWindows', 'BestAppearance', 'BestPerformance', 'Custom', 'Animation')]
        [string] $Value
    )

    dynamicparam
    {
        if ($Value -eq 'Custom' -or $Value -eq 'Animation')
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Attribute  = @{ Parameter = @{ Position = 1 } }
            }

            switch ($Value)
            {
                'Custom'
                {
                    $DynamicParamProperties += @{
                        Name = 'Setting'
                        Type = [VisualEffectsCustomSetting]
                    }
                }
                'Animation'
                {
                    $DynamicParamProperties += @{
                        Name = 'State'
                        Type = [state]
                    }
                    $DynamicParamProperties.Attribute.Parameter += @{ Mandatory = $true }
                }
            }

            Add-DynamicParameter @DynamicParamProperties
            $ParamDictionary
        }
    }

    process
    {
        if ($Value -eq 'Animation')
        {
            $State = $PSBoundParameters.State

            # default: on | off: disable the following effects.
            # (The GUI toggle will be 'on' if at least one of these effects is enabled)
            $VisualEffectsCustomSettings = @{
                'Animate controls and elements inside windows'   = $State
                'Animate windows when minimizing and maximizing' = $State
                'Fade or slide menus into view'                  = $State
                'Fade or slide ToolTips into view'               = $State
                'Fade out menu items after clicking'             = $State
                'Slide open combo boxes'                         = $State
                'Smooth-scroll list boxes'                       = $State
            }

            Set-VisualEffectsCustomSetting -Setting $VisualEffectsCustomSettings
        }
        else
        {
            $ValueSetting = switch ($Value)
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
                        Value = $ValueSetting
                        Type  = 'DWord'
                    }
                )
            }

            Write-Verbose -Message "Setting 'Visual Effects' to '$Value' ..."
            Set-RegistryEntry -InputObject $VisualEffectsReg

            if ($PSBoundParameters.ContainsKey('Setting'))
            {
                Set-VisualEffectsCustomSetting -Setting $PSBoundParameters.Setting
            }
        }
    }
}
