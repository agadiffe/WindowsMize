#=================================================================================================================
#                                       Install DirectX 9 End User Runtime
#=================================================================================================================

# Winget fails to install DirectX9EndUserRuntime.

<#
.SYNTAX
    Install-DirectX9EndUserRuntime [<CommonParameters>]
#>

function Install-DirectX9EndUserRuntime
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Installing DirectX 9 End User Runtime ...'

        $Url = 'https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe'
        $TempPath = [System.IO.Path]::GetTempPath()
        $OutFilePath = "$TempPath\directx_Jun2010_redist.exe"
        $DXSetupPath = "$TempPath\directx_Jun2010"

        Remove-Item -Recurse -Path $DXSetupPath -ErrorAction 'SilentlyContinue'

        Invoke-RestMethod -Uri $Url -OutFile $OutFilePath -Verbose:$false
        Start-Process -Wait -FilePath $OutFilePath -ArgumentList "/Q /T:$DXSetupPath"
        Start-Process -Wait -FilePath "$DXSetupPath\DXSETUP.exe" -ArgumentList '/silent'
        Remove-Item -Recurse -Path $OutFilePath, $DXSetupPath
    }
}
