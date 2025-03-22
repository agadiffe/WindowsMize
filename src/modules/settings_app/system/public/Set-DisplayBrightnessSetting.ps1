#=================================================================================================================
#                                     System > Display - Brightness Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayBrightnessSetting
        [-Brightness <int>]
        [-AdjustBasedOnContent {Disabled | Enabled | BatteryOnly}]
        [-AdjustOnLightingChanges {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-DisplayBrightnessSetting
{
    <#
    .EXAMPLE
        PS> Set-DisplayBrightnessSetting -Brightness 70 -AdjustBasedOnContent 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [ValidateRange(0, 100)]
        [int] $Brightness,

        [BrightnessContentState] $AdjustBasedOnContent,

        [state] $AdjustOnLightingChanges
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'Brightness'              { Set-DisplayBrightness -Value $Brightness }
            'AdjustBasedOnContent'    { Set-DisplayBrightnessAdjustBasedOnContent -State $AdjustBasedOnContent }
            'AdjustOnLightingChanges' { Set-DisplayBrightnessAdjustOnLightingChanges -State $AdjustOnLightingChanges }
        }
    }
}
