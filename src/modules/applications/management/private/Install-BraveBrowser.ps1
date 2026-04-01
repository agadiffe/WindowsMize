#=================================================================================================================
#                                              Install Brave Browser
#=================================================================================================================

# Brave fails to update itself when installed with Winget.

<#
.SYNTAX
    Install-BraveBrowser [<CommonParameters>]
#>

function Install-BraveBrowser
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Installing Brave Browser ...'

        $LatestRelease = (Invoke-RestMethod -Uri 'https://api.github.com/repos/brave/brave-browser/releases/latest').assets |
            Where-Object -Property 'Name' -EQ -Value 'BraveBrowserSetup.exe'
        $Url = $LatestRelease.browser_download_url
        $ExpectedFileHash = $LatestRelease.digest -replace 'sha256:'

        $OutFilePath = "$([System.IO.Path]::GetTempPath())\BraveBrowserSetup.exe"
        Invoke-RestMethod -Uri $Url -OutFile $OutFilePath -Verbose:$false
        $DowloadedFileHash = (Get-FileHash -Path $OutFilePath -Algorithm 'SHA256').Hash

        if ($ExpectedFileHash -ne $DowloadedFileHash)
        {
            Write-Error -Message '  BraveBrowserSetup.exe FileHash doesn''t match. Installation canceled.'
        }
        else
        {
            Start-Process -Wait -FilePath $OutFilePath -ArgumentList '/silent /install'
        }

        Remove-Item -Path $OutFilePath
    }
}
