#=================================================================================================================
#                                 Privacy & Security > Background App Permissions
#=================================================================================================================

# Applies only to MsStore/UWP apps (e.g. Calculator, Notepad, Photos, ...).

<#
.SYNTAX
    Set-BackgroundAppPermissionsSetting
        [-BingSearch {Always | Optimized | Never}]
        [-Calculator {Always | Optimized | Never}]
        [-Camera {Always | Optimized | Never}]
        [-Clipchamp {Always | Optimized | Never}]
        [-Clock {Always | Optimized | Never}]
        [-Compatibility {Always | Optimized | Never}]
        [-CrossDevice {Always | Optimized | Never}]
        [-DevHome {Always | Optimized | Never}]
        [-FeedbackHub {Always | Optimized | Never}]
        [-GetHelp {Always | Optimized | Never}]
        [-M365Copilot {Always | Optimized | Never}]
        [-MediaPlayer {Always | Optimized | Never}]
        [-MicrosoftCopilot {Always | Optimized | Never}]
        [-MicrosoftStore {Always | Optimized | Never}]
        [-MicrosoftTeams {Always | Optimized | Never}]
        [-News {Always | Optimized | Never}]
        [-Notepad {Always | Optimized | Never}]
        [-Outlook {Always | Optimized | Never}]
        [-Paint {Always | Optimized | Never}]
        [-PhoneLink {Always | Optimized | Never}]
        [-Photos {Always | Optimized | Never}]
        [-PowerAutomate {Always | Optimized | Never}]
        [-QuickAssist {Always | Optimized | Never}]
        [-SnippingTool {Always | Optimized | Never}]
        [-Solitaire {Always | Optimized | Never}]
        [-SoundRecorder {Always | Optimized | Never}]
        [-StickyNotes {Always | Optimized | Never}]
        [-Terminal {Always | Optimized | Never}]
        [-Todo {Always | Optimized | Never}]
        [-Weather {Always | Optimized | Never}]
        [-Xbox {Always | Optimized | Never}]
        [-XboxLive {Always | Optimized | Never}]
        [-XboxGameBar {Always | Optimized | Never}]
        [<CommonParameters>]
#>

