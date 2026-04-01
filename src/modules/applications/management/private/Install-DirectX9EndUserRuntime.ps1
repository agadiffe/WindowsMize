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

        # version: 9.29.1974.1 | date published: 7/15/2024
        $ExpectedFileHash = '053F76DCBB28802E23341B6A787E3B0791C0FA5C8D4D011B1044172DBF89C73B'
        $Url = 'https://download.microsoft.com/download/8/4/a/84a35bf1-dafe-4ae8-82af-ad2ae20b6b14/directx_Jun2010_redist.exe'
        $TempPath = [System.IO.Path]::GetTempPath()
        $OutFilePath = "$TempPath\directx_Jun2010_redist.exe"
        $DXSetupPath = "$TempPath\directx_Jun2010"

        Remove-Item -Recurse -Path $DXSetupPath -ErrorAction 'SilentlyContinue'

        Invoke-RestMethod -Uri $Url -OutFile $OutFilePath -Verbose:$false
        $DowloadedFileHash = (Get-FileHash -Path $OutFilePath -Algorithm 'SHA256').Hash

        if ($ExpectedFileHash -ne $DowloadedFileHash)
        {
            Write-Error -Message '  directx_Jun2010_redist.exe FileHash doesn''t match. Installation canceled.'
        }
        else
        {
            Start-Process -Wait -FilePath $OutFilePath -ArgumentList "/Q /T:$DXSetupPath"
            Start-Process -Wait -FilePath "$DXSetupPath\DXSETUP.exe" -ArgumentList '/silent'
            Remove-Item -Recurse -Path $DXSetupPath
        }

        Remove-Item -Path $OutFilePath
    }
}
