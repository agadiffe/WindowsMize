#=================================================================================================================
#                                      System > Power & Battery > Power Mode
#=================================================================================================================

<#
.SYNTAX
    Set-PowerMode
        [-Value] {BestPowerEfficiency | Balanced | BestPerformance}
        [<CommonParameters>]
#>

function Set-PowerMode
{
    <#
    .DESCRIPTION
        Available only when using the Balanced power plan.
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


# Function not used.

# owner: SYSTEM | full control: SYSTEM
# Requested registry access is not allowed.

<#
.SYNTAX
    Set-PowerMode
        [-Value] {BestPowerEfficiency | Balanced | BestPerformance}
        [<CommonParameters>]
#>

function Set-PowerMode_Unused
{
    <#
    .EXAMPLE
        PS> Set-PowerMode -Value 'BestPowerEfficiency'

    .NOTES
        Available only when using the Balanced power plan.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('BestPowerEfficiency', 'Balanced', 'BestPerformance')]
        [string] $Value
    )

    process
    {
        $PowerSchemeGuid = switch ($Value)
        {
            'BestPowerEfficiency' { '961cc777-2547-4f9d-8174-7d86181b8a7a' }
            'Balanced'            { '00000000-0000-0000-0000-000000000000' }
            'BestPerformance'     { 'ded574b5-45a0-4f42-8737-46345c09c238' }
        }

        # Best Power Efficiency: 961cc777-2547-4f9d-8174-7d86181b8a7a
        # Balanced: 00000000-0000-0000-0000-000000000000 (default)
        # Best Performance: ded574b5-45a0-4f42-8737-46345c09c238
        $PowerMode = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Power\User\PowerSchemes'
            Entries = @(
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

        Write-Verbose -Message "Setting 'Power Mode' to '$Value' ..."
        Set-RegistryEntry -InputObject $PowerMode
    }
}
