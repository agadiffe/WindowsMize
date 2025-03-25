#=================================================================================================================
#                                              Install Brave Browser
#=================================================================================================================

# Brave fails to update itself when installed with Winget.

function Install-BraveBrowser
{
    Write-Verbose -Message 'Installing Brave Browser ...'

    $Url = 'https://laptop-updates.brave.com/latest/winx64'
    $OutPath = "$env:TEMP\BraveBrowserSetup.exe"

    Invoke-RestMethod -Uri $Url -OutFile $OutPath -Verbose:$false
    Start-Process -Wait -FilePath $OutPath -ArgumentList '/silent /install'
    Remove-Item -Path $OutPath
}
