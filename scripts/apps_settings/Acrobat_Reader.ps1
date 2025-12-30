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
#                             Adobe Acrobat Reader
#==============================================================================

Write-Section -Name 'Acrobat Reader' -SubSection

#==========================================================
#                       Preferences
#==========================================================
#region preferences

#               Documents
#=======================================

# --- Show Tools Pane (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowToolsPane 'Disabled'

#                General
#=======================================

# --- Show online storage when openings files (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileOpen 'Disabled'

# --- Show online storage when saving files (default: Enabled)
Set-AdobeAcrobatReaderSetting -ShowCloudStorageOnFileSave 'Disabled'

# --- Show me messages when I launch Adobe Acrobat (ads & tips related) (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ShowMessagesAtLaunch 'Disabled' -ShowMessagesAtLaunchGPO 'Disabled'

# --- Show messages while viewing a document (popup tips related) (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ShowMessagesWhenViewingPdf 'Disabled' -ShowMessagesWhenViewingPdfGPO 'Disabled'

# --- Send crash reports
# State: Ask (default) | Always | Never
Set-AdobeAcrobatReaderSetting -SendCrashReports 'Never'

#            Email Accounts
#=======================================

# --- Add account
Set-AdobeAcrobatReaderSetting -WebmailGPO 'Disabled'

#              Javascript
#=======================================

# --- Enable Acrobat Javascript (default: Enabled)
Set-AdobeAcrobatReaderSetting -Javascript 'Disabled' -JavascriptGPO 'NotConfigured'

# --- Enable Menu Items Javascript Execution Privileges (default: Disabled)
Set-AdobeAcrobatReaderSetting -JavascriptMenuItemsExecution 'Disabled'

# --- Enable Global Object Security Policy (default: Enabled)
Set-AdobeAcrobatReaderSetting -JavascriptGlobalObjectSecurity 'Enabled'

#               Reviewing
#=======================================

# --- Show Welcome Dialog When Opening File (default: Enabled)
Set-AdobeAcrobatReaderSetting -SharedReviewWelcomeDialog 'Disabled'

#          Security (enhanced)
#=======================================

# --- Protected mode at startup (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
# GPO Disabled: disable both "Protected Mode At Startup" and "Run In AppContainer".
# GPO Enabled : only enforce "Protected Mode At Startup".
Set-AdobeAcrobatReaderSetting -ProtectedMode 'Enabled' -ProtectedModeGPO 'NotConfigured'

# --- Run in AppContainer (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -AppContainer 'Enabled' -AppContainerGPO 'NotConfigured'

# --- Protected view 
# State: Disabled (default) | UnsafeLocationsFiles | AllFiles
# GPO: Disabled | UnsafeLocationsFiles | AllFiles | NotConfigured
Set-AdobeAcrobatReaderSetting -ProtectedView 'Disabled' -ProtectedViewGPO 'NotConfigured'

# --- Enhanced security (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -EnhancedSecurity 'Enabled' -EnhancedSecurityGPO 'NotConfigured'

# --- Automatically trust documents with valid certification (default: Disabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -TrustCertifiedDocuments 'Disabled' -TrustCertifiedDocumentsGPO 'NotConfigured'

# --- Automatically trust sites from my Win OS security zones (default: Enabled)
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -TrustOSTrustedSites 'Disabled' -TrustOSTrustedSitesGPO 'NotConfigured'

# --- Privileged Locations: Add File / Add Folder Path
Set-AdobeAcrobatReaderSetting -AddTrustedFilesFoldersGPO 'NotConfigured'

# --- Privileged Locations: Add Host
Set-AdobeAcrobatReaderSetting -AddTrustedSitesGPO 'NotConfigured'

#             Trust Manager
#=======================================

# --- Allow opening of non-PDF file attachments with external applications (default: Enabled)
Set-AdobeAcrobatReaderSetting -OpenFileAttachments 'Disabled' -OpenFileAttachmentsGPO 'NotConfigured'

# --- Internet access from PDF files: Access All Web Sites
# State: BlockAllWebSites | AllowAllWebSites | Custom (default)
# GPO: BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured
Set-AdobeAcrobatReaderSetting -InternetAccessFromPdf 'Custom' -InternetAccessFromPdfGPO 'NotConfigured'

# --- Internet access from PDF files: Behavior if not in the list
# State: Ask (default) | Allow | Block
# GPO: Ask | Allow | Block | NotConfigured
Set-AdobeAcrobatReaderSetting -InternetAccessFromPdfUnknownUrl 'Ask' -InternetAccessFromPdfUnknownUrlGPO 'NotConfigured'

#                 Units
#=======================================

