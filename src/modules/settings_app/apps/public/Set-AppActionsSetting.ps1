#=================================================================================================================
#                                                 Apps > Actions
#=================================================================================================================

<#
.SYNTAX
    Set-AppActionsSetting
        [-M365Copilot {Disabled | Enabled}]
        [-MSOffice {Disabled | Enabled}]
        [-MSTeams {Disabled | Enabled}]
        [-Paint {Disabled | Enabled}]
        [-Photos {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AppActionsSetting
{
    <#
    .EXAMPLE
        PS> Set-AppActionsSetting -MSOffice 'Disabled' -Photos 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $M365Copilot,
        [state] $MSOffice,
        [state] $MSTeams,
        [state] $Paint,
        [state] $Photos
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        $AppActionsSettings = [System.Collections.ArrayList]::new()

        foreach ($AppName in $PSBoundParameters.Keys)
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
                Value = $PSBoundParameters[$AppName] -eq 'Enabled' ? '0' : '1'
                Type  = '5f5e10b'
            }
            $AppActionsSettings.Add([PSCustomObject]$AppActionsReg) | Out-Null
        }

        Set-UwpAppSetting -Name 'AppActions' -Setting $AppActionsSettings
    }
}
