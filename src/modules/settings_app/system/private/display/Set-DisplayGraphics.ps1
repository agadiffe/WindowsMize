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
        [ValidateSet('AutoHDR', 'GamesVariableRefreshRate', 'WindowedGamesOptimizations')]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $SettingValue = $State -eq 'Enabled' ? 1 : 0
        $SettingName = switch ($Name)
        {
            'AutoHDR'                    { 'AutoHDREnable' }
            'GamesVariableRefreshRate'   { 'VRROptimizeEnable' }
            'WindowedGamesOptimizations' { 'SwapEffectUpgradeEnable' }
        }

        $UserSID = Get-LoggedOnUserSID
        $GpuPrefRegPath = "Registry::HKEY_USERS\$UserSID\Software\Microsoft\DirectX\UserGpuPreferences"
        $CurrentSettings = (Get-ItemProperty -Path $GpuPrefRegPath -ErrorAction 'SilentlyContinue').DirectXUserGlobalSettings
        $DirectXSettings = $CurrentSettings -like "*$SettingName*" ?
            $CurrentSettings -replace "($SettingName=)\d;", "`${1}$SettingValue;" :
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
