#=================================================================================================================
#                                          Adobe Acrobat Reader Setting
#=================================================================================================================

# GPO parameters are not always a featurelockdown inside HKEY_LOCAL_MACHINE\SOFTWARE\Policies.
# In this context, GPO means that the setting may not have a GUI option.
# This is the case for all settings in the "miscellaneous" folder.

# https://adobe.com/devnet-docs/acrobatetk/tools/PrefRef/Windows/

<#
.SYNTAX
    Set-AdobeAcrobatReaderSetting
        [-ShowToolsPane {Disabled | Enabled}]
        [-ShowCloudStorageOnFileOpen {Disabled | Enabled}]
        [-ShowCloudStorageOnFileSave {Disabled | Enabled}]
        [-ShowMessagesAtLaunch {Disabled | Enabled}]
        [-ShowMessagesAtLaunchGPO {Disabled | Enabled | NotConfigured}]
        [-ShowMessagesWhenViewingPdf {Disabled | Enabled}]
        [-ShowMessagesWhenViewingPdfGPO {Disabled | Enabled | NotConfigured}]
        [-SendCrashReports {Ask | Always | Never}]
        [-WebmailGPO {Disabled | NotConfigured}]
        [-Javascript {Disabled | Enabled}]
        [-JavascriptGPO {Disabled | NotConfigured}]
        [-JavascriptMenuItemsExecution {Disabled | Enabled}]
        [-JavascriptGlobalObjectSecurity {Disabled | Enabled}]
        [-SharedReviewWelcomeDialog {Disabled | Enabled}]
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
        [-OpenFileAttachments {Disabled | Enabled}]
        [-OpenFileAttachmentsGPO {Disabled | NotConfigured}]
        [-InternetAccessFromPdf {BlockAllWebSites | AllowAllWebSites | Custom}]
        [-InternetAccessFromPdfGPO {BlockAllWebSites | AllowAllWebSites | Custom | NotConfigured}]
        [-InternetAccessFromPdfUnknownUrl {Ask | Allow | Block}]
        [-InternetAccessFromPdfUnknownUrlGPO {Ask | Allow | Block | NotConfigured}]
        [-PageUnits {Points | Inches | Millimeters | Centimeters | Picas}]
        [-UpsellGPO {Disabled | NotConfigured}]
        [-UpsellMobileAppGPO {Disabled | NotConfigured}]
        [-AdobeCloudStorageGPO {Disabled | NotConfigured}]
        [-SharePointGPO {Disabled | NotConfigured}]
        [-ThirdPartyCloudStorageGPO {Disabled | NotConfigured}]
        [-FirstLaunchExperienceGPO {Disabled | NotConfigured}]
        [-OnboardingDialogsGPO {Disabled | NotConfigured}]
        [-PopupTipsGPO {Disabled | NotConfigured}]
        [-AcceptEulaGPO {Enabled | NotConfigured}]
        [-CrashReporterDialogGPO {Disabled | NotConfigured}]
        [-HomeTopBannerGPO {Disabled | Expanded | Collapsed}]
        [-OnlineServicesGPO {Disabled | NotConfigured}]
        [-OutlookPluginGPO {Disabled | NotConfigured}]
        [-ShareFileGPO {Disabled | NotConfigured}]

        [-UsageStatistics {Disabled | Enabled}]
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
        ## documents
        [state] $ShowToolsPane,

        ## general
        [state] $ShowCloudStorageOnFileOpen,
        [state] $ShowCloudStorageOnFileSave,
        [state] $ShowMessagesAtLaunch,
        [GpoState] $ShowMessagesAtLaunchGPO,
        [state] $ShowMessagesWhenViewingPdf,
        [GpoState] $ShowMessagesWhenViewingPdfGPO,
        [AdobeCrashReportsMode] $SendCrashReports,

        ## email accounts
        [GpoStateWithoutEnabled] $WebmailGPO,

        ## javascript
        [state] $Javascript,
        [GpoStateWithoutEnabled] $JavascriptGPO,
        [state] $JavascriptMenuItemsExecution,
        [state] $JavascriptGlobalObjectSecurity,

        ## reviewing
        [state] $SharedReviewWelcomeDialog,

        ## security (enhanced)
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

        ## trust manager
        [state] $OpenFileAttachments,
        [GpoStateWithoutEnabled] $OpenFileAttachmentsGPO,
        [AdobeInternetAccessMode] $InternetAccessFromPdf,
        [AdobeInternetAccessModeGpo] $InternetAccessFromPdfGPO,
        [AdobeInternetAccessUnknownUrlMode] $InternetAccessFromPdfUnknownUrl,
        [AdobeInternetAccessUnknownUrlModeGpo] $InternetAccessFromPdfUnknownUrlGPO,

        ## units
        [AdobePageUnits] $PageUnits,

        # --- Miscellaneous
        ## ads
        [GpoStateWithoutEnabled] $UpsellGPO,
        [GpoStateWithoutEnabled] $UpsellMobileAppGPO,

        ## cloud storage
        [GpoStateWithoutEnabled] $AdobeCloudStorageGPO,
        [GpoStateWithoutEnabled] $SharePointGPO,
        [GpoStateWithoutEnabled] $ThirdPartyCloudStorageGPO,

        ## tips
        [GpoStateWithoutEnabled] $FirstLaunchExperienceGPO,
        [GpoStateWithoutEnabled] $OnboardingDialogsGPO,
        [GpoStateWithoutEnabled] $PopupTipsGPO,

        ## others
        [GpoStateWithoutDisabled] $AcceptEulaGPO,
        [GpoStateWithoutEnabled] $CrashReporterDialogGPO,
        [AdobeHomeTopBannerMode] $HomeTopBannerGPO,
        [GpoStateWithoutEnabled] $OnlineServicesGPO,
        [GpoStateWithoutEnabled] $OutlookPluginGPO,
        [GpoStateWithoutEnabled] $ShareFileGPO,
        [GpoStateWithoutEnabled] $TelemetryGPO
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
            'ShowToolsPane'                      { Set-AcrobatReaderShowToolsPane -State $ShowToolsPane }

            'ShowCloudStorageOnFileOpen'         { Set-AcrobatReaderShowCloudStorage -OnFileOpen $ShowCloudStorageOnFileOpen }
            'ShowCloudStorageOnFileSave'         { Set-AcrobatReaderShowCloudStorage -OnFileSave $ShowCloudStorageOnFileSave }
            'ShowMessagesAtLaunch'               { Set-AcrobatReaderShowMessagesAtLaunch -State $ShowMessagesAtLaunch }
            'ShowMessagesAtLaunchGPO'            { Set-AcrobatReaderShowMessagesAtLaunch -GPO $ShowMessagesAtLaunchGPO }
            'ShowMessagesWhenViewingPdf'         { Set-AcrobatReaderShowMessagesWhenViewingPdf -State $ShowMessagesWhenViewingPdf }
            'ShowMessagesWhenViewingPdfGPO'      { Set-AcrobatReaderShowMessagesWhenViewingPdf -GPO $ShowMessagesWhenViewingPdfGPO }
            'SendCrashReports'                   { Set-AcrobatReaderSendCrashReports -Value $SendCrashReports }

            'WebmailGPO'                         { Set-AcrobatReaderWebmail -GPO $WebmailGPO }

            'Javascript'                         { Set-AcrobatReaderJavascript -State $Javascript }
            'JavascriptGPO'                      { Set-AcrobatReaderJavascript -GPO $JavascriptGPO }
            'JavascriptMenuItemsExecution'       { Set-AcrobatReaderJavascriptMenuItemsExecution -State $JavascriptMenuItemsExecution }
            'JavascriptGlobalObjectSecurity'     { Set-AcrobatReaderJavascriptGlobalObjectSecurity -State $JavascriptGlobalObjectSecurity }

            'SharedReviewWelcomeDialog'          { Set-AcrobatReaderSharedReviewWelcomeDialog -State $SharedReviewWelcomeDialog }

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

            'OpenFileAttachments'                { Set-AcrobatReaderOpenFileAttachments -State $OpenFileAttachments }
            'OpenFileAttachmentsGPO'             { Set-AcrobatReaderOpenFileAttachments -GPO $OpenFileAttachmentsGPO }
            'InternetAccessFromPdf'              { Set-AcrobatReaderInternetAccess -State $InternetAccessFromPdf }
            'InternetAccessFromPdfGPO'           { Set-AcrobatReaderInternetAccess -GPO $InternetAccessFromPdfGPO }
            'InternetAccessFromPdfUnknownUrl'    { Set-AcrobatReaderInternetAccessUnknownUrl -State $InternetAccessFromPdfUnknownUrl }
            'InternetAccessFromPdfUnknownUrlGPO' { Set-AcrobatReaderInternetAccessUnknownUrl -GPO $InternetAccessFromPdfUnknownUrlGPO }

            'PageUnits'                          { Set-AcrobatReaderPageUnits -Value $PageUnits }


            'UpsellGPO'                          { Set-AcrobatReaderUpsell -GPO $UpsellGPO }
            'UpsellMobileAppGPO'                 { Set-AcrobatReaderUpsellMobileApp -GPO $UpsellMobileAppGPO }

            'AdobeCloudStorageGPO'               { Set-AcrobatReaderAdobeCloudStorage -GPO $AdobeCloudStorageGPO }
            'SharePointGPO'                      { Set-AcrobatReaderSharePoint -GPO $SharePointGPO }
            'ThirdPartyCloudStorageGPO'          { Set-AcrobatReaderThirdPartyCloudStorage -GPO $ThirdPartyCloudStorageGPO }

            'FirstLaunchExperienceGPO'           { Set-AcrobatReaderFirstLaunchExperience -GPO $FirstLaunchExperienceGPO }
            'OnboardingDialogsGPO'               { Set-AcrobatReaderOnboardingDialogs -GPO $OnboardingDialogsGPO }
            'PopupTipsGPO'                       { Set-AcrobatReaderPopupTips -GPO $PopupTipsGPO }

            'AcceptEulaGPO'                      { Set-AcrobatReaderAcceptEULA -GPO $AcceptEulaGPO }
            'CrashReporterDialogGPO'             { Set-AcrobatReaderCrashReporterDialog -GPO $CrashReporterDialogGPO }
            'ShareFileGPO'                       { Set-AcrobatReaderShareFile -GPO $ShareFileGPO }
            'HomeTopBannerGPO'                   { Set-AcrobatReaderHomeTopBanner -GPO $HomeTopBannerGPO }
            'OnlineServicesGPO'                  { Set-AcrobatReaderOnlineServices -GPO $OnlineServicesGPO }
            'OutlookPluginGPO'                   { Set-AcrobatReaderOutlookPlugin -GPO $OutlookPluginGPO }
            'TelemetryGPO'                       { Set-AcrobatReaderTelemetry -GPO $TelemetryGPO }
        }
    }
}
