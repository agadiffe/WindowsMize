#=================================================================================================================
#                                          Adobe Acrobat Reader Setting
#=================================================================================================================

<#
.SYNTAX
    Set-AdobeAcrobatReaderSetting
        [-ShowToolsPane {Disabled | Enabled}]
        [-ShowCloudStorageOnFileOpen {Disabled | Enabled}]
        [-ShowCloudStorageOnFileSave {Disabled | Enabled}]
        [-ShowMessagesAtLaunch {Disabled | Enabled}]
        [-SendCrashReports {Ask | Always | Never}]
        [-Javascript {Disabled | Enabled}]
        [-ProtectedMode {Disabled | Enabled}]
        [-AppContainer {Disabled | Enabled}]
        [-ProtectedView {Disabled | UnsafeLocationsFiles | AllFiles}]
        [-EnhancedSecurity {Disabled | Enabled}]
        [-TrustCertifiedDocuments {Disabled | Enabled}]
        [-TrustOSTrustedSites {Disabled | Enabled}]
        [-OpenFileAttachments {Disabled | Enabled}]
        [-PageUnits {Points | Inches | Millimeters | Centimeters | Picas}]
        [-RecommendedTools {Expand | Collapse}]
        [-FirstLaunchExperience {Disabled | Enabled}]
        [-Upsell {Disabled | Enabled}]
        [-UsageStatistics {Disabled | Enabled}]
        [-OnlineServices {Disabled | Enabled}]
        [-AdobeCloud {Disabled | Enabled}]
        [-SharePoint {Disabled | Enabled}]
        [-Webmail {Disabled | Enabled}]
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
        # preferences > documents
        [state] $ShowToolsPane,

        # preferences > general
        [state] $ShowCloudStorageOnFileOpen,
        [state] $ShowCloudStorageOnFileSave,
        [state] $ShowMessagesAtLaunch,
        [CrashReportsMode] $SendCrashReports,

        # preferences > javascript
        [state] $Javascript,

        # preferences > security (enhanced)
        [state] $ProtectedMode,
        [state] $AppContainer,
        [ProtectedViewMode] $ProtectedView,
        [state] $EnhancedSecurity,
        [state] $TrustCertifiedDocuments,
        [state] $TrustOSTrustedSites,

        # preferences > trust manager
        [state] $OpenFileAttachments,

        # preferences > units
        [PageUnits] $PageUnits,

        # miscellaneous
        [ExpandCollapse] $RecommendedTools,
        [state] $FirstLaunchExperience,
        [state] $Upsell,
        [state] $UsageStatistics,
        [state] $OnlineServices,
        [state] $AdobeCloud,
        [state] $SharePoint,
        [state] $Webmail
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
            'ShowToolsPane'              { Set-AcrobatReaderShowToolsPane -State $ShowToolsPane }

            'ShowCloudStorageOnFileOpen' { Set-AcrobatReaderShowCloudStorage -OnFileOpen $ShowCloudStorageOnFileOpen }
            'ShowCloudStorageOnFileSave' { Set-AcrobatReaderShowCloudStorage -OnFileSave $ShowCloudStorageOnFileSave }
            'ShowMessagesAtLaunch'       { Set-AcrobatReaderShowMessagesAtLaunch -State $ShowMessagesAtLaunch }
            'SendCrashReports'           { Set-AcrobatReaderSendCrashReports -Value $SendCrashReports }

            'Javascript'                 { Set-AcrobatReaderJavascript -State $Javascript }

            'ProtectedMode'              { Set-AcrobatReaderProtectedMode -State $ProtectedMode }
            'AppContainer'               { Set-AcrobatReaderAppContainer -State $AppContainer }
            'ProtectedView'              { Set-AcrobatReaderProtectedView -Value $ProtectedView }
            'EnhancedSecurity'           { Set-AcrobatReaderEnhancedSecurity -State $EnhancedSecurity }
            'TrustCertifiedDocuments'    { Set-AcrobatReaderTrustCertifiedDocuments -State $TrustCertifiedDocuments }
            'TrustOSTrustedSites'        { Set-AcrobatReaderTrustOSTrustedSites -State $TrustOSTrustedSites }

            'OpenFileAttachments'        { Set-AcrobatReaderOpenFileAttachments -State $OpenFileAttachments }

            'PageUnits'                  { Set-AcrobatReaderPageUnits -Value $PageUnits }

            'RecommendedTools'           { Set-AcrobatReaderRecommendedTools -Value $RecommendedTools }
            'FirstLaunchExperience'      { Set-AcrobatReaderFirstLaunchExperience -State $FirstLaunchExperience }
            'Upsell'                     { Set-AcrobatReaderUpsell -State $Upsell }
            'UsageStatistics'            { Set-AcrobatReaderUsageStatistics -State $UsageStatistics }
            'OnlineServices'             { Set-AcrobatReaderOnlineServices -State $OnlineServices }
            'AdobeCloud'                 { Set-AcrobatReaderAdobeCloud -State $AdobeCloud }
            'SharePoint'                 { Set-AcrobatReaderSharePoint -State $SharePoint }
            'Webmail'                    { Set-AcrobatReaderWebmail -State $Webmail }
        }
    }
}
