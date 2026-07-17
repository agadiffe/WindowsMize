#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

Import-Module -Name "$PSScriptRoot\..\..\src\modules\applications\settings"


# Parameters values (if not specified):
#   State: Disabled | Enabled
#   GPO:   Disabled | NotConfigured (default)

#=================================================================================================================
#                                              Applications Settings
#=================================================================================================================

Write-Section -Name 'Applications Settings'

#==============================================================================
#                               Windows Notepad
#==============================================================================

Write-Section -Name 'Windows Notepad' -SubSection

#              Appearance
#=======================================

# --- App theme
# State: System (default) | Light | Dark
Set-WindowsNotepadSetting -Theme 'System'

#            Text Formatting
#=======================================

# --- Font family
# State (e.g.): Arial | Calibri | Consolas (default) | Comic Sans MS | Times New Roman | ...
Set-WindowsNotepadSetting -FontFamily 'Consolas'

# --- Font style
# State: Regular (default) | Italic | Bold | Bold Italic
Set-WindowsNotepadSetting -FontStyle 'Regular'

# --- Font size
# Dropdown GUI values: 8,9,10,11,12,14,16,18,20,22,24,26,28,36,48,72
# default: 11 (range: 1-99)
Set-WindowsNotepadSetting -FontSize 11

# --- Word wrap (default: Enabled)
Set-WindowsNotepadSetting -WordWrap 'Enabled'

# --- Formatting (default: Enabled)
Set-WindowsNotepadSetting -Formatting 'Disabled'

#            Opening Notepad
#=======================================

# --- Opening files
# State: NewTab (default) | NewWindow
Set-WindowsNotepadSetting -OpenFile 'NewTab'

# --- When Notepad starts : Continue previous session (default: Enabled)
Set-WindowsNotepadSetting -ContinuePreviousSession 'Disabled'

# --- Recent Files (default: Enabled)
Set-WindowsNotepadSetting -RecentFiles 'Enabled'

#               Spelling
#=======================================

# --- Spell check (default: Enabled)
Set-WindowsNotepadSetting -SpellCheck 'Disabled'

# --- Autocorrect (default: Enabled)
Set-WindowsNotepadSetting -AutoCorrect 'Disabled'

#           Advanced Features
#=======================================

# --- Writing tools (aka Copilot) (default: Enabled)
Set-WindowsNotepadSetting -WritingTools 'Disabled'

#             Miscellaneous
#=======================================

# --- Status bar (default: Enabled)
Set-WindowsNotepadSetting -StatusBar 'Enabled'

# --- Teaching tips (default: Enabled)
#   What's new beacon (blue dot)
#   New badges in menu (blue badges)
#   Continue Previous Session flyout (notepad automatically saves your progress) | old
#   Formatting tips | old
#   Rewrite tips | old ?
Set-WindowsNotepadSetting -TeachingTips 'Disabled'