function Set-BackgroundAppPermissionsSetting
{
    <#
    .EXAMPLE
        PS> Set-BackgroundAppPermissionsSetting -Clipchamp 'Never' -MicrosoftTeams 'Optimized'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [BackgroundAppMode] $BingSearch,
        [BackgroundAppMode] $Calculator,
        [BackgroundAppMode] $Camera,
        [BackgroundAppMode] $Clipchamp,
        [BackgroundAppMode] $Clock,
        [BackgroundAppMode] $Compatibility,
        [BackgroundAppMode] $CrossDevice,
        [BackgroundAppMode] $DevHome,
        [BackgroundAppMode] $FeedbackHub,
        [BackgroundAppMode] $GetHelp,
        [BackgroundAppMode] $M365Copilot,
        [BackgroundAppMode] $MediaPlayer,
        [BackgroundAppMode] $MicrosoftCopilot,
        [BackgroundAppMode] $MicrosoftStore,
        [BackgroundAppMode] $MicrosoftTeams,
        [BackgroundAppMode] $News,
        [BackgroundAppMode] $Notepad,
        [BackgroundAppMode] $Outlook,
        [BackgroundAppMode] $Paint,
        [BackgroundAppMode] $PhoneLink,
        [BackgroundAppMode] $Photos,
        [BackgroundAppMode] $PowerAutomate,
        [BackgroundAppMode] $QuickAssist,
        [BackgroundAppMode] $SnippingTool,
        [BackgroundAppMode] $Solitaire,
        [BackgroundAppMode] $SoundRecorder,
        [BackgroundAppMode] $StickyNotes,
        [BackgroundAppMode] $Terminal,
        [BackgroundAppMode] $Todo,
        [BackgroundAppMode] $Weather,
        [BackgroundAppMode] $Xbox,
        [BackgroundAppMode] $XboxLive,
        [BackgroundAppMode] $XboxGameBar
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        foreach ($AppName in $PSBoundParameters.Keys)
        {
            $AppRegPathName = switch ($AppName)
            {
                'BingSearch'       { 'Microsoft.BingSearch_8wekyb3d8bbwe' }
                'Calculator'       { 'Microsoft.WindowsCalculator_8wekyb3d8bbwe' }
                'Camera'           { 'Microsoft.WindowsCamera_8wekyb3d8bbwe' }
                'Clipchamp'        { 'Clipchamp.Clipchamp_yxz26nhyzhsrt' }
                'Clock'            { 'Microsoft.WindowsAlarms_8wekyb3d8bbwe' }
                'Compatibility'    { 'Microsoft.ApplicationCompatibilityEnhancements_8wekyb3d8bbwe' }
                'CrossDevice'      { 'MicrosoftWindows.CrossDevice_cw5n1h2txyewy' }
                'DevHome'          { 'Microsoft.Windows.DevHome_8wekyb3d8bbwe' }
                'FeedbackHub'      { 'Microsoft.WindowsFeedbackHub_8wekyb3d8bbwe' }
                'GetHelp'          { 'Microsoft.GetHelp_8wekyb3d8bbwe' }
                'M365Copilot'      { 'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe' }
                'MediaPlayer'      { 'Microsoft.ZuneMusic_8wekyb3d8bbwe' }
                'MicrosoftCopilot' { 'Microsoft.Copilot_8wekyb3d8bbwe' }
                'MicrosoftStore'   { 'Microsoft.WindowsStore_8wekyb3d8bbwe' }
                'MicrosoftTeams'   { 'MSTeams_8wekyb3d8bbwe' }
                'News'             { 'Microsoft.BingNews_8wekyb3d8bbwe' }
                'Notepad'          { 'Microsoft.WindowsNotepad_8wekyb3d8bbwe' }
                'Outlook'          { 'Microsoft.OutlookForWindows_8wekyb3d8bbwe' }
                'Paint'            { 'Microsoft.Paint_8wekyb3d8bbwe' }
                'PhoneLink'        { 'Microsoft.YourPhone_8wekyb3d8bbwe' }
                'Photos'           { 'Microsoft.Windows.Photos_8wekyb3d8bbwe' }
                'PowerAutomate'    { 'Microsoft.PowerAutomateDesktop_8wekyb3d8bbwe' }
                'QuickAssist'      { 'MicrosoftCorporationII.QuickAssist_8wekyb3d8bbwe' }
                'SnippingTool'     { 'Microsoft.ScreenSketch_8wekyb3d8bbwe' }
                'Solitaire'        { 'Microsoft.MicrosoftSolitaireCollection_8wekyb3d8bbwe' }
                'SoundRecorder'    { 'Microsoft.WindowsSoundRecorder_8wekyb3d8bbwe' }
                'StickyNotes'      { 'Microsoft.MicrosoftStickyNotes_8wekyb3d8bbwe' }
                'Terminal'         { 'Microsoft.WindowsTerminal_8wekyb3d8bbwe' }
                'Todo'             { 'Microsoft.Todos_8wekyb3d8bbwe' }
                'Weather'          { 'Microsoft.BingWeather_8wekyb3d8bbwe' }
                'Xbox'             { 'Microsoft.GamingApp_8wekyb3d8bbwe' }
                'XboxLive'         { 'Microsoft.Xbox.TCUI_8wekyb3d8bbwe' }
                'XboxGameBar'      { 'Microsoft.XboxGamingOverlay_8wekyb3d8bbwe' }
            }

            $SettingValue = $PSBoundParameters.$AppName
            $DisabledByUser, $Disabled, $IgnoreBatterySaver, $SleepDisabled = switch ($SettingValue)
            {
                'Always'    { '0', '0', '1', '0' }
                'Optimized' { '0', '0', '0', '0' }
                'Never'     { '1', '1', '0', '1' }
            }

            # Always: 0010 | Optimized: 0000 (default) | Never: 1101
            $BackgroundApps = [AppPermissionSetting]::new(@{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = "Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications\$AppRegPathName"
                Entries = @(
                    @{
                        Name  = 'DisabledByUser'
                        Value = $DisabledByUser
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'Disabled'
                        Value = $Disabled
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'IgnoreBatterySaver'
                        Value = $IgnoreBatterySaver
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SleepDisabled'
                        Value = $SleepDisabled
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'SleepIgnoreBatterySaver'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            })

            $BackgroundApps.WriteVerboseMsg("$AppName Background Activity", $SettingValue)
            $BackgroundApps.SetRegistryEntry()
        }
    }
}
