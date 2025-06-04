#=================================================================================================================
#                            Personnalization > Background > Picture > Choose A Photo
#=================================================================================================================

# Default: Windows spotlight

# Default images location: C:\Windows\Web\Wallpaper
# ThemeA: Glow, ThemeB: Captured Motion, ThemeC: Sunrive, ThemeD: Flow

<#
.SYNTAX
    Set-BackgroundWallpaper
        [-FilePath] <string>
        [<CommonParameters>]
#>

function Set-BackgroundWallpaper
{
    <#
    .EXAMPLE
        PS> Set-BackgroundWallpaper -FilePath "$env:SystemRoot\Web\Wallpaper\ThemeC\img30.jpg"
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath
    )

    process
    {
        $BackgroundWallpaper = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers'
                Entries = @(
                    @{
                        Name  = 'BackgroundType'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\CurrentVersion\DesktopSpotlight\Settings'
                Entries = @(
                    @{
                        Name  = 'EnabledState'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Control Panel\Desktop'
                Entries = @(
                    @{
                        Name  = 'WallPaper'
                        Value = $FilePath
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Background Picture - Choose A Photo' to '$FilePath' ..."
        $BackgroundWallpaper | Set-RegistryEntry
    }
}
