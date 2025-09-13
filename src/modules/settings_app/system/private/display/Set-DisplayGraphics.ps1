#=================================================================================================================
#                                           System > Display > Graphics
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayGraphics
        [-Name] {AutoHDR | GamesVariableRefreshRate | WindowedGamesOptimizations}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DisplayGraphics
{
    <#
    .EXAMPLE
        PS> Set-DisplayGraphics -Name 'WindowedGamesOptimizations' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('AutoHDR', 'AutoSuperResolution', 'GamesVariableRefreshRate', 'WindowedGamesOptimizations')]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $IsEnabled = $State -eq 'Enabled'
        $SettingName, $SettingValue = switch ($Name)
        {
            'AutoHDR'                    { 'AutoHDREnable'          , ($IsEnabled ? '1' : '0') }
            'AutoSuperResolution'        { 'DXGIEffects'            , ($IsEnabled ? '1028' : '1024') }
            'GamesVariableRefreshRate'   { 'VRROptimizeEnable'      , ($IsEnabled ? '1' : '0') }
            'WindowedGamesOptimizations' { 'SwapEffectUpgradeEnable', ($IsEnabled ? '1' : '0') }
        }

        $GpuPrefRegPath = 'Software\Microsoft\DirectX\UserGpuPreferences'
        $CurrentSettings = Get-LoggedOnUserItemPropertyValue -Path $GpuPrefRegPath -Name 'DirectXUserGlobalSettings'
        $DirectXSettings = $CurrentSettings -like "*$SettingName*" ?
            $CurrentSettings -replace "($SettingName=)\d+;", "`${1}$SettingValue;" :
            $CurrentSettings + "$SettingName=$SettingValue;"

        $DisplayDirectXSettings = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\DirectX\UserGpuPreferences'
            Entries = @(
                @{
                    Name  = 'DirectXUserGlobalSettings'
                    Value = $DirectXSettings
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display Graphics - $Name' to '$State' ..."
        Set-RegistryEntry -InputObject $DisplayDirectXSettings
    }
}
