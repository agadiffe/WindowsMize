#=================================================================================================================
#                                       System > Display > Sound - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-SoundSetting
        [-MonoAudio {Disabled | Enabled}]
        [-AdjustVolumeOnCommunication {DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent |
                                       ReduceOtherSoundsBy50Percent}]
        [<CommonParameters>]
#>

function Set-SoundSetting
{
    <#
    .EXAMPLE
        PS> Set-SoundSetting -MonoAudio 'Disabled' -AdjustVolumeOnCommunication 'DoNothing'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $MonoAudio,
        [AdjustVolumeMode] $AdjustVolumeOnCommunication
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
            'MonoAudio'                   { Set-SoundMonoAudio -State $MonoAudio }
            'AdjustVolumeOnCommunication' { Set-SoundAdjustVolumeOnCommunication -Preference $AdjustVolumeOnCommunication }
        }
    }
}
