#=================================================================================================================
#                                       Export Default Appx Packages Names
#=================================================================================================================

<#
.SYNTAX
    Export-DefaultAppxPackagesNames [<CommonParameters>]
#>

function Export-DefaultAppxPackagesNames
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$(Get-LogPath)\windows_default_appx_packages_names.txt"
        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message 'Exporting Default Appx Packages Names ...'

            New-ParentPath -Path $LogFilePath

            try
            {
                $AppxPackages = (Get-AppxPackage -AllUsers).Name
            }
            catch
            {
                # PowerShell on Windows 10: Get-AppxPackage not found
                # https://github.com/PowerShell/PowerShell/issues/19031
                Import-Module -Name 'Appx' -UseWindowsPowerShell -Verbose:$false
                $AppxPackages = (Get-AppxPackage -AllUsers).Name
            }

            $DefaultAppxPackages = "# AppxPackage`n "
            $DefaultAppxPackages += $AppxPackages.ForEach{ "$_`n" }
            $DefaultAppxPackages += "`n# ProvisionedAppxPackage`n "
            $DefaultAppxPackages += ((Get-ProvisionedAppxPackage -Online -Verbose:$false).DisplayName).ForEach{ "$_`n" }

            $DefaultAppxPackages | Out-File -FilePath $LogFilePath
        }
    }
}
