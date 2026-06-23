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
#                               Microsoft Office
#==============================================================================

Write-Section -Name 'Microsoft Office' -SubSection

#==========================================================
#                         Options
#==========================================================

#                General
#=======================================

# --- Office theme
# Do not override an already manually selected theme.
# GPO: Colorful | DarkGray | Black | White | NotConfigured
Set-MicrosoftOfficeSetting -DefaultThemeGPO 'DarkGray'

# --- Enable Linkedin features in my Office applications (default: Enabled)
Set-MicrosoftOfficeSetting -LinkedinFeatures 'Disabled' -LinkedinFeaturesGPO 'NotConfigured'

# --- Show the Start screen when this application starts (default: Enabled)
Set-MicrosoftOfficeSetting -ShowStartScreen 'Disabled' -ShowStartScreenGPO 'NotConfigured'

#                 Save
#=======================================

# --- Save files in this format
# State: Office (default) | OpenDocument
Set-MicrosoftOfficeSetting -DefaultFileFormat 'Office'

# --- Save to Computer by default
# State: Computer | Cloud (default)
Set-MicrosoftOfficeSetting -DefaultSaveLocation 'Computer'

#==========================================================
#                      Miscellaneous
#==========================================================

# --- Accept all EULAs (End-User License Agreement)
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -AcceptEULAsGPO 'Enabled'

# --- Block sign-in into Office
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -BlockSigninGPO 'NotConfigured'

# --- Microsoft Workplace Discount Program notifications
# GPO: Disabled | Enabled | NotConfigured
Set-MicrosoftOfficeSetting -DiscountProgramNotifsGPO 'Disabled'

# --- About sign-in to Office on first run
Set-MicrosoftOfficeSetting -FirstRunAboutSigninGPO 'Disabled'

# --- Opt-In wizard on first run
Set-MicrosoftOfficeSetting -FirstRunOptinWizardGPO 'Disabled'

# --- Show File Format dialog
Set-MicrosoftOfficeSetting -ShowFileFormatDialogGPO 'Disabled'

# --- Teaching Tips (aka Teaching Callouts) (default: Enabled)
Set-MicrosoftOfficeSetting -TeachingTips 'Disabled'

#==========================================================
#                  Connected Experiences
#==========================================================

# --- Connected experiences
Set-MicrosoftOfficeSetting -AllConnectedExperiencesGPO 'NotConfigured'

# --- Connected experiences that analyze content
Set-MicrosoftOfficeSetting -ConnectedExperiencesThatAnalyzeContentGPO 'NotConfigured'

# --- Connected experiences that download online content
Set-MicrosoftOfficeSetting -ConnectedExperiencesThatDownloadContentGPO 'NotConfigured'

# --- Optional connected experiences
# Disabled: Also disables the "Your Privacy Matters" dialog on first run.
Set-MicrosoftOfficeSetting -OptionalConnectedExperiencesGPO 'Disabled'

#==========================================================
#                         Privacy
#==========================================================

# --- Local training of AI features
Set-MicrosoftOfficeSetting -AILocalTrainingGPO 'Disabled'

# --- Customer experience improvement program
Set-MicrosoftOfficeSetting -CeipGPO 'Disabled'

# --- Diagnostics
# GPO: Disabled | Enabled | NotConfigured
Set-MicrosoftOfficeSetting -DiagnosticsGPO 'Disabled'

# --- Error Reporting
Set-MicrosoftOfficeSetting -ErrorReportingGPO 'Disabled'

# --- Feedback
Set-MicrosoftOfficeSetting -FeedbackGPO 'Disabled'

# --- Send Personal Information
# Not applicable to Microsoft 365 App for enterprise (replaced by Connected Experiences policies).
Set-MicrosoftOfficeSetting -SendPersonalInfoGPO 'Disabled'

# --- Surveys
Set-MicrosoftOfficeSetting -SurveysGPO 'Disabled'

# --- Telemetry
Set-MicrosoftOfficeSetting -TelemetryGPO 'Disabled'
