#=================================================================================================================
#                                    Bluetooth & Devices > Keyboard - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardSetting
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
            'CharacterRepeatDelay'            { Set-KeyboardCharacterRepeatDelay -Value $CharacterRepeatDelay }
            'CharacterRepeatRate'             { Set-KeyboardCharacterRepeatRate -Value $CharacterRepeatRate }
            'CopilotAndWinCKeys'              { Set-KeyboardCopilotAndWinCKeys -Name $CopilotAndWinCKeys }
            'PrintScreenKeyOpenScreenCapture' { Set-KeyboardPrintScreenKeyOpenScreenCapture -State $PrintScreenKeyOpenScreenCapture }
        }
    }
}
