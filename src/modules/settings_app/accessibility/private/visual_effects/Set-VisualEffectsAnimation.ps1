#=================================================================================================================
#                               Accessibility > Visual Effects > Animation Effects
#=================================================================================================================

<#
.SYNTAX
    Set-VisualEffectsAnimation
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsAnimation
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsAnimation -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Visual Effects - Animation Effects' to '$State' ..."

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

        Set-VisualEffects -State 'Custom' -Setting $VisualEffectsCustomSettings
        Write-Verbose -Message "End of Setting 'Visual Effects - Animation Effects'"
    }
}
