#=================================================================================================================
#                                              Remove Microsoft Edge
#=================================================================================================================

<#
.SYNTAX
    Remove-MicrosoftEdge [<CommonParameters>]
#>

function Remove-MicrosoftEdge
{
    [CmdletBinding()]
    param ()

    process
    {
        $MicrosoftEdgeInfo = Get-ApplicationInfo -Name 'Microsoft Edge'
        if (-not $MicrosoftEdgeInfo)
        {
            Write-Verbose -Message 'Microsoft Edge is not installed'
            return
        }

        # Get the user region.
        $UserRegionRegPath = 'Control Panel\International\Geo'
        $UserRegion = Get-LoggedOnUserItemPropertyValue -Path $UserRegionRegPath -Name 'Name'

        # Get the 'RegionPolicy' config file content.
        $RegionPolicyFilePath = "$env:SystemRoot\System32\IntegratedServicesRegionPolicySet.json"
        $RegionPolicy = Get-Content -Raw -Path $RegionPolicyFilePath | ConvertFrom-Json -AsHashtable

        # Enable edge uninstallation in 'IntegratedServicesRegionPolicySet.json'.
        # The 'guid' correspond to 'Edge is uninstallable'.
        $IsRegionPolicyFileChanged = $false
        $RegionPolicy.policies |
            Where-Object -Property 'guid' -EQ -Value '{1bca278a-5d11-4acf-ad2f-f9ab6d7f93a6}' |
            ForEach-Object -Process {
                if ($_.defaultState -eq 'disabled')
                {
                    $_.defaultState = 'enabled'
                    $IsRegionPolicyFileChanged = $true
                }
                if ($_.conditions.region.enabled -notcontains $UserRegion)
                {
                    $_.conditions.region.enabled += $UserRegion
                    $IsRegionPolicyFileChanged = $true
                }
            }

        if ($IsRegionPolicyFileChanged)
        {
            # Save the original file permissions.
            $OriginalRegionPolicyAcl = Get-Acl -Path $RegionPolicyFilePath

            # Backup the original file.
            Set-FileSystemAdminsFullControl -Action 'Grant' -Path $RegionPolicyFilePath
            $RegionPolicyFileName = (Get-Item -Path $RegionPolicyFilePath).Name
            Rename-Item -Path $RegionPolicyFilePath -NewName "$RegionPolicyFileName.bak"

            # Write the modified file
            $RegionPolicy | ConvertTo-Json -Depth 100 | Out-File -FilePath $RegionPolicyFilePath

            # Set the original file permissions to the modified file.
            Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
        }

        # Uninstall Microsoft Edge.
        Remove-ApplicationPackage -Name 'Microsoft.MicrosoftEdge.Stable'
        Start-Sleep -Seconds 0.5

        Write-Verbose -Message 'Removing Microsoft Edge ...'
        $EdgeUninstallCmd = "& $($MicrosoftEdgeInfo.UninstallString) --force-uninstall".Replace('"', '\"')
        Start-Process -Wait -NoNewWindow -FilePath 'powershell.exe' -ArgumentList "-Command Invoke-Expression '$EdgeUninstallCmd'"

        if ($IsRegionPolicyFileChanged)
        {
            # Remove the modified file.
            Set-FileSystemAdminsFullControl -Action 'Grant' -Path $RegionPolicyFilePath
            Remove-Item -Path $RegionPolicyFilePath

            # Restore the original file.
            Rename-Item -Path "$RegionPolicyFilePath.bak" -NewName $RegionPolicyFileName
            Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
        }
    }
}
