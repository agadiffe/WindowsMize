#=================================================================================================================
#                                          Adobe Acrobat Reader Setting
#=================================================================================================================

# https://adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/

# GPO parameters are not always a featurelockdown inside HKEY_LOCAL_MACHINE\SOFTWARE\Policies.
# In this context, GPO means that the setting may not have a GUI option.
# This is the case for all settings in the "miscellaneous" folder.

# does not work if defined in Remove-AcrobatToolFromToolsTab (Unable to find type [AdobeAcrobatAppNames])
class AdobeAcrobatAppNames : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:AdobeAcrobatAppID.Keys
    }
}

<#
.SYNTAX
    Set-AdobeAcrobatReaderSetting

        # --- Preferences
        ## Documents
        [-ShowToolsPane {Disabled | Enabled}]

        ## General
        [-ShowCloudStorageOnFileOpen {Disabled | Enabled}]
        [-ShowCloudStorageOnFileSave {Disabled | Enabled}]
        [-ShowMessagesAtLaunch {Disabled | Enabled}]
        [-ShowMessagesAtLaunchGPO {Disabled | Enabled | NotConfigured}]
        [-ShowMessagesWhenViewingPdf {Disabled | Enabled}]
        [-ShowMessagesWhenViewingPdfGPO {Disabled | Enabled | NotConfigured}]
        [-SendCrashReports {Ask | Always | Never}]

        ## Email accounts
        [-WebmailGPO {Disabled | NotConfigured}]

        ## Javascript
        [-Javascript {Disabled | Enabled}]
        [-JavascriptGPO {Disabled | NotConfigured}]
        [-JavascriptMenuItemsExecution {Disabled | Enabled}]
        [-JavascriptGlobalObjectSecurity {Disabled | Enabled}]

        ## Reviewing
        [-SharedReviewWelcomeDialog {Disabled | Enabled}]

        ## Security (enhanced)
        [-ProtectedMode {Disabled | Enabled}]
        [-ProtectedModeGPO {Disabled | Enabled | NotConfigured}]
        [-AppContainer {Disabled | Enabled}]
        [-AppContainerGPO {Disabled | Enabled | NotConfigured}]
        [-ProtectedView {Disabled | UnsafeLocationsFiles | AllFiles}]
        [-ProtectedViewGPO {Disabled | UnsafeLocationsFiles | AllFiles | NotConfigured}]
        [-EnhancedSecurity {Disabled | Enabled}]
        [-EnhancedSecurityGPO {Disabled | Enabled | NotConfigured}]
        [-TrustCertifiedDocuments {Disabled | Enabled}]
        [-TrustCertifiedDocumentsGPO {Disabled | Enabled | NotConfigured}]
        [-TrustOSTrustedSites {Disabled | Enabled}]
        [-TrustOSTrustedSitesGPO {Disabled | Enabled | NotConfigured}]
        [-AddTrustedFilesFoldersGPO {Disabled | NotConfigured}]
        [-AddTrustedSitesGPO {Disabled | NotConfigured}]

        ## Trust manager
        [-OpenFileAttachments {Disabled | Enabled}]
        [-OpenFileAttachmentsGPO {Disabled | NotConfigured}]
        [-InternetAccessFromPdf {BlockAllWebSites | AllowAllWebSites | Custom}]
        [-InternetAccessFromPdfGPO {BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured}]
        [-InternetAccessFromPdfUnknownUrl {Ask | Allow | Block}]
        [-InternetAccessFromPdfUnknownUrlGPO {Ask | Allow | Block | NotConfigured}]

        ## Units
        [-PageUnits {Points | Inches | Millimeters | Centimeters | Picas}]

        # --- Miscellaneous
        ## Ads
        [-UpsellGPO {Disabled | NotConfigured}]
        [-UpsellMobileAppGPO {Disabled | NotConfigured}]

        ## Cloud storage
        [-AdobeCloudStorageGPO {Disabled | NotConfigured}]
        [-SharePointGPO {Disabled | NotConfigured}]
        [-ThirdPartyCloudStorageGPO {Disabled | NotConfigured}]

        ## Tips
        [-FirstLaunchExperienceGPO {Disabled | NotConfigured}]
        [-OnboardingDialogsGPO {Disabled | NotConfigured}]
        [-PopupTipsGPO {Disabled | NotConfigured}]

        ## Others
        [-AcceptEulaGPO {Enabled | NotConfigured}]
        [-ChromeExtensionGPO {Disabled | Enabled | NotConfigured}]
        [-CrashReporterDialogGPO {Disabled | NotConfigured}]
        [-HomeTopBannerGPO {Disabled | Expanded | Collapsed}]
        [-OnlineServicesGPO {Disabled | NotConfigured}]
        [-OutlookPluginGPO {Disabled | NotConfigured}]
        [-ShareFileGPO {Disabled | NotConfigured}]
        [-TelemetryGPO {Disabled | NotConfigured}]
        [-SynchronizerRunAtStartup {Disabled | Enabled}]
        [-SynchronizerTaskManagerProcess {Disabled | Enabled}]
        [-RemoveToolFromToolsTab {AddComments | AddRichMedia | AddSearchIndex | AddStamp | ApplyPdfStandards | CombineFiles |
                                  CompareFiles | CompressPdf | ConvertPdf | CreatePdf | EditPdf | ExportPdf | FillAndSign |
                                  MeasureObjects | OrganizePages | PrepareForAccessibility | PrepareForm | ProtectPdf | RedactPdf |
                                  RequestSignatures | ScanAndOCR | UseCertificate | UseGuidedActions | UsePrintProduction}]
        [-ResetRemovedToolsFromToolsTab]
        [<CommonParameters>]
