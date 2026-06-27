#=================================================================================================================
#                                            Remove Microsoft OneDrive
#=================================================================================================================

<#
.SYNTAX
    Remove-MicrosoftOneDrive [<CommonParameters>]
#>

function Remove-MicrosoftOneDrive
{
    [CmdletBinding()]
    param ()

    process
    {
        $OneDriveInfo = Get-ApplicationInfo -Name 'Microsoft OneDrive'
        if ($OneDriveInfo)
        {
            Write-Verbose -Message 'Removing OneDrive ...'

            Stop-Process -Name '*OneDrive*' -Force -ErrorAction 'SilentlyContinue'
            Invoke-Expression -Command "& $($OneDriveInfo.UninstallString)"
        }
        else
        {
            Write-Verbose -Message 'OneDrive is not installed'
        }
    }
}
