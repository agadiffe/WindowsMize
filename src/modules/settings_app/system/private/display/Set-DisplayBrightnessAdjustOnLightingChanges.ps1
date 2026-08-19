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
        Write-Verbose -Message "Setting 'Display - Change Brightness When Lighting Changes' to '$State' ..."

        # SUB_VIDEO: '7516b95f-f776-4464-8c53-06167f40cc99'
        # ADAPTBRIGHT: 'fbd9aa66-9553-4097-ba44-ed6e9d65eab8'

        $SettingIndex = $State -eq 'Enabled' ? 1 : 0
        $PowerPlanGUID = Get-PowerPlanGUID

        foreach ($GUID in $PowerPlanGUID)
        {
            # default: Enabled (1)
            powercfg.exe -SetACValueIndex $GUID SUB_VIDEO ADAPTBRIGHT $SettingIndex
            powercfg.exe -SetDCValueIndex $GUID SUB_VIDEO ADAPTBRIGHT $SettingIndex
        }
        
        powercfg.exe -SetActive SCHEME_CURRENT
    }
}