#>

function Set-AdobeAcrobatReaderSetting
{
    <#
    .EXAMPLE
        PS> Set-AdobeAcrobatReaderSetting -ShowToolsPane 'Disabled' -OpenFileAttachments 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # --- Preferences
        ## Documents
        [state] $ShowToolsPane,

        ## General
        [state] $ShowCloudStorageOnFileOpen,
        [state] $ShowCloudStorageOnFileSave,
        [state] $ShowMessagesAtLaunch,
        [GpoState] $ShowMessagesAtLaunchGPO,
        [state] $ShowMessagesWhenViewingPdf,
        [GpoState] $ShowMessagesWhenViewingPdfGPO,
        [AdobeCrashReportsMode] $SendCrashReports,

        ## Email accounts
        [GpoStateWithoutEnabled] $WebmailGPO,

        ## Javascript
        [state] $Javascript,
        [GpoStateWithoutEnabled] $JavascriptGPO,
        [state] $JavascriptMenuItemsExecution,
        [state] $JavascriptGlobalObjectSecurity,

        ## Reviewing
        [state] $SharedReviewWelcomeDialog,

        ## Security (enhanced)
        [state] $ProtectedMode,
        [GpoState] $ProtectedModeGPO,
        [state] $AppContainer,
        [GpoState] $AppContainerGPO,
        [AdobeProtectedViewMode] $ProtectedView,
        [AdobeProtectedViewModeGpo] $ProtectedViewGPO,
        [state] $EnhancedSecurity,
        [GpoState] $EnhancedSecurityGPO,
        [state] $TrustCertifiedDocuments,
        [GpoState] $TrustCertifiedDocumentsGPO,
        [state] $TrustOSTrustedSites,
        [GpoState] $TrustOSTrustedSitesGPO,
        [GpoStateWithoutEnabled] $AddTrustedFilesFoldersGPO,
        [GpoStateWithoutEnabled] $AddTrustedSitesGPO,

        ## Trust manager
        [state] $OpenFileAttachments,
        [GpoStateWithoutEnabled] $OpenFileAttachmentsGPO,
        [AdobeInternetAccessMode] $InternetAccessFromPdf,
        [AdobeInternetAccessModeGpo] $InternetAccessFromPdfGPO,
        [AdobeInternetAccessUnknownUrlMode] $InternetAccessFromPdfUnknownUrl,
        [AdobeInternetAccessUnknownUrlModeGpo] $InternetAccessFromPdfUnknownUrlGPO,

        ## Units
        [AdobePageUnits] $PageUnits,

        # --- Miscellaneous
        ## Ads
        [GpoStateWithoutEnabled] $UpsellGPO,
        [GpoStateWithoutEnabled] $UpsellMobileAppGPO,

        ## Cloud storage
        [GpoStateWithoutEnabled] $AdobeCloudStorageGPO,
        [GpoStateWithoutEnabled] $SharePointGPO,
        [GpoStateWithoutEnabled] $ThirdPartyCloudStorageGPO,

        ## Tips
        [GpoStateWithoutEnabled] $FirstLaunchExperienceGPO,
        [GpoStateWithoutEnabled] $OnboardingDialogsGPO,
        [GpoStateWithoutEnabled] $PopupTipsGPO,

        ## Others
        [GpoStateWithoutDisabled] $AcceptEulaGPO,
        [GpoState] $ChromeExtensionGPO,
        [GpoStateWithoutEnabled] $CrashReporterDialogGPO,
        [AdobeHomeTopBannerMode] $HomeTopBannerGPO,
        [GpoStateWithoutEnabled] $OnlineServicesGPO,
        [GpoStateWithoutEnabled] $OutlookPluginGPO,
        [GpoStateWithoutEnabled] $ShareFileGPO,
        [GpoStateWithoutEnabled] $TelemetryGPO,
        [state] $SynchronizerRunAtStartup,
        [state] $SynchronizerTaskManagerProcess,

        [ValidateSet([AdobeAcrobatAppNames])]
        [string[]] $RemoveToolFromToolsTab,
        [switch] $ResetRemovedToolsFromToolsTab
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
            # --- Preferences
            ## Documents
            'ShowToolsPane'                      { Set-AcrobatReaderShowToolsPane -State $ShowToolsPane }

            ## General
            'ShowCloudStorageOnFileOpen'         { Set-AcrobatReaderShowCloudStorage -OnFileOpen $ShowCloudStorageOnFileOpen }
            'ShowCloudStorageOnFileSave'         { Set-AcrobatReaderShowCloudStorage -OnFileSave $ShowCloudStorageOnFileSave }
            'ShowMessagesAtLaunch'               { Set-AcrobatReaderShowMessagesAtLaunch -State $ShowMessagesAtLaunch }
            'ShowMessagesAtLaunchGPO'            { Set-AcrobatReaderShowMessagesAtLaunch -GPO $ShowMessagesAtLaunchGPO }
            'ShowMessagesWhenViewingPdf'         { Set-AcrobatReaderShowMessagesWhenViewingPdf -State $ShowMessagesWhenViewingPdf }
            'ShowMessagesWhenViewingPdfGPO'      { Set-AcrobatReaderShowMessagesWhenViewingPdf -GPO $ShowMessagesWhenViewingPdfGPO }
            'SendCrashReports'                   { Set-AcrobatReaderSendCrashReports -Value $SendCrashReports }

            ## Email accounts
            'WebmailGPO'                         { Set-AcrobatReaderWebmail -GPO $WebmailGPO }

            ## Javascript
            'Javascript'                         { Set-AcrobatReaderJavascript -State $Javascript }
            'JavascriptGPO'                      { Set-AcrobatReaderJavascript -GPO $JavascriptGPO }
            'JavascriptMenuItemsExecution'       { Set-AcrobatReaderJavascriptMenuItemsExecution -State $JavascriptMenuItemsExecution }
            'JavascriptGlobalObjectSecurity'     { Set-AcrobatReaderJavascriptGlobalObjectSecurity -State $JavascriptGlobalObjectSecurity }

            ## Reviewing
            'SharedReviewWelcomeDialog'          { Set-AcrobatReaderSharedReviewWelcomeDialog -State $SharedReviewWelcomeDialog }

            ## Security (enhanced)
            'ProtectedMode'                      { Set-AcrobatReaderProtectedMode -State $ProtectedMode }
            'ProtectedModeGPO'                   { Set-AcrobatReaderProtectedMode -GPO $ProtectedModeGPO }
            'AppContainer'                       { Set-AcrobatReaderAppContainer -State $AppContainer }
            'AppContainerGPO'                    { Set-AcrobatReaderAppContainer -GPO $AppContainerGPO }
            'ProtectedView'                      { Set-AcrobatReaderProtectedView -State $ProtectedView }
            'ProtectedViewGPO'                   { Set-AcrobatReaderProtectedView -GPO $ProtectedViewGPO }
            'EnhancedSecurity'                   { Set-AcrobatReaderEnhancedSecurity -State $EnhancedSecurity }
            'EnhancedSecurityGPO'                { Set-AcrobatReaderEnhancedSecurity -GPO $EnhancedSecurityGPO }
            'TrustCertifiedDocuments'            { Set-AcrobatReaderTrustCertifiedDocuments -State $TrustCertifiedDocuments }
            'TrustCertifiedDocumentsGPO'         { Set-AcrobatReaderTrustCertifiedDocuments -GPO $TrustCertifiedDocumentsGPO }
            'TrustOSTrustedSites'                { Set-AcrobatReaderTrustOSTrustedSites -State $TrustOSTrustedSites }
            'TrustOSTrustedSitesGPO'             { Set-AcrobatReaderTrustOSTrustedSites -GPO $TrustOSTrustedSitesGPO }
            'AddTrustedFilesFoldersGPO'          { Set-AcrobatReaderTrustedFilesFolders -GPO $AddTrustedFilesFoldersGPO }
            'AddTrustedSitesGPO'                 { Set-AcrobatReaderTrustedSites -GPO $AddTrustedSitesGPO }

            ## Trust manager
            'OpenFileAttachments'                { Set-AcrobatReaderOpenFileAttachments -State $OpenFileAttachments }
            'OpenFileAttachmentsGPO'             { Set-AcrobatReaderOpenFileAttachments -GPO $OpenFileAttachmentsGPO }
            'InternetAccessFromPdf'              { Set-AcrobatReaderInternetAccess -State $InternetAccessFromPdf }
            'InternetAccessFromPdfGPO'           { Set-AcrobatReaderInternetAccess -GPO $InternetAccessFromPdfGPO }
            'InternetAccessFromPdfUnknownUrl'    { Set-AcrobatReaderInternetAccessUnknownUrl -State $InternetAccessFromPdfUnknownUrl }
            'InternetAccessFromPdfUnknownUrlGPO' { Set-AcrobatReaderInternetAccessUnknownUrl -GPO $InternetAccessFromPdfUnknownUrlGPO }

            ## Units
            'PageUnits'                          { Set-AcrobatReaderPageUnits -Value $PageUnits }


            # --- Miscellaneous
            ## Ads
            'UpsellGPO'                          { Set-AcrobatReaderUpsell -GPO $UpsellGPO }
            'UpsellMobileAppGPO'                 { Set-AcrobatReaderUpsellMobileApp -GPO $UpsellMobileAppGPO }

            ## Cloud storage
            'AdobeCloudStorageGPO'               { Set-AcrobatReaderAdobeCloudStorage -GPO $AdobeCloudStorageGPO }
            'SharePointGPO'                      { Set-AcrobatReaderSharePoint -GPO $SharePointGPO }
            'ThirdPartyCloudStorageGPO'          { Set-AcrobatReaderThirdPartyCloudStorage -GPO $ThirdPartyCloudStorageGPO }

            ## Tips
            'FirstLaunchExperienceGPO'           { Set-AcrobatReaderFirstLaunchExperience -GPO $FirstLaunchExperienceGPO }
            'OnboardingDialogsGPO'               { Set-AcrobatReaderOnboardingDialogs -GPO $OnboardingDialogsGPO }
            'PopupTipsGPO'                       { Set-AcrobatReaderPopupTips -GPO $PopupTipsGPO }

            ## Others
            'AcceptEulaGPO'                      { Set-AcrobatReaderAcceptEULA -GPO $AcceptEulaGPO }
            'ChromeExtensionGPO'                 { Set-AcrobatReaderChromeExtension -GPO $ChromeExtensionGPO }
            'CrashReporterDialogGPO'             { Set-AcrobatReaderCrashReporterDialog -GPO $CrashReporterDialogGPO }
            'ShareFileGPO'                       { Set-AcrobatReaderShareFile -GPO $ShareFileGPO }
            'HomeTopBannerGPO'                   { Set-AcrobatReaderHomeTopBanner -GPO $HomeTopBannerGPO }
            'OnlineServicesGPO'                  { Set-AcrobatReaderOnlineServices -GPO $OnlineServicesGPO }
            'OutlookPluginGPO'                   { Set-AcrobatReaderOutlookPlugin -GPO $OutlookPluginGPO }
            'TelemetryGPO'                       { Set-AcrobatReaderTelemetry -GPO $TelemetryGPO }
            'SynchronizerRunAtStartup'           { Set-AdobeSynchronizer -RunAtStartup $SynchronizerRunAtStartup }
            'SynchronizerTaskManagerProcess'     { Set-AdobeSynchronizer -TaskManagerProcess $SynchronizerTaskManagerProcess }
            'RemoveToolFromToolsTab'             { Remove-AcrobatToolFromToolsTab -Name $RemoveToolFromToolsTab }
            'ResetRemovedToolsFromToolsTab'      { Remove-AcrobatToolFromToolsTab -Reset:$ResetRemovedToolsFromToolsTab }
        }
    }
}
