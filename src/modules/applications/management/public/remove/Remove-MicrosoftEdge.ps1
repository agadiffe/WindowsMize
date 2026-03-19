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

        # Get the 'RegionPolicy' config file content.
        $RegionPolicyFilePath = "$env:SystemRoot\System32\IntegratedServicesRegionPolicySet.json"
        $RegionPolicy = Get-Content -Raw -Path $RegionPolicyFilePath | ConvertFrom-Json -AsHashtable

        # Enable edge uninstallation in 'IntegratedServicesRegionPolicySet.json'.
        # The 'guid' correspond to 'Edge is uninstallable'.
        $DeviceGeoIso = Get-DeviceRegionISO2
        $IsRegionPolicyFileChanged = $false
        $RegionPolicy['policies'] |
            Where-Object -Property 'guid' -EQ -Value '{1bca278a-5d11-4acf-ad2f-f9ab6d7f93a6}' |
            ForEach-Object -Process {
                if ($_['defaultState'] -eq 'disabled')
                {
                    $_['defaultState'] = 'enabled'
                    $IsRegionPolicyFileChanged = $true
                }
                if ($_['conditions']['region']['enabled'] -notcontains $DeviceGeoIso)
                {
                    $_['conditions']['region']['enabled'] += $DeviceGeoIso
                    $IsRegionPolicyFileChanged = $true
                }
            }

        if ($IsRegionPolicyFileChanged)
        {
            $AccessRuleParam = @{
                Path       = $RegionPolicyFilePath
                Sid        = 'S-1-5-32-544' # 'BUILTIN\Administrators'
                Permission = 'Allow'
                Access     = 'FullControl'
            }

            # Save the original file permissions.
            $OriginalRegionPolicyAcl = Get-Acl -Path $RegionPolicyFilePath

            # Backup the original file.
            Set-FileSystemAccessRule @AccessRuleParam
            $RegionPolicyFileName = (Get-Item -Path $RegionPolicyFilePath).Name
            Rename-Item -Path $RegionPolicyFilePath -NewName "$RegionPolicyFileName.bak"

            # Write the modified file
            $RegionPolicy | ConvertTo-Json -Depth 100 | Out-File -FilePath $RegionPolicyFilePath

            # Set the original file permissions to the modified file.
            Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
        }

        # Uninstall Microsoft Edge.
        Remove-ApplicationPackage -Name 'Microsoft.MicrosoftEdge.Stable'
        Start-Sleep -Seconds 0.3

        Write-Verbose -Message 'Removing Microsoft Edge ...'
        $EdgeUninstallCmd = "& $($MicrosoftEdgeInfo.UninstallString) --force-uninstall --delete-profile".Replace('"', '\"')
        Start-Process -Wait -NoNewWindow -FilePath 'powershell.exe' -ArgumentList "-Command Invoke-Expression '$EdgeUninstallCmd'"

        if ($IsRegionPolicyFileChanged)
        {
            # Remove the modified file.
            Set-FileSystemAccessRule @AccessRuleParam
            Remove-Item -Path $RegionPolicyFilePath

            # Restore the original file.
            Rename-Item -Path "$RegionPolicyFilePath.bak" -NewName $RegionPolicyFileName
            Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
        }
    }
}


<#
.SYNTAX
    Get-DeviceRegionISO2 [<CommonParameters>]
#>

function Get-DeviceRegionISO2
{
    [CmdletBinding()]
    param ()

    process
    {
        if (-not ('Win32.Geo' -as [type]))
        {
            Add-Type @'
                using System.Runtime.InteropServices;
                using System.Text;
                
                namespace Win32 {
                    public class Geo {
                        [DllImport("kernel32.dll")]
                        public static extern int GetGeoInfo (
                            int location,
                            int geoType,
                            StringBuilder geoData,
                            int geoDataSize,
                            int langId
                        );
                    
                        public const int GEO_ISO2 = 0x4;
                    }
                }
'@
        }

        function Convert-GeoIdToISO2
        {
            [CmdletBinding()]
            param
            (
                [Parameter(Mandatory)]
                [string] $GeoId

            )

            process
            {
                if ($GeoId -le 0) { return $null }

                $StringBuilder = New-Object -TypeName 'System.Text.StringBuilder' -ArgumentList '3'
                [Win32.Geo]::GetGeoInfo($GeoId, [Win32.Geo]::GEO_ISO2, $StringBuilder, $StringBuilder.Capacity, 0) | Out-Null
                $StringBuilder.ToString()
            }
        }

        $DeviceRegionRegPath = 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Control Panel\DeviceRegion'
        $DeviceGeoId = (Get-ItemProperty -Path "Registry::$DeviceRegionRegPath").DeviceRegion
        $DeviceGeoIso = Convert-GeoIdToISO2 -GeoId $DeviceGeoId
        $DeviceGeoIso
    }
}
