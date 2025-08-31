#=================================================================================================================
#                                          Remove All Desktop Shortcuts
#=================================================================================================================

<#
.SYNTAX
    Remove-AllDesktopShortcuts [<CommonParameters>]
#>

function Remove-AllDesktopShortcuts
{
    [CmdletBinding()]
    param ()

    process
    {
        Write-Verbose -Message 'Removing All Desktop Shortcuts ...'

        $UserDesktopPath = (Get-LoggedOnUserShellFolder).Desktop
        Remove-Item -Path "$UserDesktopPath\*.lnk"
        Remove-Item -Path "$env:PUBLIC\Desktop\*.lnk"
    }
}
