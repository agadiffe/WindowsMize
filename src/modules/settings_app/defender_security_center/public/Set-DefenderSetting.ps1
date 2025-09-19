#=================================================================================================================
#                              Privacy & Security > Windows Security App - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderSetting
        [-CloudDeliveredProtection {Disabled | Basic | Advanced}]
        [-CloudDeliveredProtectionGPO {Disabled | Basic | Advanced | NotConfigured}]
        [-AutoSampleSubmission {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples}]
        [-AutoSampleSubmissionGPO {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured}]
        [-AdminProtection {Disabled | Enabled}]
        [-SmartAppControl {Disabled | Enabled}]
        [-CheckAppsAndFiles {Disabled | Enabled}]
        [-CheckAppsAndFilesGPO {Disabled | Warn | Block | NotConfigured}]
        [-PhishingProtectionGPO {Disabled | Enabled | NotConfigured}]
        [-UnwantedAppBlocking {Disabled | Enabled | AuditMode}]
        [-UnwantedAppBlockingGPO {Disabled | Enabled | AuditMode | NotConfigured}]
        [-SmartScreenForEdge {Disabled | Enabled}]
        [-SmartScreenForEdgeGPO {Disabled | Enabled | NotConfigured}]
        [-SmartScreenForStoreApps {Disabled | Enabled}]
        [-WatsonEventsReportGPO {Disabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-DefenderSetting
{
    <#
    .EXAMPLE
        PS> Set-DefenderSetting -CloudDeliveredProtection 'Disabled' -AutoSampleSubmission 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        # virus & threat protection
        [CloudDelivereMode] $CloudDeliveredProtection,

        [GpoCloudDelivereMode] $CloudDeliveredProtectionGPO,

        [SampleSubmissionMode] $AutoSampleSubmission,

        [GpoSampleSubmissionMode] $AutoSampleSubmissionGPO,

        # account protection
        [state] $AdminProtection,

        # app & browser control
        [state] $SmartAppControl,

        [state] $CheckAppsAndFiles,

        [GpoCheckAppsAndFilesMode] $CheckAppsAndFilesGPO,

        [GpoState] $PhishingProtectionGPO,

        [PUAProtectionMode] $UnwantedAppBlocking,

        [GpoPUAProtectionMode] $UnwantedAppBlockingGPO,

        [state] $SmartScreenForEdge,

        [GpoState] $SmartScreenForEdgeGPO,

        [state] $SmartScreenForStoreApps,

        # miscellaneous
        [GpoStateWithoutEnabled] $WatsonEventsReportGPO
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
            'CloudDeliveredProtection'    { Set-DefenderCloudDeliveredProtection -State $CloudDeliveredProtection }
            'CloudDeliveredProtectionGPO' { Set-DefenderCloudDeliveredProtection -GPO $CloudDeliveredProtectionGPO }
            'AutoSampleSubmission'        { Set-DefenderAutoSampleSubmission -State $AutoSampleSubmission }
            'AutoSampleSubmissionGPO'     { Set-DefenderAutoSampleSubmission -GPO $AutoSampleSubmissionGPO }

            'AdminProtection'             { Set-DefenderAdminProtection -State $AdminProtection }

            'SmartAppControl'             { Set-DefenderSmartAppControl -State $SmartAppControl }
            'CheckAppsAndFiles'           { Set-DefenderCheckAppsAndFiles -State $CheckAppsAndFiles }
            'CheckAppsAndFilesGPO'        { Set-DefenderCheckAppsAndFiles -GPO $CheckAppsAndFilesGPO }
            'PhishingProtectionGPO'       { Set-DefenderPhishingProtection -GPO $PhishingProtectionGPO }
            'UnwantedAppBlocking'         { Set-DefenderUnwantedAppBlocking -State $UnwantedAppBlocking }
            'UnwantedAppBlockingGPO'      { Set-DefenderUnwantedAppBlocking -GPO $UnwantedAppBlockingGPO }
            'SmartScreenForEdge'          { Set-DefenderSmartScreenForEdge -State $SmartScreenForEdge }
            'SmartScreenForEdgeGPO'       { Set-DefenderSmartScreenForEdge -GPO $SmartScreenForEdgeGPO }
            'SmartScreenForStoreApps'     { Set-DefenderSmartScreenForStoreApps -State $SmartScreenForStoreApps }

            'WatsonEventsReportGPO'       { Set-DefenderWatsonEventsReport -GPO $WatsonEventsReportGPO }
        }
    }
}
