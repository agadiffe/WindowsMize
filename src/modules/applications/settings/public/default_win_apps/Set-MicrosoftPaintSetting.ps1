#=================================================================================================================
#                                             Microsoft Paint Setting
#=================================================================================================================

<#
.SYNTAX
    Set-MicrosoftPaintSetting
        # appearance
        [-Theme {System | Light | Dark}]

        # ai
        [-AIWatermark {Never | Always | Ask}]

        # image properties
        [-Unit {Pixels | Inches | Centimeters}]
        [-ImageWidthPixel <int>]
        [-ImageHeightPixel <int>]

        # view
        [-Rulers {Disabled | Enabled}]
        [-Gridlines {Disabled | Enabled}]
        [-StatusBar {Disabled | Enabled}]
        [-AutoHideToolbar {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MicrosoftPaintSetting
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftPaintSetting -Theme 'System' -AIWatermark 'Never'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # appearance
        [ValidateSet('System', 'Light', 'Dark')]
        [string] $Theme,

        # ai
        [ValidateSet('Never', 'Always', 'Ask')]
        [string] $AIWatermark,

        # image properties
        [ValidateSet('Pixels', 'Inches', 'Centimeters')]
        [string] $Unit,

        [ValidateRange(1, 99999)]
        [int] $ImageWidthPixel,

        [ValidateRange(1, 99999)]
        [int] $ImageHeightPixel,

        # view
        [state] $Rulers,
        [state] $Gridlines,
        [state] $StatusBar,
        [state] $AutoHideToolbar
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $AppxPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\Packages\Microsoft.Paint_8wekyb3d8bbwe"
        $AppxSettingsFilePath = "$AppxPath\Settings\settings.dat"

        if (-not (Test-Path -Path $AppxSettingsFilePath))
        {
            Write-Verbose -Message "Microsoft Paint is not installed (settings.dat not found)"
            return
        }

        # The app could be open or running in background.
        $ProcessName = 'mspaint'
        Stop-Process -Name $ProcessName -Force -ErrorAction 'SilentlyContinue'
        Wait-Process -Name $ProcessName -ErrorAction 'SilentlyContinue'

        $HeliumUserSettingFilePath = "$AppxPath\SystemAppData\Helium\User.dat"

        # User.dat file doesn't exist if Paint has never be launched.
        if (-not (Test-Path -Path $HeliumUserSettingFilePath))
        {
            $Proc = Start-Process -FilePath $ProcessName -WindowStyle 'Hidden' -PassThru
            $Proc.WaitForInputIdle() | Out-Null
            Start-Sleep -Seconds 1

            Stop-Process -Name $ProcessName -Force
            Wait-Process -Name $ProcessName -ErrorAction 'SilentlyContinue'
        }

        # User.dat file is not instantly unlocked after process termination.
        try
        {
            Wait-FileUnlock -FilePath $HeliumUserSettingFilePath -TimeoutSeconds 3
        }
        catch
        {
            Write-Error -Message "Microsoft Paint : $($_.Exception.Message) Setting not applied."
            return
        }

        $AppSettingsRegHive = 'HKEY_USERS'
        $AppSettingsRegKey = 'UWP_APP_SETTINGS_4242'
        $AppSettingsRegPath = "$AppSettingsRegHive\$AppSettingsRegKey"

        reg.exe UNLOAD $AppSettingsRegPath 2>&1 | Out-Null
        reg.exe LOAD $AppSettingsRegPath $HeliumUserSettingFilePath | Out-Null

        switch ($PSBoundParameters.Keys)
        {
            #region appearance
            #---------------
            'Theme'
            {
                $ThemeValue = switch ($Theme)
                {
                    'System' { '0' }
                    'Light'  { '1' }
                    'Dark'   { '2' }
                }

                # light: 1 | dark: 2 | use system setting: 0 (default)
                $ThemeReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'ThemeSetting'
                            Value = $ThemeValue
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Theme' to '$Theme' ..."
                Set-RegistryEntry -InputObject $ThemeReg

            }
            #endregion appearance

            #region ai
            #---------------
            'AIWatermark'
            {
                $WatermarkValue = switch ($AIWatermark)
                {
                    'Never'  { '0' }
                    'Always' { '1' }
                    'Ask'    { '2' }
                }

                # never: 0 (default) | always: 1 | ask: 2
                $AIWatermarkReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'WatermarkSetting'
                            Value = $WatermarkValue
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - AI Watermark' to '$AIWatermark' ..."
                Set-RegistryEntry -InputObject $AIWatermarkReg
            }
            #endregion ai

            #region image properties
            #---------------
            'Unit'
            {
                $UnitValue = switch ($Unit)
                {
                    'Pixels'      { '0' }
                    'Inches'      { '1' }
                    'Centimeters' { '2' }
                }

                # pixels: 0 (default) | inches: 1 | centimeters: 2
                $UnitReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'UnitSetting'
                            Value = $UnitValue
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Unit' to '$Unit' ..."
                Set-RegistryEntry -InputObject $UnitReg
            }
            'ImageWidthPixel'
            {
                # value is in pixel
                # default: 1152 (range: 1-99999)
                $ImageWidthReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'BMPWidth'
                            Value = $ImageWidthPixel
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Image Width' to '$ImageWidthPixel' ..."
                Set-RegistryEntry -InputObject $ImageWidthReg
            }
            'ImageHeightPixel'
            {
                # value is in pixel
                # default: 648 (range: 1-99999)
                $ImageHeightReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'BMPHeight'
                            Value = $ImageHeightPixel
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Image Width' to '$ImageHeightPixel' ..."
                Set-RegistryEntry -InputObject $ImageHeightReg
            }
            #endregion image properties

            #region view
            #---------------
            'Rulers'
            {
                # on: 1 | off: 0 (default)
                $RulersReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'ShowRulers'
                            Value = $Rulers -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Rulers' to '$Rulers' ..."
                Set-RegistryEntry -InputObject $RulersReg
            }
            'Gridlines'
            {
                # on: 1 | off: 0 (default)
                $GridlinesReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'ShowGrid'
                            Value = $Gridlines -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Gridlines' to '$Gridlines' ..."
                Set-RegistryEntry -InputObject $GridlinesReg
            }
            'StatusBar'
            {
                # on: 1 (default) | off: 0
                $StatusBarReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'ShowStatusBar'
                            Value = $StatusBar -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Status Bar' to '$StatusBar' ..."
                Set-RegistryEntry -InputObject $StatusBarReg
            }
            'AutoHideToolbar'
            {
                # on: 1 | off: 0 (default)
                $AutoHideToolbarReg = @{
                    Hive    = $AppSettingsRegHive
                    Path    = "$AppSettingsRegKey\Software\Microsoft\Windows\CurrentVersion\Applets\Paint\View"
                    Entries = @(
                        @{
                            Name  = 'RibbonDisplayMode'
                            Value = $AutoHideToolbar -eq 'Enabled' ? '1' : '0'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting 'Microsoft Paint - Auto Hide Toolbar' to '$AutoHideToolbar' ..."
                Set-RegistryEntry -InputObject $AutoHideToolbarReg
            }
            #endregion view
        }

        reg.exe UNLOAD $AppSettingsRegPath | Out-Null
    }
}
