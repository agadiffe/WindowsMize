#=================================================================================================================
#                                      System > Power & Battery > Power Mode
#=================================================================================================================

<#
.SYNTAX
    Set-PowerMode
        [-Value] {BestPowerEfficiency | Balanced | BestPerformance}
        [[-PowerSource] {PluggedIn | OnBattery}]
        [<CommonParameters>]
#>

function Set-PowerMode
{
    <#
    .DESCRIPTION
        Available only when using the default Balanced power plan.

    .EXAMPLE
        PS> Set-PowerMode -PowerSource 'PluggedIn' -Value 'BestPowerEfficiency'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [PowerMode] $Value,

        [PowerSource] $PowerSource
    )

    process
    {
        # owner: SYSTEM | full control: SYSTEM
        # Requested registry access is not allowed.

        # default: Balanced
        $PowerSchemeGuid = switch ($Value)
        {
            'BestPowerEfficiency' { '961cc777-2547-4f9d-8174-7d86181b8a7a' }
            'Balanced'            { '00000000-0000-0000-0000-000000000000' }
            'BestPerformance'     { 'ded574b5-45a0-4f42-8737-46345c09c238' }
        }

        $PowerMode = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes'
            Entries = [System.Collections.ArrayList]@(
                @{
                    Name  = 'ActiveOverlayAcPowerScheme'
                    Value = $PowerSchemeGuid
                    Type  = 'String'
                }
                @{
                    Name  = 'ActiveOverlayDcPowerScheme'
                    Value = $PowerSchemeGuid
                    Type  = 'String'
                }
            )
        }

        switch ($PowerSource)
        {
            'PluggedIn' { $PowerMode.Entries.RemoveAt(1) }
            'OnBattery' { $PowerMode.Entries.RemoveAt(0) }
        }

        $PowerSourceMsg = $PSBoundParameters.ContainsKey('PowerSource') ? "$PowerSource" : 'PluggedIn & OnBattery'

        Write-Verbose -Message "Setting 'Power Mode ($PowerSourceMsg)' to '$Value' ..."
        Set-RegistryEntrySystemProtected -InputObject $PowerMode
    }
}


# Function not used.

<#
.SYNTAX
    Set-PowerMode
        [-Value] {BestPowerEfficiency | Balanced | BestPerformance}
        [<CommonParameters>]
#>

function Set-PowerMode_Unused
{
    <#
    .DESCRIPTION
        Available only when using the default Balanced power plan.
        Applies only to the active power source (e.g. Laptop: PluggedIn or OnBattery).

    .EXAMPLE
        PS> Set-PowerMode -Value 'BestPowerEfficiency'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [PowerMode] $Value
    )

    process
    {
        # default: Balanced
        $OverlayGUID = switch ($Value)
        {
            'BestPowerEfficiency' { 'OVERLAY_SCHEME_MIN' }
            'Balanced'            { 'OVERLAY_SCHEME_NONE' }
            'BestPerformance'     { 'OVERLAY_SCHEME_MAX' }
        }

        Write-Verbose -Message "Setting 'Power Mode' to '$Value' ..."
        powercfg.exe -OverlaySetActive $OverlayGUID
    }
}
