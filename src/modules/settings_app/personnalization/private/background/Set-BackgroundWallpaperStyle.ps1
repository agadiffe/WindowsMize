#=================================================================================================================
#                  Personnalization > Background > Picture > Choose A Fit For Your Desktop Image
#=================================================================================================================

<#
.SYNTAX
    Set-BackgroundWallpaperStyle
        [-Value] {Fill | Fit | Stretch | Span | Tile | Center}
        [<CommonParameters>]
#>

function Set-BackgroundWallpaperStyle
{
    <#
    .EXAMPLE
        PS> Set-BackgroundWallpaperStyle -Value 'Fill'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [WallpaperFitMode] $Value
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
                    Value = [int]$Value
                    Type  = 'String'
                }
                @{
                    Name  = 'TileWallpaper'
                    Value = $Value -eq 'Tile' ? '1' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Background Picture - Choose A Fit For Your Desktop Image' to '$Value' ..."
        Set-RegistryEntry -InputObject $BackgroundWallpaperStyle
    }
}
