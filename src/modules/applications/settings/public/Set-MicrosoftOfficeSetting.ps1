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
        [-AcceptEULAsGPO {Enabled | NotConfigured}]
        [-BlockSigninGPO {Enabled | NotConfigured}]
        [-LinkedinFeatures {Disabled | Enabled}]
        [-LinkedinFeaturesGPO {Disabled | NotConfigured}]
        [-ShowStartScreen {Disabled | Enabled}]
        [-ShowStartScreenGPO {Disabled | NotConfigured}]
        [-TeachingTips {Disabled | Enabled}]
        [-AILocalTrainingGPO {Disabled | Enabled}]
        [-CeipGPO {Disabled | NotConfigured}]
        [-DiagnosticsGPO {Disabled | Enabled | NotConfigured}]
        [-DiscountProgramNotifsGPO {Disabled | Enabled | NotConfigured}]
        [-ErrorReportingGPO {Disabled | NotConfigured}]
        [-FeedbackGPO {Disabled | NotConfigured}]
        [-FirstRunAboutSigninGPO {Disabled | NotConfigured}]
        [-FirstRunOptinWizardGPO {Disabled | NotConfigured}]
        [-SendPersonalInfoGPO {Disabled | NotConfigured}]
        [-SurveysGPO {Disabled | NotConfigured}]
        [-TelemetryGPO {Disabled | NotConfigured}]
        [-AllConnectedExperiencesGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatAnalyzeContentGPO {Disabled | NotConfigured}]
        [-ConnectedExperiencesThatDownloadContentGPO {Disabled | NotConfigured}]
        [-OptionalConnectedExperiences {Disabled | Enabled}]
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
        # options
        [state] $LinkedinFeatures,
        [GpoStateWithoutEnabled] $LinkedinFeaturesGPO,
        [state] $ShowStartScreen,
        [GpoStateWithoutEnabled] $ShowStartScreenGPO,

        # miscellaneous
        [GpoStateWithoutDisabled] $AcceptEULAsGPO,
        [GpoStateWithoutDisabled] $BlockSigninGPO,
        [state] $TeachingTips,

        # privacy
        [GpoStateWithoutEnabled] $AILocalTrainingGPO,
        [GpoStateWithoutEnabled] $CeipGPO,
        [GpoState] $DiagnosticsGPO,
        [GpoState] $DiscountProgramNotifsGPO,
        [GpoStateWithoutEnabled] $ErrorReportingGPO,
        [GpoStateWithoutEnabled] $FeedbackGPO,
        [GpoStateWithoutEnabled] $FirstRunAboutSigninGPO,
        [GpoStateWithoutEnabled] $FirstRunOptinWizardGPO,
        [GpoStateWithoutEnabled] $SendPersonalInfoGPO,
        [GpoStateWithoutEnabled] $SurveysGPO,
        [GpoStateWithoutEnabled] $TelemetryGPO,

        # connected experiences
        [GpoStateWithoutEnabled] $AllConnectedExperiencesGPO,
        [GpoStateWithoutEnabled] $ConnectedExperiencesThatAnalyzeContentGPO,
        [GpoStateWithoutEnabled] $ConnectedExperiencesThatDownloadContentGPO,
        [state] $OptionalConnectedExperiences,
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
            'LinkedinFeatures'         { Set-MSOfficeLinkedinFeatures -State $LinkedinFeatures }
            'LinkedinFeaturesGPO'      { Set-MSOfficeLinkedinFeatures -GPO $LinkedinFeaturesGPO }
            'ShowStartScreen'          { Set-MSOfficeShowStartScreen -State $ShowStartScreen }
            'ShowStartScreenGPO'       { Set-MSOfficeShowStartScreen -GPO $ShowStartScreenGPO }

            'AcceptEULAsGPO'           { Set-MSOfficeAcceptEULAs -GPO $AcceptEULAsGPO }
            'BlockSigninGPO'           { Set-MSOfficeBlockSignin -GPO $BlockSigninGPO }
            'TeachingTips'             { Set-MSOfficeTeachingTips -State $TeachingTips }

            'AILocalTrainingGPO'       { Set-MSOfficeAILocalTraining -GPO $AILocalTrainingGPO }
            'CeipGPO'                  { Set-MSOfficeCeip -GPO $CeipGPO }
            'DiagnosticsGPO'           { Set-MSOfficeDiagnostics -GPO $DiagnosticsGPO }
            'DiscountProgramNotifsGPO' { Set-MSOfficeDiscountProgramNotifs -GPO $DiscountProgramNotifsGPO }
            'ErrorReportingGPO'        { Set-MSOfficeErrorReporting -GPO $ErrorReportingGPO }
            'FeedbackGPO'              { Set-MSOfficeFeedback -GPO $FeedbackGPO }
            'FirstRunAboutSigninGPO'   { Set-MSOfficeFirstRunAboutSignin -GPO $FirstRunAboutSigninGPO }
            'FirstRunOptinWizardGPO'   { Set-MSOfficeFirstRunOptinWizard -GPO $FirstRunOptinWizardGPO }
            'SendPersonalInfoGPO'      { Set-MSOfficeSendPersonalInfo -GPO $SendPersonalInfoGPO }
            'SurveysGPO'               { Set-MSOfficeSurveys -GPO $SurveysGPO }
            'TelemetryGPO'             { Set-MSOfficeTelemetry -GPO $TelemetryGPO }

            'AllConnectedExperiencesGPO'                 { Set-MSOfficeConnectedExperiences -AllConnectedExperiencesGPO $AllConnectedExperiencesGPO }
            'ConnectedExperiencesThatAnalyzeContentGPO'  { Set-MSOfficeConnectedExperiences -ConnectedExperiencesThatAnalyzeContentGPO $ConnectedExperiencesThatAnalyzeContentGPO }
            'ConnectedExperiencesThatDownloadContentGPO' { Set-MSOfficeConnectedExperiences -ConnectedExperiencesThatDownloadContentGPO $ConnectedExperiencesThatDownloadContentGPO }
            'OptionalConnectedExperiences'               { Set-MSOfficeConnectedExperiences -OptionalConnectedExperiences $OptionalConnectedExperiences }
            'OptionalConnectedExperiencesGPO'            { Set-MSOfficeConnectedExperiences -OptionalConnectedExperiencesGPO $OptionalConnectedExperiencesGPO }
        }
    }
}
