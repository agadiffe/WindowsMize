#=================================================================================================================
#                                            Fullscreen Optimizations
#=================================================================================================================

# If your game doesn't run well, you might try to enable or disable Fullscreen optimizations.

# If you don't need/want to disable it system-wide, you can do it for specific application:
#   Right-click on the executable and click on Properties.
#   Click on the Compatibility tab.
#   Check or uncheck Disable fullscreen optimizations.

# If issues with color managment or alt + tab, set GameDVR_DXGIHonorFSEWindowsCompatible to 0 ?

# Recommendation: Default

<#
.SYNTAX
    Set-FullscreenOptimizations
        [-State] {Disabled | Enabled | Default}
        [<CommonParameters>]
#>

function Set-FullscreenOptimizations
{
    <#
    .EXAMPLE
        PS> Set-FullscreenOptimizations -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Disabled', 'Enabled', 'Default')]
        [string] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'
        $IsDisabled = $State -eq 'Disabled'

        # default: delete 0 0 delete 2 0
        # on: 0 0 1 0 0 0 | off: 2 1 0 2 2 1
        $FullscreenOptimizations = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'System\GameConfigStore'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Default'
                    Name  = 'GameDVR_DSEBehavior'
                    Value = $IsEnabled ? '0' : '2'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'GameDVR_DXGIHonorFSEWindowsCompatible'
                    Value = $IsDisabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'GameDVR_EFSEFeatureFlags'
                    Value = $IsEnabled ? '1' : '0'
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $State -eq 'Default'
                    Name  = 'GameDVR_FSEBehavior'
                    Value = $IsEnabled ? '0' : '2'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'GameDVR_FSEBehaviorMode'
                    Value = $IsEnabled ? '0' : '2'
                    Type  = 'DWord'
                }
                @{
                    Name  = 'GameDVR_HonorUserFSEBehaviorMode'
                    Value = $IsDisabled ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Fullscreen Optimizations' to '$State' ..."
        Set-RegistryEntry -InputObject $FullscreenOptimizations
    }
}

<#
source: internet

GameDVR_DSEBehavior:
  0: Game DVR can use full system resources for recording and broadcasting while in DSE.
  2: Limits Game DVR resource usage in DSE, potentially improving gaming performance.

GameDVR_DXGIHonorFSEWindowsCompatible:
  0: Game DVR can still record even if the game sets FSE on, potentially impacting performance.
  1: Game DVR respects the FSE flag and won't record while games are in true full-screen mode.

GameDVR_EFSEFeatureFlags:
  This key controls additional functionality related to Enhanced Full-screen Exclusive (EFSE), a newer version of FSE.
  Different bit values within the key enable or disable specific features.
  0: disabled | 1: enabled.
    Bit 0: Enables or disables EFSE mode.
    Bit 1: Enables or disables the use of DXGI flip model swap chains for EFSE mode.
    Bit 2: Enables or disables the use of DXGI swap chain scaling for EFSE mode.
    Bit 3: Enables or disables the use of DXGI swap chain color space support for EFSE mode.
    Bit 4: Enables or disables the use of DXGI swap chain HDR metadata support for EFSE mode.
    Bit 5: Enables or disables the use of DXGI swap chain overlay support for EFSE mode.
  There are probably more, better to leave this untouched or at least just enable/disable it.

GameDVR_FSEBehavior:
  0: Game DVR can use full system resources while games are full-screen.
  2: Limits Game DVR resource usage in full-screen games, potentially improving performance.

GameDVR_FSEBehaviorMode:
  0: Only applies GameDVR_FSEBehavior to games marked as "high impact" on your system.
  1: Applies GameDVR_FSEBehavior to all full-screen games.
  2: Disabled.

GameDVR_HonorUserFSEBehaviorMode:
  0: Uses the default mode.
  1: Forces application of GameDVR_FSEBehavior to all full-screen games.
#>
