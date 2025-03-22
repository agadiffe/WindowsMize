#=================================================================================================================
#                                    Personnalization > Background - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-BackgroundSetting
        [-Wallpaper <string>]
        [-WallpaperStyle {Fill | Fit | Stretch | Span | Tile | Center}]
        [<CommonParameters>]
#>

function Set-BackgroundSetting
{
    <#
    .EXAMPLE
        PS> Set-BackgroundSetting -Wallpaper 'X:\MyAwesomePicture.jpg' -WallpaperStyle 'Fill'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [string] $Wallpaper,

        [WallpaperFitMode] $WallpaperStyle
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
            'Wallpaper'      { Set-BackgroundWallpaper -FilePath $Wallpaper }
            'WallpaperStyle' { Set-BackgroundWallpaperStyle -Value $WallpaperStyle }
        }
    }
}
