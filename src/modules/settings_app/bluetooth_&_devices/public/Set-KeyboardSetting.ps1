#=================================================================================================================
#                                    Bluetooth & Devices > Keyboard - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardSetting
        [-AdjustBrightnessOnLightingChanges {Disabled | Enabled}]
        [-CharacterRepeatDelay <int>]
        [-CharacterRepeatRate <int>]
        [-CopilotAndWinCKeys <string>]
        [-PrintScreenKeyOpenScreenCapture {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardSetting
{
    <#
    .EXAMPLE
        PS> Set-KeyboardSetting -PrintScreenKeyOpenScreenCapture 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AdjustBrightnessOnLightingChanges,

        [ValidateRange(0, 3)]
        [int] $CharacterRepeatDelay,

        [ValidateRange(0, 31)]
        [int] $CharacterRepeatRate,

        [string] $CopilotAndWinCKeys,
        [state] $PrintScreenKeyOpenScreenCapture
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
            'AdjustBrightnessOnLightingChanges' { Set-KeyboardBrightnessAdjustOnLightingChanges -State $AdjustBrightnessOnLightingChanges }
            'CharacterRepeatDelay'              { Set-KeyboardCharacterRepeatDelay -Delay $CharacterRepeatDelay }
            'CharacterRepeatRate'               { Set-KeyboardCharacterRepeatRate -Speed $CharacterRepeatRate }
            'CopilotAndWinCKeys'                { Set-KeyboardCopilotAndWinCKeys -Name $CopilotAndWinCKeys }
            'PrintScreenKeyOpenScreenCapture'   { Set-KeyboardPrintScreenKeyOpenScreenCapture -State $PrintScreenKeyOpenScreenCapture }
        }
    }
}
