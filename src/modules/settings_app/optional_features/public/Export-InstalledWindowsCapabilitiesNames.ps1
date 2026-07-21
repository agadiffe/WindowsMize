#=================================================================================================================
#                    System > Optional Features - Export Installed Windows Capabilities Names
#=================================================================================================================

<#
.SYNTAX
    Export-InstalledWindowsCapabilitiesNames [<CommonParameters>]
#>

function Export-InstalledWindowsCapabilitiesNames
{
    [CmdletBinding()]
    param ()

    process
    {
        $LogFilePath = "$(Get-LogPath)\windows_default_capabilities_names.txt"
        if (-not (Test-Path -Path $LogFilePath))
        {
            Write-Verbose -Message 'Exporting Installed Windows Capabilities Names ...'

            New-ParentPath -Path $LogFilePath

            # "Get-WindowsCapability -Online" fails on PowerShell from MSIX installation: Class not registered.
            # https://github.com/PowerShell/PowerShell/issues/13866
            # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

            powershell.exe -NoProfile -Command {
                Get-WindowsCapability -Online -Verbose:$false |
                    Where-Object -Property 'State' -EQ -Value 'Installed' |
                    Select-Object -ExpandProperty 'Name' |
                    Sort-Object
            } | Out-File -FilePath $LogFilePath
        }
    }
}
