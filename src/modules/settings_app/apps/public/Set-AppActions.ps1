#=================================================================================================================
#                                                 Apps > Actions
#=================================================================================================================

class AppActionsSetting : ValidateHashtableSettings
{
    # Constructors
    #-------------
    AppActionsSetting([hashtable]$Settings) : base($Settings)
    {
        $KeyNames = 'M365Copilot', 'MSOffice', 'MSTeams', 'Paint', 'Photos'
        $KeyValues = 'Disabled', 'Enabled'
        $this.ValidateSettings($Settings, $KeyNames, $KeyValues)
    }
}

<#
.SYNTAX
    Set-AppActions
        [-Setting] <AppActionsSetting>
        [<CommonParameters>]
#>

function Set-AppActions
{
    <#
    .EXAMPLE
        PS> $AppActionsSettings = @{
                MSOffice = 'Disabled'
                Paint    = 'Disabled'
                Photos   = 'Enabled'
            }
        PS> Set-AppActions -Setting $AppActionsSettings
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [AppActionsSetting] $Setting
    )

    process
    {
        if (-not $Setting.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $AppActionsSettings = [System.Collections.ArrayList]::new()

        foreach ($AppName in $Setting.Keys)
        {
            $AppInternalName = switch ($AppName)
            {
                'M365Copilot' { 'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe' }
                'MSOffice'    { 'Microsoft.Office.ActionsServer_8wekyb3d8bbwe' }
                'MSTeams'     { 'MSTeams_8wekyb3d8bbwe' }
                'Paint'       { 'Microsoft.Paint_8wekyb3d8bbwe' }
                'Photos'      { 'Microsoft.Windows.Photos_8wekyb3d8bbwe' }
            }

            # on: 0 (default) | off: 1 (or delete)
            $AppActionsReg = @{
                Path  = 'LocalState\DisabledApps'
                Name  = $AppInternalName
                Value = $Setting.$AppName -eq 'Enabled' ? '0' : '1'
                Type  = '5f5e10b'
            }
            $AppActionsSettings.Add([PSCustomObject]$AppActionsReg) | Out-Null
        }

        Set-UwpAppSetting -Name 'AppActions' -Setting $AppActionsSettings
    }
}
