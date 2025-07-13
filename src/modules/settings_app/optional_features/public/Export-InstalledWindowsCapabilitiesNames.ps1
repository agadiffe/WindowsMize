#=================================================================================================================
#                    System > Optional Features - Export Installed Windows Capabilities Names
#=================================================================================================================

function Export-InstalledWindowsCapabilitiesNames
{
    $LogFilePath = "$PSScriptRoot\..\..\..\..\..\log\windows_default_capabilities_names.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Installed Windows Capabilities Names ...'

        New-ParentPath -Path $LogFilePath

        Get-WindowsCapability -Online -Verbose:$false |
            Where-Object -Property 'State' -EQ -Value 'Installed' |
            Select-Object -ExpandProperty 'Name' |
            Sort-Object |
            Out-File -FilePath $LogFilePath
    }
}
