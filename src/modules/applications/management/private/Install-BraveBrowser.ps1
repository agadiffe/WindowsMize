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

        $Url = 'https://laptop-updates.brave.com/latest/winx64'
        $OutPath = "$([System.IO.Path]::GetTempPath())\BraveBrowserSetup.exe"

        Invoke-RestMethod -Uri $Url -OutFile $OutPath -Verbose:$false
        Start-Process -Wait -FilePath $OutPath -ArgumentList '/silent /install'
        Remove-Item -Path $OutPath
    }
}
