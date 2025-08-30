#=================================================================================================================
#                                                 Remove OneDrive
#=================================================================================================================

function Remove-OneDrive
{
    $OneDriveInfo = Get-ApplicationInfo -Name 'Microsoft OneDrive'
    if ($OneDriveInfo)
    {
        Write-Verbose -Message 'Removing OneDrive ...'

        Stop-Process -Name '*OneDrive*' -Force -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.5

        Invoke-Expression -Command "& $($OneDriveInfo.UninstallString)"
    }
    else
    {
        Write-Verbose -Message 'OneDrive is not installed'
    }
}
