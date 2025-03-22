#=================================================================================================================
#                     System > Display > Brightness > Change Brightness When Lighting Changes
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayBrightnessAdjustOnLightingChanges
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DisplayBrightnessAdjustOnLightingChanges
{
    <#
    .DESCRIPTION
        Available with a built-in display (e.g. Laptop).

    .EXAMPLE
        PS> Set-DisplayBrightnessAdjustOnLightingChanges -State 'Disabled'
#>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # default: Enabled
        Write-Verbose -Message "Setting 'Display - Change Brightness When Lighting Changes' to '$State' ..."

        $SettingIndex = $State -eq 'Enabled' ? 1 : 0
        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT $SettingIndex
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_VIDEO ADAPTBRIGHT $SettingIndex
    }
}
