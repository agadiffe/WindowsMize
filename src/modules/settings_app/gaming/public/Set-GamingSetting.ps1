#=================================================================================================================
#                                                Gaming - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-GamingSetting
        # game bar
        [-OpenGameBarWithController {Disabled | Enabled}]
        [-UseViewMenuAsGuideButtonInApps {Disabled | Enabled}]

        # captures
        [-GameRecording {Disabled | Enabled}]
        [-GameRecordingGPO {Disabled | NotConfigured}]

        # game mode
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
        # game bar
        [state] $OpenGameBarWithController,
        [state] $UseViewMenuAsGuideButtonInApps,

        # captures
        [state] $GameRecording,
        [GpoStateWithoutEnabled] $GameRecordingGPO,

        # game mode
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
            # game bar
            'OpenGameBarWithController'      { Set-GameBarOpenWithController -State $OpenGameBarWithController }
            'UseViewMenuAsGuideButtonInApps' { Set-GameBarUseViewMenuAsGuideButtonInApps -State $UseViewMenuAsGuideButtonInApps }

            # captures
            'GameRecording'                  { Set-GameRecording -State $GameRecording }
            'GameRecordingGPO'               { Set-GameRecording -GPO $GameRecordingGPO }

            # game mode
            'GameMode'                       { Set-GameMode -State $GameMode }
        }
    }
}
