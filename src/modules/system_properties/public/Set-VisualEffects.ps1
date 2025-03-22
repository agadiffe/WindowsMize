#=================================================================================================================
#                           System Properties - Advanced > Performance > Visual Effects
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# Select the settings you want to use for the appearance and performance of Windows on this computer.

<#
.SYNTAX
    Set-VisualEffects
        [-State] {ManagedByWindows | BestAppearance | BestPerformance | Custom}
        [[-Setting] <VisualEffectsCustomSetting>]
        [<CommonParameters>]
#>

function Set-VisualEffects
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            [[-Setting] <VisualEffectsCustomSetting>] : available when 'State' is defined to 'Custom'.

    .EXAMPLE
        PS> Set-VisualEffects -State 'ManagedByWindows'

    .EXAMPLE
        PS> $VisualEffectsCustomSettings = @{
                'Animations in the taskbar'       = 'Enabled'
                'Enable Peek'                     = 'Enabled'
                'Save taskbar thumbnail previews' = 'Disabled'
            }
        PS> Set-VisualEffects -State 'Custom' -Setting $VisualEffectsCustomSettings
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('ManagedByWindows', 'BestAppearance', 'BestPerformance', 'Custom')]
        [string] $State
    )

    dynamicparam
    {
        if ($State -eq 'Custom')
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Name       = 'Setting'
                Type       = [VisualEffectsCustomSetting]
                Attribute  = @{ Parameter = @{ Position = 1 } }
            }
            Add-DynamicParameter @DynamicParamProperties
            $ParamDictionary
        }
    }

    process
    {
        $Value = switch ($State)
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
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Visual Effects' to '$State' ..."
        Set-RegistryEntry -InputObject $VisualEffectsReg

        if ($PSBoundParameters.ContainsKey('Setting'))
        {
            Set-VisualEffectsCustomSetting -Setting $PSBoundParameters.Setting
        }
    }
}
