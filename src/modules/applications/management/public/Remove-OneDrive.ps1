#=================================================================================================================
#                                                 Remove OneDrive
#=================================================================================================================

function Remove-OneDrive
{
    $OneDriveInfo = Get-ApplicationInfo -Name 'Microsoft OneDrive'
    if ($OneDriveInfo)
    {
        Write-Verbose -Message 'Removing OneDrive ...'

        Stop-ProcessByName -Name '*OneDrive*'
        Invoke-Expression -Command "& $($OneDriveInfo.UninstallString)"
    }
    else
    {
        Write-Verbose -Message 'OneDrive is not installed'
    }
}
