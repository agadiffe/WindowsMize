#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                    PowerShell script to automate and customize the configuration of Windows
#
#=================================================================================================================

#Requires -RunAsAdministrator
#Requires -Version 7.5

Import-Module -Name "$PSScriptRoot\..\..\src\modules\ramdisk"


# Advanced topic (a bit).

#=================================================================================================================
#                                                     RamDisk
#=================================================================================================================

Write-Section -Name 'RamDisk'

<#
  Brave (and web browsers in general) write a lot to the disk, wearing off SSD.

  Brave write a lot of temp files in the 'User Data' directory.
  It seems that everything is written to these temp files and then written to the cache ?
  e.g.
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\random-file-name.tmp"
  "$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\random-file-name.tmp"

  Moving the Cache to a RamDisk reduce write disk, but that's not enought (because of the temp files).
  Lets move everything ('User Data' folder) to the RamDisk.
  Make some exceptions for extensions folders, bookmarks and preferences files.

  This should also make Brave (a bit) faster (will probably not be noticeable).

  SSD lifespan is pretty high nowday, so it should be fine even without a RamDisk.
  If you watch stream videos all day long, a RamDisk might be usefull.

  Let's do the same for VSCode (as it's somehow a web browser too).
#>

# Brave:
#   If you changed the user data directory with '--user-data-dir=',
#   you need to change the value of $BraveAppDataPath in
#     src > modules > ramdisk > private > Get-BraveBrowserPathInfo.ps1

# You can configure which folders/files are exclude from the RamDisk in:
#   src > modules > ramdisk > private > app_data > Get-BraveDataToSymlink.ps1
#   src > modules > ramdisk > private > app_data > Get-VSCodeDataToSymlink.ps1

# The RamDisk will be created on the next computer restart.


# --- RamDisk application
Install-OSFMount

# --- RamDisk
# If you have multiple Brave profiles, make sure to allocate enought RAM (at least 512MB per profile).
# Size: number + M or G (e.g. 512M or 4G)

$AppToRamDisk = @(
    'Brave'
    #'VSCode'
)
Set-RamDisk -Size '2G' -AppToRamDisk $AppToRamDisk
