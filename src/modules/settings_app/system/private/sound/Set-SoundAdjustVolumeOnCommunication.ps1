#=================================================================================================================
#                              System > Sound > More Sound Settings > Communications
#=================================================================================================================

# sound properties (mmsys.cpl) > communications > when Windows detects communications activity

<#
.SYNTAX
    Set-SoundAdjustVolumeOnCommunication
        [-Value] {DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent | ReduceOtherSoundsBy50Percent}
        [<CommonParameters>]
#>

function Set-SoundAdjustVolumeOnCommunication
{
    <#
    .EXAMPLE
        PS> Set-SoundAdjustVolumeOnCommunication -Value 'DoNothing'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdjustVolumeMode] $Value
    )

    process
    {
        # mute all other sounds: 0
        # reduce the volume of the other sounds by 80%: 1 (default)
        # reduce the volume of the other sounds by 50%: 2
        # do nothing: 3
        $SoundVolumeCommunicationsActivity = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Multimedia\Audio'
            Entries = @(
                @{
                    Name  = 'UserDuckingPreference'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sound - When Windows Detects Communications Activity' to '$Value' ..."
        Set-RegistryEntry -InputObject $SoundVolumeCommunicationsActivity
    }
}
