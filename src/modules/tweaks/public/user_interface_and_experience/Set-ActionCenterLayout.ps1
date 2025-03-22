#=================================================================================================================
#                                              Action Center Layout
#=================================================================================================================

# Windows 11 24H2+ only.

<#
.SYNTAX
    Set-ActionCenterLayout
        [-Value] {WiFi | Bluetooth | Cellular | WindowsStudio | AirplaneMode | Accessibility | Vpn |
                 RotationLock | BatterySaver | EnergySaverAcOnly | LiveCaptions | BlueLightReduction |
                 MobileHotspot | NearShare | ColorProfile | Cast | ProjectL2 | LocalBluetooth}
        [<CommonParameters>]

    Set-ActionCenterLayout
        -Reset
        [<CommonParameters>]
#>

function Set-ActionCenterLayout
{
    <#
    .EXAMPLE
        PS> $ActionCenterLayout = @(
                'WiFi'
                'Bluetooth'
                'Cellular'
                'BatterySaver'
                'EnergySaverAcOnly'
                ...
            )
        PS> Set-ActionCenterLayout -Value $ActionCenterLayout

    .EXAMPLE
        PS> Set-ActionCenterLayout -Reset
    #>

    [CmdletBinding(DefaultParameterSetName = 'Layout')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Layout')]
        [ValidateSet(
            'WiFi',
            'Bluetooth',
            'Cellular',
            'WindowsStudio',
            'AirplaneMode',
            'Accessibility',
            'Vpn',
            'RotationLock',
            'BatterySaver',
            'EnergySaverAcOnly',
            'LiveCaptions',
            'BlueLightReduction',
            'MobileHotspot',
            'NearShare',
            'ColorProfile',
            'Cast',
            'ProjectL2',
            'LocalBluetooth')]
        [string[]] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Reset')]
        [switch] $Reset
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Reset' -and -not $Reset)
        {
            return
        }

        $LayoutValue = @(
            @{
                Name = 'Toggles'
                QuickActions = [System.Collections.ArrayList]::new()
            }
            @{
                Name = 'Sliders'
                QuickActions = @(
                    @{ FriendlyName = 'Microsoft.QuickAction.Brightness' }
                    @{ FriendlyName = 'Microsoft.QuickAction.VolumeNoTimer' }
                )
            }
        )

        # There is 'Microsoft.QuickAction.A9' that should be in last position.
        # Don't know what it is used for.
        # It will be automatically added by Windows if the value is missing.
        foreach ($QuickAction in $Value)
        {
            $LayoutValue[0].QuickActions.Add([PSCustomObject]@{
                FriendlyName = "Microsoft.QuickAction.$QuickAction"
            }) | Out-Null
        }

        $LayoutValue = ($LayoutValue | ConvertTo-Json -Depth 100) -replace '\s+'

        $ActionCenterLayout = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Quick Actions\Control Center'
            Entries = @(
                @{
                    RemoveEntry = $Reset
                    Name  = 'UserLayoutPaginated'
                    Value = $LayoutValue
                    Type  = 'String'
                }
            )
        }

        $Action = $Reset ? 'Resetting' : 'Setting'

        Write-Verbose -Message "$Action 'Action Center Layout' ..."
        Set-RegistryEntry -InputObject $ActionCenterLayout
    }
}
