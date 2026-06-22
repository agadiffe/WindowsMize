#=================================================================================================================
#                              Privacy & Security > Windows Security App - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderSetting
        # virus & threat protection
        [-CloudDeliveredProtection {Disabled | Basic | Advanced}]
        [-CloudDeliveredProtectionGPO {Disabled | Basic | Advanced | NotConfigured}]
        [-AutoSampleSubmission {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples}]
        [-AutoSampleSubmissionGPO {NeverSend | AlwaysPrompt | SendSafeSamples | SendAllSamples | NotConfigured}]

        # account protection
        [-AdminProtection {Disabled | Enabled}]

        # app & browser control
        [-SmartAppControl {Disabled | Enabled}]
        [-CheckAppsAndFiles {Disabled | Enabled}]
        [-CheckAppsAndFilesGPO {Disabled | Warn | Block | NotConfigured}]
        [-PhishingProtectionGPO {Disabled | Enabled | NotConfigured}]
        [-UnwantedAppBlocking {Disabled | Enabled | AuditMode}]
        [-UnwantedAppBlockingGPO {Disabled | Enabled | AuditMode | NotConfigured}]
        [-SmartScreenForEdge {Disabled | Enabled}]
        [-SmartScreenForEdgeGPO {Disabled | Enabled | NotConfigured}]
        [-SmartScreenForStoreApps {Disabled | Enabled}]

        # miscellaneous
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
        [CloudDeliveredMode] $CloudDeliveredProtection,
        [GpoCloudDeliveredMode] $CloudDeliveredProtectionGPO,
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
            # virus & threat protection
            'CloudDeliveredProtection'    { Set-DefenderCloudDeliveredProtection -State $CloudDeliveredProtection }
            'CloudDeliveredProtectionGPO' { Set-DefenderCloudDeliveredProtection -GPO $CloudDeliveredProtectionGPO }
            'AutoSampleSubmission'        { Set-DefenderAutoSampleSubmission -Consent $AutoSampleSubmission }
            'AutoSampleSubmissionGPO'     { Set-DefenderAutoSampleSubmission -GPO $AutoSampleSubmissionGPO }

            # account protection
            'AdminProtection'             { Set-DefenderAdminProtection -State $AdminProtection }

            # app & browser control
            'SmartAppControl'             { Set-DefenderSmartAppControl -State $SmartAppControl }
            'CheckAppsAndFiles'           { Set-DefenderCheckAppsAndFiles -State $CheckAppsAndFiles }
            'CheckAppsAndFilesGPO'        { Set-DefenderCheckAppsAndFiles -GPO $CheckAppsAndFilesGPO }
            'PhishingProtectionGPO'       { Set-DefenderPhishingProtection -GPO $PhishingProtectionGPO }
            'UnwantedAppBlocking'         { Set-DefenderUnwantedAppBlocking -State $UnwantedAppBlocking }
            'UnwantedAppBlockingGPO'      { Set-DefenderUnwantedAppBlocking -GPO $UnwantedAppBlockingGPO }
            'SmartScreenForEdge'          { Set-DefenderSmartScreenForEdge -State $SmartScreenForEdge }
            'SmartScreenForEdgeGPO'       { Set-DefenderSmartScreenForEdge -GPO $SmartScreenForEdgeGPO }
            'SmartScreenForStoreApps'     { Set-DefenderSmartScreenForStoreApps -State $SmartScreenForStoreApps }

            # miscellaneous
            'WatsonEventsReportGPO'       { Set-DefenderWatsonEventsReport -GPO $WatsonEventsReportGPO }
        }
    }
}
