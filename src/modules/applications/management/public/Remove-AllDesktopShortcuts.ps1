#=================================================================================================================
#                                          Remove All Desktop Shortcuts
#=================================================================================================================

function Remove-AllDesktopShortcuts
{
    Write-Verbose -Message 'Removing All Desktop Shortcuts ...'

    $UserDesktopPath = (Get-LoggedOnUserShellFolder).Desktop
    Remove-Item -Path "$UserDesktopPath\*.lnk"
    Remove-Item -Path "$env:PUBLIC\Desktop\*.lnk"
}
