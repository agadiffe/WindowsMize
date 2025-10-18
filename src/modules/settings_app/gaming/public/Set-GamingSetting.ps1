#=================================================================================================================
#                                                Gaming - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-GamingSetting
        [-OpenGameBarWithController {Disabled | Enabled}]
        [-GuideButtonInApps {Disabled | Enabled}]
        [-GameRecording {Disabled | Enabled}]
        [-GameRecordingGPO {Disabled | NotConfigured}]
        [-GameMode {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-GamingSetting
{
    <#
    .EXAMPLE
        PS> Set-GamingSetting -OpenGameBarWithController 'Disabled' -GameRecordingGPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $OpenGameBarWithController,

        [state] $GuideButtonInApps,

        [state] $GameRecording,

        [GpoStateWithoutEnabled] $GameRecordingGPO,

        [state] $GameMode
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
            'OpenGameBarWithController' { Set-GameBarOpenWithController -State $OpenGameBarWithController }
            'GuideButtonInApps'         { Set-GameBarGuideButtonInApps -State $GuideButtonInApps }
            'GameRecording'             { Set-GameRecording -State $GameRecording }
            'GameRecordingGPO'          { Set-GameRecording -GPO $GameRecordingGPO }
            'GameMode'                  { Set-GameMode -State $GameMode }
        }
    }
}
