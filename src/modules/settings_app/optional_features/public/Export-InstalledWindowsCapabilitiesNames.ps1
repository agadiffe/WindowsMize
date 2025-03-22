#=================================================================================================================
#                    System > Optional Features - Export Installed Windows Capabilities Names
#=================================================================================================================

function Export-InstalledWindowsCapabilitiesNames
{
    $LogFilePath = "$PSScriptRoot\..\..\..\..\..\log\windows_capabilities_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Installed Windows Capabilities Names ...'

        Get-WindowsCapability -Online -Verbose:$false |
            Where-Object -Property 'State' -EQ -Value 'Installed' |
            Select-Object -ExpandProperty 'Name' |
            Sort-Object |
            Out-File -FilePath $LogFilePath
    }
}
