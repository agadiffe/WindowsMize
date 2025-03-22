#=================================================================================================================
#                                             Windows Photos Setting
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsPhotosSetting
        [-RunAtStartup {Disabled | Enabled}]
        [-ShowGalleryTilesAttributes {Disabled | Enabled}]
        [-LocationBasedFeatures {Disabled | Enabled}]
        [-ShowICloudPhotos {Disabled | Enabled}]
        [-DeleteConfirmationDialog {Disabled | Enabled}]
        [-MouseWheelBehavior {ZoomInOut | NextPreviousItems}]
        [-ZoomPreference {FitWindow | ViewActualSize}]
        [-Theme {System | Light | Dark}]
        [<CommonParameters>]
#>

function Set-WindowsPhotosSetting
{
    <#
    .EXAMPLE
        PS> Set-WindowsPhotosSetting -Theme 'Dark' -ZoomPreference 'FitWindow' -RunAtStartup 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $RunAtStartup,
        [state] $ShowGalleryTilesAttributes,
        [state] $LocationBasedFeatures,
        [state] $ShowICloudPhotos,
        [state] $DeleteConfirmationDialog,

        [ValidateSet('ZoomInOut', 'NextPreviousItems')]
        [string] $MouseWheelBehavior,

        [ValidateSet('FitWindow', 'ViewActualSize')]
        [string] $ZoomPreference,

        [ValidateSet('System', 'Light', 'Dark')]
        [string] $Theme
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $WindowsPhotosSettings = [System.Collections.ArrayList]::new()

        switch ($PSBoundParameters.Keys)
        {
            'RunAtStartup'
            {
                # Run in the background at startup
                #   There is a registry key in the settings file: IsBackgroundProcessEnabled (5f5e10b).
                #   But it will be applied only when Photos is launched.
                #   So let's use the below registry entry instead.

                # on: 2 (default) | off: 1
                $RunAtStartupReg = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\SystemAppData\Microsoft.Windows.Photos_8wekyb3d8bbwe\PhotosStartupTaskId'
                    Entries = @(
                        @{
                            Name  = 'State'
                            Value = $RunAtStartup -eq 'Enabled' ? '2' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Windows Photos - Run In The Background At Startup' to '$RunAtStartup' ..."
                Set-RegistryEntry -InputObject $RunAtStartupReg
            }
            'ShowGalleryTilesAttributes'
            {
                # on: true (default) | off: false
                $GalleryTilesAttributesReg = @{
                    Name  = 'GalleryAttributionDisplayStatus'
                    Value = $GalleryTilesAttributes -eq 'Enabled' ? 'true' : 'false'
                    Type  = '5f5e10c'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$GalleryTilesAttributesReg) | Out-Null
            }
            'LocationBasedFeatures'
            {
                # on: true | off: false (default)
                $LocationBasedFeaturesReg = @{
                    Name  = 'GeolocationConsent'
                    Value = $LocationBasedFeatures -eq 'Enabled' ? 'true' : 'false'
                    Type  = '5f5e10c'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$LocationBasedFeaturesReg) | Out-Null
            }
            'ShowICloudPhotos'
            {
                # on: true (default) | off: false
                $ICloudPhotosReg = @{
                    Name  = 'ICloudPhotosDisplayStatus'
                    Value = $ShowICloudPhotos -eq 'Enabled' ? 'true' : 'false'
                    Type  = '5f5e10c'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$ICloudPhotosReg) | Out-Null
            }
            'DeleteConfirmationDialog'
            {
                # on: 0 (default) | off: 1
                $DeleteConfirmationDialogReg = @{
                    Name  = 'DeleteConfirmationDialogStatus'
                    Value = $DeleteConfirmationDialog -eq 'Enabled' ? '0' : '1'
                    Type  = '5f5e10b'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$DeleteConfirmationDialogReg) | Out-Null
            }
            'MouseWheelBehavior'
            {
                # zoom in or out: 0 (default) | view next or previous items: 1
                $MouseWheelBehaviorReg = @{
                    Name  = 'MouseWheelControl'
                    Value = $MouseWheelBehavior -eq 'ZoomInOut' ? '0' : '1'
                    Type  = '5f5e104'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$MouseWheelBehaviorReg) | Out-Null
            }
            'ZoomPreference'
            {
                # zoom to fit in window: 0 | view at actual size: 1 (default)
                $ZoomPreferenceReg = @{
                    Name  = 'SmallMediaDefaultZoomLevel'
                    Value = $ZoomPreference -eq 'FitWindow' ? '0' : '1'
                    Type  = '5f5e104'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$ZoomPreferenceReg) | Out-Null
            }
            'Theme'
            {
                $ThemeValue = switch ($Theme)
                {
                    'System' { '0' }
                    'Light'  { '1' }
                    'Dark'   { '2' }
                }

                # light: 1 | dark: 2 (default) | Windows default: 0
                $ThemeReg = @{
                    Name  = 'AppBackgroundRequestedTheme'
                    Value = $ThemeValue
                    Type  = '5f5e104'
                }
                $WindowsPhotosSettings.Add([PSCustomObject]$ThemeReg) | Out-Null
            }
        }

        if (-not ($PSBoundParameters.Keys.Count -eq 1 -and $PSBoundParameters.Keys.Contains(('RunAtStartup'))))
        {
            Set-UwpAppSetting -Name 'WindowsPhotos' -Setting $WindowsPhotosSettings
        }
    }
}
