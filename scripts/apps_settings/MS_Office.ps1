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

# --- Enable Linkedin features in my Office applications (default: Enabled)
Set-MicrosoftOfficeSetting -LinkedinFeatures 'Disabled' -LinkedinFeaturesGPO 'NotConfigured'

# --- Show the Start screen when this application starts (default: Enabled)
Set-MicrosoftOfficeSetting -ShowStartScreen 'Disabled' -ShowStartScreenGPO 'NotConfigured'

#==========================================================
#                      Miscellaneous
#==========================================================

# --- Accept all EULAs (End-User License Agreement)
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -AcceptEULAsGPO 'Enabled'

# --- Block sign-in into Office
# GPO: Enabled | NotConfigured
Set-MicrosoftOfficeSetting -BlockSigninGPO 'NotConfigured'

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

# --- Optional connected experiences (default: Enabled)
Set-MicrosoftOfficeSetting -OptionalConnectedExperiences 'Disabled' -OptionalConnectedExperiencesGPO 'NotConfigured'

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

# --- Microsoft Workplace Discount Program notifications
# GPO: Disabled | Enabled | NotConfigured
Set-MicrosoftOfficeSetting -DiscountProgramNotifsGPO 'Disabled'

# --- Error Reporting
Set-MicrosoftOfficeSetting -ErrorReportingGPO 'Disabled'

# --- Feedback
Set-MicrosoftOfficeSetting -FeedbackGPO 'Disabled'

# --- First Run about sign-in to Office
Set-MicrosoftOfficeSetting -FirstRunAboutSigninGPO 'Disabled'

# --- Opt-In Wizard On First Run
Set-MicrosoftOfficeSetting -FirstRunOptinWizardGPO 'Disabled'

# --- Send Personal Information
# Not applicable to Microsoft 365 App for enterprise (Replaced by Connected Experiences policies).
Set-MicrosoftOfficeSetting -SendPersonalInfoGPO 'Disabled'

# --- Surveys
Set-MicrosoftOfficeSetting -SurveysGPO 'Disabled'

# --- Telemetry
Set-MicrosoftOfficeSetting -TelemetryGPO 'Disabled'
