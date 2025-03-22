#=================================================================================================================
#                                            Windows Update - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateSetting
        [-GetLatestAsSoonAsAvailable {Disabled | Enabled}]
        [-GetLatestAsSoonAsAvailableGPO {Disabled | Enabled | NotConfigured}]
        [-PauseUpdatesGPO {Disabled | NotConfigured}]
        [-UpdateOtherMicrosoftProducts {Disabled | Enabled}]
        [-UpdateOtherMicrosoftProductsGPO {Enabled | NotConfigured}]
        [-GetMeUpToDate {Disabled | Enabled}]
        [-DownloadOverMeteredConnections {Disabled | Enabled}]
        [-DownloadOverMeteredConnectionsGPO {Disabled | Enabled | NotConfigured}]
        [-RestartNotification {Disabled | Enabled}]
        [-RestartNotificationGPO {Disabled | NotConfigured}]
        [-DeliveryOptimization {Disabled | LocalNetwork | InternetAndLocalNetwork}]
        [-DeliveryOptimizationGPO {Disabled | LocalNetwork | InternetAndLocalNetwork | NotConfigured}]
        [-InsiderProgramPageVisibility {Disabled | Enabled}]
        [-ActiveHoursMode {Automatically | Manually}]
        [-ActiveHoursGPO {Enabled | NotConfigured}]
        -ActiveHoursStart <int>
        -ActiveHoursEnd <int>
        [<CommonParameters>]
#>

function Set-WinUpdateSetting
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            -ActiveHoursStart <int> & -ActiveHoursEnd <int> : (range 0-23)
                available when 'ActiveHoursMode' is 'Manually' or 'ActiveHoursGPO' is 'Enabled'.

    .EXAMPLE
        PS> Set-WinUpdateSetting -GetLatestAsSoonAsAvailable 'Disabled' -DeliveryOptimization 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $GetLatestAsSoonAsAvailable,

        [GpoState] $GetLatestAsSoonAsAvailableGPO,

        [GpoStateWithoutEnabled] $PauseUpdatesGPO,

        [state] $UpdateOtherMicrosoftProducts,

        [GpoStateWithoutDisabled] $UpdateOtherMicrosoftProductsGPO,

        [state] $GetMeUpToDate,

        [state] $DownloadOverMeteredConnections,

        [GpoState] $DownloadOverMeteredConnectionsGPO,

        [state] $RestartNotification,

        [GpoStateWithoutEnabled] $RestartNotificationGPO,

        [DeliveryOptimizationMode] $DeliveryOptimization,

        [GpoDeliveryOptimizationMode] $DeliveryOptimizationGPO,

        [state] $InsiderProgramPageVisibility,

        [ActiveHoursMode] $ActiveHoursMode,

        [GpoStateWithoutDisabled] $ActiveHoursGPO
    )

    dynamicparam
    {
        if ($ActiveHoursMode -eq 'Manually' -or $ActiveHoursGPO -eq 'Enabled')
        {
            $DynParameter = 'ActiveHoursStart', 'ActiveHoursEnd'

            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynParameter | ForEach-Object -Process {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = $_
                    Type       = [int]
                    Attribute  = @{ Parameter = @{ Mandatory = $true }; ValidateRange = 0, 23 }
                }
                Add-DynamicParameter @DynamicParamProperties
            }
            $ParamDictionary
        }
    }

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'GetLatestAsSoonAsAvailable'        { Set-WinUpdateGetLatestAsSoonAsAvailable -State $GetLatestAsSoonAsAvailable }
            'GetLatestAsSoonAsAvailableGPO'     { Set-WinUpdateGetLatestAsSoonAsAvailable -GPO $GetLatestAsSoonAsAvailableGPO }
            'PauseUpdatesGPO'                   { Set-WinUpdatePauseUpdates -GPO $PauseUpdatesGPO }
            'UpdateOtherMicrosoftProducts'      { Set-WinUpdateOtherMicrosoftProducts -State $UpdateOtherMicrosoftProducts }
            'UpdateOtherMicrosoftProductsGPO'   { Set-WinUpdateOtherMicrosoftProducts -GPO $UpdateOtherMicrosoftProductsGPO }
            'GetMeUpToDate'                     { Set-WinUpdateGetMeUpToDate -State $GetMeUpToDate }
            'DownloadOverMeteredConnections'    { Set-WinUpdateOverMeteredConnections -State $DownloadOverMeteredConnections }
            'DownloadOverMeteredConnectionsGPO' { Set-WinUpdateOverMeteredConnections -GPO $DownloadOverMeteredConnectionsGPO }
            'RestartNotification'               { Set-WinUpdateRestartNotification -State $RestartNotification }
            'RestartNotificationGPO'            { Set-WinUpdateRestartNotification -GPO $RestartNotificationGPO }
            'DeliveryOptimization'              { Set-WinUpdateDeliveryOptimization -State $DeliveryOptimization }
            'DeliveryOptimizationGPO'           { Set-WinUpdateDeliveryOptimization -GPO $DeliveryOptimizationGPO }
            'InsiderProgramPageVisibility'      { Set-WinUpdateInsiderProgramPageVisibility -State $InsiderProgramPageVisibility }

            { $_ -eq 'ActiveHoursMode' -or $_ -eq 'ActiveHoursGPO' }
            {
                $HashtableSubsetParam = @{
                    Source            = $PSBoundParameters
                    DesiredKeys       = 'ActiveHoursStart', 'ActiveHoursEnd'
                    SubStringToRemove = 'ActiveHours'
                }
                $ActiveHoursParam = Get-HashtableSubset @HashtableSubsetParam
            }
            'ActiveHoursMode'
            {
                if ($ActiveHoursMode -eq 'Manually')
                {
                    Set-WinUpdateActiveHours -Mode $ActiveHoursMode @ActiveHoursParam
                }
                else
                {
                    Set-WinUpdateActiveHours -Mode $ActiveHoursMode
                }
            }
            'ActiveHoursGPO'
            {
                if ($ActiveHoursGPO -eq 'Enabled')
                {
                    Set-WinUpdateActiveHours -GPO $ActiveHoursGPO @ActiveHoursParam
                }
                else
                {
                    Set-WinUpdateActiveHours -GPO $ActiveHoursGPO
                }
            }
        }
    }
}
