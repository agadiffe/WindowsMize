#=================================================================================================================
#                                       WindowsMize - Download and extract
#=================================================================================================================

if ($Host.Version.Major -eq 5)
{
    # Progress bar can significantly impact cmdlet performance (fixed on PowerShell 7).
    # Impacted cmdlet in this file: Invoke-RestMethod and Expand-Archive.
    $Global:ProgressPreference = 'SilentlyContinue'
}

#==============================================================================
#                                   Download
#==============================================================================
Write-Output -InputObject "Downloading WindowsMize ..."

$WindowsMizeParam = @{
    Uri     = 'https://github.com/agadiffe/WindowsMize/archive/main.zip'
    OutFile = "$([System.IO.Path]::GetTempPath())\WindowsMize-main.zip"
}
Invoke-RestMethod @WindowsMizeParam


#==============================================================================
#                                   Extract
#==============================================================================
Write-Output -InputObject "Extracting $(Split-Path -Path $WindowsMizeParam.OutFile -Leaf) ..."

$DownloadsFolderParam = @{
    Path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
    Name = '{374de290-123f-4565-9164-39c4925e467b}'
}
$DownloadsFolder = Get-ItemPropertyValue @DownloadsFolderParam

$WindowsMizePath = "$DownloadsFolder\WindowsMize"

# Remove WindowsMize folder if it exist.
Remove-Item -Recurse -Path $WindowsMizePath -ErrorAction 'SilentlyContinue'

# Extract the archive
$ExtractParam = @{
    Path            = $WindowsMizeParam.OutFile
    DestinationPath = $WindowsMizePath
}
Expand-Archive @ExtractParam
Remove-Item -Path $WindowsMizeParam.OutFile

# Github archives have their contents inside a folder (instead of directly inside the archive's root folder).
# i.e. Once extracted, the data will be at: C:\...\Downloads\WindowsMize-main\WindowsMize-main.
# Move the content of this nested folder to the parent folder.
$MoveItemParam = @{
    Path        = "$($ExtractParam.DestinationPath)\WindowsMize-main\*"
    Destination = $ExtractParam.DestinationPath
}
Move-Item @MoveItemParam
Remove-Item -Path "$($ExtractParam.DestinationPath)\WindowsMize-main"

# Unblock the script files (might not be necessary).
Get-ChildItem -Path $ExtractParam.DestinationPath -File -Recurse | Unblock-File


Write-Output -InputObject "WindowsMize have been extracted to '$($ExtractParam.DestinationPath)'."
