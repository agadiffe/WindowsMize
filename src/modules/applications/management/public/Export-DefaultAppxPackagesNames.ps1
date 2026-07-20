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
                # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

                $AppxPackages = powershell.exe -NoProfile -Command {
                    (Get-AppxPackage -AllUsers).Name
                }
            }

            # "Get-ProvisionedAppxPackage -Online" fails on PowerShell from MSIX installation: Class not registered.
            # https://github.com/PowerShell/PowerShell/issues/13866
            # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

            $ProvisionedAppxPackage = powershell.exe -NoProfile -Command {
                (Get-ProvisionedAppxPackage -Online -Verbose:$false).DisplayName
            }

            $DefaultAppxPackages = "# AppxPackage`n "
            $DefaultAppxPackages += $AppxPackages.ForEach{ "$_`n" }
            $DefaultAppxPackages += "`n# ProvisionedAppxPackage`n "
            $DefaultAppxPackages += $ProvisionedAppxPackage.ForEach{ "$_`n" }

            $DefaultAppxPackages | Out-File -FilePath $LogFilePath
        }
    }
}
