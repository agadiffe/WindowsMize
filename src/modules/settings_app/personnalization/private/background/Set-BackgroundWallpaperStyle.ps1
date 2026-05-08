#=================================================================================================================
#                  Personnalization > Background > Picture > Choose A Fit For Your Desktop Image
#=================================================================================================================

<#
.SYNTAX
    Set-BackgroundWallpaperStyle
        [-Style] {Fill | Fit | Stretch | Span | Tile | Center}
        [<CommonParameters>]
#>

function Set-BackgroundWallpaperStyle
{
    <#
    .EXAMPLE
        PS> Set-BackgroundWallpaperStyle -Style 'Fill'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [WallpaperFitMode] $Style
    )

    process
    {
        # fill: 10 0 (default) | fit: 6 0 | stretch: 2 0 | span: 22 0 | tile: 0 1 | center: 0 0
        $BackgroundWallpaperStyle = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'WallpaperStyle'
                    Value = [int]$Style
                    Type  = 'String'
                }
                @{
                    Name  = 'TileWallpaper'
                    Value = $Style -eq 'Tile' ? '1' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Background Picture - Choose A Fit For Your Desktop Image' to '$Style' ..."
        Set-RegistryEntry -InputObject $BackgroundWallpaperStyle
    }
}