# --- Page units
# Points | Inches | Millimeters | Centimeters | Picas
Set-AdobeAcrobatReaderSetting -PageUnits 'Centimeters'

#endregion preferences

#==========================================================
#                      Miscellaneous
#==========================================================
#region miscellaneous

#                  Ads
#=======================================

# --- Upsell (offers to buy extra tools)
Set-AdobeAcrobatReaderSetting -UpsellGPO 'Disabled'

# --- Upsell Mobile App (ads on Home banner)
Set-AdobeAcrobatReaderSetting -UpsellMobileAppGPO 'Disabled'

#             Cloud Storage
#=======================================

# --- Adobe Cloud Storage
# Disable annoyances if you don't use an Adobe account.
# Disables:
#   Home page online services
#   Tools that requires Acrobat
Set-AdobeAcrobatReaderSetting -AdobeCloudStorageGPO 'Disabled'

# --- SharePoint
Set-AdobeAcrobatReaderSetting -SharePointGPO 'Disabled'

# --- Third Party Cloud Storage
Set-AdobeAcrobatReaderSetting -ThirdPartyCloudStorageGPO 'Disabled'

#                 Tips
#=======================================

# --- First launch experiences
Set-AdobeAcrobatReaderSetting -FirstLaunchExperienceGPO 'Disabled'

# --- Onboarding dialogs
Set-AdobeAcrobatReaderSetting -OnboardingDialogsGPO 'Disabled'

# --- Popup tips
Set-AdobeAcrobatReaderSetting -PopupTipsGPO 'Disabled'

#                Others
#=======================================

# --- Accept EULA (End-User License Agreement)
# GPO: Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -AcceptEulaGPO 'Enabled'

# --- Chrome extension
# The extension is automatically installed if not disabled.
# GPO: Disabled | Enabled | NotConfigured
Set-AdobeAcrobatReaderSetting -ChromeExtensionGPO 'Disabled'

# --- Crash reporter dialog
Set-AdobeAcrobatReaderSetting -CrashReporterDialogGPO 'Disabled'

# --- Home View : Top Banner
# GPO: Disabled | Expanded (default) | Collapsed
Set-AdobeAcrobatReaderSetting -HomeTopBannerGPO 'Disabled'

# --- Adobe Online Services
# Disable annoyances if you don't use an Adobe account.
# Disables:
#   Top bar icons (sign-in, notifs, ...)
#   Home page online services
#   Tools that requires Acrobat
Set-AdobeAcrobatReaderSetting -OnlineServicesGPO 'Disabled'

# --- Outlook Plugin (Adobe Send and Track plugin)
Set-AdobeAcrobatReaderSetting -OutlookPluginGPO 'Disabled'

# --- Share File (replace the Share Icon with the Email Icon)
Set-AdobeAcrobatReaderSetting -ShareFileGPO 'Disabled'

# --- Telemetry
Set-AdobeAcrobatReaderSetting -TelemetryGPO 'Disabled'

# --- Synchronizer: Run At Startup (default: Enabled)
# Disabled: Need to be reapplied after each update (or create a scheduled task).
Set-AdobeAcrobatReaderSetting -SynchronizerRunAtStartup 'Disabled'

# --- Synchronizer: Task Manager Process (default: Enabled)
# Disabled:
#   Add a ".bak" extension to "AdobeCollabSync.exe" and "FullTrustNotifier.exe" files.
#   Need to be reapplied after each update (or create a scheduled task).
#Set-AdobeAcrobatReaderSetting -SynchronizerTaskManagerProcess 'Disabled'

# --- Remove tool from the Tools tab
# RemoveToolFromToolsTab: list of tools to remove.
# ResetRemovedToolsFromToolsTab: Reset every removed tools.
# Most tools are only available on Acrobat.
# Override any existing removed tools.
# i.e. Only the listed tools will be removed from the Tools tab.
$RemovedTools = @(
    #'AddComments'
    'AddRichMedia'
    'AddSearchIndex'
    #'AddStamp'
    'ApplyPdfStandards'
    'CreatePdf'
    'CombineFiles'
    'CompareFiles'
    'CompressPdf'
    'ConvertPdf'
    'EditPdf'
    'ExportPdf'
    #'FillAndSign'
    'MeasureObjects'
    'OrganizePages'
    'PrepareForAccessibility'
    'PrepareForm'
    'ProtectPdf'
    'RedactPdf'
    'RequestSignatures'
    'ScanAndOcr'
    'UseCertificate'
    'UseGuidedActions'
    'UsePrintProduction'
)
Set-AdobeAcrobatReaderSetting -RemoveToolFromToolsTab $RemovedTools
#Set-AdobeAcrobatReaderSetting -ResetRemovedToolsFromToolsTab

#endregion miscellaneous
