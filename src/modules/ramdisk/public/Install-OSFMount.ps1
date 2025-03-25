#=================================================================================================================
#                                                Install OSFMount
#=================================================================================================================

function Install-OSFMount
{
    Install-ApplicationWithWinget -Name 'PassmarkSoftware.OSFMount'
    Remove-Item -Path "$((Get-LoggedOnUserShellFolder).Desktop)\OSFMount.lnk" -ErrorAction 'SilentlyContinue'

    # OSFMount is launched after installation. Close it.
    Stop-Process -Name 'OSFMount' -Force -ErrorAction 'SilentlyContinue'
}
