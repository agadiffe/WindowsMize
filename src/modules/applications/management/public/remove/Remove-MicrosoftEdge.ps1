#=================================================================================================================
#                                              Remove Microsoft Edge
#=================================================================================================================

# https://gist.github.com/ave9858/c3451d9f452389ac7607c99d45edecc6

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
        Remove-ApplicationPackage -Name 'Microsoft.MicrosoftEdge.Stable'
        Start-Sleep -Seconds 0.3

        $MicrosoftEdgeInfo = Get-ApplicationInfo -Name 'Microsoft Edge'
        if (-not $MicrosoftEdgeInfo)
        {
            Write-Verbose -Message 'Microsoft Edge is not installed'
            return
        }

        $MicrosoftEdge = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\EdgeUpdateDev'
            Entries = @(
                @{
                    Name  = 'AllowUninstall'
                    Value = ''
                    Type  = 'String'
                }
            )
        }
        Set-RegistryEntry -InputObject $MicrosoftEdge -Verbose:$false

        $EdgeUwpPath = "$env:SystemRoot\SystemApps\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"
        New-Item -ItemType 'Directory' -Path $EdgeUwpPath -ErrorAction 'SilentlyContinue' | Out-Null
        New-Item -Path "$EdgeUwpPath\MicrosoftEdge.exe" -ErrorAction 'SilentlyContinue' | Out-Null

        Write-Verbose -Message 'Removing Microsoft Edge ...'
        Invoke-Expression -Command "& $($MicrosoftEdgeInfo.UninstallString) --force-uninstall"
    }
}
