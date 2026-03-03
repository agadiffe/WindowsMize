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


#=================================================================================================================
#                                                     RamDisk
#=================================================================================================================

Write-Section -Name 'RamDisk'

<#
  Brave (and web browsers in general) write a lot of data to the disk, wearing off SSD.

  Moving the Cache to a RamDisk will reduce write disk.
  Moving the entire 'User Data' folder will reduce it even more.

  This should also make Brave (a bit) faster (will probably not be noticeable).

  SSD lifespan is pretty high nowday, so it should be fine even without a RamDisk.
#>

<#
  Brave:
    If you changed the user data directory with '--user-data-dir=',
    you need to change the value of $BraveAppDataPath in
      src > modules > ramdisk > private > Get-BraveBrowserPathInfo.ps1

  You can configure which folders/files are exclude from the RamDisk in:
    src > modules > ramdisk > private > app_data > Get-BraveDataToSymlink.ps1
    src > modules > ramdisk > private > app_data > Get-VSCodeDataToSymlink.ps1

  The RamDisk will be created on the next computer restart.
#>

# --- RamDisk application
Install-OSFMount

# --- RamDisk
# If you have multiple Brave profiles, make sure to allocate enought RAM (e.g. 512MB per profile).
# Size: number + M or G (e.g. 512M or 4G)

# Brave and BraveCache cannot be used together.
# Brave: Move the entire 'User Data' folder to the RamDisk.
#        Only extensions, bookmarks and preferences are restored across logoff/logon.
#        You need to edit the ps1 file to change this behavior.
# BraveCache: Move only the cache folders to the RamDisk (Recommended for non-tech savy users).
$AppToRamDisk = @(
    #'Brave'
    'BraveCache'
    #'VSCode'
)
Set-RamDisk -Size '2G' -AppToRamDisk $AppToRamDisk

# RemoveCreationScript: delete script/task that create the RamDisk at startup.
# RemoveUserScript: delete script/task (for the current user) that setup the RamDisk.
#Set-RamDisk -RemoveCreationScript -RemoveUserScript
