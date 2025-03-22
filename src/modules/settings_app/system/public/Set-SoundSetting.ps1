#=================================================================================================================
#                                       System > Display > Sound - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-SoundSetting
        [-AdjustVolumeOnCommunication {DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent |
                                       ReduceOtherSoundsBy50Percent}]
        [<CommonParameters>]
#>

function Set-SoundSetting
{
    <#
    .EXAMPLE
        PS> Set-SoundSetting -AdjustVolumeOnCommunication 'DoNothing'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
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
            'AdjustVolumeOnCommunication' { Set-SoundAdjustVolumeOnCommunication -Value $AdjustVolumeOnCommunication }
        }
    }
}
