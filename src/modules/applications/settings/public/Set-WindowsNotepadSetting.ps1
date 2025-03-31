#=================================================================================================================
#                                             Windows Notepad Setting
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsNotepadSetting
        [-Theme {System | Light | Dark}]
        [-FontFamily <string>]
        [-FontStyle {Regular | Italic | Bold | Bold Italic}]
        [-FontSize <int>]
        [-WordWrap {Disabled | Enabled}]
        [-OpenFile {NewTab | NewWindow}]
        [-ContinuePreviousSession {Disabled | Enabled}]
        [-RecentFiles {Disabled | Enabled}]
        [-SpellCheck {Disabled | Enabled}]
        [-AutoCorrect {Disabled | Enabled}]
        [-Copilot {Disabled | Enabled}]
        [-StatusBar {Disabled | Enabled}]
        [-FirstLaunchTip {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-WindowsNotepadSetting
{
    <#
    .DESCRIPTION
        If you provide an invalid FontFamily name, the default font will be used.

    .EXAMPLE
        PS> Set-WindowsNotepadSetting -Theme 'Dark' -OpenFile 'NewTab' -FontSize 42
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # appearance
        [ValidateSet('System', 'Light', 'Dark')]
        [string] $Theme,

        # text formatting
        [string] $FontFamily,

        [ValidateSet('Regular', 'Italic', 'Bold', 'Bold Italic')]
        [string] $FontStyle,

        [ValidateRange(1, 99)]
        [int] $FontSize,

        [state] $WordWrap,

        # opening notepad
        [ValidateSet('NewTab', 'NewWindow')]
        [string] $OpenFile,

        [state] $ContinuePreviousSession,

        [state] $RecentFiles,

        # spelling
        [state] $SpellCheck,

        [state] $AutoCorrect,

        # AI features
        [state] $Copilot,

        # miscellaneous
        [state] $StatusBar,

        [state] $FirstLaunchTip
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $NotepadSettings = [System.Collections.ArrayList]::new()

        switch ($PSBoundParameters.Keys)
        {
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
                    Name  = 'Theme'
                    Value = $ThemeValue
                    Type  = '5f5e104'
                }
                $NotepadSettings.Add([PSCustomObject]$ThemeReg) | Out-Null
            }
            'FontFamily'
            {
                # example: Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman | ...
                $FontFamilyReg = @{
                    Name  = 'FontFamily'
                    Value = $FontFamily
                    Type  = '5f5e10c'
                }
                $NotepadSettings.Add([PSCustomObject]$FontFamilyReg) | Out-Null
            }
            'FontStyle'
            {
                # Regular (default) | Italic | Bold | Bold Italic
                $FontStyleReg = @{
                    Name  = 'FontStyle'
                    Value = $FontStyle
                    Type  = '5f5e10c'
                }
                $NotepadSettings.Add([PSCustomObject]$FontStyleReg) | Out-Null
            }
            'FontSize'
            {
                # GUI values: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72
                # default: 11 (range 1-99)
                $FontSizeReg = @{
                    Name  = 'FontSize'
                    Value = $FontSize
                    Type  = '5f5e104'
                }
                $NotepadSettings.Add([PSCustomObject]$FontSizeReg) | Out-Null
            }
            'WordWrap'
            {
                # on: 1 (default) | off: 0
                $WordWrapReg = @{
                    Name  = 'WordWrap'
                    Value = $WordWrap -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$WordWrapReg) | Out-Null
            }
            'OpenFile'
            {
                # open in a new tab: 0 (default) | open in a new window: 1
                $OpenFileReg = @{
                    Name  = 'OpenFile'
                    Value = $OpenFile -eq 'NewWindow' ? '1' : '0'
                    Type  = '5f5e104'
                }
                $NotepadSettings.Add([PSCustomObject]$OpenFileReg) | Out-Null
            }
            'ContinuePreviousSession'
            {
                # continue previous session: 1 (default) | start new session and discard unsaved change: 0
                $ContinuePreviousSessionReg = @{
                    Name  = 'GhostFile'
                    Value = $ContinuePreviousSession -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$ContinuePreviousSessionReg) | Out-Null
            }
            'RecentFiles'
            {
                # on: 1 (default) | off: 0
                $RecentFilesReg = @{
                    Name  = 'RecentFilesEnabled'
                    Value = $RecentFiles -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$RecentFilesReg) | Out-Null

                if ($RecentFiles -eq 'Enabled')
                {
                    # populate Recent Files list
                    $RecentFilesFirstLoad = @{
                        Name  = 'RecentFilesFirstLoad'
                        Value = '1'
                        Type  = '5f5e10b'
                    }
                    $NotepadSettings.Add([PSCustomObject]$RecentFilesFirstLoad) | Out-Null
                }
                else
                {
                    # remove Recent Files list
                    $RecentFilesList = @{
                        Name  = 'RecentFiles'
                        Value = '[]'
                        Type  = '5f5e10c'
                    }
                    $NotepadSettings.Add([PSCustomObject]$RecentFilesList) | Out-Null
                }
            }
            'SpellCheck'
            {
                # '.srt & .ass' share the same GUI toggle
                # on: true (default) | off: false
                $SpellCheckValue = @{
                    Enabled = $SpellCheck -eq 'Enabled'
                    FileExtensionsOverrides = @(
                        @(  '.md', $true ),
                        @( '.ass', $true ),
                        @( '.lic', $true ),
                        @( '.srt', $true ),
                        @( '.lrc', $true ),
                        @( '.txt', $true )
                    )
                }
                $SpellCheckValue = ($SpellCheckValue | ConvertTo-Json) -replace '\s+'

                $SpellCheckReg = @{
                    Name  = 'SpellCheckState'
                    Value = $SpellCheckValue
                    Type  = '5f5e10c'
                }
                $NotepadSettings.Add([PSCustomObject]$SpellCheckReg) | Out-Null
            }
            'AutoCorrect'
            {
                # on: 1 (default) | off: 0
                $AutoCorrectReg = @{
                    Name  = 'AutoCorrect'
                    Value = $AutoCorrect -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$AutoCorrectReg) | Out-Null
            }
            'Copilot'
            {
                # on: 1 (default) | off: 0
                $CopilotReg = @{
                    Name  = 'RewriteEnabled'
                    Value = $Copilot -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$CopilotReg) | Out-Null
            }
            'StatusBar'
            {
                # on: 1 (default) | off: 0
                $StatusBarReg = @{
                    Name  = 'StatusBarShown'
                    Value = $StatusBar -eq 'Enabled' ? '1' : '0'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$StatusBarReg) | Out-Null
            }
            'FirstLaunchTip'
            {
                # first launch tip closed (tip: notepad automatically saves your progress)
                # on: 1 | off: 0 (default)
                $FirstLaunchTipReg = @{
                    Name  = 'TeachingTipExplicitClose'
                    Value = $FirstLaunchTip -eq 'Enabled' ? '0' : '1'
                    Type  = '5f5e10b'
                }
                $NotepadSettings.Add([PSCustomObject]$FirstLaunchTipReg) | Out-Null
            }
        }

        Set-UwpAppSetting -Name 'WindowsNotepad' -Setting $NotepadSettings
    }
}
