#=================================================================================================================
#       System > Optional Features > More Windows Features - Export Enabled Windows Optional Features Names
#=================================================================================================================

<#
.SYNTAX
    Export-EnabledWindowsOptionalFeaturesNames [<CommonParameters>]
#>

function Export-EnabledWindowsOptionalFeaturesNames
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$(Get-LogPath)\windows_default_optional_features_names.txt"
        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message 'Exporting Enabled Windows Optional Features Names ...'

            New-ParentPath -Path $LogFilePath

            # "Get-WindowsOptionalFeature -Online" fails on PowerShell from MSIX installation: Class not registered.
            # https://github.com/PowerShell/PowerShell/issues/13866
            # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

            powershell.exe -NoProfile -Command {
                Get-WindowsOptionalFeature -Online -Verbose:$false |
                    Where-Object -Property 'State' -EQ -Value 'Enabled' |
                    Select-Object -ExpandProperty 'FeatureName' |
                    Sort-Object
            } | Out-File -FilePath $LogFilePath
        }
    }
}
