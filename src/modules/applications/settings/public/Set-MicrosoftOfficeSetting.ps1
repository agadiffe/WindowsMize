#=================================================================================================================
#                                            Microsoft Office Setting
#=================================================================================================================

<#
  You can use the 'Office Deployment Tool (ODT)' to automate the installation of Microsoft Office.
  With that tool, you can choose which program to install. e.g. Only Word, Excel and PowerPoint.
  
  https://officecdn.microsoft.com/pr/wsus/setup.exe (Office Deployment Tool (ODT))
  https://config.office.com/deploymentsettings (MS Office configuration file)

  Run 'tools\MsOffice365_Install.cmd' to install Ms Office 365.

  To activate Office, be careful not to fall into the mass grave.
#>

<#
.SYNTAX
    Set-MicrosoftOfficeSetting
        # Options
        [-DefaultThemeGPO {Colorful | DarkGray | Black | White | NotConfigured}]
        [-LinkedinFeatures {Disabled | Enabled}]
        [-LinkedinFeaturesGPO {Disabled | NotConfigured}]
        [-ShowStartScreen {Disabled | Enabled}]
        [-ShowStartScreenGPO {Disabled | NotConfigured}]
        [-Copilot {Disabled | Enabled}]
        [-DefaultFileFormat {Office | OpenDocument}]
        [-DefaultSaveLocation {Computer | Cloud}]

        # Miscellaneous
        [-AcceptEULAsGPO {Enabled | NotConfigured}]
        [-AIContentSafetyGPO {Disabled | NotConfigured}]
        [-BlockSigninGPO {Enabled | NotConfigured}]
        [-DiscountProgramNotifsGPO {Disabled | Enabled | NotConfigured}]
        [-FirstRunAboutSigninGPO {Disabled | NotConfigured}]
        [-FirstRunOptinWizardGPO {Disabled | NotConfigured}]
        [-ShowFileFormatDialogGPO {Disabled | NotConfigured}]
        [-TeachingTips {Disabled | Enabled}]

        # Privacy
        [-AITrainingGPO {Disabled | NotConfigured}]
        [-CeipGPO {Disabled | NotConfigured}]
        [-DiagnosticsGPO {Disabled | Enabled | NotConfigured}]
        [-ErrorReportingGPO {Disabled | NotConfigured}]
        [-FeedbackGPO {Disabled | NotConfigured}]
        [-SendPersonalInfoGPO {Disabled | NotConfigured}]
        [-SurveysGPO {Disabled | NotConfigured}]
        [-TelemetryGPO {Disabled | NotConfigured}]

        # Connected experiences
        [-AllConnectedExperiencesGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatAnalyzeContentGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatDownloadContentGPO {Disabled | NotConfigured}]
        [-OptionalConnectedExperiencesGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-MicrosoftOfficeSetting
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftOfficeSetting -TeachingTips 'Disabled' -SendPersonalInfoGPO 'Disabled' -TelemetryGPO 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # Options
        [OfficeThemeGpo] $DefaultThemeGPO,
        [state] $LinkedinFeatures,
        [GpoStateWithoutEnabled] $LinkedinFeaturesGPO,
        [state] $ShowStartScreen,
        [GpoStateWithoutEnabled] $ShowStartScreenGPO,
        [state] $Copilot,
        [OfficeFileFormat] $DefaultFileFormat,
        [OfficeSaveLocation] $DefaultSaveLocation,

        # Miscellaneous
        [GpoStateWithoutDisabled] $AcceptEULAsGPO,
        [GpoStateWithoutEnabled] $AIContentSafetyGPO,
        [GpoStateWithoutDisabled] $BlockSigninGPO,
        [GpoState] $DiscountProgramNotifsGPO,
        [GpoStateWithoutEnabled] $FirstRunAboutSigninGPO,
        [GpoStateWithoutEnabled] $FirstRunOptinWizardGPO,
        [GpoStateWithoutEnabled] $ShowFileFormatDialogGPO,
        [state] $TeachingTips,

        # Privacy
        [GpoStateWithoutEnabled] $AITrainingGPO,
        [GpoStateWithoutEnabled] $CeipGPO,
        [GpoState] $DiagnosticsGPO,
        [GpoStateWithoutEnabled] $ErrorReportingGPO,
        [GpoStateWithoutEnabled] $FeedbackGPO,
        [GpoStateWithoutEnabled] $SendPersonalInfoGPO,
        [GpoStateWithoutEnabled] $SurveysGPO,
        [GpoStateWithoutEnabled] $TelemetryGPO,

        # Connected experiences
        [GpoStateWithoutEnabled] $AllConnectedExperiencesGPO,
        [GpoStateWithoutEnabled] $ConnectedExperiencesThatAnalyzeContentGPO,
        [GpoStateWithoutEnabled] $ConnectedExperiencesThatDownloadContentGPO,
        [GpoStateWithoutEnabled] $OptionalConnectedExperiencesGPO
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
            # Options
            'DefaultThemeGPO'          { Set-MSOfficeDefaultTheme -GPO $DefaultThemeGPO }
            'LinkedinFeatures'         { Set-MSOfficeLinkedinFeatures -State $LinkedinFeatures }
            'LinkedinFeaturesGPO'      { Set-MSOfficeLinkedinFeatures -GPO $LinkedinFeaturesGPO }
            'ShowStartScreen'          { Set-MSOfficeShowStartScreen -State $ShowStartScreen }
            'ShowStartScreenGPO'       { Set-MSOfficeShowStartScreen -GPO $ShowStartScreenGPO }
            'Copilot'                  { Set-MSOfficeCopilot -State $Copilot }
            'DefaultFileFormat'        { Set-MSOfficeDefaultFileFormat -FileFormat $DefaultFileFormat }
            'DefaultSaveLocation'      { Set-MSOfficeDefaultSaveLocation -Location $DefaultSaveLocation }

            # Miscellaneous
            'AcceptEULAsGPO'           { Set-MSOfficeAcceptEULAs -GPO $AcceptEULAsGPO }
            'AIContentSafetyGPO'       { Set-MSOfficeAIContentSafety -GPO $AIContentSafetyGPO }
            'BlockSigninGPO'           { Set-MSOfficeBlockSignin -GPO $BlockSigninGPO }
            'DiscountProgramNotifsGPO' { Set-MSOfficeDiscountProgramNotifs -GPO $DiscountProgramNotifsGPO }
            'FirstRunAboutSigninGPO'   { Set-MSOfficeFirstRunAboutSignin -GPO $FirstRunAboutSigninGPO }
            'FirstRunOptinWizardGPO'   { Set-MSOfficeFirstRunOptinWizard -GPO $FirstRunOptinWizardGPO }
            'ShowFileFormatDialogGPO'  { Set-MSOfficeShowFileFormatDialog -GPO $ShowFileFormatDialogGPO }
            'TeachingTips'             { Set-MSOfficeTeachingTips -State $TeachingTips }

            # Privacy
            'AITrainingGPO'            { Set-MSOfficeAITraining -GPO $AITrainingGPO }
            'CeipGPO'                  { Set-MSOfficeCeip -GPO $CeipGPO }
            'DiagnosticsGPO'           { Set-MSOfficeDiagnostics -GPO $DiagnosticsGPO }
            'ErrorReportingGPO'        { Set-MSOfficeErrorReporting -GPO $ErrorReportingGPO }
            'FeedbackGPO'              { Set-MSOfficeFeedback -GPO $FeedbackGPO }
            'SendPersonalInfoGPO'      { Set-MSOfficeSendPersonalInfo -GPO $SendPersonalInfoGPO }
            'SurveysGPO'               { Set-MSOfficeSurveys -GPO $SurveysGPO }
            'TelemetryGPO'             { Set-MSOfficeTelemetry -GPO $TelemetryGPO }

            # Connected experiences
            'AllConnectedExperiencesGPO'                 { Set-MSOfficeConnectedExperiences -AllConnectedExperiencesGPO $AllConnectedExperiencesGPO }
            'ConnectedExperiencesThatAnalyzeContentGPO'  { Set-MSOfficeConnectedExperiences -ConnectedExperiencesThatAnalyzeContentGPO $ConnectedExperiencesThatAnalyzeContentGPO }
            'ConnectedExperiencesThatDownloadContentGPO' { Set-MSOfficeConnectedExperiences -ConnectedExperiencesThatDownloadContentGPO $ConnectedExperiencesThatDownloadContentGPO }
            'OptionalConnectedExperiencesGPO'            { Set-MSOfficeConnectedExperiences -OptionalConnectedExperiencesGPO $OptionalConnectedExperiencesGPO }
        }
    }
}
