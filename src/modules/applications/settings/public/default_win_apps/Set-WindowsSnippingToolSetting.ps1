#=================================================================================================================
#                                          Windows Snipping Tool Setting
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsSnippingToolSetting
        [-AutoCopyScreenshotChangesToClipboard {Disabled | Enabled}]
        [-AutoSaveScreenshots {Disabled | Enabled}]
        [-AskToSaveEditedScreenshots {Disabled | Enabled}]
        [-MultipleWindows {Disabled | Enabled}]
        [-ScreenshotBorder {Disabled | Enabled}]
        [-HDRColorCorrector {Disabled | Enabled}]
        [-AutoCopyRecordingChangesToClipboard {Disabled | Enabled}]
        [-AskToSaveEditedRecordings {Disabled | Enabled}]
        [-AutoSaveRecordings {Disabled | Enabled}]
        [-IncludeMicrophoneInRecording {Disabled | Enabled}]
        [-IncludeSystemAudioInRecording {Disabled | Enabled}]
        [-Theme {System | Light | Dark}]
        [-TeachingTips {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-WindowsSnippingToolSetting
{
    <#
    .EXAMPLE
        PS> Set-WindowsSnippingToolSetting -AskToSaveEditedScreenshots 'Disabled' -Theme 'Dark'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # snipping
        [state] $AutoCopyScreenshotChangesToClipboard,
        [state] $AutoSaveScreenshots,
        [state] $AskToSaveEditedScreenshots,
        [state] $MultipleWindows,
        [state] $ScreenshotBorder,
        [state] $HDRColorCorrector,

        # screen recording
        [state] $AutoCopyRecordingChangesToClipboard,
        [state] $AutoSaveRecordings,
        [state] $AskToSaveEditedRecordings,
        [state] $IncludeMicrophoneInRecording,
        [state] $IncludeSystemAudioInRecording,

        # appearance
        [ValidateSet('System', 'Light', 'Dark')]
        [string] $Theme,

        # miscellaneous
        [state] $TeachingTips
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $SnippingToolSettings = [System.Collections.ArrayList]::new()

        switch ($PSBoundParameters.Keys)
        {
            'AutoCopyScreenshotChangesToClipboard'
            {
                # on: 1 (default) | off: 0
                $AutoCopyScreenshotToClipboardReg = @{
                    Name  = 'AutoCopyScreenshotToClipboard'
                    Value = $AutoCopyScreenshotChangesToClipboard -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AutoCopyScreenshotToClipboardReg) | Out-Null
            }
            'AutoSaveScreenshots'
            {
                # on: 1 (default) | off: 0
                $AutoSaveScreenshotsReg = @{
                    Name  = 'AutoSaveCaptures'
                    Value = $AutoSaveScreenshots -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AutoSaveScreenshotsReg) | Out-Null
            }
            'AskToSaveEditedScreenshots'
            {
                # on: 1 | off: 0 (default)
                $AskToSaveEditedScreenshotsReg = @{
                    Name  = 'Setting_ShowUnsavedScreenshotChangesConfirmations'
                    Value = $AskToSaveEditedScreenshots -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AskToSaveEditedScreenshotsReg) | Out-Null
            }
            'MultipleWindows'
            {
                # on: 1 | off: 0 (default)
                $MultipleWindowsReg = @{
                    Name  = 'Setting_PreferNewWindow'
                    Value = $MultipleWindows -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$MultipleWindowsReg) | Out-Null
            }
            'ScreenshotBorder'
            {
                # on: 1 | off: 0 (default)
                $ScreenshotBorderReg = @{
                    Name  = 'Setting_OutlineOn'
                    Value = $ScreenshotBorder -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$ScreenshotBorderReg) | Out-Null
            }
            'HDRColorCorrector'
            {
                # on: 1 | off: 0 (default)
                $HdrColorCorrectorReg = @{
                    Name  = 'IsHDRToneMappingEnabled'
                    Value = $HDRColorCorrector -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$HdrColorCorrectorReg) | Out-Null
            }
            'AutoCopyRecordingChangesToClipboard'
            {
                # on: 1 (default) | off: 0
                $AutoCopyRecordingToClipboardReg = @{
                    Name  = 'AutoCopyRecordingToClipboard'
                    Value = $AutoCopyRecordingChangesToClipboard -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AutoCopyRecordingToClipboardReg) | Out-Null
            }
            'AutoSaveRecordings'
            {
                # on: 1 (default) | off: 0
                $AutoSaveRecordingsReg = @{
                    Name  = 'AutoSaveScreenRecordings'
                    Value = $AutoSaveRecordings -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AutoSaveRecordingsReg) | Out-Null
            }
            'AskToSaveEditedRecordings'
            {
                # on: 1 (default) | off: 0
                $AskToSaveEditedRecordingsReg = @{
                    Name  = 'Setting_ShowUnsavedRecordingChangesConfirmations'
                    Value = $AskToSaveEditedRecordings -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$AskToSaveEditedRecordingsReg) | Out-Null
            }
            'IncludeMicrophoneInRecording'
            {
                # on: 1 | off: 0 (default)
                $IncludeMicrophoneInRecordingReg = @{
                    Name  = 'IsMicrophoneIncludedInRecording'
                    Value = $IncludeMicrophoneInRecording -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$IncludeMicrophoneInRecordingReg) | Out-Null
            }
            'IncludeSystemAudioInRecording'
            {
                # on: 1 (default) | off: 0
                $IncludeSystemAudioInRecordingReg = @{
                    Name  = 'IsSystemAudioIncludedInRecording'
                    Value = $IncludeSystemAudioInRecording -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$IncludeSystemAudioInRecordingReg) | Out-Null
            }
            'TeachingTips'
            {
                # on: 0 (default) | off: 1
                $RecordingsAutoSaveBannerReg = @{
                    Name  = 'IsRecordingsAutoSaveBannerDismissed'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '1'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$RecordingsAutoSaveBannerReg) | Out-Null

                # on: 0 (default) | off: 1
                $SnipAutoSaveBannerReg = @{
                    Name  = 'IsSnipAutoSaveBannerDismissed'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '1'
                    Type  = '5f5e10b'
                }
                $SnippingToolSettings.Add([PSCustomObject]$SnipAutoSaveBannerReg) | Out-Null

                # on: 0 (default) | off: 3 # old
                $ShapesTeachingTipReg = @{
                    Name  = 'ShapesTeachingTipDismissedCount'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '3'
                    Type  = '5f5e104'
                }
                #$SnippingToolSettings.Add([PSCustomObject]$ShapesTeachingTipReg) | Out-Null

                # on: 0 (default) | off: 3 # old
                $VisualSearchTeachingTipReg = @{
                    Name  = 'VisualSearchTeachingTipDismissedCount'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '3'
                    Type  = '5f5e104'
                }
                #$SnippingToolSettings.Add([PSCustomObject]$VisualSearchTeachingTipReg) | Out-Null

                # on: 0 (default) | off: 10
                $ColorPickerBeaconReg = @{
                    Name  = 'ColorPickerBeaconShownCounter'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '10'
                    Type  = '5f5e104'
                }
                $SnippingToolSettings.Add([PSCustomObject]$ColorPickerBeaconReg) | Out-Null

                # on: 0 (default) | off: 10
                $TextExtractorBeaconReg = @{
                    Name  = 'TextExtractorBeaconShownCounter'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '10'
                    Type  = '5f5e104'
                }
                $SnippingToolSettings.Add([PSCustomObject]$TextExtractorBeaconReg) | Out-Null

                # on: 0 (default) | off: 3
                $LiveAnnotationModeTipReg = @{
                    Name  = 'LiveAnnotationModeTipDismissedCount'
                    Value = $TeachingTips -eq 'Enabled' ? '0' : '3'
                    Type  = '5f5e104'
                }
                $SnippingToolSettings.Add([PSCustomObject]$LiveAnnotationModeTipReg) | Out-Null
            }
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
                    Name  = 'RequestedTheme'
                    Value = $ThemeValue
                    Type  = '5f5e104'
                }
                $SnippingToolSettings.Add([PSCustomObject]$ThemeReg) | Out-Null
            }
        }

        Set-UwpAppSetting -Name 'WindowsSnippingTool' -Setting $SnippingToolSettings
    }
}
