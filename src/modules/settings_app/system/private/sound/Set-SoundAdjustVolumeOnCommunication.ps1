#=================================================================================================================
#                              System > Sound > More Sound Settings > Communications
#=================================================================================================================

# sound properties (mmsys.cpl) > communications > when Windows detects communications activity

<#
.SYNTAX
    Set-SoundAdjustVolumeOnCommunication
        [-Preference] {DoNothing | MuteOtherSounds | ReduceOtherSoundsBy80Percent | ReduceOtherSoundsBy50Percent}
        [<CommonParameters>]
#>

function Set-SoundAdjustVolumeOnCommunication
{
    <#
    .EXAMPLE
        PS> Set-SoundAdjustVolumeOnCommunication -Preference 'DoNothing'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AdjustVolumeMode] $Preference
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
                    Value = [int]$Preference
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sound - When Windows Detects Communications Activity' to '$Preference' ..."
        Set-RegistryEntry -InputObject $SoundVolumeCommunicationsActivity
    }
}
