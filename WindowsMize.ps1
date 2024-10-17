#=================================================================================================================
#                   __      __  _             _                       __  __   _
#                   \ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
#                    \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
#                     \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|
#
#                      PowerShell script to automate and customize the settings of Windows,
#                    remove bloatware, minimize telemetry, disable services & scheduled tasks,
#                                           and various other tweaks.
#
#=================================================================================================================
#region WindowsMize

#==============================================================================
#                                requirements
#==============================================================================
#region requirements

#Requires -RunAsAdministrator
#Requires -Version 7.4

<#
- PowerShell Core.
  Open a terminal and run:
    winget install --exact --id 'Microsoft.PowerShell'

- Update (optional, but good practice).
  Make sure your Windows is fully updated:
    settings > windows update > check for updates
    microsoft store > library (or downloads) > get updates

- Backup (optional, but good practice).
  Make sure to backup all of your data.
  e.g. browser bookmarks, apps settings, personal files, passwords database
#>

#endregion requirements


#==============================================================================
#                            windows installation
#==============================================================================
#region windows installation

<#
Create a local account and disable Bitlocker auto device encryption (only auto enabled for online account ?).
Disable password expiration as well (a force password reset is not recommended).
See the below minimal autounattend.xml file (Change the username (if desired) and the password).

More customization can be done with the answer file, see Microsoft documentation and/or the online generator.

If you do not want to use the answer file to create a local accout:
    if you have a Desktop, do not connect to Internet (unplug the cable).
    'Shift + F10' to open a Command Prompt (use 'Alt + Tab' to bring it to the foreground).
    type 'oobe\bypassnro' (computer will reboot).
    if you have a Laptop with a wireless device:
    open a Command Prompt and type 'ipconfig /release'.
#>

function New-WindowsAnswerFile
{
    <#
    .SYNTAX
        New-WindowsAnswerFile [[-FilePath] <string>] [[-UserName] <string>] [[-Password] <string>] [<CommonParameters>]

    .EXAMPLE
        PS> New-WindowsAnswerFile -UserName 'Bob' -Password 'MyPassword'

    .NOTES
        Copy the "autounattend.xml" file to the USB drive root folder.
        It can be the 'Windows install' USB or an other USB drive.
    #>

    [CmdletBinding()]
    param
    (
        [string]
        $Path = "$PSScriptRoot\autounattend.xml",

        [string]
        $UserName = "User",

        [string]
        $Password = "password"
    )

    '<?xml version="1.0" encoding="utf-8"?>
    <unattend xmlns="urn:schemas-microsoft-com:unattend" xmlns:wcm="http://schemas.microsoft.com/WMIConfig/2002/State">
        <settings pass="offlineServicing"></settings>
        <settings pass="windowsPE">
            <component name="Microsoft-Windows-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                <UserData>
                    <ProductKey>
                        <!-- Win11 generic product key: -->
                            <!-- Home: YTMG3-N6DKC-DKB77-7M9GH-8HVX7 -->
                            <!-- Pro: VK7JG-NPHTM-C97JM-9MPGT-3V66T -->
                        <!-- choose a generic key to skip the Windows Key screen during Windows installation -->
                        <Key>00000-00000-00000-00000-00000</Key>
                    </ProductKey>
                    <AcceptEula>true</AcceptEula>
                </UserData>
            </component>
        </settings>
        <settings pass="generalize"></settings>
        <settings pass="specialize">
            <component name="Microsoft-Windows-Deployment" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                <RunSynchronous>
                    <RunSynchronousCommand wcm:action="add">
                        <!-- disable password expiration -->
                        <Order>1</Order>
                        <Path>net.exe accounts /maxpwage:UNLIMITED</Path>
                    </RunSynchronousCommand>
                    <RunSynchronousCommand wcm:action="add">
                        <!-- disable Bitlocker auto device encryption -->
                        <Order>2</Order>
                        <Path>reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\BitLocker" /v "PreventDeviceEncryption" /t REG_DWORD /d 1 /f</Path>
                    </RunSynchronousCommand>
                </RunSynchronous>
            </component>
        </settings>
        <settings pass="auditSystem"></settings>
        <settings pass="auditUser"></settings>
        <settings pass="oobeSystem">
            <component name="Microsoft-Windows-Shell-Setup" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" versionScope="nonSxS">
                <UserAccounts>
                    <!-- create a local account (modify the username (20 chars max) and password) -->
                    <LocalAccounts>
                        <LocalAccount wcm:action="add">
                            <Name>$UserName</Name>
                            <Group>Administrators</Group>
                            <Password>
                                <Value>$Password</Value>
                                <PlainText>true</PlainText>
                            </Password>
                        </LocalAccount>
                    </LocalAccounts>
                </UserAccounts>
                <AutoLogon>
                    <!-- auto logon once (modify the username and password with the LocalAccount values) -->
                    <Username>$UserName</Username>
                    <Enabled>true</Enabled>
                    <LogonCount>1</LogonCount>
                    <Password>
                        <Value>$Password</Value>
                        <PlainText>true</PlainText>
                    </Password>
                </AutoLogon>
                <OOBE>
                    <!-- deny privacy settings (do not send diagnostics data, ... etc) -->
                    <ProtectYourPC>3</ProtectYourPC>
                    <HideEULAPage>true</HideEULAPage>
                    <HideWirelessSetupInOOBE>false</HideWirelessSetupInOOBE>
                </OOBE>
                <FirstLogonCommands>
                    <SynchronousCommand wcm:action="add">
                        <!-- disable auto logon after the first logon -->
                        <Order>1</Order>
                        <CommandLine>reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon" /v AutoLogonCount /t REG_DWORD /d 0 /f</CommandLine>
                    </SynchronousCommand>
                </FirstLogonCommands>
            </component>
        </settings>
    </unattend>
    '.Replace('$UserName', $UserName).Replace('$Password', $Password) -replace '(?m)^ {4}' |
        Out-File -FilePath $Path
}

#endregion windows installation


#==============================================================================
#                                todo manually
#==============================================================================
#region todo manually

# Review these todos after the script execution and computer restart.
# (or before, depending of the setting. e.g. you probably want to set the 'display scale' right away)

#=======================================
## settings
#=======================================
<#
- settings > apps > startup (or task manager > startup apps)
  Disable unwanted startup apps.
  e.g. intel graphics command center, terminal

- settings > system > display > scale > 100% (or else)
- settings > system > display > advanced display > choose a refresh rate

- settings > system > sound > properties > 24bits, 96000Hz (Studio Quality)
  Most games use 96kHz as default ?

- settings > system > power > power & sleep buttons controls

- settings > bluetooth & devices > printers & scanners > Microsoft Print to PDF > printing preferences > advanced
  Change default page size to A4.

- settings > network & internet > wi-fi > random hardware addresses (if needed: e.g. public wifi)
- settings > network & internet > advanced network settings > advanced sharing settings
  If network discovery service is not disabled, adjust the settings as needed.

- settings > personalization > taskbar > hidden icon menu
  e.g. always show: adobe acrobat reader (new update), bluetooth, windows updates status

- settings > privacy & security > windows security (aka Defender)
  Review the settings and dismiss any warning message.
  If phishing wasn't disable with GPO, toggle off (or not) the setting.

- settings > privacy & security > device encryption
  Turn off device encryption (not automated because it can take a long time).
  The recommended way is to use an answer file to prevent auto device encryption.
#>

#=======================================
## miscellaneous
#=======================================
<#
- Move default user folders location outside of system drive.
  i.e. desktop, downloads, documents, music, pictures, videos

- Personalize the Start Menu and taskbar items.
  e.g. unpin Microsoft Store

- Monitor: Download icc profile (if needed).
  settings > system > display > color profile
  control panel (icons view) > color management (colorcpl.exe)

- Update needed driver/firmware.
  e.g. audio, bios, bluetooth, ethernet, gpu, monitor, wifi

  If Windows Update rollback to an older version, open Device manager:
  update driver > browse my computer for drivers > let me pick from a list of available drivers on my computer:
    Choose the newest driver and apply. This should prevent Window Update to override the driver.
  When installing Intel Graphics Drivers (iGPU), do not choose clean installation.
  If the old driver (the one installed by Windows) is removed, Windows update will reinstall it.

- Device Manager: Disable unused hardware.
  e.g. biometric, bluetooth, cameras

- Undervolt cpu/gpu (if desired).
  cpu: Intel XTU / AMD Ryzen Master / Throttlestop
  gpu: MSI afterburner
  tools: heaven benchmark / cinebench
#>

#=======================================
## nvidia
#=======================================
<#
Uninstall the old driver with Display Driver Uninstaller (DDU)

NVCleanstall: select the following options
- tweaks menu:
  - disable installer telemetry & advertising
  - perform a clean installation (not necessary if you used DDU)
  - disable Multiplane Overlay (MPO) (select if you have issues with flickering/blackscreens)
  - show expert tweaks:
    - disable driver telemetry (experimental) (will auto-select rebuild digital signature)
    - disable Nvidia HD audio device sleep timer (might fail)
    - enable message signaled interrupts (interrupt policy: default | interrupt priority: High)
    - disable HDCP
  - rebuild digital signature (required for one or more selected tweaks on this page)
    - use method compatible with Easy-Anti-Cheat
    - automatically accept the "driver unsigned" warning
#>

#endregion todo manually

#==============================================================================
#                              helper functions
#==============================================================================
#region helper functions

#=======================================
## user info
#=======================================
# Needed to be able to execute the script on standart account.
# i.e. elevated terminal modify the admin's Hive, therefore not HKEY_CURRENT_USER.

# It should also works for Active Directory users ?
# As I haven't tested this use case, the script will exit if it fails to retrieve the username.

function Get-LoggedUserUsername
{
    $ComputerInfo = Get-CimInstance -ClassName 'Win32_ComputerSystem' -Verbose:$false
    $DeviceName = $ComputerInfo.Name
    $Username = ($ComputerInfo.UserName) -ireplace "$DeviceName\\"

    if (-not $Username)
    {
        Write-Error -Message 'Error to get the UserName of current logged user'
        Exit # exit the script
    }
    $Username
}

function Get-LoggedUserEnvVariable
{
    $LoggedUserSID = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
    $LoggedUserEnvRegPath = "Registry::HKEY_USERS\$LoggedUserSID\Volatile Environment"
    $EnvVariable = Get-ItemProperty -Path $LoggedUserEnvRegPath | Select-Object -Property '*' -Exclude 'PS*'
    $EnvVariable
}

#=======================================
## regedit
#=======================================
function Set-RegistryEntry
{
    <#
    .SYNTAX
        Set-RegistryEntry [-InputObject] <RegistryEntry> [<CommonParameters>]

    .EXAMPLE
        PS> $Foo = '[
              {
                "Hive"    : "HKEY_LOCAL_MACHINE",
                "Path"    : "SOFTWARE\\FooApp\\Config",
                "Entries" : [
                  {
                    "Name"  : "Enabled",
                    "Value" : "1",
                    "Type"  : "DWord"
                  },
                  {
                    "RemoveEntry" : true,
                    "Name"  : "Autostart",
                    "Value" : "1",
                    "Type"  : "DWord"
                  }
                ]
              }
            ]' | ConvertFrom-Json
        PS> $Foo | Set-RegistryEntry

    .EXAMPLE
        PS> $Bar = '[
              {
                "SkipKey" : true,
                "Hive"    : "HKEY_LOCAL_MACHINE",
                "Path"    : "SOFTWARE\\BarApp\\Config",
                "Entries" : [
                  {
                    "Name"  : "Enabled",
                    "Value" : "1",
                    "Type"  : "DWord"
                  }
                ]
              },
              {
                "RemoveKey" : true,
                "Hive"    : "HKEY_LOCAL_MACHINE",
                "Path"    : "SOFTWARE\\BarApp\\Config",
                "Entries" : [
                  {
                    "Name"  : "Autostart",
                    "Value" : "1",
                    "Type"  : "DWord"
                  }
                ]
              }
            ]' | ConvertFrom-Json
        PS> @( $Foo; $Bar ) | Set-RegistryEntry
        PS> $FooBar = @(
                $Foo
                $Bar
            )
        PS> $FooBar | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [RegistryEntry]
        $InputObject
    )

    begin
    {
        class RegistryEntry
        {
            [bool] $SkipKey
            [bool] $RemoveKey
            [string] $Hive
            [string] $Path
            [RegistryKeyEntry[]] $Entries
        }

        class RegistryKeyEntry
        {
            [bool] $RemoveEntry
            [string] $Name
            [string] $Value
            [string] $Type
        }

        $LoggedUserSID = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
    }

    process
    {
        if ($InputObject.SkipKey)
        {
            return
        }

        $RegistryPath = ($InputObject.Hive + '\' + $InputObject.Path) -replace '\\+', '\'
        $RegistryPathOriginal = $RegistryPath

        if ($RegistryPath -match '^(?:HKCU|HKEY_CURRENT_USER)')
        {
            $RegistryPath = $RegistryPath -ireplace '^(?:HKCU|HKEY_CURRENT_USER)', "HKEY_USERS\$LoggedUserSID"
        }

        $RegistryPath = "Registry::$RegistryPath"
        if ($InputObject.RemoveKey)
        {
            Write-Verbose -Message "Removing key: $RegistryPathOriginal"
            Remove-Item -Recurse -Path $RegistryPath -ErrorAction 'SilentlyContinue'
        }
        else
        {
            Write-Verbose -Message "Setting key: $RegistryPathOriginal"

            if (-not (Test-Path -Path $RegistryPath))
            {
                New-Item -Path $RegistryPath -Force | Out-Null
            }

            foreach ($Entry in $InputObject.Entries)
            {
                if ($Entry.RemoveEntry)
                {
                    Write-Verbose -Message "     remove: '$($Entry.Name)'"
                    Remove-ItemProperty -Path $RegistryPath -Name $Entry.Name -ErrorAction 'SilentlyContinue'
                }
                else
                {
                    $RegistryEntryData = @{
                        Path  = $RegistryPath
                        Name  = $Entry.Name
                        Value = $Entry.Value
                        Type  = $Entry.Type
                    }
                    if ($Entry.Type -eq 'Binary')
                    {
                        $RegistryEntryData.Value = $Entry.Value -eq '' ? $null : $Entry.Value -split '\s+'
                    }
                    Write-Verbose -Message "        set: '$($Entry.Name)' to '$($Entry.Value)' ($($Entry.Type))"
                    Set-ItemProperty @RegistryEntryData | Out-Null
                }
            }
        }
    }
}

#endregion helper functions

#endregion WindowsMize


#=================================================================================================================
#                                                     tweaks
#=================================================================================================================
#region tweaks

#==============================================================================
#                                action center
#==============================================================================
#region action center

# Windows 11 24H2+ only.
function Set-ActionCenterLayout
{
    # Default order for the quick-settings.
    # Adjust according to your preferences.
    $QuickActionsLayout = '[
      {
        "Name": "Toggles",
        "QuickActions": [
          { "FriendlyName": "Microsoft.QuickAction.WiFi" },
          { "FriendlyName": "Microsoft.QuickAction.Bluetooth" },
          { "FriendlyName": "Microsoft.QuickAction.Cellular" },
          { "FriendlyName": "Microsoft.QuickAction.WindowsStudio" },
          { "FriendlyName": "Microsoft.QuickAction.AirplaneMode" },
          { "FriendlyName": "Microsoft.QuickAction.Accessibility" },
          { "FriendlyName": "Microsoft.QuickAction.Vpn" },
          { "FriendlyName": "Microsoft.QuickAction.RotationLock" },
          { "FriendlyName": "Microsoft.QuickAction.BatterySaver" },
          { "FriendlyName": "Microsoft.QuickAction.EnergySaverAcOnly" },
          { "FriendlyName": "Microsoft.QuickAction.LiveCaptions" },
          { "FriendlyName": "Microsoft.QuickAction.BlueLightReduction" },
          { "FriendlyName": "Microsoft.QuickAction.MobileHotspot" },
          { "FriendlyName": "Microsoft.QuickAction.NearShare" },
          { "FriendlyName": "Microsoft.QuickAction.ColorProfile" },
          { "FriendlyName": "Microsoft.QuickAction.Cast" },
          { "FriendlyName": "Microsoft.QuickAction.ProjectL2" },
          { "FriendlyName": "Microsoft.QuickAction.LocalBluetooth" },
          { "FriendlyName": "Microsoft.QuickAction.A9" }
        ]
      },
      {
        "Name": "Sliders",
        "QuickActions": [
          { "FriendlyName": "Microsoft.QuickAction.Brightness" },
          { "FriendlyName": "Microsoft.QuickAction.VolumeNoTimer" }
        ]
      }
    ]'.Replace('"', '\"') -replace '\s+'

    $QuickActionsReg = '[
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Control Panel\\Quick Actions\\Control Center",
        "Entries" : [
            {
            "Name"  : "UserLayoutPaginated",
            "Value" : "$QuickActionsLayout",
            "Type"  : "String"
            }
        ]
      }
    ]'.Replace('$QuickActionsLayout', $QuickActionsLayout) | ConvertFrom-Json

    Write-Verbose -Message "Setting Action Center Layout ..."
    Set-RegistryEntry -InputObject $QuickActionsReg -Verbose:$false
}

#endregion action center


#==============================================================================
#                                   drivers
#==============================================================================
#region drivers

# See also $HardwareAutoDownloadManufacturersApps (tweaks > system properties > hardware).

#=======================================
## device installation
#=======================================
# gpo\ computer config > administrative tpl > system > device installation
#   specify search order for device driver source location
# not configured: delete (default)
# do not search Windows Update: 0
# always search Windows Update: 1
# search Windows Update only if needed: 2
$DeviceInstallationDriversGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DriverSearching",
    "Entries" : [
      {
        "Name"  : "SearchOrderConfig",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#=======================================
## printer drivers download over HTTP
#=======================================
# gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
#   turn off downloading of print drivers over HTTP
# not configured: delete (default) | off: 1
$PrinterDriversDownloadOverHttpGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\Printers",
    "Entries" : [
      {
        "Name"  : "DisableWebPnPDownload",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#=======================================
## windows update
#=======================================
# gpo\ computer config > administrative tpl > windows components > windows update > manage updates offered from windows update
#   do not include drivers with Windows updates
# not configured: delete (default) | off: 1 0
$WindowsUpdateDriversGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate",
    "Entries" : [
      {
        "Name"  : "ExcludeWUDriversInQualityUpdate",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DriverSearching",
    "Entries" : [
      {
        "Name"  : "DriverUpdateWizardWUSearchEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion drivers


#==============================================================================
#                                  event log
#==============================================================================
#region event log

# Somehow a test to see if it would help to reduce SSD write. It doesn't do much ...
function Move-EventLogDriveLocation
{
    <#
    .SYNTAX
        Move-EventLogDriveLocation [-Drive] <String> [<CommonParameters>]

    .EXAMPLE
        PS> Move-EventLogDriveLocation -Drive 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidatePattern(
            "[A-Za-z]:\\?",
            ErrorMessage = 'The drive syntax is not valid. Syntax is <DriveLetter>: or <DriveLetter>:\')]
        [string]
        $Drive
    )

    Write-Verbose -Message "Moving Event Log Drive Location to '$Drive' ..."

    $EventPath = "$env:SystemRoot\system32\winevt\"
    $EventLogPath = "$EventPath\Logs\"
    $NewEventLogPath = "$Drive\winevt\Logs\"

    Stop-Service -Name 'EventLog' -Force
    New-SymbolicLink -Path $EventLogPath -Target $NewEventLogPath -TargetType 'Directory'

    $EventAcl = Get-Acl -Path $EventPath
    Set-Acl -Path $EventLogPath, $NewEventLogPath -AclObject $EventAcl

    Start-Service -Name 'EventLog'
}

#endregion event log


#==============================================================================
#                                file explorer
#==============================================================================
#region file explorer

#=======================================
## general
#=======================================
#region general

# open file explorer to
#-------------------
# This PC: 1 | Home: 2 (default) | Downloads: 3 | OneDrive: 4
$FileExplorerOpenTo = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "LaunchTo",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show recently used files
# (if disabled, also remove recent items from the Start Menu)
#-------------------
# on: 1 (default) | off: 0
$FileExplorerRecentlyUsedFiles = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "ShowRecent",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show frequently used folders
#-------------------
# on: 1 (default) | off: 0
$FileExplorerFrequentlyUsedFolders = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "ShowFrequent",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show files from Office.com
#-------------------
# on: 1 (default) | off: 0
$FileExplorerFilesFromOfficeDotCom = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "ShowCloudFilesInQuickAccess",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion general

#=======================================
## view
#=======================================
#region view

# decrease space between items (compact view)
#-------------------
# on: 1 | off: 0 (default)
$FileExplorerCompactView = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "UseCompactMode",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# use check boxes to select items
#-------------------
# on: 1 | off: 0 (default)
$FileExplorerItemCheckBoxes = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "AutoCheckSelect",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# hide extensions for known file types
#-------------------
# on: 1 (default) | off: 0
$FileExplorerFileNameExtensions = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "HideFileExt",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# hide folder merge conflicts
#-------------------
# on: 1 (default) | off: 0
$FileExplorerFolderMergeConflicts = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "HideMergeConflicts",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# hidden files, folders, and drives
#-------------------
# on: 1 | off: 2 (default)
$FileExplorerHiddenItems = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Hidden",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show encrypted or compressed NTFS files in color
#-------------------
# on: 1 | off: 0 (default)
$FileExplorerEncryptedOrCompressedNtfsFilesInColor = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowEncryptCompressedColor",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show sync provider notifications
#-------------------
# on: 1 (default) | off: 0
$FileExplorerSyncProviderNotifications = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowSyncProviderNotifications",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# use sharing wizard
#-------------------
# on: 1 (default) | off: 0
$FileExplorerSharingWizard = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "SharingWizardOn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion view

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

# gallery shorcut (navigation pane)
#-------------------
# on: key present (default) | off: delete key
$FileExplorerGalleryShorcut = '[
  {
    "RemoveKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}",
    "Entries" : [
      {
        "Name"  : "(Default)",
        "Value" : "Gallery Folder",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# duplicate drives (navigation pane)
#-------------------
# on: key present (default) | off: delete key
$FileExplorerDuplicateDrives = '[
  {
    "RemoveKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Desktop\\NameSpace\\DelegateFolders\\{F5FB2C77-0E2F-4A16-A381-3E560C68BC83}",
    "Entries" : [
      {
        "Name"  : "(Default)",
        "Value" : "Removable Drives",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# icon cache size
#-------------------
# default: 512KB
$FileExplorerIconCacheSize = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "MaxCachedIcons",
        "Value" : "4096",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# folder type detection
#-------------------
# Might be usefull for folders that contains big or many files.
# Bags & BagMRU\ current saved folders type
# FolderType\ on: delete (default) | off: NotSpecified
$FileExplorerFolderTypeDetection = '[
  {
    "RemoveKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags",
    "Entries" : []
  },
  {
    "RemoveKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\BagMRU",
    "Entries" : []
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\Shell\\Bags\\AllFolders\\Shell",
    "Entries" : [
      {
        "Name"  : "FolderType",
        "Value" : "NotSpecified",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion miscellaneous

#endregion file explorer


#==============================================================================
#                                miscellaneous
#==============================================================================
#region miscellaneous

#=======================================
## automatic login
#=======================================
#region automatic login

# This registry entry will show the following option in user accounts (Netplwiz.exe):
#   Users must enter a user name and password to use this computer.
# Untick this option to enable automatic login.
#-------------------
# on: 0 | off: 2 (default)
$AutoLogin = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\PasswordLess\\Device",
    "Entries" : [
      {
        "Name"  : "DevicePasswordLessBuildVersion",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion automatic login

#=======================================
## clear recent files on exit
#=======================================
#region clear recent files on exit

# Only include:
#   Recent items menu on the Start Menu
#   Jump Lists in the Start Menu and Taskbar
# See $StartRecentlyOpenedItems to completely disable recent files.
#-------------------
# gpo\ user config > administrative tpl > start menu and taskbar
#   clear history of recently openened documents on exit
# not configured: delete (default) | off: 1
$ClearRecentFilesOnExitGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "ClearRecentDocsOnExit",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion clear recent files on exit

#=======================================
## cloud configuration download
#=======================================
#region cloud configuration download

# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   disable OneSettings downloads
# not configured: delete (default) | off: 1
$CloudConfigDownloadGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "DisableOneSettingsDownloads",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion cloud configuration download

#=======================================
## control panel (icons view) > ease of access center (control access.cpl)
#=======================================
#region ease of access center

# always read this section
# always scan this section
#-------------------
# on: 1 (default) | off: 0
$ControlPanelEaseOfAccessCenterReadAndScan = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Ease of Access",
    "Entries" : [
      {
        "Name"  : "selfvoice",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "selfscan",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion ease of access center

#=======================================
## copy/paste more details
#=======================================
#region copy/paste more details

# on: 1 | off: 0 (default)
$CopyPasteMoreDetails = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\OperationStatusManager",
    "Entries" : [
      {
        "Name"  : "EnthusiastMode",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion copy/paste more details

#=======================================
## file history
#=======================================
#region file history

# control panel (icons view) > file history
# (control.exe /name Microsoft.FileHistory)

# gpo\ computer config > administrative tpl > windows components > file history
#   turn off file history
# not configured: delete (default) | off: 1
$FileHistoryGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\FileHistory",
    "Entries" : [
      {
        "Name"  : "Disabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion file history

#=======================================
## first sign-in animation
#=======================================
#region first sign-in animation

# gpo\ computer config > administrative tpl > system > logon
#   show first sign-in animation
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 (default) | off: 0
$FirstSigninAnimationGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
    "Entries" : [
      {
        "Name"  : "EnableFirstLogonAnimation",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon",
    "Entries" : [
      {
        "Name"  : "EnableFirstLogonAnimation",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion first sign-in animation

#=======================================
## font streaming
#=======================================
#region font streaming

# download font on demand if not available on the device
#-------------------
# gpo\ computer config > administrative tpl > network > fonts
#   enable font providers
# not configured: delete (default) | on: 1 | off: 0
$FontStreamingGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableFontProviders",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion font streaming

#=======================================
## fullscreen optimizations
#=======================================
#region fullscreen optimizations

# If your game doesn't run well, you might try to enable or disable Fullscreen optimizations.
# If you don't need/want to disable it system-wide, you can do it for specific application:
#   Right-click on the executable and click on Properties.
#   Click on the Compatibility tab.
#   Check or uncheck Disable fullscreen optimizations.
#
# If issues with color managment or alt + tab, set GameDVR_DXGIHonorFSEWindowsCompatible to 0 ?

<#
source: internet

GameDVR_DSEBehavior:
  0 (default): Game DVR can use full system resources for recording and broadcasting while in DSE.
  2: Limits Game DVR resource usage in DSE, potentially improving gaming performance.

GameDVR_DXGIHonorFSEWindowsCompatible:
  0 (default): Game DVR can still record even if the game sets FSE on, potentially impacting performance.
  1: Game DVR respects the FSE flag and won't record while games are in true full-screen mode.

GameDVR_EFSEFeatureFlags:
  This key controls additional functionality related to Enhanced Full-screen Exclusive (EFSE), a newer version of FSE.
  Different bit values within the key enable or disable specific features. 0 means disabled, 1 means enabled.
    Bit 0: Enables or disables EFSE mode.
    Bit 1: Enables or disables the use of DXGI flip model swap chains for EFSE mode.
    Bit 2: Enables or disables the use of DXGI swap chain scaling for EFSE mode.
    Bit 3: Enables or disables the use of DXGI swap chain color space support for EFSE mode.
    Bit 4: Enables or disables the use of DXGI swap chain HDR metadata support for EFSE mode.
    Bit 5: Enables or disables the use of DXGI swap chain overlay support for EFSE mode.
  There are probably more, better to leave this untouched or at least just enable/disable it.

GameDVR_FSEBehavior:
  0 (default): Game DVR can use full system resources while games are full-screen.
  2: Limits Game DVR resource usage in full-screen games, potentially improving performance.

GameDVR_FSEBehaviorMode:
  0 (default): Only applies GameDVR_FSEBehavior to games marked as "high impact" on your system.
  1: Applies GameDVR_FSEBehavior to all full-screen games.
  2: Disabled.

GameDVR_HonorUserFSEBehaviorMode:
  0 (default): Uses the default mode.
  1: Forces application of GameDVR_FSEBehavior to all full-screen games.
#>

# See also $GameDVR (settings > gaming > gameDVR).

# on: 0 0 1 0 0 0 (default) | off: 2 1 0 2 2 1
$FullscreenOptimizations = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "System\\GameConfigStore",
    "Entries" : [
      {
        "Name"  : "GameDVR_DSEBehavior",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "GameDVR_DXGIHonorFSEWindowsCompatible",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "GameDVR_EFSEFeatureFlags",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "GameDVR_FSEBehavior",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "GameDVR_FSEBehaviorMode",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "GameDVR_HonorUserFSEBehaviorMode",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion fullscreen optimizations

#=======================================
## help and support feedback
#=======================================
#region help and support feedback

# gpo\ user config > administrative tpl > system > internet communication management > internet communication settings
#   turn off help experience improvement program
#   turn off help ratings
# not configured: delete (default) | off: 1
$HelpAndSupportFeedbackGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Assistance\\Client\\1.0",
    "Entries" : [
      {
        "Name"  : "NoImplicitFeedback",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "NoExplicitFeedback",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion help and support feedback

#=======================================
## help tips
#=======================================
#region help tips

# gpo\ computer config > administrative tpl > windows components > edge ui
#   disable help tips
# not configured: delete (default) | off: 1
$HelpTipsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\EdgeUI",
    "Entries" : [
      {
        "Name"  : "DisableHelpSticker",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion help tips

#=======================================
## home page setting visibility
#=======================================
#region home page setting visibility

# gpo\ computer config > administrative tpl > control panel
#   settings page visibility
# not configured: delete (default) | on: 'showonly:about;bluetooth' (example) | off: 'hide:home'
$HomePageSettingVisibilityGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "SettingsPageVisibility",
        "Value" : "hide:home",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion home page setting visibility

#=======================================
## indexing of encrypted files
#=======================================
#region indexing of encrypted files

# gpo\ computer config > administrative tpl > windows components > search
#   allow indexing of encrypted files
# not configured: delete (default) | on: 1 | off: 0
$IndexingOfEncryptedFilesGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search",
    "Entries" : [
      {
        "Name"  : "AllowIndexingEncryptedStoresOrItems",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion indexing of encrypted files

#=======================================
## location and sensors
#=======================================
#region location and sensors

# See also $PrivacyLocation (settings > privacy & security > app permissions > location).

# gpo\ computer config > administrative tpl > windows components > location and sensors
#   turn off location
#   turn off location scripting
#   turn off sensors
# not configured: delete (default) | off: 1
$LocationAndSensorsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\LocationAndSensors",
    "Entries" : [
      {
        "RemoveEntry": true,
        "Name"  : "DisableLocation",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableLocationScripting",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableSensors",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion location and sensors

#=======================================
## lock screen camera access
#=======================================
#region lock screen camera access

# gpo\ computer config > administrative tpl > control panel > personalization
#   prevent enabling lock screen camera
# not configured: delete (default) | off: 1
$LockScreenCameraAccessGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Personalization",
    "Entries" : [
      {
        "Name"  : "NoLockScreenCamera",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion lock screen camera access

#=======================================
## messaging cloud sync
#=======================================
#region messaging cloud sync

# gpo\ computer config > administrative tpl > windows components > messaging
#   allow message service cloud sync
# not configured: delete (default) | off: 0
$MessagingCloudSyncGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Messaging",
    "Entries" : [
      {
        "Name"  : "AllowMessageSync",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion messaging cloud sync

#=======================================
## notification network usage
#=======================================
#region notification network usage

# Windows Push Notifications System Service (WpnService)

# gpo\ computer config > administrative tpl > start menu and taskbar > notifications
#   turn off notifications network usage
# not configured: delete (default) | off: 1
$NotificationNetworkUsageGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\CurrentVersion\\PushNotifications",
    "Entries" : [
      {
        "Name"  : "NoCloudApplicationNotification",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion notification network usage

#=======================================
## NTFS Last Access Time
#=======================================
#region NTFS Last Access Time

# 0: User Managed, Last Access Time Updates Enabled
# 1: User Managed, Last Access Time Updates Disabled
# 2: System Managed, Last Access Time Updates Enabled (default)
# 3: System Managed, Last Access Time Updates Disabled
function Set-NTFSLastAccessTime
{
    <#
    .SYNTAX
        Set-NTFSLastAccessTime [-Managed] {User | System} [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-NTFSLastAccessTime -Managed 'User' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('User', 'System')]
        [string]
        $Managed,

        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'NTFS LastAccessTime' to '$Managed Managed: $State' ..."

    $Value = $State -eq 'Enabled' ? 0 : 1
    if ($Managed -eq 'System')
    {
        $Value += 2
    }
    fsutil.exe behavior set DisableLastAccess $Value | Out-Null
}

function Disable-NTFSLastAccessTime
{
    Set-NTFSLastAccessTime -Managed 'User' -State 'Disabled'
}

#endregion NTFS Last Access Time

#=======================================
## numlock at startup
#=======================================
#region numlock at startup

# on: 2147483650 (or 2) | off: 2147483648 (or 0) (default)
# 32bits integer limits: INT_MAX == 2147483647
$NumlockAtStartup = '[
  {
    "Hive"    : "HKEY_USERS",
    "Path"    : ".DEFAULT\\Control Panel\\Keyboard",
    "Entries" : [
      {
        "Name"  : "InitialKeyboardIndicators",
        "Value" : "2",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion numlock at startup

#=======================================
## online tips and help in Settings app
#=======================================
#region online tips and help in Settings app

# gpo\ computer config > administrative tpl > control panel
#   allow online tips
# not configured: delete (default) | off: 0
$OnlineTipsInSettingsAppGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "AllowOnlineTips",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion online tips and help in Settings app

#=======================================
## 'open with' dialog: Look for an app in the Store
#=======================================
#region 'open with' dialog

# Remove the 'Look for an app in the Store' item in the 'Open With' dialog.
# This does not affect the 'Open with > Search the Microsoft Store' context menu item.
#-------------------
# gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
#   turn off access to the Store
# not configured: delete (default) | off: 1
$OpenWithDialogSearchAppInStoreGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoUseStoreOpenWith",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion 'open with' dialog

#=======================================
## path length limit (260 characters MAX_PATH)
#=======================================
#region path length limit

# on: 0 (default) | off: 1
$PathLengthLimit = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\FileSystem",
    "Entries" : [
      {
        "Name"  : "LongPathsEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion path length limit

#=======================================
## password expiration
#=======================================
#region password expiration

# Already done within the unattend file (if you used it).
function Disable-PasswordExpiration
{
    Write-Verbose -Message 'Disabling Password Expiration ...'

    # Disable for all local users.
    Get-LocalUser | Set-LocalUser -PasswordNeverExpires $true

    # Disable for all local users and make default to never expires.
    #net.exe accounts /maxpwage:UNLIMITED | Out-Null
}

#endregion password expiration

#=======================================
## password reveal button
#=======================================
#region password reveal button

# gpo\ user config > administrative tpl > windows components > credential user interface
#   do not display the password reveal button
# not configured: delete (default) | off: 1
$PasswordRevealButtonGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\CredUI",
    "Entries" : [
      {
        "Name"  : "DisablePasswordReveal",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion password reveal button

#=======================================
## recycle bin
#=======================================
#region recycle bin

# gpo\ user config > administrative tpl > windows components > file explorer
#   do not move deleted files to the Recycle Bin
# not configured: delete (default) | off: 1
$RecycleBinRemoveFilesImmediatelyGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoRecycleFiles",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# gpo\ user config > administrative tpl > windows components > file explorer
#   display confirmation dialog when deleting files
# not configured: delete (default) | on: 1
$RecycleBinDeleteConfirmationDialogGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "ConfirmFileDelete",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion recycle bin

#=======================================
## service host splitting
#=======================================
#region service host splitting

# Benefits of separating SvcHost services:
#   Increased reliability, security and scalability.
#   Improved resource and memory management.

# Disabling service host splitting reduces RAM usage (a bit) and decreases the process count.
# It might increase performances with the trade-off of losing the benefits mentioned above.

# default: On systems with 3.5 GB or less RAM, SvcHost services will be grouped.
# default: 3670016 (3.5 GB x 1024 x 1024) | off: 0 (or <YOUR_RAM> in KB)
$ServiceHostSplitting = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control",
    "Entries" : [
      {
        "Name"  : "SvcHostSplitThresholdInKB",
        "Value" : "3670016",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion service host splitting

#=======================================
## short 8.3 filenames
#=======================================
#region short 8.3 filenames

function Disable-8Dot3FileName
{
    Write-Verbose -Message 'Disabling Short 8.3 Filenames ...'

    fsutil.exe behavior set Disable8dot3 1

    <#
    The following command (fsutil.exe 8Dot3Name strip) will display a scary Warning. That's not as bad as stated.

    You should replace any mention of 8Dot3 Name in the registry (open the generated log file to find them).

    Checking the log file:
    In the first part of the log (between the start and before 'Total affected registry keys:').
    In the column 'Registry Data', if you have a 8Dot3 Name, open the registry and replace the value with the full path.

    There shouldn't have many, if at all, registry keys affected. On my fresh install testing VM, I had none.
    This script run this command before installing any programs, so in theory, there shouldn't have any 8Dot3 filenames.

    The tool report all keys with a tilde(~) character, but that doesn't mean it's a 8Dot3 Name.
    This was the only one on my system ... despite the tool reported 200+ affected registry keys.
    hive  : HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{CA8A9780-280D-11CF-A24D-444553540000}\ToolboxBitmap32
    key   : (Default)
    value : C:\PROGRA~1\COMMON~1\Adobe\Acrobat\ActiveX\AcroPDF.dll, 102

    The 8Dot3 FileNames are 'PROGRA~1' and 'COMMON~1'.
    Replace the value with the full path name in the registry.
    i.e. "C:\Program Files\Common Files\Adobe\Acrobat\ActiveX\AcroPDF.dll"
    #>

    # This can take a while on HDD (few minutes) (it's really fast on SSD (few seconds)).
    Write-Verbose -Message ("   The Warning is not as bad as stated.`n" +
        "            Open the generated log file and replace any mention of 8Dot3 Name in the registry.`n" +
        "            Read the comment in the script for more details.`n")
    fsutil.exe 8Dot3Name strip /f /s $env:SystemDrive
}

#endregion short 8.3 filenames

#=======================================
## shorcut character map
#=======================================
#region shorcut character map

# After running the script, the 'character map' shorcut (all apps > windows tools) is shown in the Start Menu.
# Probably a Windows bug, as it is not visible in the Start Menu on a fresh install.

# Let's move this shorcut to the 'Windows Tools' folder.
# 'sfc /scannow' will revert back the location of the 'character map' shorcut ...

function Move-CharacterMapShorcutToWindowsTools
{
    Write-Verbose -Message "Moving 'Character Map Shorcut' To 'Windows Tools Folder' ..."

    $CharacterMapFilePath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Accessories\System Tools\Character Map.lnk"
    $WindowsToolsPath = "$env:ProgramData\Microsoft\Windows\Start Menu\Programs\Administrative Tools"
    Move-Item -Path $CharacterMapFilePath -Destination $WindowsToolsPath -ErrorAction 'SilentlyContinue'
}

#endregion shorcut character map

#=======================================
## shortcut name suffix
#=======================================
#region shortcut name suffix

# e.g. "File - Shortcut"
#-------------------
# on: delete or 30 00 00 00 (default) | off: 00 00 00 00
$ShortcutNameSuffix = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "link",
        "Value" : "00 00 00 00",
        "Type"  : "Binary"
      }
    ]
  }
]' | ConvertFrom-Json

# Alternative method (allow personalization).
# If 'ShortcutNameTemplate' exist, the value of 'link' will be ignored.
#-------------------
# default: delete
$ShortcutNameSuffixCustom = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\NamingTemplates",
    "Entries" : [
      {
        "Name"  : "ShortcutNameTemplate",
        "Value" : "\"%s (shorcut).lnk\"",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion shortcut name suffix

#=======================================
## start menu recommended section
#=======================================
#region start menu recommended section

# gpo\ computer config > administrative tpl > start menu and taskbar
#   remove recommended section from Start Menu (only applies to Enterprise and Education SKUs)
# not configured: delete (default) | on: 1
$StartMenuRecommendedSection = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "HideRecommendedSection",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion start menu recommended section

#=======================================
## suggested content
#=======================================
#region suggested content

# Leftover from Windows 10 ? probably still works on 11.
# The keys still exist in Windows 11, doesn't hurt to disable them.
# Show suggestions occasionally in Start: (Windows 10 only)
#   SubscribedContent-338388Enabled (old: SystemPaneSuggestionsEnabled)
#-------------------
# on: 1 (default) | off: 0
$SuggestedContent = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
    "Entries" : [
      {
        "Name"  : "ContentDeliveryAllowed",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "OemPreInstalledAppsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "PreInstalledAppsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "PreInstalledAppsEverEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SilentInstalledAppsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SubscribedContent-338388Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SystemPaneSuggestionsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion suggested content

#=======================================
## verbose startup/shutdown status messages
#=======================================
#region verbose startup/shutdown

# gpo\ computer config > administrative tpl > system
#   display highly detailed status messages
# not configured: delete (default) | on: 1
$VerboseStartupShutdownGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
    "Entries" : [
      {
        "Name"  : "VerboseStatus",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion verbose boot/shutdown

#=======================================
## wifi sense (or hotspot 2.0)
#=======================================
#region wifi sense

# Wifi Sense has been removed from Windows 10 and 11.
# Does Windows still connect automatically to free hotspots ? (probably not)
# Doesn't hurt to disable it anyway, just in case ...
#-------------------
# gpo\ computer config > administrative tpl > network > wlan service > wlan settings
#   allow Windows to automatically connect to suggested open hotspots,
#     to networks shared by contacts, and to hotspots offering paid services
# not configured: delete (default) | off: 0
$WifiSenseGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "AutoConnectAllowedOEM",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion wifi sense

#=======================================
## windows experimentation
#=======================================
#region windows experimentation

# on: 1 (default) | off: 0
$WindowsExperimentation = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\PolicyManager\\default\\System\\AllowExperimentation",
    "Entries" : [
      {
        "Name"  : "value",
        "Value" : "0",
        "Type"  : "DWord"
      }
]' | ConvertFrom-Json

#endregion windows experimentation

#=======================================
## windows help & support (F1 key)
#=======================================
#region windows help & support

# F1 key is not disabled, it disable only the opening of Windows help & support.
#-------------------
# on: delete (default) | off: empty value
$WindowsHelpAndSupportF1Key = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Typelib\\{8cec5860-07a1-11d9-b15e-000d56bfe6ee}\\1.0\\0\\win64",
    "Entries" : [
      {
        "Name"  : "(Default)",
        "Value" : "",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion windows help & support

#=======================================
## windows input experience
#=======================================
#region windows input experience

# on: 1 (default) | off: 0
$WindowsInputExperience = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Input",
    "Entries" : [
      {
        "Name"  : "IsInputAppPreloadEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
]' | ConvertFrom-Json

#endregion windows input experience

#=======================================
## windows media digital rights management (DRM)
#=======================================
#region windows media DRM

# gpo\ computer config > administrative tpl > windows components > windows media digital rights management
#   prevent Windows Media DRM Internet Access
# not configured: delete (default) | off: 1
$WindowsMediaDRMGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "Software\\Policies\\Microsoft\\WMDRM",
    "Entries" : [
      {
        "Name"  : "DisableOnline",
        "Value" : "1",
        "Type"  : "DWord"
      }
]' | ConvertFrom-Json

#endregion windows media DRM

#=======================================
## windows privacy settings experience
#=======================================
#region windows privacy settings experience

# gpo\ computer config > administrative tpl > windows components > OOBE
#   don't launch privacy settings experience on user logon
# not configured: delete (default) | off: 1
$WindowsPrivacySettingsExperienceGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\OOBE",
    "Entries" : [
      {
        "Name"  : "DisablePrivacyExperience",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion windows privacy settings experience

#=======================================
## windows shared experience
#=======================================
#region windows shared experience

# Disable and grayed out:
#   settings > system > nearby sharing
#   settings > apps > advanced app settings > Share Across Devices
#-------------------
# gpo\ computer config > administrative tpl > system > group policy
#   continue experiences on this device
# not configured: delete (default) | off: 0
$WindowsSharedExperienceGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableCdp",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion windows shared experience

#=======================================
## windows spotlight
#=======================================
#region windows spotlight

# Not mentionned in Group Policy, but only applies to Enterprise and Education SKUs.

# gpo\ user config > administrative tpl > windows components > cloud content
#   do not suggest third-party content in Windows spotlight
#   turn off all Windows spotlight features
#     personalization > background > windows spotlight
#     personalization > lockscreen > windows spotlight
#     personalization > lockscreen > get fun facts, tips, tricks, and more
#     system > notifications > show the Windows welcome experience [...]
#     system > notifications > get tips and suggestions when using Windows
#     privacy & security > general > show me suggested content in the setting app
#   turn off spotlight collection on Desktop
#     personalization > background > windows spotlight
#   turn off Windows spotlight on Action Center
#     do not display suggested content (apps or features) in Action Center
#
# not configured: delete (default) | off: 1
$WindowsSpotlightGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableThirdPartySuggestions",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableWindowsSpotlightFeatures",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableSpotlightCollectionOnDesktop",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableWindowsSpotlightOnActionCenter",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion windows spotlight

#endregion miscellaneous


#==============================================================================
#                                   network
#==============================================================================
#region network

#=======================================
## helper functions
#=======================================
#region helper functions

function Export-EnabledNetAdapterProtocolNames
{
    $LogFilePath = "$PSScriptRoot\windows_netadapter_protocol_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Enabled NetAdapter Protocol Names ...'

        Get-NetAdapterBinding |
            Where-Object -Property 'Enabled' -EQ -Value $true |
            Select-Object -Property 'Name', 'DisplayName', 'ComponentID', 'Enabled' |
            ConvertTo-Json |
            Out-File -FilePath $LogFilePath
    }
}

# See also 'services & scheduled tasks > services > system driver' to unload the related system driver.
function Set-NetAdapterProtocol
{
    <#
    .SYNTAX
        Set-NetAdapterProtocol [-InputObject] <NetAdapterProtocol> [-RestoreDefault] [<CommonParameters>]

    .EXAMPLE
        PS> $Protocol = '[
              {
                "DisplayName": "File and Printer Sharing for Microsoft Networks",
                "ComponentID": "ms_server",
                "Enabled"    : false,
                "Default"    : true,
                "Comment"    : "SMB server"
              }
            ]' | ConvertFrom-Json
        PS> $Protocol | Set-NetAdapterProtocol -RestoreDefault

    .NOTES
        settings > network & internet > advanced network settings > Ethernet and/or Wi-FI:
          more adapter options > edit
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [NetAdapterProtocol]
        $InputObject,

        [switch]
        $RestoreDefault
    )

    begin
    {
        class NetAdapterProtocol
        {
            [string] $DisplayName
            [string] $ComponentID
            [bool] $Enabled
            [bool] $Default
            [string] $Comment
        }
    }

    process
    {
        $IsEnabled = $RestoreDefault ? $InputObject.Default : $InputObject.Enabled
        $PhysicalNetAdapter = Get-NetAdapter -Physical
        $CurrentNetAdapterBinding = $PhysicalNetAdapter |
            Get-NetAdapterBinding -ComponentID $InputObject.ComponentID -ErrorAction 'SilentlyContinue'

        if ($CurrentNetAdapterBinding)
        {
            if ($IsEnabled -eq $CurrentNetAdapterBinding.Enabled)
            {
                Write-Verbose -Message "Network protocol '$($InputObject.DisplayName) ($($InputObject.ComponentID))' is already set to '$IsEnabled'"
            }
            else
            {
                Write-Verbose -Message "Setting network protocol '$($InputObject.DisplayName) ($($InputObject.ComponentID))' to '$IsEnabled' ..."
                $PhysicalNetAdapter | Set-NetAdapterBinding -ComponentID $InputObject.ComponentID -Enabled $IsEnabled
            }
        }
    }
}

function Add-NetFirewallRuleToGroup
{
    <#
    .SYNTAX
        Add-NetFirewallRuleToGroup [-DisplayName] <String> [-Group] <String> [<CommonParameters>]

    .EXAMPLE
        PS> Add-NetFirewallRuleToGroup -DisplayName 'some rule' -Group 'some group'

    .NOTES
        Will add the following info banner to the GUI properties:
          This is a predefined rule and some of its properties cannot be modified.

        i.e. The GUI properties 'Protocols and Ports' and 'Programs and Services' will be grayed out.
        Use Set-NetFirewallRule to modify these properties.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $DisplayName,

        [Parameter(Mandatory)]
        [string]
        $Group
    )

    Get-NetFirewallRule -DisplayName $DisplayName |
        ForEach-Object -Process {
            $_.Group = $Group
            Set-NetFirewallRule -InputObject $_
        }
}

function Block-InboundFirewallPort
{
    <#
    .SYNTAX
        Block-InboundFirewallPort [-Rule] <psobject[]> [-Group] <string> [<CommonParameters>]

    .EXAMPLE
        PS> $Rules = @{
                DisplayName = 'Block Inbound Port 445 TCP (SMB)'
                LocalPort   = '445'
                Protocol    = 'TCP'
            }
        PS> $GroupName = '!Custom block inbound port (SMB)'
        PS> Block-InboundFirewallPort -Rule $Rules -Group $GroupName
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [PSCustomObject[]]
        $Rule,

        [Parameter(Mandatory)]
        [string]
        $Group
    )

    $BlockInbound = @{
        Direction   = 'Inbound'
        Action      = 'Block'
    }

    Write-Verbose -Message 'Adding firewall rules:'
    Write-Verbose -Message "    $($Rule.DisplayName | Join-String -Separator "`n             ")"

    Remove-NetFirewallRule -Group $Group -ErrorAction 'SilentlyContinue'
    foreach ($Item in $Rule)
    {
        New-NetFirewallRule @BlockInbound @Item | Out-Null
        Add-NetFirewallRuleToGroup -DisplayName $Item.DisplayName -Group $Group
    }
}

#endregion helper functions

#=======================================
## Connected Devices Platform Service
#=======================================
#region CDP Service

# Ports 5040 and 5050 should not be exposed to the internet.
# Needed by miracast and project ? if issues, don't block these ports.
function Block-CDPFirewallPort5040And5050
{
    $Rules = @(
        @{
            DisplayName = 'Block Inbound Port 5040 TCP (CDP)'
            LocalPort   = '5040'
            Protocol    = 'TCP'
        },
        @{
            DisplayName = 'Block Inbound Port 5050 UDP (CDP)'
            LocalPort   = '5050'
            Protocol    = 'UDP'
        }
    )

    $GroupName = '!Custom block inbound port (CDP)'
    Block-InboundFirewallPort -Rule $Rules -Group $GroupName
}

#endregion CDP Service

#=======================================
## DCOM Service Control Manager (RPC)
#=======================================
#region DCOM Service

# Port 135 should not be exposed to the internet.
# Needed by remote assistance (and more ?).
function Block-DCOMFirewallPort135
{
    $Rules = @(
        @{
            DisplayName = 'Block Inbound Port 135 TCP (RPC)'
            LocalPort   = '135'
            Protocol    = 'TCP'
        },
        @{
            DisplayName = 'Block Inbound Port 135 UDP (RPC)'
            LocalPort   = '135'
            Protocol    = 'UDP'
        }
    )

    $GroupName = '!Custom block inbound port (RPC)'
    Block-InboundFirewallPort -Rule $Rules -Group $GroupName
}

#endregion DCOM Service

#=======================================
## firewall rules - miscellaneous Inbound TCP
#=======================================
#region firewall rules

# Ports 49664-49668 should not be exposed to the internet.
# Used for remote management (probably) ?
#
# These ports are shown as listening in netstat or TCP View.
# As it is probably dynamic ports, block the program/service.
# Not sure if it makes sense to block them ? I guess it does.
function Block-FirewallMiscInboundTCP
{
    $Rules = @(
        @{
            DisplayName = 'Block Inbound TCP - lsass.exe'
            #LocalPort   = '49664'
            Protocol    = 'TCP'
            Program     = "$env:SystemRoot\System32\lsass.exe"
        },
        @{
            DisplayName = 'Block Inbound TCP - wininit.exe'
            #LocalPort   = '49665'
            Protocol    = 'TCP'
            Program     = "$env:SystemRoot\System32\wininit.exe"
        },
        @{
            DisplayName = 'Block Inbound TCP - Schedule'
            #LocalPort   = '49666'
            Protocol    = 'TCP'
            Program     = "$env:SystemRoot\System32\svchost.exe"
            Service     = 'Schedule'
        },
        @{
            DisplayName = 'Block Inbound TCP - EventLog'
            #LocalPort   = '49667'
            Protocol    = 'TCP'
            Program     = "$env:SystemRoot\System32\svchost.exe"
            Service     = 'EventLog'
        },
        @{
            DisplayName = 'Block Inbound TCP - services.exe'
            #LocalPort   = '49668' or '49669'
            Protocol    = 'TCP'
            Program     = "$env:SystemRoot\System32\services.exe"
        }
    )

    $GroupName = '!Custom block inbound prog/service (misc)'
    Block-InboundFirewallPort -Rule $Rules -Group $GroupName
}

#endregion firewall rules

#=======================================
## internet control message protocol (ICMP) redirects
#=======================================
#region ICMP redirects

# default: on
function Set-IcmpRedirects
{
    <#
    .SYNTAX
        Set-IcmpRedirects [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-IcmpRedirects -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Icmp Redirects' to '$State' ..."
    Set-NetIPv4Protocol -IcmpRedirects $State
    Set-NetIPv6Protocol -IcmpRedirects $State
}

function Enable-IcmpRedirects
{
    Set-IcmpRedirects -State 'Enabled'
}

function Disable-IcmpRedirects
{
    Set-IcmpRedirects -State 'Disabled'
}

#endregion ICMP redirects

#=======================================
## ip source routing
#=======================================
#region ip source routing

# on: delete (default) | off: 2
$IPSourceRouting = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\Tcpip\\Parameters",
    "Entries" : [
      {
        "Name"  : "DisableIPSourceRouting",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters",
    "Entries" : [
      {
        "Name"  : "DisableIPSourceRouting",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion ip source routing

#=======================================
## ipv6 protocol
#=======================================
#region ipv6 protocol

# This registry value doesn't affect the state of the GUI check box.
#-------------------
# on: delete (default) | prefer IPv4: 32 | off: 255
$NetworkProtocolsIPv6Preference = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\Tcpip6\\Parameters",
    "Entries" : [
      {
        "Name"  : "DisabledComponents",
        "Value" : "32",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# This setting is equivalent to check/uncheck the GUI check box.
$NetworkProtocolsIPv6 = '[
  {
    "DisplayName": "Internet Protocol Version 6 (TCP/IPv6)",
    "ComponentID": "ms_tcpip6",
    "Enabled"    : true,
    "Default"    : true
  }
]' | ConvertFrom-Json

#endregion ipv6 protocol

#=======================================
## ipv6 transition technologies
#=======================================
#region ipv6 transition technologies

# 6to4
#-------------------
# gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
#   set 6to4 state
# not configured: delete (default)
# default state: 'Default'
# enabled state: 'Enabled'
# disabled state: 'Disabled'
$NetworkProtocol6to4GPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\TCPIP\\v6Transition",
    "Entries" : [
      {
        "Name"  : "6to4_State",
        "Value" : "Disabled",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# teredo
#-------------------
# gpo\ computer config > administrative tpl > network > tcpip settings > ipv6 transition technologies
#   set teredo state
# not configured: delete (default)
# default state: 'Default'
# disabled state: 'Disabled'
# client: 'Client'
# enterprise client: 'Enterprise Client'
$NetworkProtocolTeredoGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\TCPIP\\v6Transition",
    "Entries" : [
      {
        "Name"  : "Teredo_State",
        "Value" : "Disabled",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# user\
function Set-NetworkTeredo
{
    <#
    .SYNTAX
        Set-NetworkTeredo [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-NetworkTeredo -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Default', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Network Protocol Teredo' to '$State' ..."
    Set-NetTeredoConfiguration -Type $State
}

function Enable-NetworkTeredo
{
    Set-NetworkTeredo -State 'Default'
}

function Disable-NetworkTeredo
{
    Set-NetworkTeredo -State 'Disabled'
}

#endregion ipv6 transition technologies

#=======================================
## link-layer discovery protocol (LLDP)
#=======================================
#region LLDP

$NetworkProtocolLldp = '[
  {
    "DisplayName": "Microsoft LLDP Protocol Driver",
    "ComponentID": "ms_lldp",
    "Enabled"    : false,
    "Default"    : true
  }
]' | ConvertFrom-Json

#endregion LLDP

#=======================================
## link-layer topology discovery (LLTD)
#=======================================
#region LLTD

# gpo\ computer config > administrative tpl > network > link-layer topology discovery
#   turn off mapper I/O (LLTDIO) driver
#   turn off responder (RSPNDR) driver
# not configured: delete (default) | on: 1 | off: 0
$NetworkProtocolLltdGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\LLTD",
    "Entries" : [
      {
        "Name"  : "AllowLLTDIOOnDomain",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AllowLLTDIOOnPublicNet",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableLLTDIO",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ProhibitLLTDIOOnPrivateNet",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AllowRspndrOnDomain",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AllowRspndrOnPublicNet",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableRspndr",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ProhibitRspndrOnPrivateNet",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

$NetworkProtocolLltd = '[
  {
    "DisplayName": "Link-Layer Topology Discovery Mapper I/O Driver",
    "ComponentID": "ms_lltdio",
    "Enabled"    : false,
    "Default"    : true
  },
  {
    "DisplayName": "Link-Layer Topology Discovery Responder",
    "ComponentID": "ms_rspndr",
    "Enabled"    : false,
    "Default"    : true
  }
]' | ConvertFrom-Json

#endregion LLTD

#=======================================
## link local multicast name resolution (LLMNR)
#=======================================
#region LLMNR

# gpo\ computer config > administrative tpl > network > dns client
#   turn off multicast name resolution
# not configured: delete (default) | off: 0
$NetworkProtocolLlmnrGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\DNSClient",
    "Entries" : [
      {
        "Name"  : "EnableMulticast",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion LLMNR

#=======================================
## NetBIOS over TCP/IP
#=======================================
#region NetBIOS over TCP/IP

<#
Ports 137-139 should not be exposed to the internet.
Used by 'file and printer sharing' to contact computer using this old/legacy protocol.

Even if 'file and printer sharing' is disabled, these ports are still listening.
To close them, you need to disable NetBios over TCP/IP kernel driver service (NetBT).
See $NetBiosDriver in 'services & scheduled tasks > services > system driver'.
#>

<#
settings > network & internet > advanced network settings > Ethernet and/or Wi-FI
  more adapter options > edit > Internet Protocol Version 4 (TCP/IPv4) > properties
    general > advanced > WINS > disable NetBIOS over TCP/IP
#>

# disable NetBIOS over TCP/IP on all network adapters
#-------------------
# default: 0 (default) | on: 1 | off: 2
$NetBIOSProtocol = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\NetBT\\Parameters\\Interfaces\\Tcpip_*",
    "Entries" : [
      {
        "Name"  : "NetbiosOptions",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# block inbound ports UDP/137,138 and TCP/139
#-------------------
function Block-NetBiosFirewallPort137to139
{
    $Rules = @(
        @{
            DisplayName = 'Block Inbound Port 139 TCP (NetBiosTCPIP)'
            LocalPort   = '139'
            Protocol    = 'TCP'
        },
        @{
            DisplayName = 'Block Inbound Port 137, 138 UDP (NetBiosTCPIP)'
            LocalPort   = '137', '138'
            Protocol    = 'UDP'
        }
    )

    $GroupName = '!Custom block inbound port (NetBiosTCPIP)'
    Block-InboundFirewallPort -Rule $Rules -Group $GroupName
}

#endregion NetBIOS over TCP/IP

#=======================================
## network protocols
#=======================================
#region network protocols

# settings > network & internet > advanced network settings > Ethernet and/or Wi-FI:
#   more adapter options > edit

$NetworkProtocolBridgeDriver = '[
  {
    "DisplayName": "Bridge Driver",
    "ComponentID": "ms_l2bridge",
    "Enabled"    : false,
    "Default"    : true,
    "Comment"    : "create a bridge connection that combines two or more network adapters.
                    e.g. used by the Mobile Hotspot feature to share the internet connection."
  }
]' | ConvertFrom-Json

$NetworkProtocolQosPacketScheduler = '[
  {
    "DisplayName": "QoS Packet Scheduler",
    "ComponentID": "ms_pacer",
    "Enabled"    : false,
    "Default"    : true,
    "Comment"    : "somehow useless for (small) Home network ?"
  }
]' | ConvertFrom-Json

$NetworkProtocolsHyperVExtensibleVirtualSwitch = '[
  {
    "DisplayName": "Hyper-V Extensible Virtual Switch",
    "ComponentID": "vms_pp",
    "Enabled"    : false,
    "Default"    : false
  }
]' | ConvertFrom-Json

$NetworkProtocolsIPv4 = '[
  {
    "DisplayName": "Internet Protocol Version 4 (TCP/IPv4)",
    "ComponentID": "ms_tcpip",
    "Enabled"    : true,
    "Default"    : true
  }
]' | ConvertFrom-Json

$NetworkProtocolsMicrosoftNetworkAdapterMultiplexor = '[
  {
    "DisplayName": "Microsoft Network Adapter Multiplexor Protocol",
    "ComponentID": "ms_implat",
    "Enabled"    : false,
    "Default"    : false
  }
]' | ConvertFrom-Json

#endregion network protocols

#=======================================
## server message block (SMB)
#=======================================
#region SMB

# Port 445 should not be exposed to the internet.
# Used by 'file and printer sharing' (port is closed if the feature is disabled).
# Needed by Docker and Shared drives ?

$NetworkProtocolSMB = '[
  {
    "DisplayName": "Client for Microsoft Networks",
    "ComponentID": "ms_msclient",
    "Enabled"    : false,
    "Default"    : true,
    "Comment"    : "SMB client"
  },
  {
    "DisplayName": "File and Printer Sharing for Microsoft Networks",
    "ComponentID": "ms_server",
    "Enabled"    : false,
    "Default"    : true,
    "Comment"    : "SMB server"
  }
]' | ConvertFrom-Json

function Block-SMBFirewallPort445
{
    $Rules = @{
        DisplayName = 'Block Inbound Port 445 TCP (SMB)'
        LocalPort   = '445'
        Protocol    = 'TCP'
    }

    $GroupName = '!Custom block inbound port (SMB)'
    Block-InboundFirewallPort -Rule $Rules -Group $GroupName
}

#endregion SMB

#=======================================
## smart name resolution
#=======================================
#region smart name resolution

# gpo\ computer config > administrative tpl > network > dns client
#   turn off smart multi-homed name resolution
# not configured: delete (default) | off: 1
$SmartNameResolutionGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\DNSClient",
    "Entries" : [
      {
        "Name"  : "DisableSmartNameResolution",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion smart name resolution

#=======================================
## Web Proxy Auto-Discovery protocol (WPAD)
#=======================================
#region WPAD

# See also $ProxyAutoDetectSettings (settings > network & internet > proxy).

# If you disable WPAD, you have to manually configure all proxies.
#-------------------
# on: delete (default) | off: 1
$WPADProtocol = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\WinHttp",
    "Entries" : [
      {
        "Name"  : "DisableWpad",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion WPAD

#endregion network


#==============================================================================
#                                power options
#==============================================================================
#region power options

#=======================================
## fast startup
#=======================================
#region fast startup

# control panel (icons view) > power options > Choose What the power button do
# (control.exe /name Microsoft.PowerOptions /page pageGlobalSettings)
#-------------------
# on: 1 (default) | off: 0
$FastStartup = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Session Manager\\Power",
    "Entries" : [
      {
        "Name"  : "HiberbootEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion fast startup

#=======================================
## hibernate
#=======================================
#region hibernate

# control panel (icons view) > power options > Choose What the power button do
# (control.exe /name Microsoft.PowerOptions /page pageGlobalSettings)
#-------------------
# on: on (default) | off: off
function Set-Hibernate
{
    <#
    .SYNTAX
        Set-Hibernate [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-Hibernate -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Hibernate' to '$State' ..."
    powercfg.exe -Hibernate ($State -eq 'Enabled' ? 'on' : 'off')
}

function Enable-Hibernate
{
    Set-Hibernate -State 'Enabled'
}

# Fast startup will also get disabled.
function Disable-Hibernate
{
    Set-Hibernate -State 'Disabled'
}

#endregion hibernate

#=======================================
## turn off hard disk after idle time
#=======================================
#region hard disk timeout

function Set-HardDiskTimeout
{
    <#
    .SYNTAX
        Set-HardDiskTimeout [-PowerState] {AC | DC} [-Value] <int> [<CommonParameters>]

    .EXAMPLE
        PS> Set-HardDiskTimeout -PowerState 'AC' -Value 42
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet('AC', 'DC')]
        [string]
        $PowerState,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateRange('NonNegative')]
        [int]
        $Value
    )

    process
    {
        Write-Verbose -Message "Setting 'Hard Disk Timeout ($PowerState)' to '$Value min' ..."
        powercfg.exe -Change Disk-Timeout-$PowerState $Value
    }
}

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
# > change advanced power settings > hard disk > turn off hard disk after
#-------------------
# value are in minutes
# never: 0 | default: 10 20
$SystemPowerHardDiskTimeout = '[
  {
    "PowerState"  : "AC",
    "Value"       : "60"
  },
  {
    "PowerState"  : "DC",
    "Value"       : "10"
  }
]' | ConvertFrom-Json

function Set-SystemPowerHardDiskTimeout
{
    $SystemPowerHardDiskTimeout | Set-HardDiskTimeout
}

#endregion hard disk timeout

#=======================================
## network connectivity in Standby
#=======================================
#region standby connectivity

function Set-ModernStandbyNetworkConnectivity
{
    <#
    .SYNTAX
        Set-ModernStandbyNetworkConnectivity [-State] {Enabled | Disabled | ManagedByWindows} [<CommonParameters>]

    .EXAMPLE
        PS> Set-ModernStandbyNetworkConnectivity -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet('AC', 'DC')]
        [string]
        $PowerState,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet(
            'Enabled',
            'Disabled',
            'ManagedByWindows')]
        [string]
        $State
    )

    process
    {
        $Value = switch ($State)
        {
            'Enabled' { 1 }
            'Disabled' { 0 }
            'ManagedByWindows' { 2 }
        }

        Write-Verbose -Message "Setting 'Modern Standby Network Connectivity ($PowerState)' to '$State' ..."

        $SetValueIndex = $PowerState -eq 'AC' ? '-SetACValueIndex' : '-SetDCValueIndex'
        powercfg.exe $SetValueIndex SCHEME_CURRENT SUB_NONE CONNECTIVITYINSTANDBY $Value
    }
}

# control panel (icons view) > power options > change plan settings
# (control.exe /name Microsoft.PowerOptions /page pagePlanSettings)
# > change advanced power settings > balanced (current power plan) > network connectivity in Standby
#-------------------
# Enabled | Disabled | ManagedByWindows
$ModernStandbyNetworkConnectivity = '[
  {
    "PowerState"  : "AC",
    "State"       : "Enabled"
  },
  {
    "PowerState"  : "DC",
    "State"       : "ManagedByWindows"
  }
]' | ConvertFrom-Json

function Set-SystemPowerModernStandbyNetworkConnectivity
{
    $ModernStandbyNetworkConnectivity | Set-ModernStandbyNetworkConnectivity
}

#endregion standby connectivity

#endregion power options


#==============================================================================
#                              system properties
#==============================================================================
#region system properties

# settings > system > about > device specifications > related links (sysdm.cpl)

#=======================================
## hardware
#=======================================
#region hardware

# See also $DeviceInstallationDriversGPO and $WindowsUpdateDriversGPO (tweaks > drivers).

# device installation settings
#-------------------
# gpo\ computer config > administrative tpl > system > device installation
#   prevent device metadata retrieval from the Internet
# gpo\ not configured: delete (default) | off: 1
# user\ on: 0 (default) | off: 1
$HardwareAutoDownloadManufacturersApps = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Device Metadata",
    "Entries" : [
      {
        "Name"  : "PreventDeviceMetadataFromNetwork",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Device Metadata",
    "Entries" : [
      {
        "Name"  : "PreventDeviceMetadataFromNetwork",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion hardware

#=======================================
## advanced
#=======================================
#region advanced

#===================
### performance > visual effects
#===================
#region visual effects

# visual effects
#-------------------
# let windows choose what's best for my computer: 0 (default)
# adjust for best appearance: 1 | adjust for best performance: 2 | custom: 3
$VisualEffectsMode = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\VisualEffects",
    "Entries" : [
      {
        "Name"  : "VisualFXSetting",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# visual effects custom
#-------------------
function Set-SystemPropertiesVisualEffects
{
    <#
    .SYNTAX
        Set-SystemPropertiesVisualEffects [-InputObject] <VisualEffectsProperties> [<CommonParameters>]

    .EXAMPLE
        PS> $VisualEffectsProperties = '[
              {
                "Name"    : "Show shadows under mouse pointer",
                "State"   : "Enabled",
                "ByteNum" : 1,
                "Bitmask" : 32
              },
              {
                "Name"    : "Show shadows under windows",
                "State"   : "Disabled",
                "ByteNum" : 2,
                "Bitmask" : 4
              }
            ]' | ConvertFrom-Json
        PS> $VisualEffectsProperties | Set-SystemPropertiesVisualEffects

    .NOTES
        [Convert]::ToInt32('10011110', 2)       -> 158
        [Convert]::ToString('158', 2)           -> 10011110
        [Convert]::ToHexString('158')           -> 9E
        [Convert]::ToString('158', 16)          -> 9e
        [Convert]::ToDecimal([UInt32]'0x9e')    -> 158
        [Convert]::ToString([UInt32]'0x9e', 10) -> 158

        UserPreferencesMask Binary value
        1001???0 00?1??10 00000?11 10000100 000100?0 00000000 00000000 00000000
            |||    | ||        |                  |
            ABC    D EF        G                  H

        A: Smooth-scroll list boxes
        B: Slide open combo boxes
        C: Fade or slide menus into view
        D: Show shadows under mouse pointer
        E: Fade or slide ToolTips into view
        F: Fade out menu items after clicking
        G: Show shadows under windows
        H: Animate controls and elements inside windows
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [VisualEffectsProperties]
        $InputObject
    )

    begin
    {
        class VisualEffectsProperties
        {
            [string] $Name
            [string] $State
            [int] $ByteNum
            [int] $Bitmask
        }

        $SystemPropertiesVisualEffects = '[
          {
            "Hive"    : "HKEY_CURRENT_USER",
            "Path"    : "Control Panel\\Desktop",
            "Entries" : [
              {
                "Name"  : "UserPreferencesMask",
                "Value" : "",
                "Type"  : "Binary"
              }
            ]
          }
        ]' | ConvertFrom-Json

        $VisualEffectsPath = 'Registry::HKEY_CURRENT_USER\Control Panel\Desktop'
        $VisualEffectsByteValue = (Get-ItemProperty -Path $VisualEffectsPath).UserPreferencesMask
    }

    process
    {
        Write-Verbose -Message "Setting Visual Effect '$($InputObject.Name)' to '$($InputObject.State)' ..."

        $VisualEffectsByteValue[$InputObject.ByteNum] = switch ($InputObject.State)
        {
            'Enabled'  { $VisualEffectsByteValue[$InputObject.ByteNum] -bor $InputObject.Bitmask }
            'Disabled' { $VisualEffectsByteValue[$InputObject.ByteNum] -band -bnot $InputObject.Bitmask }
        }
    }

    end
    {
        $SystemPropertiesVisualEffects.Entries[0].Value = $VisualEffectsByteValue
        Set-RegistryEntry -InputObject $SystemPropertiesVisualEffects
    }
}

# on: Enabled | off: Disabled
$VisualEffectsCustomPart1 = '[
  {
    "Name"    : "Smooth-scroll list boxes",
    "State"   : "Enabled",
    "ByteNum" : 0,
    "Bitmask" : 8
  },
  {
    "Name"    : "Slide open combo boxes",
    "State"   : "Enabled",
    "ByteNum" : 0,
    "Bitmask" : 4
  },
  {
    "Name"    : "Fade or slide menus into view",
    "State"   : "Enabled",
    "ByteNum" : 0,
    "Bitmask" : 2
  },
  {
    "Name"    : "Show shadows under mouse pointer",
    "State"   : "Enabled",
    "ByteNum" : 1,
    "Bitmask" : 32
  },
  {
    "Name"    : "Fade or slide ToolTips into view",
    "State"   : "Enabled",
    "ByteNum" : 1,
    "Bitmask" : 8
  },
  {
    "Name"    : "Fade out menu items after clicking",
    "State"   : "Enabled",
    "ByteNum" : 1,
    "Bitmask" : 4
  },
  {
    "Name"    : "Show shadows under windows",
    "State"   : "Enabled",
    "ByteNum" : 2,
    "Bitmask" : 4
  },
  {
    "Name"    : "Animate controls and elements inside windows",
    "State"   : "Enabled",
    "ByteNum" : 4,
    "Bitmask" : 2
  }
]' | ConvertFrom-Json

# Animate windows when minimizing and maximizing
# Enable Peek
# Save taskbar thumbnail previews
# Animations in the taskbar
# Show thumbnails instead of icons (on: 0)
# Show translucent selection rectangle
# Use drop shadows for icon labels on the desktop
# Show window contents while dragging
# Smooth edges of screen fonts (on: 2)
#
# if not specified above\ on: 1 | off: 0
$VisualEffectsCustomPart2 = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop\\WindowMetrics",
    "Entries" : [
      {
        "Name"  : "MinAnimate",
        "Value" : "1",
        "Type"  : "String"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\DWM",
    "Entries" : [
      {
        "Name"  : "EnableAeroPeek",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AlwaysHibernateThumbnails",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarAnimations",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "IconsOnly",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ListviewAlphaSelect",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ListviewShadow",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "DragFullWindows",
        "Value" : "1",
        "Type"  : "String"
      },
      {
        "Name"  : "FontSmoothing",
        "Value" : "2",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion visual effects

#===================
### performance > virtual memory
#===================
#region virtual memory

# automatically manage paging file size for all drives
#-------------------
# default: on
function Set-AllDrivesAutoManagedPagingFile
{
    <#
    .SYNTAX
        Set-AllDrivesAutoManagedPagingFile [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-AllDrivesAutoManagedPagingFile -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'All Drives AutoManaged Paging File' to '$State'"

    $ComputerSystem = Get-CimInstance -ClassName 'Win32_ComputerSystem' -Verbose:$false
    $ComputerSystem.AutomaticManagedPagefile = $State -eq 'Enabled' ? $true : $false
    Set-CimInstance -InputObject $ComputerSystem -Verbose:$false
}

function Enable-AllDrivesAutoManagedPagingFile
{
    Set-AllDrivesAutoManagedPagingFile -State 'Enabled'
}

function Disable-AllDrivesAutoManagedPagingFile
{
    Set-AllDrivesAutoManagedPagingFile -State 'Disabled'
}

# custom paging file size
#-------------------
# Depends on how much RAM you have:
#   32GB+: 512/512 for safeguard and (very) old programs that needs pagefile.
#   16GB: 2048/2048 should be enought, safeguard in case you eat up all ram.
#   8GB-: 4096/4096 should be enought, adjust to your needs.

function Set-DrivePagingFile
{
    <#
    .SYNTAX
        Set-DrivePagingFile [-Drive] <string[]> [-InitialSize] <int> [-MaximumSize] <int> [<CommonParameters>]

        Set-DrivePagingFile [-Drive] <string[]> -SystemManaged [<CommonParameters>]

        Set-DrivePagingFile [-Drive] <string[]> -NoPagingFile [<CommonParameters>]

    .EXAMPLE
        PS> Set-DrivePagingFile -Drive "$env:SystemDrive" -InitialSize 512 -MaximumSize 2048

    .EXAMPLE
        PS> Set-DrivePagingFile -Drive 'X:', 'Y:' -NoPagingFile
    #>

    [CmdletBinding(DefaultParameterSetName = 'CustomSize')]
    param
    (
        [Parameter(
            Mandatory,
            Position = 0)]
        [ValidatePattern(
            "[A-Za-z]:\\?",
            ErrorMessage = 'The drive syntax is not valid. Syntax is <DriveLetter>: or <DriveLetter>:\')]
        [string[]]
        $Drive,

        [Parameter(
            ParameterSetName = 'CustomSize',
            Mandatory,
            Position = 1)]
        [ValidateRange('NonNegative')]
        [int]
        $InitialSize,

        [Parameter(
            ParameterSetName = 'CustomSize',
            Mandatory,
            Position = 2)]
        [ValidateScript(
           { $_ -ge $InitialSize },
            ErrorMessage = 'MaximumSize must be greater than or equal to InitialSize.')]
        [int]
        $MaximumSize,

        [Parameter(
            ParameterSetName = 'SystemManaged',
            Mandatory)]
        [switch]
        $SystemManaged,

        [Parameter(
            ParameterSetName = 'NoPagingFile',
            Mandatory)]
        [switch]
        $NoPagingFile
    )

    if ($SystemManaged)
    {
        $InitialSize = $MaximumSize = 0
    }

    foreach ($DriveLetter in $Drive)
    {
        $DriveLetter = $DriveLetter.Replace('\', '')

        $PagingFileProperties = @{
            ClassName = 'Win32_PageFileSetting'
            Filter    = "Name like '$DriveLetter%'"
        }
        $PagingFileSetting = Get-CimInstance @PagingFileProperties -Verbose:$false

        $State = switch ($PSCmdlet.ParameterSetName)
        {
            'CustomSize'    { "$InitialSize / $MaximumSize" }
            'SystemManaged' { 'SystemManaged' }
            'NoPagingFile'  { 'Disabled' }
        }

        Write-Verbose -Message "Setting 'Paging File for Drive $DriveLetter' to '$State'"

        if ($NoPagingFile)
        {
            Remove-CimInstance -InputObject $PagingFileSetting -Verbose:$false
        }
        else
        {
            if (-not $PagingFileSetting)
            {
                $NewPagingFileProperties = @{
                    ClassName = 'Win32_PageFileSetting'
                    Property  = @{ Name = "$DriveLetter\pagefile.sys" }
                }
                $PagingFileSetting = New-CimInstance @NewPagingFileProperties -Verbose:$false
            }
            $PagingFileSetting.InitialSize = $InitialSize
            $PagingFileSetting.MaximumSize = $MaximumSize
            Set-CimInstance -InputObject $PagingFileSetting -Verbose:$false
        }
    }
}

#endregion virtual memory

#===================
### performance > data execution prevention
#===================
#region data execution prevention

# turn on DEP for essential Windows programs and services only: OptIn (default)
# turn on DEP for all programs and services except those I select: OptOut
function Set-DataExecutionPrevention
{
    <#
    .SYNTAX
        Set-DataExecutionPrevention [-State] {OptIn | OptOut} [<CommonParameters>]

    .EXAMPLE
        PS> Set-DataExecutionPrevention -State 'OptOut'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('OptIn', 'OptOut')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Data Execution Prevention' to '$State'"
    bcdedit.exe -Set '{current}' nx $State | Out-Null
}

#endregion data execution prevention

#===================
### startup and recovery
#===================
#region startup and recovery

# system failure > automatically restart
#-------------------
# on: 1 (default) | off: 0
$SystemFailureAutoRestart = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\CrashControl",
    "Entries" : [
      {
        "Name"  : "AutoReboot",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# write debugging information
#-------------------
# None: 0
# Complete: 1 (need at least <YOUR_RAM> MB paging file)
# Kernel: 2 (need at least 800 MB paging file)
# Small: 3 (need at least 256 KB paging file)
# Automatic: 7 (need at least 800 MB paging file)
$SystemFailureWriteDebugInfo = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\CrashControl",
    "Entries" : [
      {
        "Name"  : "CrashDumpEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion startup and recovery

#===================
### environment variables
#===================
#region environment variables

function Disable-PowerShellTelemetry
{
    Write-Verbose -Message 'Disabling PowerShell Telemetry ...'
    [Environment]::SetEnvironmentVariable('POWERSHELL_TELEMETRY_OPTOUT', 'true', 'Machine')
}

function Disable-DotNetTelemetry
{
    Write-Verbose -Message 'Disabling DotNet Telemetry ...'
    [Environment]::SetEnvironmentVariable('DOTNET_CLI_TELEMETRY_OPTOUT', 'true', 'Machine')
}

#endregion environment variables

#endregion advanced

#=======================================
## system protection
#=======================================
#region system protection

# protection settings
#-------------------
# system drive (e.g. 'C:\')
# default: on
function Enable-SystemDriveRestore
{
    Write-Verbose -Message 'Enabling SystemDrive Restore ...'
    Enable-ComputerRestore -Drive "$env:SystemDrive"
}

function Disable-SystemDriveRestore
{
    Write-Verbose -Message 'Disabling SystemDrive Restore ...'
    Disable-ComputerRestore -Drive "$env:SystemDrive"
}

# turn off for all drives
# gpo\ computer config > administrative tpl > system > system restore
#   turn off configuration
#   turn off system restore
# gpo\ not configured: delete (default) | off: 1
# user\ off: delete {09F7EDC5-294E-4180-AF6A-FB0E6A0E9513} + RPSessionInterval: 0
$SystemProtection = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\SystemRestore",
    "Entries" : [
      {
        "Name"  : "DisableConfig",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableSR",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SPP\\Clients",
    "Entries" : [
      {
        "RemoveEntry" : true,
        "Name"  : "{09F7EDC5-294E-4180-AF6A-FB0E6A0E9513}",
        "Value" : "",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\SystemRestore",
    "Entries" : [
      {
        "Name"  : "RPSessionInterval",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion system protection

#=======================================
## remote
#=======================================
#region remote

#===================
### remote assistance
#===================
# allow remote assistance connections to this computer
# allow this computer to be controlled remotely
#-------------------
# gpo\ computer config > administrative tpl > system > remote assistance
#   configure solicited remote assistance
# gpo\ not configured: delete (default) | off: 0
# user\ on: 1 (default) | off: 0
$RemoteAssistance = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services",
    "Entries" : [
      {
        "Name"  : "fAllowToGetHelp",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "fAllowFullControl",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Remote Assistance",
    "Entries" : [
      {
        "Name"  : "fAllowToGetHelp",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "fAllowFullControl",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# offer remote assistance (msra.exe)
#-------------------
# gpo\ computer config > administrative tpl > system > remote assistance
#   configure offer remote assistance
# gpo\ not configured: delete (default) | off: 0
$RemoteAssistanceOfferGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services",
    "Entries" : [
      {
        "Name"  : "fAllowUnsolicited",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### remote desktop
#===================
# See $RemoteDesktop (windows settings app > system > remote desktop).

#endregion remote

#endregion system properties


#==============================================================================
#                                  telemetry
#==============================================================================
#region telemetry

#=======================================
## app and device inventory
#=======================================
#region app and device inventory

# Windows 11 24H2+ only.
# Application compatibility related.

# gpo\ computer config > administrative tpl > windows components > app and device inventory
#   turn off API sampling
#   turn off application footprint
#   turn off compatibility scan for backed up applications
#   turn off install tracing
# not configured: delete (default) | off: 1
$AppAndDeviceInventoryGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\AppCompat",
    "Entries" : [
      {
        "Name"  : "DisableAPISamping",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableApplicationFootprint",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableWin32AppBackup",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableInstallTracing",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion app and device inventory

#=======================================
## application compatibility
#=======================================
#region application compatibility

# gpo\ computer config > administrative tpl > windows components > application compatibility
#   turn off application compatibility engine
#   turn off application telemetry
#   turn off inventory collector
#   turn off program compatibility assistant
#   turn off switchback compatibility engine
# not configured: delete (default) | off: 1 0 1 1 0
$ApplicationCompatibilityGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\AppCompat",
    "Entries" : [
      {
        "Name"  : "DisableEngine",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AITEnable",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableInventory",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisablePCA",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SbEnable",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion application compatibility

#=======================================
## cloud content experience
#=======================================
#region cloud content experience

# gpo\ computer config > administrative tpl > windows components > cloud content
#   turn off cloud optimized content
#   turn off cloud consumer account state content
#   turn off microsoft consumer experiences (only applies to Enterprise and Education SKUs)
#     (also disable 'settings > bluetooth & devices > mobile devices')
# not configured: delete (default) | off: 1
$CloudContentExperienceGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableCloudOptimizedContent",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableConsumerAccountStateContent",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "RemoveEntry" : true,
        "Name"  : "DisableWindowsConsumerFeatures",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion cloud content experience

#=======================================
## customer experience improvement program
#=======================================
#region CEIP

# gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
#   turn off Windows customer experience improvement program
#
# gpo\ computer config > administrative tpl > system > appv > ceip
#   Microsoft customer experience improvement program (CEIP)
#
# not configured: delete (default) | off: 0
$CustomerExperienceImprovementGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\SQMClient\\Windows",
    "Entries" : [
      {
        "Name"  : "CEIPEnable",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\AppV\\CEIP",
    "Entries" : [
      {
        "Name"  : "CEIPEnable",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion CEIP

#=======================================
## diagnostic auto-logger (system boot log)
#=======================================
#region diagnostic auto-logger

# all apps > windows tools > performance monitor > data collector sets > startup events trace sessions (perfmon.msc)

# on: 1 (default) | off: 0
$DiagnosticsAutoLogger = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\WMI\\Autologger\\DiagTrack-Listener",
    "Entries" : [
      {
        "Name"  : "Start",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion diagnostic auto-logger

#=======================================
## diagnostic tracing
#=======================================
#region diagnostic tracing

# Since this is the only protected key whose default value is undesirable, I guess it's okay to change it manually.

<#
Open 'regedit'.
Right-click on the key and select 'Permissions'.
On the Permissions window, select 'Advanced'.
Click on 'Change' to change the owner.
Type 'Administrators' in the 'Enter the object name and select' field and press OK.
Double-click on 'Administrators' from the list of Permission Entries.
Select the checkbox besides 'Full Control' under Basic permissions and press OK.

Modify the registry entry 'DisableDiagnosticTracing' to '1'.

Restore permissions to 'TrustedInstaller':
  remove 'Full Control' from 'Administrators'.
  change the owner to 'TrustedInstaller' (use 'NT SERVICE\TrustedInstaller' for the object name).
#>

<#
# owner: TrustedInstaller | full control: TrustedInstaller
# Requested registry access is not allowed.
# on: 0 (default) | off: 1
$DiagnosticTracing = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Diagnostics\\Performance",
    "Entries" : [
      {
        "Name"  : "DisableDiagnosticTracing",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json
#>

#endregion diagnostic tracing

#=======================================
## diagnostic log collection
#=======================================
#region diagnostic log collection

# Data are not sent if 'send optional diagnostic data' is disabled.
# This setting prevent the creation of the log files.

# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   limit diagnostic log collection
# not configured: delete (default) | off: 1
$DiagnosticLogCollectionGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "LimitDiagnosticLogCollection",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion diagnostic log collection

#=======================================
## dump collection
#=======================================
#region dump collection

# Data are not sent if 'send optional diagnostic data' is disabled.
# This setting prevent the creation of the log files.

# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   limit dump collection
# not configured: delete (default) | off: 1
$DumpCollectionGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "LimitDumpCollection",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion dump collection

#=======================================
## error reporting
#=======================================
#region error reporting

# gpo\ computer config > administrative tpl > windows components > Windows error reporting
#   automatically send memory dumps for OS-generated error reports
#   disable Windows error reporting
#   do not send additional data
#
# gpo\ computer config > administrative tpl > system > device installation (windows 10 only ?)
#   do not send a Windows error report when a generic driver is installed on a device
#   prevent Windows from sending an error report when a device driver requests
#     additional software during installation
#
# gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
#   turn off Windows error reporting
#
# not configured: delete (default) | off: 0 1 1 1 1 0
$ErrorReportingGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Error Reporting",
    "Entries" : [
      {
        "Name"  : "AutoApproveOSDumps",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "Disabled",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DontSendAdditionalData",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DeviceInstall\\Settings",
    "Entries" : [
      {
        "Name"  : "DisableSendGenericDriverNotFoundToWER",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableSendRequestAdditionalSoftwareToWER",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\PCHealth\\ErrorReporting",
    "Entries" : [
      {
        "Name"  : "DoReport",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion error reporting

#=======================================
## group policy settings logging
#=======================================
#region gpo settings logging

# gpo\ computer config > administrative tpl > system > group policy
#   turn off resultant set of policy logging
# not configured: delete (default) | off: 0
$GroupPolicySettingsLoggingGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "RSoPLogging",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion gpo settings logging

#=======================================
## handwriting
#=======================================
#region handwriting

# Not present in Windows 11 Group Policy. Only applies to Windows 10 ? probably not.

# gpo\ computer config > administrative tpl > system > internet communication management > internet communication settings
#   turn off handwriting personalization data sharing
#   turn off handwriting recognition error reporting
# not configured: delete (default) | off: 1
$HandwritingTelemetryGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\TabletPC",
    "Entries" : [
      {
        "Name"  : "PreventHandwritingDataSharing",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\HandwritingErrorReports",
    "Entries" : [
      {
        "Name"  : "PreventHandwritingErrorReports",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion handwriting

#=======================================
## license telemetry (KMS)
#=======================================
#region license telemetry

# gpo\ computer config > administrative tpl > windows components > software protection platform
#   turn off KMS client online AVS validation
# not configured: delete (default) | off: 1
$LicenseTelemetryGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\CurrentVersion\\Software Protection Platform",
    "Entries" : [
      {
        "Name"  : "NoGenTicket",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion license telemetry

#=======================================
## nvidia
#=======================================
#region nvidia

function Grant-AdminsFullControlFileSystemAccess
{
    <#
    .SYNTAX
        Grant-AdminsFullControlFileSystemAccess [-Path] <string> [-RemoveAccess] [<CommonParameters>]

    .EXAMPLE
        PS> Grant-AdminsFullControlFileSystemAccess -Path 'C:\FooBar\' -RemoveAccess
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Path,

        [switch]
        $RemoveAccess
    )

    $IdentityReferenceData = @{
        TypeName     = 'System.Security.Principal.SecurityIdentifier'
        ArgumentList = 'S-1-5-32-544' # 'BUILTIN\Administrators'
    }
    $AdminIdentityReference = New-Object @IdentityReferenceData
    $SystemAccessProperties = @(
        $AdminIdentityReference
        'FullControl'
        'Allow'
    )
    $SystemAccessRuleData = @{
        TypeName     = 'System.Security.AccessControl.FileSystemAccessRule'
        ArgumentList = $SystemAccessProperties
    }
    $SystemAccessRule = New-Object @SystemAccessRuleData

    $Acl = Get-Acl -Path $Path
    if ($RemoveAccess)
    {
        $Acl.RemoveAccessRule($SystemAccessRule) | Out-Null
    }
    else
    {
        $Acl.SetAccessRule($SystemAccessRule) | Out-Null
    }
    Set-Acl -Path $Path -AclObject $Acl | Out-Null
}

function Disable-NvidiaGameSessionTelemetry
{
    Write-Verbose -Message 'Disabling Nvidia GameSession Telemetry ...'

    $DriverStorePath = "$env:SystemDrive\Windows\System32\DriverStore\"
    $NvidiaDisplayPath = "$DriverStorePath\FileRepository\nvdmsi.inf_amd64_*\Display.NvContainer\"
    $NvidiaPluginsSessionPath = "$NvidiaDisplayPath\plugins\Session\"
    $GameSessionTelemetryPluginName = "_NvGSTPlugin.dll"
    $GSTPluginFile = "$NvidiaPluginsSessionPath\$GameSessionTelemetryPluginName"

    if (Test-Path -Path $GSTPluginFile)
    {
        Grant-AdminsFullControlFileSystemAccess -Path $NvidiaPluginsSessionPath
        Grant-AdminsFullControlFileSystemAccess -Path $GSTPluginFile
        Rename-Item -Path $GSTPluginFile -NewName "$GameSessionTelemetryPluginName.bak"
    }
    else
    {
        Write-Verbose -Message '    Nvidia GameSession Telemetry Plugin file not found.'
    }
}

# 'OptInOrOutPreference' and 'EnableRIDXXXXX' no longer needed (outdated) ?
$NvidiaTelemetry = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\nvlddmkm\\Global\\Startup\\SendTelemetryData",
    "Entries" : [
      {
        "Name"  : "(Default)",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\nvlddmkm\\Global\\Startup\\SendNonNvDisplayDetails",
    "Entries" : [
      {
        "Name"  : "(Default)",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\NVIDIA Corporation\\NvControlPanel2\\Client",
    "Entries" : [
      {
        "Name"  : "OptInOrOutPreference",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\NVIDIA Corporation\\Global\\FTS",
    "Entries" : [
      {
        "Name"  : "EnableRID44231",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableRID64640",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableRID66610",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion nvidia

#endregion telemetry

#endregion tweaks


#=================================================================================================================
#                                                  applications
#=================================================================================================================
#region applications

#==============================================================================
#                                installation
#==============================================================================
#region installation

#=======================================
## new apps
#=======================================
#region new apps

function Install-Application
{
    <#
    .SYNTAX
        Install-Application [-Name] <string> [[-Scope] {Machine | User}] [<CommonParameters>]

    .EXAMPLE
        PS> Install-Application -Name 'VideoLAN.VLC' -Scope 'Machine'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name,

        [ValidateSet('Machine', 'User')]
        [string]
        $Scope
    )

    process
    {
        Write-Verbose -Message "Installing $Name ..."

        $InstallOptions = @(
            '--exact'
            '--accept-source-agreements'
            '--accept-package-agreements'
            '--silent'
            '--disable-interactivity'
            '--source=winget'
        )

        if ($Scope)
        {
            $InstallOptions += "--scope=$Scope"
        }
        winget.exe install --id $Name @InstallOptions
    }
}

function Remove-ApplicationDesktopShortcut
{
    $AppsShortcutsNames = @(
        'VLC media player'
        'Bitwarden'
        'Adobe Acrobat'
        'SumatraPDF'
        'Brave'
        'Firefox'
    )
    Remove-Item -Path $AppsShortcutsNames.ForEach({ "$env:PUBLIC\Desktop\$_.lnk" }) -ErrorAction 'SilentlyContinue'
}

# Development
#-------------------
$Git            = 'Git.Git'
$VSCode         = 'Microsoft.VisualStudioCode'

# Multimedia
#-------------------
$VLC            = 'VideoLAN.VLC'

# Password Manager
#-------------------
$Bitwarden      = 'Bitwarden.Bitwarden'
$KeePassXC      = 'KeePassXCTeam.KeePassXC'

# PDF Viewer
#-------------------
$AcrobatReader  = 'Adobe.Acrobat.Reader.64-bit'
$SumatraPDF     = 'SumatraPDF.SumatraPDF'

# Utilities
#-------------------
$7zip           = '7zip.7zip'
$qBittorrent    = 'qBittorrent.qBittorrent'

# Web Browser
#-------------------
$Brave          = 'Brave.Brave'
$Firefox        = 'Mozilla.Firefox'
$MullvadBrowser = 'MullvadVPN.MullvadBrowser'

# Microsoft Visual C++ Redistributable
#-------------------
${VisualCppRedist2015+} = @(
    'Microsoft.VCRedist.2015+.x64'
    'Microsoft.VCRedist.2015+.x86'
)
$VisualCppRedist2013 = @(
    'Microsoft.VCRedist.2013.x64'
    'Microsoft.VCRedist.2013.x86'
)
$VisualCppRedist2012 = @(
    'Microsoft.VCRedist.2012.x64'
    'Microsoft.VCRedist.2012.x86'
)
$VisualCppRedist2010 = @(
    'Microsoft.VCRedist.2010.x64'
    'Microsoft.VCRedist.2010.x86'
)
$VisualCppRedist2008 = @(
    'Microsoft.VCRedist.2008.x64'
    'Microsoft.VCRedist.2008.x86'
)
$VisualCppRedist2005 = @(
    'Microsoft.VCRedist.2005.x64'
    'Microsoft.VCRedist.2005.x86'
)

#endregion new apps

#=======================================
## Windows Subsystem For Linux
#=======================================
#region WSL

function Install-WindowsSubsystemForLinux
{
    <#
    .SYNTAX
        Install-WindowsSubsystemForLinux [[-Distribution] <string>] [<CommonParameters>]

    .DESCRIPTION
        Install WSL and the default Ubuntu distribution of Linux.
        You can also use the '-Distribution' parameter to change the installed Linux distribution.

    .EXAMPLE
        PS> Install-WindowsSubsystemForLinux

    .EXAMPLE
        PS> Install-WindowsSubsystemForLinux -Distribution 'Debian'

    .NOTES
        Run 'wsl.exe --list --online' to see a list of available distros.
    #>

    [CmdletBinding()]
    param
    (
        [string]
        $Distribution
    )

    Write-Verbose -Message 'Installing Windows Subsystem For Linux ...'

    if ($Distribution)
    {
        wsl.exe --install --no-launch --distribution $Distribution
    }
    else
    {
        wsl.exe --install --no-launch
    }
}

#endregion WSL

#endregion installation


#==============================================================================
#                         appx & provisioned packages
#==============================================================================
#region appx & provisioned packages

#=======================================
## bing search in start menu
#=======================================
#region bing search in start menu

# Only one of these two registry entries is necessary to disable the web search.

# gpo\ user config > administrative tpl > windows components > file explorer
#   turn off display of recent search entries in the File Explorer search box
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$BingSearchStartMenuGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "DisableSearchBoxSuggestions",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Search",
    "Entries" : [
      {
        "Name"  : "BingSearchEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion bing search in start menu

#=======================================
## copilot
#=======================================
#region copilot

# gpo\ user config > administrative tpl > windows components > windows copilot​
#   turn off Windows Copilot
# not configured: delete (default) | off: 1
$CopilotGPO = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\WindowsCopilot",
    "Entries" : [
      {
        "Name"  : "TurnOffWindowsCopilot",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion copilot

#=======================================
## cortana | old
#=======================================
#region cortana

# gpo\ computer config > administrative tpl > windows components > search
#   allow cortana
#   allow cortana above lock screen
# not configured: delete (default) | off: 0
$CortanaGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search",
    "Entries" : [
      {
        "Name"  : "AllowCortana",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AllowCortanaAboveLock",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion cortana

#=======================================
## microsoft edge
#=======================================
#region microsoft edge

function Get-ApplicationInfo
{
    <#
    .SYNTAX
        Get-ApplicationInfo [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Get-ApplicationInfo -Name '*vlc*'
        DisplayName     : VLC media player
        UninstallString : "C:\Program Files\VideoLAN\VLC\uninstall.exe"
        InstallLocation : C:\Program Files\VideoLAN\VLC
        DisplayIcon     : C:\Program Files\VideoLAN\VLC\vlc.exe
        DisplayVersion  : X.X.X
        [...]

    .EXAMPLE
        PS> Get-ApplicationInfo -Name '*update*'
        DisplayName     : Microsoft Update Health Tools
        [...]
        InstallLocation :
        InstallSource   : C:\Windows\TEMP\0EE55CA6-4890-4284-9919-D63B07C40F74\
        ModifyPath      : MsiExec.exe /X{C6FD611E-7EFE-488C-A0E0-974C09EF6473}
        [...]
        UninstallString : MsiExec.exe /X{C6FD611E-7EFE-488C-A0E0-974C09EF6473}
        [...]

        DisplayName    : Microsoft Edge Update
        DisplayVersion : X.X.X.X
        Version        : X.X.X.X
        NoRemove       : 1
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    $RegistryUninstallPath = @(
        'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Uninstall'
        'Registry::HKEY_CURRENT_USER\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
        'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall'
        'Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall'
    )
    $LoggedUserSID = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
    $RegistryUninstallPath = $RegistryUninstallPath -ireplace 'HKEY_CURRENT_USER', "HKEY_USERS\$LoggedUserSID"

    $AppInfo = $RegistryUninstallPath |
        Get-ChildItem -ErrorAction 'SilentlyContinue' |
        Get-ItemProperty |
        Where-Object -Property 'DisplayName' -Like -Value $Name |
        Select-Object -Property '*' -Exclude 'PS*'
    $AppInfo
}

function Remove-MicrosoftEdge
{
    $MicrosoftEdgeInfo = Get-ApplicationInfo -Name 'Microsoft Edge'
    if (-not $MicrosoftEdgeInfo)
    {
        Write-Verbose -Message 'Microsoft Edge is not installed'
        return
    }

    Write-Verbose -Message 'Removing Microsoft Edge ...'

    Stop-Process -Name '*edge*' -Force -ErrorAction 'SilentlyContinue'

    # Get the 'RegionPolicy' config file content.
    $RegionPolicyFilePath = "$env:SystemRoot\System32\IntegratedServicesRegionPolicySet.json"
    $RegionPolicy = Get-Content -Raw -Path $RegionPolicyFilePath | ConvertFrom-Json -AsHashtable

    # Enable edge uninstallation in 'IntegratedServicesRegionPolicySet.json'.
    # The 'guid' correspond to 'Edge is uninstallable'.
    $IsRegionPolicyFileChanged = $false
    $RegionPolicy.policies |
        Where-Object -Property 'guid' -EQ -Value '{1bca278a-5d11-4acf-ad2f-f9ab6d7f93a6}' |
        ForEach-Object -Process {
            if ($_.defaultState -eq 'disabled')
            {
                $_.defaultState = 'enabled'
                $IsRegionPolicyFileChanged = $true
            }
        }

    if ($IsRegionPolicyFileChanged)
    {
        # Save the original file permissions.
        $OriginalRegionPolicyAcl = Get-Acl -Path $RegionPolicyFilePath

        # Backup the original file.
        Grant-AdminsFullControlFileSystemAccess -Path $RegionPolicyFilePath
        $RegionPolicyFileName = (Get-Item -Path $RegionPolicyFilePath).Name
        Rename-Item -Path $RegionPolicyFilePath -NewName "$RegionPolicyFileName.bak"

        # Write the modified file
        $RegionPolicy | ConvertTo-Json -Depth 42 | Out-File -FilePath $RegionPolicyFilePath

        # Set the original file permissions to the modified file.
        Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
    }

    # Uninstall Microsoft Edge.
    Remove-Package -Name 'Microsoft.MicrosoftEdge.Stable'
    $EdgeUninstallCmd = "& $($MicrosoftEdgeInfo.UninstallString) --force-uninstall".Replace('"', '\"')
    Start-Process -Wait -NoNewWindow -FilePath 'pwsh.exe' -ArgumentList "-Command Invoke-Expression '$EdgeUninstallCmd'"

    if ($IsRegionPolicyFileChanged)
    {
        # Remove the modified file.
        Grant-AdminsFullControlFileSystemAccess -Path $RegionPolicyFilePath
        Remove-Item -Path $RegionPolicyFilePath

        # Restore the original file.
        Rename-Item -Path "$RegionPolicyFilePath.bak" -NewName $RegionPolicyFileName
        Set-Acl -Path $RegionPolicyFilePath -AclObject $OriginalRegionPolicyAcl
    }
}

#endregion microsoft edge

#=======================================
## microsoft store push to install
#=======================================
#region microsoft store push to install

# gpo\ computer config > administrative tpl > windows components > push to install
#   turn off push to install service
# not configured: delete (default) | off: 1
$MicrosoftStorePushToInstallGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\PushToInstall",
    "Entries" : [
      {
        "Name"  : "DisablePushToInstall",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion microsoft store push to install

#=======================================
## microsoft windows malicious software removal tool
#=======================================
#region MSRT

# Use $MicrosoftWindowsMsrtWindowsUpdateGPO to prevent reinstall.

function Remove-MSRT
{
    if (Get-Command -Name 'mrt.exe' -ErrorAction 'SilentlyContinue')
    {
        Write-Verbose -Message 'Removing Microsoft Windows Malicious Software Removal Tool (MSRT) ...'
        wusa.exe /uninstall /kb:890830 /quiet /norestart
    }
    else
    {
        Write-Verbose -Message 'Microsoft Windows Malicious Software Removal Tool (MSRT) is not installed'
    }
}

# install with windows update
#-------------------
# not configured: delete (default) | off: 1
$MicrosoftWindowsMsrtWindowsUpdateGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\MRT",
    "Entries" : [
      {
        "Name"  : "DontOfferThroughWUAU",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# heartbeat report (telemetry)
#-------------------
# not configured: delete (default) | off: 1
$MicrosoftWindowsMsrtHeartbeatReportGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\MRT",
    "Entries" : [
      {
        "Name"  : "DontReportInfectionInformation",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion MSRT

#=======================================
## onedrive
#=======================================
#region onedrive

function Remove-OneDrive
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

function Remove-OneDriveAutoInstallationForNewUser
{
    Write-Verbose -Message 'Removing OneDrive Auto-Installation for new user ...'

    $OneDriveSetup = '[
      {
        "Hive"    : "HKEY_USERS",
        "Path"    : "TMPDEFAULT\\Software\\Microsoft\\Windows\\CurrentVersion\\Run",
        "Entries" : [
          {
            "RemoveEntry" : true,
            "Name"  : "OneDriveSetup",
            "Value" : "C:\\Windows\\System32\\OneDriveSetup.exe /thfirstsetup",
            "Type"  : "String"
          }
        ]
      }
    ]' | ConvertFrom-Json

    reg.exe LOAD 'HKEY_USERS\TMPDEFAULT' "$env:SystemDrive\Users\Default\NTUSER.DAT" | Out-Null
    Set-RegistryEntry -InputObject $OneDriveSetup -Verbose:$false
    reg.exe UNLOAD 'HKEY_USERS\TMPDEFAULT' | Out-Null
}

#endregion onedrive

#=======================================
## widgets
#=======================================
#region widgets

# Should not be needed if you have uninstalled widgets.
# Disable it anyway in case widgets reinstall itself.

# gpo\ computer config > administrative tpl > windows components> widgets
#   allow widgets
# not configured: delete (default) | off: 0
$WidgetsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Dsh",
    "Entries" : [
      {
        "Name"  : "AllowNewsAndInterests",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion widgets

#=======================================
## default apps
#=======================================
#region default apps

function Export-DefaultAppxPackagesNames
{
    $LogFilePath = "$PSScriptRoot\windows_appx_packages_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Default Appx Packages Names ...'

        $DefaultAppxPackages = "# AppxPackage`n "
        $DefaultAppxPackages += ((Get-AppxPackage -AllUsers).Name).foreach{ "$_`n" }
        $DefaultAppxPackages += "`n# ProvisionedAppxPackage`n "
        $DefaultAppxPackages += ((Get-ProvisionedAppxPackage -Online).DisplayName).foreach{ "$_`n" }

        $DefaultAppxPackages | Out-File -FilePath $LogFilePath
    }
}

function Remove-Package
{
    <#
    .SYNTAX
        Remove-Package [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Remove-Package -Name 'Microsoft.WindowsAlarms'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name
    )

    begin
    {
        # "-PackageTypeFilter 'All'" also retrieves Provisionned packages
        $AllAppxPackages = Get-AppxPackage -AllUsers -PackageTypeFilter 'All' -Verbose:$false
    }

    process
    {
        $AppxPackagesName = ($AllAppxPackages | Where-Object -Property 'Name' -EQ -Value $Name).PackageFullName

        if ($AppxPackagesName)
        {
            Write-Verbose -Message "Removing $Name ..."

            # The progress bar of Remove-AppxPackage mess up the terminal rendering.
            # Use a PowerShell child process as workaround.
            powershell.exe -args $AppxPackagesName -NoProfile -Command {
                $args | Remove-AppxPackage -ErrorAction 'SilentlyContinue'
                $args | Remove-AppxPackage -AllUsers -ErrorAction 'SilentlyContinue'
            }
        }
        else
        {
            Write-Verbose -Message "$Name is not installed"
        }
    }
}

$BingSearch         = 'Microsoft.BingSearch'
$Calculator         = 'Microsoft.WindowsCalculator'
$Camera             = 'Microsoft.WindowsCamera'
$Clipchamp          = 'Clipchamp.Clipchamp'
$Clock              = 'Microsoft.WindowsAlarms'
$Compatibility      = 'Microsoft.ApplicationCompatibilityEnhancements'
$Cortana            = 'Microsoft.549981C3F5F10'
$CrossDevice        = 'MicrosoftWindows.CrossDevice'
$DevHome            = 'Microsoft.Windows.DevHome'
$Extensions         = @(
                      'Microsoft.HEIFImageExtension'
                      'Microsoft.HEVCVideoExtension'
                      'Microsoft.RawImageExtension'
                      'Microsoft.VP9VideoExtensions'
                      'Microsoft.WebMediaExtensions'
                      'Microsoft.WebpImageExtension'
                    )
$Family             = 'MicrosoftCorporationII.MicrosoftFamily'
$FeedbackHub        = 'Microsoft.WindowsFeedbackHub'
$GetHelp            = 'Microsoft.GetHelp'
$Journal            = 'Microsoft.MicrosoftJournal'
$MailAndCalendar    = 'microsoft.windowscommunicationsapps'
$Maps               = 'Microsoft.WindowsMaps'
$MediaPlayer        = 'Microsoft.ZuneMusic'
$Microsoft365       = 'Microsoft.MicrosoftOfficeHub'
$MicrosoftCopilot   = @(
                      'Microsoft.Copilot'
                      'Microsoft.Windows.Ai.Copilot.Provider'
                      'Microsoft.Windows.Copilot'
                      'MicrosoftWindows.Client.CoPilot'
                    )
$MicrosoftStore     = @(
                      'Microsoft.Services.Store.Engagement'
                      'Microsoft.StorePurchaseApp'
                      'Microsoft.WindowsStore'
                    )
$MicrosoftTeams     = @(
                      'MicrosoftTeams' # old
                      'MSTeams'
                    )
$MoviesAndTV        = 'Microsoft.ZuneVideo'
$News               = 'Microsoft.BingNews'
$Notepad            = 'Microsoft.WindowsNotepad'
$Outlook            = 'Microsoft.OutlookForWindows'
$Paint              = 'Microsoft.Paint'
$People             = 'Microsoft.People'
$PhoneLink          = 'Microsoft.YourPhone'
$Photos             = 'Microsoft.Windows.Photos'
$PowerAutomate      = 'Microsoft.PowerAutomateDesktop'
$QuickAssist        = 'MicrosoftCorporationII.QuickAssist'
$SnippingTool       = 'Microsoft.ScreenSketch'
$Solitaire          = 'Microsoft.MicrosoftSolitaireCollection'
$SoundRecorder      = 'Microsoft.WindowsSoundRecorder'
$StickyNotes        = 'Microsoft.MicrosoftStickyNotes'
$Terminal           = 'Microsoft.WindowsTerminal'
$Tips               = 'Microsoft.Getstarted'
$Todo               = 'Microsoft.Todos'
$Weather            = 'Microsoft.BingWeather'
$Whiteboard         = 'Microsoft.Whiteboard'
$Widgets            = @(
                      'MicrosoftWindows.Client.WebExperience'
                      'Microsoft.WidgetsPlatformRuntime'
                    )
$Xbox               = @( # might be required for some games
                      'Microsoft.GamingApp'
                      'Microsoft.XboxApp' # old
                      'Microsoft.Xbox.TCUI'
                      'Microsoft.XboxGameOverlay'
                      'Microsoft.XboxGamingOverlay'
                      'Microsoft.XboxIdentityProvider'
                      'Microsoft.XboxSpeechToTextOverlay'
                    )

# Windows 10 only
$3DViewer           = 'Microsoft.Microsoft3DViewer'
$MixedRealityPortal = 'Microsoft.MixedReality.Portal'
$OneNote            = 'Microsoft.Office.OneNote'
$Paint3D            = 'Microsoft.MSPaint'
$Skype              = 'Microsoft.SkypeApp'
$Wallet             = 'Microsoft.Wallet'

#endregion default apps

#=======================================
## promoted/sponsored apps (bloatware)
#=======================================
#region promoted

# Windows 11 only (there is probably a similar registry key for Windows 10).
# Remove unwanted pinned shortcuts from the Start Menu (e.g. Disney+, Netflix, TikTok, ...).
# It does only remove the quick installer shorcuts that actually install the app if we click on it.
#   i.e. It will not remove an already installed app (e.g. manufacturer apps).
function Remove-StartMenuPromotedApps
{
    Write-Verbose -Message 'Removing Start Menu Promoted Apps (e.g. Spotify, LinkedIn) ...'

    $StartMenuPromotedApps = '[
      {
        "RemoveKey" : true,
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CloudStore\\Store\\Cache\\DefaultAccount\\$de${*}$$windows.data.placeholdertilecollection",
        "Entries" : []
      }
    ]' | ConvertFrom-Json

    Set-RegistryEntry -InputObject $StartMenuPromotedApps -Verbose:$false
    Stop-Process -Name 'StartMenuExperienceHost'
    Start-Sleep -Seconds 2
}

# Windows 11 only.
# Customization of the Start Menu layout works only for new user that haven't log yet - not even once.
# You can use an 'unattend.xml' file to customize the Start Menu layout for the first user.
function Set-NewUserDefaultStartMenuLayout
{
    Write-Verbose -Message 'Setting Default Start Menu Layout for New User ...'

    # Adjust according to your preferences.
    $StartMenuLayout = '{
        "pinnedList": [
            { "packagedAppId":"Microsoft.WindowsStore_8wekyb3d8bbwe!App" },
            { "packagedAppId":"Microsoft.Windows.Photos_8wekyb3d8bbwe!App" },
            { "packagedAppId":"Microsoft.WindowsCalculator_8wekyb3d8bbwe!App" },
            { "packagedAppId":"Microsoft.WindowsNotepad_8wekyb3d8bbwe!App" },
            { "packagedAppId":"Microsoft.Paint_8wekyb3d8bbwe!App" },
            { "packagedAppId":"Microsoft.ScreenSketch_8wekyb3d8bbwe!App" }
        ]
    }'.Replace('"', '\"') -replace '\s+'

    $DefaultStartMenuLayout = '[
      {
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Microsoft\\PolicyManager\\current\\device\\Start",
        "Entries" : [
          {
            "Name"  : "ConfigureStartPins",
            "Value" : "$StartMenuLayout",
            "Type"  : "String"
          }
        ]
      }
    ]'.Replace('$StartMenuLayout', $StartMenuLayout) | ConvertFrom-Json

    Set-RegistryEntry -InputObject $DefaultStartMenuLayout -Verbose:$false
}

#endregion promoted

#endregion appx & provisioned packages

#endregion applications


#=================================================================================================================
#                                             applications settings
#=================================================================================================================
#region applications settings

#==============================================================================
#                            adobe acrobat reader
#==============================================================================
#region adobe acrobat reader

#=======================================
## preferences
#=======================================
#region preferences

#===================
### documents
#===================
# remember current state of Tools Pane
#-------------------
# on: 1 | off: 0 (default)
$AdobeAcrobatDocumentsRememberToolsPaneState = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\AVGeneral",
    "Entries" : [
      {
        "Name"  : "bRHPSticky",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# saved state of Tools Pane
#-------------------
# If bRHPSticky is enabled, it reads the state from this entry.
# on: 4 (default) | off: 3
$AdobeAcrobatDocumentsSavedToolsPaneState = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\AVGeneral",
    "Entries" : [
      {
        "Name"  : "iAV2ViewerAllToolsState",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### general
#===================
# show online storage when openings files
#-------------------
# on: 0 | off: 1 (default)
$AdobeAcrobatGeneralOnlineStorageOpenFiles = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\AVGeneral",
    "Entries" : [
      {
        "Name"  : "bToggleCustomOpenExperience",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show online storage when saving files
#-------------------
# on: 0 (default) | off: 1
$AdobeAcrobatGeneralOnlineStorageSaveFiles = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\AVGeneral",
    "Entries" : [
      {
        "Name"  : "bToggleCustomSaveExperience",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show me messages when I launch Adobe Acrobat
#-------------------
# on: 1 (default) | off: 0
$AdobeAcrobatGeneralShowMessagesAtLaunch = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\IPM",
    "Entries" : [
      {
        "Name"  : "bShowMsgAtLaunch",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# send crash reports
#-------------------
# ask every time: 0 (default) | always: 1 | never: 2
$AdobeAcrobatGeneralCrashReports = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\SendCrashReports",
    "Entries" : [
      {
        "Name"  : "iSendCrashReportsOption",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### javascript
#===================
# enable Acrobat Javascript
#-------------------
# on: 1 (default) | off: 0
$AdobeAcrobatJavascript = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\JSPrefs",
    "Entries" : [
      {
        "Name"  : "bEnableJS",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### security (enhanced)
#===================
# protected mode at startup
#-------------------
# on: 1 (default) | off: 0
$AdobeAcrobatSecurityProtectedMode = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\Privileged",
    "Entries" : [
      {
        "Name"  : "bProtectedMode",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# run in AppContainer
#-------------------
# on: 1 (default) | off: 0
$AdobeAcrobatSecurityProtectedModeAppContainer = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\Privileged",
    "Entries" : [
      {
        "Name"  : "bEnableProtectedModeAppContainer",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# protected view
#-------------------
# off: 0 (default) | files from potentially unsafe locations: 1 | all files: 2
$AdobeAcrobatSecurityProtectedView = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\TrustManager",
    "Entries" : [
      {
        "Name"  : "iProtectedView",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# enhanced security
#-------------------
# on: 1 or delete (default) | off: 0
$AdobeAcrobatSecurityEnhancedSecurity = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\TrustManager",
    "Entries" : [
      {
        "Name"  : "bEnhancedSecurityInBrowser",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bEnhancedSecurityStandalone",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatically trust documents with valid certification
#-------------------
# on: 1 | off: 0 or delete (default)
$AdobeAcrobatSecurityTrustCertifiedDocuments = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\TrustManager",
    "Entries" : [
      {
        "Name"  : "bTrustCertifiedDocuments",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatically trust sites from my Win OS security zones
#-------------------
# on: 1 (default) | off: 0
$AdobeAcrobatSecurityTrustOSTrustedSites = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\TrustManager",
    "Entries" : [
      {
        "Name"  : "bTrustOSTrustedSites",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### trust manager
#===================
# allow opening of non-PDF file attachments with external applications
#-------------------
# on: 1 or delete (default) | off: 0
$AdobeAcrobatTrustManagerPdfFileAttachmentsExternalApps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\Originals",
    "Entries" : [
      {
        "Name"  : "bAllowOpenFile",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# allow opening of non-PDF file attachments
#-------------------
# If off, disable and grayed out 'allow opening of non-PDF file attachments with external applications'.
# on: 0 or delete (default) | off: 1
$AdobeAcrobatTrustManagerPdfFileAttachments = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\Originals",
    "Entries" : [
      {
        "Name"  : "bSecureOpenFile",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### units
#===================
# page units
#-------------------
# centimeters: 3 | inches: 1 | millimeters: 2 | points: 0 | picas: 4
$AdobeAcrobatPageUnits = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\Originals",
    "Entries" : [
      {
        "Name"  : "iPageUnits",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion preferences

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

# home page: collapse recommended tools for you
#-------------------
# expand: 0 (default) | collapse: 1
$AdobeAcrobatMiscHomePageTopBanner = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\HomeWelcomeFirstMile",
    "Entries" : [
      {
        "Name"  : "bFirstMileMinimized",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# first launch introduction and UI tutorial overlay
#-------------------
# gpo\ on: 0 or delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$AdobeAcrobatMiscFirstLaunchIntro = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown",
    "Entries" : [
      {
        "Name"  : "bToggleFTE",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bWhatsNewExp",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\AVGeneral",
    "Entries" : [
      {
        "Name"  : "bisFirstLaunch",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bappFirstLaunchForNotifications",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\FTEDialog",
    "Entries" : [
      {
        "Name"  : "bIsAcrobatUpdateAvailableToShowWhatsNew",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bShowInstallFTE",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bShownHomeOnboarding",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bShownViewerOnboarding",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# upsell (offers to buy extra tools)
#-------------------
# gpo\ on: 0 or delete (default) | off: 1
# user\ on: 1 or delete (default) | off: 0
$AdobeAcrobatMiscUpsell = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown",
    "Entries" : [
      {
        "Name"  : "bAcroSuppressUpsell",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Adobe\\Adobe Acrobat\\DC\\ArmUpsell",
    "Entries" : [
      {
        "Name"  : "bIsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# usage statistics
#-------------------
# Doesn't work for Acrobat DC ?
# on: 1 or delete (default) | off: 0
$AdobeAcrobatMiscUsageStatistics = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown",
    "Entries" : [
      {
        "Name"  : "bUsageMeasurement",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# online services and features
#-------------------
# bUpdater\ on: 1 or delete (default) | off: 0
# bToggleXXXXX\ on: 0 or delete (default) | off: 1
# bAdobeSendPluginToggle\ on: 0 or delete | off: 1 (default)
$AdobeAcrobatMiscOnlineServices = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown\\cServices",
    "Entries" : [
      {
        "Name"  : "bUpdater",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bToggleAdobeDocumentServices",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bToggleAdobeSign",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bTogglePrefSync",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "bToggleWebConnectors",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown\\cServices",
    "Entries" : [
      {
        "Name"  : "bAdobeSendPluginToggle",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# Adobe cloud
#-------------------
# on: 0 or delete (default) | off: 1
$AdobeAcrobatMiscAdobeCloud = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown\\cCloud",
    "Entries" : [
      {
        "Name"  : "bDisableADCFileStore",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# SharePoint
#-------------------
# on: 0 or delete (default) | off: 1
$AdobeAcrobatMiscSharePoint = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown\\cSharePoint",
    "Entries" : [
      {
        "Name"  : "bDisableSharePointFeatures",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# Webmail
#-------------------
# on: 0 or delete (default) | off: 1
$AdobeAcrobatMiscWebmail = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Adobe\\Adobe Acrobat\\DC\\FeatureLockDown\\cWebmailProfiles",
    "Entries" : [
      {
        "Name"  : "bDisableWebmail",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion miscellaneous

#endregion adobe acrobat reader


#==============================================================================
#                                brave browser
#==============================================================================
#region brave browser

#=======================================
## configuration
#=======================================
#region brave configuration

function Merge-Hashtable
{
    <#
    .SYNTAX
        Merge-Hashtable [-Hashtable] <hashtable> [-Data] <hashtable> [-OverrideValue] [<CommonParameters>]

    .EXAMPLE
        PS> $foo = '{
                "data": {
                    "name": "answer"
                }
            }' | ConvertFrom-Json -AsHashtable
        PS> $bar = '{
                "data": {
                    "value": 42
                }
            }' | ConvertFrom-Json -AsHashtable
        PS> Merge-Hashtable -Hashtable $foo -Data $bar
        PS> $foo | ConvertTo-Json
        {
          "data": {
            "name": "answer",
            "value": 42
          }
        }
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable]
        $Hashtable,

        [Parameter(Mandatory)]
        [hashtable]
        $Data,

        [switch]
        $OverrideValue
    )

    foreach ($Key in $Data.Keys)
    {
        if ($Hashtable.$Key -is [hashtable] -and $Data.$Key -is [hashtable])
        {
            Merge-Hashtable -Hashtable $Hashtable.$Key -Data $Data.$Key -OverrideValue:$OverrideValue
        }
        else
        {
            $Hashtable.$Key = $OverrideValue ? $Data.$Key : $Hashtable.$Key + $Data.$Key
        }
    }
}

function New-BraveConfigData
{
    $BraveLocalState = @{}
    $BravePreferences = @{}

    [regex]$MatchComment = '(?m) #.*$'

    #------------------------------------
    ## brave://flags
    #------------------------------------
    Merge-Hashtable $BraveLocalState ('{
        "browser": {
            "enabled_labs_experiments": [
                "enable-force-dark@1", # web content night mode
                "enable-gpu-rasterization@1",
                "enable-parallel-downloading@1"
            ]
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Get started
    #------------------------------------
    ### New Tab Page
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "brave_search": {
                "ntp-search_prompt_enable_suggestions": false,
                "show-ntp-search": false # search widgets
            },
            "new_tab_page": {
                "hide_all_widgets": true, # cards
                "show_background_image": true,
                "show_branded_background_image": false,
                "show_brave_news": false,
                "show_clock": false,
                "show_stats": false,
                "shows_options": 0 # new tab page: dashboard
            }
        },
        "ntp": {
            "shortcust_visible": false, # top sites
            "use_most_visited_tiles": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Appearance
    #------------------------------------
    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "dark_mode": 0 # same as Windows
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Toolbar
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "bookmark_bar": {
            "show_on_all_tabs": true
        },
        "brave": {
            "always_show_bookmark_bar_on_ntp": false, # ignored if show_on_all_tabs is true
            "show_bookmarks_button": true,
            "today": {
                "should_show_toolbar_button": false # brave news button
            },
            "rewards": {
                "inline_tip_buttons_enabled": false,
                "show_brave_rewards_button_in_location_bar": false
            },
            "wallet": {
                "show_wallet_icon_on_toolbar": false
            },
            "show_side_panel_button": false,
            "brave_vpn": {
                "show_button": false
            },
            "location_bar_is_wide": false,
            "autocomplete_enabled": true,
            "omnibox": {
                "prevent_url_elisions": false, # show full URL
                "bookmark_suggestions_enabled": true,
                "commander_suggestions_enabled": true, # quick commands
                "history_suggestions_enabled": true
            },
            "top_site_suggestions_enabled": false,
            "ai_chat": {
                "autocomplete_provider_enabled": false, # Leo in address bar
                "show_toolbar_button": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Tabs
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "tabs": {
                "vertical_tabs_enabled": false,
                "mute_indicator_not_clickable": false,
                "hover_mode": 1, # card
                "shared_pinned_tab": false
            },
            "tabs_search_show": true
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    Merge-Hashtable $BraveLocalState ('{
        "browser": {
            "hovercard": {
                "memory_usage_enabled": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Sidebar
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "sidebar": {
                "sidebar_show_option": 3 # never
            }
        },
        "side_panel": {
            "is_right_aligned": true
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Content
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "mru_cycling_enabled": false, # cycle most recently tabs
            "wayback_machine_enabled": false,
            "speedreader": {
                "enabled": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Shields
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "shields": {
                "stats_badge_visible": false # number on icon
            },
            "no_script_default": false
        },
        "profile": {
            "content_settings": {
                "exceptions": {
                    "fingerprintingV2": {
                        "*,*": {
                            "setting": 3 # enabled
                        }
                    },
                    "cosmeticFiltering": { # tackers & ads
                        "*,*": {
                            "setting": 2 # agressive
                        },
                        "*,https://firstparty": {
                            "setting": 2 # agressive (for standard, change only this one to 1)
                        }
                    },
                    "shieldsAds": { # tackers & ads
                        "*,*": {
                            "setting": 2 # agressive
                        }
                    },
                    "trackers": { # tackers & ads
                        "*,*": {
                            "setting": 2 # agressive
                        }
                    }
                }
            },
            # works in pair with: default_content_setting_values > cookies
            "cookie_controls_mode": 1, # block third-party
            "default_content_setting_values": {
                "brave_remember_1p_storage": 2, # forget when close site
                "httpsUpgrades": 2 # strict
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Content Filtering
    #---------------
    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "ad_block": {
                "cookie_list_opt_in_shown": true,
                "list_subscriptions": {
                    "https://secure.fanboy.co.nz/fanboy-antifacebook.txt": {
                        "enabled": true, # Fanboy Anti-Facebook
                        "last_successful_update_attempt": "1",
                        "last_update_attempt": "1"
                    },
                    "https://secure.fanboy.co.nz/fanboy-antifonts.txt": {
                        "enabled": true, # Fanboy Anti-thirdparty Fonts
                        "last_successful_update_attempt": "1",
                        "last_update_attempt": "1"
                    }
                },
                "regional_filters": {
                    "AC023D22-AE88-4060-A978-4FEEEC4221693": {
                        "enabled": false # EasyList Cookie (included in Fanboy Annoyances)
                    },
                    "67E792D4-AE03-4D1A-9EDE-80E01C81F9B8": {
                        "enabled": true # Fanboy Annoyances + uBO Annoyances
                    },
                    "7911A1CB-304E-4CDB-ABB3-E2A94A37E4DD": {
                        "enabled": false # Fanboy Social (included in Fanboy Annoyances)
                    },
                    "690FF3B4-8B6B-4709-8505-FEC6643D7BD9": {
                        "enabled": false # Fanboy Anti-Newsletter (included in Fanboy Annoyances)
                    },
                    "2F3DCE16-A19A-493C-A88F-2E110FBD37D6": {
                        "enabled": false # Fanboy Mobile Notifications (included in Fanboy Annoyances)
                    },
                    "1ED1870B-997C-4BFE-AEBC-B67D679BAF3B": {
                        "enabled": true # Fanboy Anti-chat Apps
                    },
                    "BD308B90-D3BB-4041-9114-22E096B0BA77": {
                        "enabled": false # YouTube Mobile Distractions
                    },
                    "2D57ADED-3531-419A-9DED-7F8868BC1561": {
                        "enabled": false # YouTube Mobile Recommendations
                    },
                    "9E8EC586-4E17-4E5E-99D7-35172C4CEA74": {
                        "enabled": false # YouTube Anti-Shorts
                    },
                    "78672887-A098-4D2C-B0CB-A3DEC4834DA7": {
                        "enabled": false # Bypass Paywalls Clean Filters
                    },
                    "E2FA7D98-0BD5-493E-8AF4-950604ADE9CB": {
                        "enabled": true # AdGuard URL Tracking Protection
                    },
                    "F61D6B7B-4110-4EA4-9C81-38FB4CE90AEC": {
                        "enabled": false # Blocklists Anti-Porn
                    },
                    "529A3F3B-7EBA-4351-B986-D176A82E7F5A": {
                        "enabled": false # Brave Twitch Adblock Rules
                    },
                    "564C3B75-8731-404C-AD7C-5683258BA0B0": {
                        "enabled": false # Brave Experimental Adblock Rules
                    }
                }
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Social media blocking
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "google_login_default": false, # old
            "fb_embed_default": false,
            "twitter_embed_default": false,
            "linkedin_embed_default": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Privacy and security
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "webrtc": {
            "ip_handling_policy": "disable_non_proxied_udp"
        },
        "brave": {
            "gcm": { # google for push messaging
                "channel_status": false
            },
            "de_amp": {
                "enabled": true # auto-redirect AMP
            },
            "debounce": {
                "enabled": true # auto redirect tracking urls
            },
            "reduce_language": true # prevent fingerprinting
        },
        "enable_do_not_track": false
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Clear Browsing data
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "browser": {
            "clear_data": {
                "browsing_history_on_exit": true,
                "cache_on_exit": false,
                "cookies_on_exit": true,
                "download_history_on_exit": true,
                "form_data_on_exit": true,
                "hosted_apps_data_on_exit": true,
                "passwords_on_exit": true,
                "site_settings_on_exit": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Security
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "safebrowsing": {
            "enabled": true
        },
        "https_only_mode_enabled": true # old
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    Merge-Hashtable $BraveLocalState ('{
        "dns_over_https": {
            "mode": "automatic", # use "secure" for custom template
            "templates": "" # choose a DNS if you didnt change it system-wide
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Site and Shields Settings
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "profile": {
            "default_content_setting_values": { # enabled: 1 | disabled: 2
                "ar": 2, # augmented reality
                "auto_picture_in_picture": 2,
                "automatic_downloads": 1,
                "autoplay": 1,
                "brave_ethereum": 2,
                "brave_google_sign_in": 2,
                "brave_solana": 2,
                "captured_surface_control": 2, # scrolling & zooming
                "clipboard": 2,
                "cookies": 4, # on-device site data: delete data when close (if 2: block all cookies)
                "file_system_write_guard": 2, # file editing
                "geolocation": 2,
                "hid_guard": 2, # HID devices
                "images": 1,
                "javascript_jit": 2, # v8 optimizer
                "local_fonts": 2, # fonts
                "media_stream_camera": 2,
                "media_stream_mic": 2,
                "midi_sysex": 2, # MIDI device control & reprogram
                "notifications": 2,
                "payment_handler": 2,
                "popups": 2, # pop-ups and redirects
                "protected_media_identifier": 2, # protected content IDs
                "sensors": 2, # motion sensors
                "serial_guard": 2, # serial devices (no GUI toggle anymore ?)
                "sound": 1,
                "usb_guard": 2, # USB devices
                "vr": 2, # virtual reality
                "window_placement": 2 # window management
            }
        },
        "custom_handlers": {
            "enabled": false # protocol handlers
        },
        "plugins": {
            "always_open_pdf_externally": false # download pdf
        },
        "webkit": {
            "webprefs": {
                "encrypted_media_enabled": false # protected content
            }
        },
        "safety_hub": {
            "unused_site_permissions_revocation": {
                "enabled": true
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Tor windows
    #---------------
    Merge-Hashtable $BraveLocalState ('{
        "tor": {
            "tor_disabled": true
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Data collection
    #---------------
    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "p3a": {
                "enabled": false # product analytics
            },
            "stats": {
                "reporting_enabled": false # daily ping
            }
        },
        "user_experience_metrics": {
            "reporting_enabled": false # diagnostic reports
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Web3
    #------------------------------------
    ### Wallet
    #---------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "wallet": {
                "default_solana_wallet": 1, # no fallback
                "default_wallet2": 1, # eth: no fallback
                "nft_discovery_enabled": false,
                "private_windows_enabled": false,
                "auto_pin_enabled": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    ### Web3 domains
    #---------------
    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "ens": {
                "resolve_method": 1 # disabled
            },
            "sns": {
                "resolve_method": 1 # disabled
            },
            "unstoppable_domains": {
                "resolve_method": 1 # disabled
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Leo
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "sidebar": {
                "sidebar_items": [
                    {
                        "built_in_item_type": 7 # show Leo icon
                    }
                ]
            },
            "ai_chat": {
                "auto_generate_questions": false, # suggested prompts
                "context_menu_enabled": false,
                "user_dismissed_premium_prompt": true
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Search engine
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "search": {
            "suggest_enabled": false # improve search
        },
        "brave": {
            "other_search_engines_enabled": false,
            "web_discovery_enabled": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Extensions
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "webtorrent_enabled": false
        },
        "signin": {
            "allowed": false # google login
        },
        "media_router": {
            "enable_media_router": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "widevine_opted_in": false # needed for some online stream content
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Autofill and passwords
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "autofill": {
            "credit_card_enabled": false, # save payment
            "payment_methods_mandatory_reauth": false,
            "profile_enabled": false # addresses
        },
        "credentials_enable_autosignin": false,
        "credentials_enable_service": false, # save password
        "payments": {
            "can_make_payment_enabled": false # allow sites to check
        },
        "brave": {
            "autofill_private_windows": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Languages
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "translate": {
            "enabled": false # still possible with right click
        },
        "browser": {
            "enable_spellchecking": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Downloads
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "download": {
            "prompt_for_download": true
        },
        "download_bubble": {
            "partial_view_enabled": true # show when done
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## System
    #------------------------------------
    Merge-Hashtable $BraveLocalState ('{
        "background_mode": {
            "enabled": false
        },
        "hardware_acceleration_mode": {
            "enabled": true
        },
        "performance_tuning": {
            "battery_saver_mode": {
                "state": 0 # energy saver
            },
            "high_efficiency_mode": {
                "state": 0 # memory saver
            }
        },
        "brave": {
            "brave_vpn": {
                "wireguard_enabled": false
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    Merge-Hashtable $BravePreferences ('{
        "brave": {
            "enable_closing_last_tab": true,
            "enable_window_closing_confirm": true,
            "show_fullscreen_reminder": false
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    #------------------------------------
    ## Miscellaneous
    #------------------------------------
    Merge-Hashtable $BravePreferences ('{
        "browser": {
            "has_seen_welcome_page": true
        },
        "brave": {
            "shields": {
                "advanced_view_enabled": true
            },
            "sidebar": {
                "hidden_built_in_items": [
                    1, # Brave Talk
                    2, # Brave Wallet
                    3, # Bookmarks
                    4  # Reading List
                ],
                "side_panel_width": 500
            }
        },
        "tab_search": {
            "recently_closed_expanded": true
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)

    Merge-Hashtable $BraveLocalState ('{
        "brave": {
            "dont_ask_for_crash_reporting": true,
            "onboarding": {
                "last_shields_icon_highlighted_time": "1" # disable Shields onboarding highlight
            }
        }
    }' -replace $MatchComment | ConvertFrom-Json -AsHashtable)


    $BraveLocalState
    $BravePreferences
}

function Get-BravePathInfo
{
    $LoggedUserLocalAppData = (Get-LoggedUserEnvVariable).LOCALAPPDATA
    $BraveAppDataPath = "$LoggedUserLocalAppData\BraveSoftware\Brave-Browser\"
    $BravePathInfo = @{
        LocalAppData   = $BraveAppDataPath
        UserData       = "$BraveAppDataPath\User Data\"
        PersistentData = "$BraveAppDataPath\User Data Persistent\"
        Profile        = "$BraveAppDataPath\User Data\Default\"
    }
    $BravePathInfo
}

function Set-BraveSettings
{
    Write-Verbose -Message 'Setting Brave Settings ...'

    $BraveLocalState, $BravePreferences = New-BraveConfigData
    $BraveUserDataPath = (Get-BravePathInfo).UserData
    $BraveProfilePath = (Get-BravePathInfo).Profile

    if (-not (Test-Path -Path $BraveProfilePath))
    {
        New-Item -ItemType 'Directory' -Path $BraveProfilePath -Force | Out-Null
    }

    # Remove welcome splash screen on first launch.
    New-Item -ItemType 'File' -Path "$BraveUserDataPath\First Run" -ErrorAction 'SilentlyContinue' | Out-Null

    $BraveLocalState | ConvertTo-Json -Depth 42 | Out-File -FilePath "$BraveUserDataPath\Local State"
    $BravePreferences | ConvertTo-Json -Depth 42 | Out-File -FilePath "$BraveProfilePath\Preferences"
}

#endregion brave configuration

#=======================================
## default browser
#=======================================
#region default browser

function Set-ForegroundWindow
{
    <#
    .SYNTAX
        Set-ForegroundWindow -ProcessName <string> [<CommonParameters>]

        Set-ForegroundWindow -MainWindowHandle <IntPtr> [<CommonParameters>]

    .EXAMPLE
        PS> Set-ForegroundWindow -ProcessName 'Notepad'

    .NOTES
        Doesn't seem to work very well for the Windows settings app.
        It gets the focus, but it is not always brought to the foreground.

        Works as expected for other applications.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            ParameterSetName = 'ProcessName',
            Mandatory)]
        [string]
        $ProcessName,

        [Parameter(
            ParameterSetName = 'MainWindowHandle',
            Mandatory)]
        [IntPtr]
        $MainWindowHandle
    )

    $Signature = @"
        [DllImport("user32.dll")]
        public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool SetForegroundWindow(IntPtr hWnd);
"@

    $WindowFunctionsType = @{
        Namespace        = 'Win32Functions'
        Name             = 'WindowManagement'
        MemberDefinition = $Signature
    }
    $WindowFunctions = Add-Type @WindowFunctionsType -PassThru -Verbose:$false
    $MainWindowHandleProcess =
        $ProcessName ? (Get-Process -Name $ProcessName).MainWindowHandle : $MainWindowHandle

    $SW_SHOWDEFAULT = 10
    $WindowFunctions::ShowWindowAsync($MainWindowHandleProcess, $SW_SHOWDEFAULT) | Out-Null
    Start-Sleep -Seconds 0.5
    $WindowFunctions::SetForegroundWindow($MainWindowHandleProcess) | Out-Null
    Start-Sleep -Seconds 0.5
}

function Open-SystemSettings
{
    <#
    .SYNTAX
        Open-SystemSettings [[-SettingPage] <string>] [<CommonParameters>]

    .EXAMPLE
        PS> Open-SystemSettings -SettingPage 'defaultapps'
    #>

    [CmdletBinding()]
    param
    (
        [string]
        $SettingPage = ''
    )

    Stop-Process -Name 'SystemSettings' -ErrorAction 'SilentlyContinue'
    Start-Process -FilePath "ms-settings:$SettingPage"
    $SystemSettingsProcess = Get-Process -Name 'SystemSettings'
    $SystemSettingsMainWindowHandle = $SystemSettingsProcess.MainWindowHandle

    # when launched, 'MainWindowHandle' get a number.
    # when ready (and not minimized), 'MainWindowHandle' change to 0.
    # when minimized, 'MainWindowHandle' will get back its number.
    # when not minimized, 'MainWindowHandle' will get back to 0.
    while ([int]$SystemSettingsProcess.MainWindowHandle)
    {
        Start-Sleep -Seconds 0.5
        $SystemSettingsProcess.Refresh()
    }

    Set-ForegroundWindow -MainWindowHandle $SystemSettingsMainWindowHandle
}

function Send-KeyboardKeys
{
    <#
    .SYNTAX
        Send-KeyboardKeys [-Keys] <string> [[-SleepDelay] <double>] [<CommonParameters>]

    .EXAMPLE
        PS> Send-KeyboardKeys -Keys '{TAB 3}{ENTER}'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Keys,

        [double]
        $SleepDelay = 0.5
     )

    Add-Type -AssemblyName 'System.Windows.Forms' -Verbose:$false
    [Windows.Forms.SendKeys]::SendWait($Keys)
    Start-Sleep -Seconds $SleepDelay
}

function Set-DefaultBrowser
{
    <#
    .SYNTAX
        Set-DefaultBrowser [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Set-DefaultBrowser -Name 'Microsoft Edge'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    Open-SystemSettings -SettingPage "defaultapps?registeredAppMachine=$Name"

    # Set default (.htm, .html, HTTP, HTTPS)
    Send-KeyboardKeys -Keys '{TAB 3}{ENTER}'

    Stop-Process -Name 'SystemSettings'
}

function Set-BraveDefaultBrowser
{
    Write-Verbose -Message 'Setting Brave as Default Browser ...'

    $BraveInfo = Get-ApplicationInfo -Name 'Brave'
    if ($BraveInfo)
    {
        Set-DefaultBrowser -Name 'Brave'
    }
    else
    {
        Write-Verbose -Message '    Brave Browser is not installed'
    }
}

#endregion default browser

#endregion brave browser


#==============================================================================
#                                  git
#==============================================================================
#region git

function Set-GitSettings
{
    <#
    .SYNTAX
        Set-GitSettings [-Name] <string> [-Email] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Set-GitSettings -Name 'John Doe' -Email 'johndoe@example.com'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $Email
    )

    Write-Verbose -Message 'Setting Git Settings ...'

    $UserProfilePath = (Get-LoggedUserEnvVariable).USERPROFILE

    "[user]
        name = $Name
        email = $Email
    " -replace '(?m)^ {4}' |
        Out-File -FilePath "$UserProfilePath\.gitconfig"
}

#endregion git


#==============================================================================
#                                  keepassxc
#==============================================================================
#region keepassxc

# Use DuckDuckGo service to download website icons.
function Set-KeePassXCSettings
{
    Write-Verbose -Message 'Setting KeePassXC Settings ...'

    $KeePassXCUserDataPath = "$((Get-LoggedUserEnvVariable).APPDATA)\KeePassXC\"
    if (-not (Test-Path -Path $KeePassXCUserDataPath))
    {
        New-Item -ItemType 'Directory' -Path $KeePassXCUserDataPath -Force | Out-Null
    }

    '[Security]
    IconDownloadFallback=true
    ' -replace '(?m)^ *' |
        Out-File -FilePath "$KeePassXCUserDataPath\keepassxc.ini"
}

#endregion keepassxc


#==============================================================================
#                               microsoft edge
#==============================================================================
#region microsoft edge

# Basic settings if you don't use Edge and didn't removed it.
# Prevent Edge to run all the time in the background.

# prelaunch at startup
#-------------------
# gpo\ computer config > administrative tpl > microsoft edge
#   allow Microsoft Edge to pre-launch at Windows startup, when the sytem idle,
#     and each time Microsoft Edge is closed
# not configured: delete (default) | on: 1 | off: 0
$MicrosoftEdgePrelaunch = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\MicrosoftEdge\\Main",
    "Entries" : [
      {
        "Name"  : "AllowPrelaunch",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# startup boost
#-------------------
# not configured: delete (default) | on: 1 | off: 0
$MicrosoftEdgeStartupBoostAndBackground = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Edge",
    "Entries" : [
      {
        "Name"  : "StartupBoostEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# continue running background extensions and apps when Microsoft Edge is closed
#-------------------
# not configured: delete (default) | on: 1 | off: 0
$MicrosoftEdgeBackgroundExtensionsAndApps = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Edge",
    "Entries" : [
      {
        "Name"  : "BackgroundModeEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion microsoft edge


#==============================================================================
#                              microsoft office
#==============================================================================
#region microsoft office

<#
You can use the 'Office Deployment Tool (ODT)' to automate the installation of Microsoft Office.
With that tool, you can choose which program to install. e.g. Only Word, Excel and PowerPoint.
Use your favorite search engine for more information.

Configuration file example (configuration.xml):
<Configuration>
  <Add OfficeClientEdition="64" Channel="PerpetualVL2024">
    <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">
      <Language ID="MatchOS" />
      <ExcludeApp ID="Access" />
      <ExcludeApp ID="Lync" />
      <ExcludeApp ID="OneDrive" />
      <ExcludeApp ID="OneNote" />
      <ExcludeApp ID="Outlook" />
      <ExcludeApp ID="Publisher" />
    </Product>
  </Add>
  <Display AcceptEULA="TRUE" />
</Configuration>
#>

#=======================================
## options
#=======================================
#region options

#===================
### general
#===================
# privacy settings: turn on optional connected experiences
#-------------------
# on: 1 (default) | off: 2
$MicrosoftOfficeConnectedExperiences = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common\\Privacy",
    "Entries" : [
      {
        "Name"  : "ControllerConnectedServicesEnabled",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common\\Privacy\\SettingsStore\\Anonymous",
    "Entries" : [
      {
        "Name"  : "ControllerConnectedServicesState",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# enable Linkedin features in my Office applications
#-------------------
# on: 1 (default) | off: 0
$MicrosoftOfficeLinkedinFeatures = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common",
    "Entries" : [
      {
        "Name"  : "LinkedIn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common\\LinkedIn",
    "Entries" : [
      {
        "Name"  : "OfficeLinkedIn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show the Start screen when this application starts
#-------------------
# on: 0 (default) | off: 1
$MicrosoftOfficeStartScreen = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\excel\\options",
    "Entries" : [
      {
        "Name"  : "DisableBootToOfficeStart",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\powerpoint\\options",
    "Entries" : [
      {
        "Name"  : "DisableBootToOfficeStart",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Word\\options",
    "Entries" : [
      {
        "Name"  : "DisableBootToOfficeStart",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion options

#=======================================
## privacy
#=======================================
#region privacy

# customer experience improvement program
#-------------------
$MicrosoftOfficeCEIP = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common",
    "Entries" : [
      {
        "Name"  : "QMEnable",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common",
    "Entries" : [
      {
        "Name"  : "QMEnable",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# feedback
#-------------------
$MicrosoftOfficeFeedback = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common\\Feedback",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "IncludeEmail",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SurveyEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common\\Feedback",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# logging
#-------------------
$MicrosoftOfficeLogging = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\OSM",
    "Entries" : [
      {
        "Name"  : "EnableFileObfuscation",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableLogging",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableUpload",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# telemetry
#-------------------
$MicrosoftOfficeTelemetry = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\Common\\ClientTelemetry",
    "Entries" : [
      {
        "Name"  : "SendTelemetry",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common",
    "Entries" : [
      {
        "Name"  : "SendCustomerData",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "UpdateReliabilityData",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Office\\16.0\\Common\\Privacy",
    "Entries" : [
      {
        "Name"  : "DisconnectedState",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DownloadContentDisabled",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "UserContentDisabled",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common",
    "Entries" : [
      {
        "Name"  : "SendCustomerData",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SendCustomerDataOptIn",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SendCustomerDataOptInReason",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\Common\\ClientTelemetry",
    "Entries" : [
      {
        "Name"  : "DisableTelemetry",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "VerboseLogging",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Office\\16.0\\Common\\ClientTelemetry",
    "Entries" : [
      {
        "Name"  : "DisableTelemetry",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "VerboseLogging",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion privacy

#endregion microsoft office


#==============================================================================
#                             visual studio code
#==============================================================================
#region visual studio code

function Get-VSCodeUserDataPath
{
    "$((Get-LoggedUserEnvVariable).APPDATA)\Code\"
}

function Set-VisualStudioCodeSettings
{
    Write-Verbose -Message 'Setting Visual Studio Code Settings ...'

    $VSCodeUserDataPath = "$(Get-VSCodeUserDataPath)\User\"
    if (-not (Test-Path -Path $VSCodeUserDataPath))
    {
        New-Item -ItemType 'Directory' -Path $VSCodeUserDataPath -Force | Out-Null
    }

    '{
        // text editor
        "editor.detectIndentation": false,
        "editor.rulers": [
            79,
            114
        ],

        // workbench
        "workbench.colorCustomizations": {
            "editorRuler.foreground": "#464646"
        },
        "workbench.enableExperiments": false,
        "workbench.settings.enableNaturalLanguageSearch": false,
        "workbench.welcomePage.walkthroughs.openOnInstall": false,

        // features
        "extensions.ignoreRecommendations": true,
        "terminal.integrated.useWslProfiles": false,

        // applications
        "telemetry.telemetryLevel": "off",
        "update.mode": "none", // none, manual, start
        "update.showReleaseNotes": false,

        // extensions
        "json.schemaDownload.enable": false,
        "npm.fetchOnlinePackageInfo": false,
        "powershell.integratedConsole.showOnStartup": false,
        "powershell.developer.editorServicesLogLevel": "None",
        "powershell.promptToUpdatePowerShell": false,
        "typescript.disableAutomaticTypeAcquisition": true,
        "typescript.surveys.enabled": false

        // others (not preconfigured)
    }' -replace '(?m)^ {4}' |
        Out-File -FilePath "$VSCodeUserDataPath\settings.json"
}

#endregion visual studio code


#==============================================================================
#                              vlc media player
#==============================================================================
#region vlc media player

function Set-VLCSettings
{
    Write-Verbose -Message 'Setting VLC media player Settings ...'

    $VLCUserDataPath = "$((Get-LoggedUserEnvVariable).APPDATA)\vlc\"
    if (-not (Test-Path -Path $VLCUserDataPath))
    {
        New-Item -ItemType 'Directory' -Path $VLCUserDataPath -Force | Out-Null
    }

    '[qt]
    qt-privacy-ask=0
    qt-recentplay=0
    qt-system-tray=0
    qt-video-autorezise=0

    [core]
    metadata-network-access=0
    ' -replace '(?m)^ *' |
        Out-File -FilePath "$VLCUserDataPath\vlcrc"
}

#endregion vlc media player


#==============================================================================
#                              windows terminal
#==============================================================================
#region windows terminal

# default terminal app
#-------------------
# Let Windows decide: {00000000-0000-0000-0000-000000000000}
# Windows Console Host: {B23D10C0-E52E-411E-9D5B-C09FDF709C7D} (default)
# Windows Terminal: {2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69} + {E12CFF52-A866-4C77-9A90-F570A7AA2C6B}
$TerminalDefaultApp = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Console\\%%Startup",
    "Entries" : [
      {
        "Name"  : "DelegationConsole",
        "Value" : "{2EACA947-7F5F-4CFA-BA87-8F7FBEEFBE69}",
        "Type"  : "String"
      },
      {
        "Name"  : "DelegationTerminal",
        "Value" : "{E12CFF52-A866-4C77-9A90-F570A7AA2C6B}",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# settings
#-------------------
# default profile:      Powershell Core
# default color scheme: One Half Dark
# default historySize:  32,767 (max)
# start on login:       disabled
function Set-WindowsTerminalSettings
{
    $TerminalPath = "$((Get-LoggedUserEnvVariable).LOCALAPPDATA)\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\"
    $TerminalSettingsFilePath = "$TerminalPath\LocalState\settings.json"
    $TerminalSettingsContent = Get-Content -Raw -Path $TerminalSettingsFilePath -ErrorAction 'SilentlyContinue'

    if ($TerminalSettingsContent)
    {
        Write-Verbose -Message 'Setting Windows Terminal Settings ...'

        $TerminalSettings = $TerminalSettingsContent | ConvertFrom-Json -AsHashtable

        $TerminalSettings.defaultProfile =
            ($TerminalSettings.profiles.list | Where-Object -Property 'name' -EQ -Value 'PowerShell').guid
        $TerminalSettings.profiles.defaults.historySize = 32767
        $TerminalSettings.profiles.defaults.colorScheme = 'One Half Dark'
        $TerminalSettings.startOnUserLogin = $false

        $TerminalSettings | ConvertTo-Json -Depth 42 | Out-File -FilePath $TerminalSettingsFilePath
        $TerminalDefaultApp | Set-RegistryEntry -Verbose:$false
    }
    else
    {
        Write-Verbose -Message 'Windows Terminal is not installed'
    }
}

#endregion windows terminal

#endregion applications settings


#=================================================================================================================
#                                                    ramdisk
#=================================================================================================================
#region ramdisk

<#
Brave (and browsers in general) write a lot to the disk, wearing off SSD.

Brave write a lot of temp files in the 'User Data' directory.
It seems that everything is written to these temp files and then written to the cache ?
e.g.
"$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\random-file-name.tmp"
"$env:LOCALAPPDATA\BraveSoftware\Brave-Browser\User Data\Default\random-file-name.tmp"

Moving the Cache to a RamDisk reduce write disk, but that's not enought.
Lets move everything ('User Data' folder) to the RamDisk.
Make some exceptions for extensions folders, bookmarks and preferences files.

This should also make Brave (a bit) faster.

SSD lifespan is pretty high nowday, so it should be fine even without a RamDisk.
If you watch stream videos all day long, a RamDisk might be usefull.

Let's do the same for VSCode (as it's somehow a web browser too).
#>

#==============================================================================
#                                 application
#==============================================================================
#region application

function Install-OSFMount
{
    Install-Application -Name 'PassmarkSoftware.OSFMount'
    Remove-Item -Path "$((Get-LoggedUserEnvVariable).USERPROFILE)\Desktop\OSFMount.lnk" -ErrorAction 'SilentlyContinue'

    # OSFMount is launched after installation. Close it.
    Stop-Process -Name 'OSFMount' -ErrorAction 'SilentlyContinue'
}

#endregion application


#==============================================================================
#                              helper functions
#==============================================================================
#region helper functions

function New-ParentPath
{
    <#
    .SYNTAX
        New-ParentPath [-Path] <string> [<CommonParameters>]

    .DESCRIPTION
        Create the parent directory of Path if it does not exist.

    .EXAMPLE
        PS> $FilePath = X:\foo\bar\baz.txt
        PS> New-ParentPath -Path $FilePath # create X:\foo\bar\
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    $ParentPath = Split-Path -Path $Path
    if (-not (Test-Path -Path $ParentPath))
    {
        New-Item -ItemType 'Directory' -Path $ParentPath -Force | Out-Null
    }
}

function New-SymbolicLink
{
    <#
    .SYNTAX
        New-SymbolicLink [-Path] <string> [-Target] <string> [-TargetType] {Directory | File} [<CommonParameters>]

    .DESCRIPTION
        Create a symbolic link of Target to Path (i.e. Path is the symbolic link).
        Delete the symbolic link if it already exist.
        Create the target if it does not exist.

    .EXAMPLE
        PS> New-SymbolicLink -Path 'X:\Logs\foo\' -Target 'C:\foo\logs\' -TargetType 'Directory'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]
        $Path,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [string]
        $Target,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet('Directory', 'File')]
        [string]
        $TargetType
    )

    process
    {
        New-ParentPath -Path $Path
        if (-not (Test-Path -Path $Target))
        {
            New-Item -ItemType $TargetType -Path $Target -Force | Out-Null
        }

        Remove-Item -Path $Path -Recurse -ErrorAction 'SilentlyContinue'
        New-Item -ItemType 'SymbolicLink' -Path $Path -Target $Target | Out-Null
    }
}

function Write-Function
{
    <#
    .SYNTAX
        Write-Function [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Write-Function -Name 'MyFunction'
        function MyFunction
        {
            [...]
        }
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name
    )

    process
    {
        "function $Name"
        "{$((Get-Command -Name $Name).Definition)}"
        ''
    }
}

#endregion helper functions


#==============================================================================
#                               data to symlink
#==============================================================================
#region data to symlink

#=======================================
## Brave
#=======================================
# Add the related directories/files if you are using a specific feature (e.g. history, cookies, ...).

# Directories will be symlinked.
# Files will be saved on user logout and restored on ramdisk creation (at computer startup or user logon).

# TODO: FilterListSubscriptionCache as a symlink causes custom list update to fail.

function Get-BraveDataException
{
    $BraveProfileName = Split-Path -Path (Get-BravePathInfo).Profile -Leaf

    $BraveDataException = @{
        Directory = @(
            "$BraveProfileName\DNR Extension Rules" # e.g. uBOL
            "$BraveProfileName\Extensions"
            "$BraveProfileName\FilterListSubscriptionCache" # custom filter lists
            "$BraveProfileName\Local Extension Settings"
        )
        File = @(
            "First Run"
            "Local State"
            "$BraveProfileName\Bookmarks"
            "$BraveProfileName\Favicons"
            "$BraveProfileName\Preferences"
            "$BraveProfileName\Secure Preferences"
        )
    }
    $BraveDataException
}

function Get-BraveDataToSymlink
{
    <#
    .SYNTAX
        Get-BraveDataToSymlink [-RamDiskPath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Get-BraveDataToSymlink -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskPath
    )

    $BraveDataToSymlink = @{
        Brave = @{
            LinkPath = (Get-BravePathInfo).LocalAppData
            TargetPath = "$RamDiskPath\Brave-Browser\"
            Data = @{
                Directory = @(
                    'User Data'
                )
            }
        }
        BraveException = @{
            LinkPath = "$RamDiskPath\Brave-Browser\User Data\"
            TargetPath = (Get-BravePathInfo).PersistentData
            Data = @{
                Directory = (Get-BraveDataException).Directory
            }
        }
    }
    $BraveDataToSymlink
}

#=======================================
## VSCode
#=======================================
function Get-VSCodeDataToRamDisk
{
    $VSCodeUserFolders = @(
        'User\globalStorage\ms-vscode.powershell' # powershell extension
    )

    $VSCodeDataExcluded = @{
        Directory = @(
            'Backups'
            'User'
        )
    }

    $VSCodeFoldersParam = @{
        Path      = Get-VSCodeUserDataPath
        Directory = $true
        Name      = $true
        Exclude   = $VSCodeDataExcluded.Directory
    }
    $VSCodeFolders = Get-ChildItem @VSCodeFoldersParam

    $VSCodeDataToRamDisk = @{
        Directory = @(
            $VSCodeFolders
            $VSCodeUserFolders
        )
    }
    $VSCodeDataToRamDisk
}

function Get-VSCodeDataToSymlink
{
    <#
    .SYNTAX
        Get-VSCodeDataToSymlink [-RamDiskPath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Get-VSCodeDataToSymlink -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskPath
    )

    $VSCodeDataToSymlink = @{
        VSCode = @{
            LinkPath = Get-VSCodeUserDataPath
            TargetPath = "$RamDiskPath\VSCode\"
            Data = Get-VSCodeDataToRamDisk
        }
    }
    $VSCodeDataToSymlink
}

#=======================================
## get data to symlink
#=======================================
function Get-DataToSymlink
{
    <#
    .SYNTAX
        Get-DataToSymlink [-RamDiskPath] <string> [-Data] {Brave | VSCode} [<CommonParameters>]

    .EXAMPLE
        PS> Get-DataToSymlink -RamDiskPath 'X:' -Data 'Brave', 'VSCode'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskPath,

        [Parameter(Mandatory)]
        [ValidateSet('Brave', 'VSCode')]
        [string[]]
        $Data
    )

    $DataToSymlink = @{}
    switch ($Data)
    {
        'Brave'  { $DataToSymlink += Get-BraveDataToSymlink -RamDiskPath $RamDiskPath }
        'VSCode' { $DataToSymlink += Get-VSCodeDataToSymlink -RamDiskPath $RamDiskPath }
    }
    $DataToSymlink
}

#endregion data to symlink


#==============================================================================
#                               data to ramdisk
#==============================================================================
#region data to ramdisk

#=======================================
## helper functions
#=======================================
function Copy-Data
{
    <#
    .SYNTAX
        Copy-Data [-Name] <string[]> [-Path] <string> [-Destination] <string> [<CommonParameters>]

    .DESCRIPTION
        Copies an item from one location to another.
        Keep the tree folders of copied item.

    .EXAMPLE
        PS> Copy-Data -Name 'foo.txt', 'bar\baz.txt' -Path 'X:' -Destination 'Y:\data\'
        PS> Get-ChildItem -Path 'Y:' -Name
        data\foo.txt
        data\bar\baz.txt
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $Path,

        [Parameter(Mandatory)]
        [string]
        $Destination
    )

    foreach ($Item in $Name)
    {
        $ItemParameter = @{
            Path        = "$Path\$Item"
            Destination = "$Destination\$Item"
            Recurse     = $true
        }
        if (Test-Path -Path $ItemParameter.Path)
        {
            New-ParentPath -Path $ItemParameter.Destination
        }
        Copy-Item @ItemParameter -ErrorAction 'SilentlyContinue'
    }
}

function New-SymbolicLinksPair
{
    <#
    .SYNTAX
        New-SymbolicLinksPair [-Data] <hashtable> [<CommonParameters>]

    .EXAMPLE
        PS>
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable]
        $Data
    )

    $SymbolicLinksPair = foreach ($Value in $Data.Values)
    {
        foreach ($Key in $Value.Data.Keys)
        {
            foreach ($Name in $Value.Data[$Key])
            {
                [PSCustomObject]@{
                    Path       = "$($Value.LinkPath)\$Name"
                    Target     = "$($Value.TargetPath)\$Name"
                    TargetType = $Key
                }
            }
        }
    }
    $SymbolicLinksPair
}

function New-RamDiskUserProfile
{
    <#
    .SYNTAX
        New-RamDiskUserProfile [-Path] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-RamDiskUserProfile -Path 'X:\UserName'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Path
    )

    New-Item -Path $Path -ItemType 'Directory' -Force | Out-Null
    $UserProfilePath = (Get-LoggedUserEnvVariable).USERPROFILE
    $UserProfileAcl = Get-Acl -Path $UserProfilePath
    Set-Acl -Path $Path -AclObject $UserProfileAcl
}

function Remove-SymbolicLink
{
    <#
    .SYNTAX
        Remove-SymbolicLink [-Path] <string[]> [<CommonParameters>]

    .EXAMPLE
        PS> Remove-SymbolicLink -Path 'C:\SymbolicLink1', 'C:\SymbolicLink2'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]]
        $Path
    )

    Get-Item -Path $Path |
        Where-Object -Property 'LinkType' -EQ -Value 'SymbolicLink' |
        Remove-Item -ErrorAction 'SilentlyContinue'
}

function Copy-BravePersitentDataToBraveUserData
{
    $BravePersistentFiles = @{
        Name        = (Get-BraveDataException).File
        Path        = (Get-BravePathInfo).PersistentData
        Destination = (Get-BravePathInfo).UserData
    }
    Copy-Data @BravePersistentFiles
}

#=======================================
## set data to ramdisk
#=======================================
function Set-DataToRamDisk
{
    <#
    .SYNTAX
        Set-DataToRamDisk [-RamDiskPath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Set-DataToRamDisk -RamDiskPath 'X:'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskPath
    )

    # Comment/Uncomment the items according to your preferences.
    $DataToRamdisk = @(
        'Brave'
        #'VSCode'
    )
    $RamDiskUserProfilePath = "$RamDiskPath\$(Get-LoggedUserUsername)\"
    $DataToSymlink = Get-DataToSymlink -RamDiskPath $RamDiskUserProfilePath -Data $DataToRamdisk
    $SymbolicLinksPair = New-SymbolicLinksPair -Data $DataToSymlink

    if (Test-Path -Path $RamDiskPath)
    {
        if (-not (Test-Path -Path $RamDiskUserProfilePath))
        {
            New-RamDiskUserProfile -Path $RamDiskUserProfilePath
            $SymbolicLinksPair | New-SymbolicLink
        }
    }
    else
    {
        Remove-SymbolicLink -Path $SymbolicLinksPair.Path
    }

    Copy-BravePersitentDataToBraveUserData
}

#endregion data to ramdisk


#==============================================================================
#                          backup Brave data script
#==============================================================================
#region backup Brave data script

<#
The purpose is to save the files that doesn't work when symlinked.
'Favicons' works fine when symlinked, but some others doesn't.
e.g. 'Bookmarks', 'Preferences', 'Secure Preferences', 'Locate State'

Copy these files from the RamDisk to the persistent path on user logout.
Copy them back to the ramdisk on computer startup or user logon.
#>

<#
gpo\ User Configuration > Windows Settings > Scripts (logon/logoff)
As with policies done via regedit, this script will not be displayed in Group Policy Editor.
If you add a script in the Group Policy Editor, this one (backup Brave data) will be removed.
Even if you just open the dialog and click on OK/Apply, it will be removed.
#>

function New-GroupPolicyLogoffScript
{
    <#
    .SYNTAX
        New-GroupPolicyLogoffScript [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-GroupPolicyLogoffScript -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    $UserSid = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
    $LogOffScriptRegPath = "HKEY_USERS\$UserSID\Software\Microsoft\Windows\CurrentVersion\Group Policy\Scripts\Logoff\0\"
    $ScriptNumber = (Get-ChildItem -Path "Registry::$LogOffScriptRegPath" -ErrorAction 'SilentlyContinue').Count

    $LogoffScriptGPO = '[
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Logoff\\0",
        "Entries" : [
          {
            "Name"  : "DisplayName",
            "Value" : "Local Group Policy",
            "Type"  : "String"
          },
          {
            "Name"  : "FileSysPath",
            "Value" : "$env:SystemRoot\\System32\\GroupPolicy\\User",
            "Type"  : "String"
          },
          {
            "Name"  : "GPO-ID",
            "Value" : "LocalGPO",
            "Type"  : "String"
          },
          {
            "Name"  : "GPOName",
            "Value" : "Local Group Policy",
            "Type"  : "String"
          },
          {
            "Name"  : "PSScriptOrder",
            "Value" : "1",
            "Type"  : "DWord"
          },
          {
            "Name"  : "SOM-ID",
            "Value" : "Local",
            "Type"  : "String"
          }
        ]
      },
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\Scripts\\Logoff\\0\\$ScriptNumber",
        "Entries" : [
          {
            "Name"  : "ExecTime",
            "Value" : "0",
            "Type"  : "QWord"
          },
          {
            "Name"  : "IsPowershell",
            "Value" : "1",
            "Type"  : "DWord"
          },
          {
            "Name"  : "Parameters",
            "Value" : "",
            "Type"  : "String"
          },
          {
            "Name"  : "Script",
            "Value" : "$ScriptFilePath",
            "Type"  : "String"
          }
        ]
      },
      {
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\State\\$UserSid\\Scripts\\Logoff\\0",
        "Entries" : []
      },
      {
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Group Policy\\State\\$UserSid\\Scripts\\Logoff\\0\\$ScriptNumber",
        "Entries" : []
      }
    ]'.Replace('$ScriptNumber', $ScriptNumber).
       Replace('$ScriptFilePath', $FilePath.Replace('\', '\\')).
       Replace('$env:SystemRoot', ($env:SystemRoot).Replace('\', '\\')).
       Replace('$UserSid', $UserSid) | ConvertFrom-Json
    $LogoffScriptGPO[2].Entries = $LogoffScriptGPO[0].Entries
    $LogoffScriptGPO[3].Entries = $LogoffScriptGPO[1].Entries | Where-Object -Property 'Name' -NE -Value 'IsPowershell'

    # These directories must exist to allow the GPO script to works.
    $GroupPolicyScriptDirectories = @(
        "$env:SystemRoot\System32\GroupPolicy\Machine\Scripts\Startup"
        "$env:SystemRoot\System32\GroupPolicy\Machine\Scripts\Shutdown"
        "$env:SystemRoot\System32\GroupPolicy\User\Scripts\Logon"
        "$env:SystemRoot\System32\GroupPolicy\User\Scripts\Logoff"
    )

    foreach ($Item in $GroupPolicyScriptDirectories)
    {
        if (-not (Test-Path -Path $Item))
        {
            New-Item -ItemType 'Directory' -Path $Item -Force | Out-Null
        }
    }

    $LogoffScriptGPO | Set-RegistryEntry -Verbose:$false
}

function New-BackupBravePersitentDataScheduledGPO
{
    <#
    .SYNTAX
        New-BackupBravePersitentDataScheduledGPO [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-BackupBravePersitentDataScheduledGPO -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''Backup Brave Persitent Data'' Scheduled GPO ...'
    New-GroupPolicyLogoffScript -FilePath $FilePath
}

function Copy-BraveUserDataToBravePersitentData
{
    $BravePersistentFiles = @{
        Name        = (Get-BraveDataException).File
        Path        = (Get-BravePathInfo).UserData
        Destination = (Get-BravePathInfo).PersistentData
    }
    Copy-Data @BravePersistentFiles
}

function Write-BackupBravePersitentDataScript
{
    $FunctionsToWrite = @(
        'Get-LoggedUserUsername'
        'Get-LoggedUserEnvVariable'
        'Get-BravePathInfo'
        'Get-BraveDataException'
        'New-ParentPath'
        'Copy-Data'
        'Copy-BraveUserDataToBravePersitentData'
    )

    $RamDiskLogoffScriptContent = $FunctionsToWrite | Write-Function
    $RamDiskLogoffScriptContent += '
        Copy-BraveUserDataToBravePersitentData
    ' -replace '(?m)^ *'
    $RamDiskLogoffScriptContent
}

function New-BackupBravePersitentDataScript
{
    <#
    .SYNTAX
        New-BackupBravePersitentDataScript [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-BackupBravePersitentDataScript -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''Backup Brave Persitent Data'' Script ...'

    New-ParentPath -Path $FilePath
    Write-BackupBravePersitentDataScript | Out-File -FilePath $FilePath
}

#endregion backup Brave data script


#==============================================================================
#                               set data script
#==============================================================================
#region set data script

function Get-DrivePath
{
    <#
    .SYNTAX
        Get-DrivePath [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Get-DrivePath -Name 'RamdDisk'
        X:\
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    (Get-PSDrive -PSProvider 'FileSystem' | Where-Object -Property 'Description' -EQ -Value $Name).Root
}

function Write-RamDiskSetDataScript
{
    <#
    .SYNTAX
        Write-RamDiskSetDataScript [-RamDiskName] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Write-RamDiskSetDataScript -RamDiskName 'RamDisk'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskName
    )

    $FunctionsToWrite = @(
        'Get-LoggedUserUsername'
        'Get-LoggedUserEnvVariable'
        'Get-BravePathInfo'
        'Get-BraveDataException'
        'Get-BraveDataToSymlink'
        'Get-VSCodeUserDataPath'
        'Get-VSCodeDataToRamDisk'
        'Get-VSCodeDataToSymlink'
        'Get-DataToSymlink'
        'New-ParentPath'
        'New-SymbolicLink'
        'New-SymbolicLinksPair'
        'Remove-SymbolicLink'
        'Copy-Data'
        'Copy-BravePersitentDataToBraveUserData'
        'New-RamDiskUserProfile'
        'Set-DataToRamDisk'
        'Get-DrivePath'
    )
    $RamDiskSetDataScriptContent = $FunctionsToWrite | Write-Function

    $RamDiskSetDataScriptContent += "
        `$RamDiskPath = Get-DrivePath -Name '$RamDiskName' | Select-Object -First 1
        Set-DataToRamDisk -RamDiskPath `$RamDiskPath
    " -replace '(?m)^ *'
    $RamDiskSetDataScriptContent
}

function New-RamDiskSetDataScript
{
    <#
    .SYNTAX
        New-RamDiskSetDataScript [-RamDiskName] <string> [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-RamDiskSetDataScript -RamDiskName 'RamDisk' -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskName,

        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''RamDisk - Set Data'' Script ...'

    New-ParentPath -Path $FilePath
    Write-RamDiskSetDataScript -RamDiskName $RamDiskName | Out-File -FilePath $FilePath
}

#endregion set data script


#==============================================================================
#                               new ramdisk script
#==============================================================================
#region new ramdisk script

function Get-AvailableDriveLetter
{
    <#
    .SYNTAX
        Get-AvailableDriveLetter [-ReturnFirstLetterOnly] [<CommonParameters>]

    .EXAMPLE
        PS> $DriveLetter = Get-AvailableDriveLetter -ReturnFirstLetterOnly
        PS> $DriveLetter
        X
    #>

    [CmdletBinding()]
    param
    (
        [switch]
        $ReturnFirstLetterOnly
    )

    $AllDriveLetter = 'D'..'Z'
    $DriveLetterInUse = (Get-PSDrive -PSProvider 'FileSystem').Name
    $AvailableDriveLetter = $AllDriveLetter | Where-Object -FilterScript { $DriveLetterInUse -notcontains $_ }

    if ($ReturnFirstLetterOnly)
    {
        $AvailableDriveLetter | Select-Object -First 1
    }
    else
    {
        $AvailableDriveLetter
    }
}

function New-RamDisk
{
    <#
    .SYNTAX
        New-RamDisk [-Name] <string> [[-MountPoint] <string>] [[-Size] <string>] [<CommonParameters>]

    .EXAMPLE
        PS> $RamDiskPath = New-RamDisk -Name 'My RamDisk' -Size '4G'
        PS> $RamDiskPath
        X:\

    .EXAMPLE
        PS> $RamDiskPath = New-RamDisk -Name 'My RamDisk' -MountPoint 'foo'
        PS> $null -eq $RamDiskPath
        True

    .NOTES
        See OSFMount documentation for more info.
        e.g.
        -s size
            Size of the virtual disk. Size is number of bytes unless suffixed with
                [...]
                'M'    megabytes
                'G'    gigabytes
                [...]
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [string]
        $MountPoint = "$(Get-AvailableDriveLetter -ReturnFirstLetterOnly):\",

        [string]
        $Size = '512M'
    )

    $OSFMountProcess = @{
        FilePath     = "$((Get-ApplicationInfo -Name 'OSFMount').InstallLocation)\OSFMount.com"
        ArgumentList = "-a -t vm -m $MountPoint -o rw,format:ntfs:""$Name"" -s $Size"
    }
    Start-Process @OSFMountProcess -NoNewWindow -Wait

    if (Test-Path -Path $MountPoint)
    {
        $MountPoint
    }
}

function Test-DriveDescription
{
    <#
    .SYNTAX
        Test-DriveDescription [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Test-DriveDescription -Name 'RamDisk'
        True
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name
    )

    $DriveDescriptionInUse = (Get-PSDrive -PSProvider 'FileSystem').Description
    $DriveDescriptionInUse -contains $Name
}

function Write-RamDiskCreationScript
{
    <#
    .SYNTAX
        Write-RamDiskCreationScript [-RamDiskName] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Write-RamDiskCreationScript -RamDiskName 'RamDisk'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskName
    )

    $FunctionsToWrite = @(
        'Get-LoggedUserUsername'
        'Get-ApplicationInfo'
        'Get-AvailableDriveLetter'
        'New-RamDisk'
        'Test-DriveDescription'
    )
    $RamDiskCreationScriptContent = $FunctionsToWrite | Write-Function

    # If you have multiple users, make sure to allocate enought RAM.
    # For Brave, allocate at least 256MB per user.
    $RamDiskCreationScriptContent += "
        if (-not (Test-DriveDescription -Name '$RamDiskName'))
        {
            New-RamDisk -Name '$RamDiskName' -Size '1G'
        }
    " -replace '(?m)^ {8}'
    $RamDiskCreationScriptContent
}

function New-RamDiskCreationScript
{
    <#
    .SYNTAX
        New-RamDiskCreationScript [-RamDiskName] <string> [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-RamDiskCreationScript -RamDiskName 'RamDisk' -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $RamDiskName,

        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''RamDisk - Creation'' Script ...'

    New-ParentPath -Path $FilePath
    Write-RamDiskCreationScript -RamDiskName $RamDiskName | Out-File -FilePath $FilePath
}

#endregion new ramdisk script


#==============================================================================
#                                setup ramdisk
#==============================================================================
#region setup ramdisk

function New-ScriptScheduledTask
{
    <#
    .SYNTAX
        New-ScriptScheduledTask [-FilePath] <string> [-TaskName] <string> [-Trigger] <ciminstance> [<CommonParameters>]

    .EXAMPLE
        PS> $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
        PS> New-ScriptScheduledTask -FilePath 'C:\MyScript.ps1' -TaskName 'MyTask' -Trigger $TaskTrigger
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath,

        [Parameter(Mandatory)]
        [string]
        $TaskName,

        [Parameter(Mandatory)]
        [CimInstance]
        $Trigger
    )

    $TaskPath = '\'
    $TaskActionParam = @{
        Execute  = 'pwsh.exe'
        Argument = "-NoProfile -ExecutionPolicy Bypass -File ""$FilePath"""
    }
    $TaskAction = New-ScheduledTaskAction @TaskActionParam
    $SystemSID = 'S-1-5-18' # 'NT AUTHORITY\SYSTEM'
    $TaskPrincipal = New-ScheduledTaskPrincipal -UserID $SystemSID
    $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries
    $ScheduledTaskParam = @{
        TaskName  = $TaskName
        TaskPath  = $TaskPath
        Action    = $TaskAction
        Trigger   = $Trigger
        Principal = $TaskPrincipal
        Settings  = $TaskSettings
    }
    Unregister-ScheduledTask -TaskPath $TaskPath -TaskName $TaskName -Confirm:$false -ErrorAction 'SilentlyContinue'
    Register-ScheduledTask @ScheduledTaskParam -Verbose:$false | Out-Null
}

function Add-ScriptActionToScheduledTask
{
    <#
    .SYNTAX
        Add-ScriptActionToScheduledTask [-FilePath] <string> [-TaskName] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Add-ScriptActionToScheduledTask -FilePath 'C:\MyScript.ps1' -TaskName 'MyTask'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath,

        [Parameter(Mandatory)]
        [string]
        $TaskName
    )

    $TaskActionParam = @{
        Execute  = 'pwsh.exe'
        Argument = "-NoProfile -ExecutionPolicy Bypass -File ""$FilePath"""
    }
    $NewTaskAction = New-ScheduledTaskAction @TaskActionParam

    Get-ScheduledTask -TaskPath '\' -TaskName $TaskName |
        ForEach-Object -Process {
            $TaskActions = $_.Actions
            $TaskActions += $NewTaskAction
            Set-ScheduledTask -TaskName $_.TaskName -Action $TaskActions | Out-Null
        }
}

function New-RamDiskSetDataScheduledTask
{
    <#
    .SYNTAX
        New-RamDiskSetDataScheduledTask [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-RamDiskSetDataScheduledTask -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''RamDisk - Set Data'' Scheduled Task ...'

    # -AtLogOn doesn't work if autologin is enabled, -AtStartup must be used.
    # If you use autologin, use -AtStartup for the autologged account and -AtLogOn for others.
    $IsUserAutoLogin = $true
    if ($IsUserAutoLogin)
    {
        Add-ScriptActionToScheduledTask -FilePath $FilePath -TaskName 'RamDisk - Creation'
    }
    else
    {
        $UserName = Get-LoggedUserUsername
        $TaskName = "RamDisk - Set Data for '$UserName'"
        $TaskTrigger = New-ScheduledTaskTrigger -AtLogOn -User $UserName
        New-ScriptScheduledTask -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
    }
}

function New-RamDiskCreationScheduledTask
{
    <#
    .SYNTAX
        New-RamDiskCreationScheduledTask [-FilePath] <string> [<CommonParameters>]

    .EXAMPLE
        PS> New-RamDiskCreationScheduledTask -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $FilePath
    )

    Write-Verbose -Message 'Setting ''RamDisk - Creation'' Scheduled Task ...'

    $TaskName  = 'RamDisk - Creation'
    $TaskTrigger = New-ScheduledTaskTrigger -AtStartup
    New-ScriptScheduledTask -FilePath $FilePath -TaskName $TaskName -Trigger $TaskTrigger
}

function Set-RamDiskScriptsAndTasks
{
    $RamDiskName = 'RamDisk'
    $StartupScriptFilePath = "$env:SystemDrive\RamDisk script\create_ramdisk.ps1"
    $LogonScriptFilePath = "$((Get-LoggedUserEnvVariable).LOCALAPPDATA)\set_data_to_ramdisk.ps1"
    $LogoffScriptFilePath = "$((Get-LoggedUserEnvVariable).LOCALAPPDATA)\save_brave_files_to_persistent_path.ps1"

    New-RamDiskCreationScript -RamDiskName $RamDiskName -FilePath $StartupScriptFilePath
    New-RamDiskCreationScheduledTask -FilePath $StartupScriptFilePath

    New-RamDiskSetDataScript -RamDiskName $RamDiskName -FilePath $LogonScriptFilePath
    New-RamDiskSetDataScheduledTask -FilePath $LogonScriptFilePath

    New-BackupBravePersitentDataScript -FilePath $LogoffScriptFilePath
    New-BackupBravePersitentDataScheduledGPO -FilePath $LogoffScriptFilePath
}

#endregion setup ramdisk

#endregion ramdisk


#=================================================================================================================
#                                              windows settings app
#=================================================================================================================
#region windows settings app

#==============================================================================
#                              settings > system
#==============================================================================
#region settings > system

#=======================================
## display
#=======================================
#region display

# change brightness based on content
#-------------------
# Off: 0 | Always: 1 | On Battery Only: 2 (default)
$DisplayChangeBrightnessBasedOnContent = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers",
    "Entries" : [
      {
        "Name"  : "CABCOption",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### graphics
#===================
# optimizations for windowed games
#-------------------
# on: 1 (default) | off: 0
$WindowedGamesSettingValue = 0
$WindowedGamesKey = 'SwapEffectUpgradeEnable'
$GpuPrefRegPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\DirectX\UserGpuPreferences'
$CurrentDirectXSettings = (Get-ItemProperty -Path $GpuPrefRegPath -ErrorAction 'SilentlyContinue').DirectXUserGlobalSettings
$DirectXSettings = $CurrentDirectXSettings -like "*$WindowedGamesKey*" ?
    ($CurrentDirectXSettings -replace "($WindowedGamesKey=)\d;", '$1') + "$WindowedGamesSettingValue;" :
    $CurrentDirectXSettings + "$WindowedGamesKey=$WindowedGamesSettingValue;"

$DisplayOptimizationsForWindowedGames = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\DirectX\\UserGpuPreferences",
    "Entries" : [
      {
        "Name"  : "DirectXUserGlobalSettings",
        "Value" : "$DirectXSettings",
        "Type"  : "String"
      }
    ]
  }
]'.Replace('$DirectXSettings', $DirectXSettings) | ConvertFrom-Json

# hardware-accelerated GPU scheduling
#-------------------
# on: 2 | off: 1 (default)
$DisplayHardwareAcceleratedGPUScheduling = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\GraphicsDrivers",
    "Entries" : [
      {
        "Name"  : "HwSchMode",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion display

#=======================================
## sound
#=======================================
#region sound

#===================
### more sound settings
#===================
# communications > when Windows detects communications activity
#-------------------
# mute all other sounds: 0
# reduce the volume of the other sounds by 80%: 1 (default)
# reduce the volume of the other sounds by 50%: 2
# do nothing: 3
$SoundCommunicationsActivity = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Multimedia\\Audio",
    "Entries" : [
      {
        "Name"  : "UserDuckingPreference",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion sound

#=======================================
## notifications
#=======================================
#region notifications

# notifications
#-------------------
# on: 1 (default) | off: 0
$Notifications = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications",
    "Entries" : [
      {
        "Name"  : "ToastEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# allow notifications to play sounds
#-------------------
# on: delete (default) | off: 0
$NotificationsPlaySounds = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Notifications\\Settings",
    "Entries" : [
      {
        "Name"  : "NOC_GLOBAL_SETTING_ALLOW_NOTIFICATION_SOUND",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show notifications on the lock screen
#-------------------
# on: 1 + delete NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK (default) | off: 0
$NotificationsLockScreen = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PushNotifications",
    "Entries" : [
      {
        "Name"  : "LockScreenToastEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Notifications\\Settings",
    "Entries" : [
      {
        "Name"  : "NOC_GLOBAL_SETTING_ALLOW_TOASTS_ABOVE_LOCK",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show reminders and incoming VoIP calls on the lock screen
#-------------------
# on: delete (default) | off: 0
$NotificationsRemindersAndIncomingVoIP = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Notifications\\Settings",
    "Entries" : [
      {
        "Name"  : "NOC_GLOBAL_SETTING_ALLOW_CRITICAL_TOASTS_ABOVE_LOCK",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show notifications bell icon
#-------------------
# on: 1 (default) | off: 0
$NotificationsBellIcon = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowNotificationIcon",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### notifications from apps and other senders
#===================
function New-NotificationRegData
{
    <#
    .SYNTAX
        New-NotificationRegData [-Key] <string> [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> $AutoplayNotif = New-NotificationRegData -Key 'Windows.SystemToast.AutoPlay' -State 'Disabled'
        PS> $AutoplayNotif | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Key,

        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    $NewData = '[
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Notifications\\Settings\\",
        "Entries" : [
          {
            "Name"  : "Enabled",
            "Value" : "",
            "Type"  : "DWord"
          }
        ]
      }
    ]' | ConvertFrom-Json

    $NewData.Path += $Key
    $NewData.Entries[0].Value = $State -eq 'Enabled' ? 1 : 0
    $NewData
}

# Depending on which notifications you already got, you might have more or less items.
# Not needed if you already disabled main notification toggle.
#-------------------
$AppsAndOtherSenders = @{
    Disabled = @(
        'Windows.SystemToast.PinConsent' # apps
        'Windows.SystemToast.AutoPlay' # autoplay
        'Windows.SystemToast.BackgroundAccess' # power (& battery)
        'Microsoft.WindowsStore_8wekyb3d8bbwe!App' # microsoft store
        'Windows.ActionCenter.SmartOptOut' # notification suggestions
        'Windows.SystemToast.Print.Notification' # print notification
        'windows.immersivecontrolpanel_cw5n1h2txyewy!microsoft.windows.immersivecontrolpanel' # settings
        'Microsoft.ScreenSketch_8wekyb3d8bbwe!App' # snipping tool
        'Windows.SystemToast.StartupApp' # startup app notification
        'Windows.SystemToast.Suggested' # suggested (ads for microsoft apps)
        'MicrosoftWindows.Client.CBS_cw5n1h2txyewy!WindowsBackup' # Windows Backup
    )
    Enabled = @(
    )
}

$NotificationsFromAppsAndOtherSenders = $AppsAndOtherSenders.GetEnumerator() |
    ForEach-Object -Process {
        foreach ($Item in $_.Value)
        {
            New-NotificationRegData -Key $Item -State $_.Key
        }
    }

#===================
### additional settings
#===================
# show the Windows welcome experience after updates and when signed in to show what's new and suggested
#-------------------
# gpo\ user config > administrative tpl > windows components > cloud content
#   turn off the Windows welcome experience
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$NotificationsWelcomeExperience = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableWindowsSpotlightWindowsWelcomeExperience",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
    "Entries" : [
      {
        "Name"  : "SubscribedContent-310093Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# suggest ways to get the most out of Windows and finish setting up this device
#-------------------
# on: 1 (default) | off: 0
$NotificationsFinishSettings = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\UserProfileEngagement",
    "Entries" : [
      {
        "Name"  : "ScoobeSystemSettingEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# get tips and suggestions when using Windows
#-------------------
# gpo\ computer config > administrative tpl > windows components > cloud content
#   do not show Windows tips (only applies to Enterprise and Education SKUs)
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
#   (SoftLandingEnabled is for Windows 10)
$NotificationsTipsAndSuggestions = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableSoftLanding",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
    "Entries" : [
      {
        "Name"  : "SoftLandingEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SubscribedContent-338389Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion notifications

#=======================================
## power (& battery)
#=======================================
#region power (& battery)

#===================
### power mode
#===================
# Available when using the Balanced power plan.
# Laptop: Applies only to the active power state (AC or DC).

# Best power efficiency | Balanced (default) | Best performance
function Set-PowerMode
{
    <#
    .SYNTAX
        Set-PowerMode [-Name] {BestPowerEfficiency | Balanced | BestPerformance} [<CommonParameters>]

    .EXAMPLE
        PS> Set-PowerMode -Name 'BestPowerEfficiency'
    #>

    [CmdletBinding()]
    param
    (
        [ValidateSet(
            'BestPowerEfficiency',
            'Balanced',
            'BestPerformance')]
        [string]
        $Name
    )

    $Value = switch ($Name)
    {
        'BestPowerEfficiency' { 'OVERLAY_SCHEME_MIN' }
        'Balanced'            { 'OVERLAY_SCHEME_NONE' }
        'BestPerformance'     { 'OVERLAY_SCHEME_MAX' }
    }

    Write-Verbose -Message "Setting 'Power Mode' to '$Name' ..."
    powercfg.exe -OverlaySetActive $Value
}

<#
# owner: SYSTEM | full control: SYSTEM
# Requested registry access is not allowed.
# Best Power Efficiency: 961cc777-2547-4f9d-8174-7d86181b8a7a
# Balanced: 00000000-0000-0000-0000-000000000000
# Best Performance: ded574b5-45a0-4f42-8737-46345c09c238
$PowerMode = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Power\\User\\PowerSchemes",
    "Entries" : [
      {
        "Name"  : "ActiveOverlayAcPowerScheme",
        "Value" : "00000000-0000-0000-0000-000000000000",
        "Type"  : "String"
      },
      {
        "Name"  : "ActiveOverlayDcPowerScheme",
        "Value" : "00000000-0000-0000-0000-000000000000",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json
#>

#===================
### screen, sleep, & hibernate timeouts
#===================
function Set-PowerSateTimeout
{
    <#
    .SYNTAX
        Set-PowerSateTimeout [-PowerState] {AC | DC} [-TimeoutType] {Monitor | Standby} [-Value] <int> [<CommonParameters>]

    .EXAMPLE
        PS> Set-PowerSateTimeout -PowerState 'AC' -TimeoutType 'Monitor' -Value 4

    .NOTES
        AC: plugged in
        DC: battery
        Monitor: screen
        Standby: sleep
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet('AC', 'DC')]
        [string]
        $PowerState,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateSet('Monitor', 'Standby')]
        [string]
        $TimeoutType,

        [Parameter(
            Mandatory,
            ValueFromPipelineByPropertyName)]
        [ValidateRange('NonNegative')]
        [int]
        $Value
    )

    process
    {
        Write-Verbose -Message "Setting '$TimeoutType ($PowerState) Timeout' to '$Value min' ..."
        powercfg.exe -Change $TimeoutType-Timeout-$PowerState $Value
    }
}

# on battery power, turn off my screen after
# when plugged in, turn off my screen after
# on battery power, put my device to sleep after
# when plugged in, put my device to sleep after
#-------------------
# value are in minutes
# never: 0 | default: 3 5 10 15
$PowerScreenAndSleep = '[
  {
    "PowerState"  : "DC",
    "TimeoutType" : "Monitor",
    "Value"       : "3"
  },
  {
    "PowerState"  : "AC",
    "TimeoutType" : "Monitor",
    "Value"       : "3"
  },
  {
    "PowerState"  : "DC",
    "TimeoutType" : "Standby",
    "Value"       : "10"
  },
  {
    "PowerState"  : "AC",
    "TimeoutType" : "Standby",
    "Value"       : "10"
  }
]' | ConvertFrom-Json

function Set-ScreenAndSleepTimeout
{
    $PowerScreenAndSleep | Set-PowerSateTimeout
}

#===================
### energy saver
#===================
# always use energy saver
#-------------------
# on: 1 | off: 2 (default)
$PowerEnergySaver = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Power",
    "Entries" : [
      {
        "Name"  : "EnergySaverState",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# turn energy saver on automatically when battery level is at
#-------------------
# default: 30 | never: 0 | always: 100
function Set-EnergySaverAutoTurnOnAt
{
    <#
    .SYNTAX
        Set-EnergySaverAutoTurnOnAt [[-Percent] <int>] [<CommonParameters>]

    .EXAMPLE
        PS> Set-EnergySaverAutoTurnOnAt -Percent 0
    #>

    [CmdletBinding()]
    param
    (
        [ValidateSet(0, 10, 20, 30, 40, 50, 100)]
        [int]
        $Percent = 30
    )

    $State = switch ($Percent)
    {
        0       { 'Never' }
        100     { 'Always' }
        Default { "$Percent%" }
    }

    Write-Verbose -Message "Setting 'Energy Saver Auto Turn On when battery level is At' to '$State' ..."
    powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBATTTHRESHOLD $Percent
}

# lower screen brightness when using energy saver
#-------------------
# If you use a custom value and turn off the feature in the GUI,
# when you turn it back on, the default value will be set.
# on: 70 (default) (range 0-99) | off: 100
function Set-EnergySaverLowerBrightness
{
    <#
    .SYNTAX
        Set-EnergySaverLowerBrightness [-Percent] <int> [<CommonParameters>]

    .EXAMPLE
        PS> Set-EnergySaverLowerBrightness -Percent 100
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int]
        $Percent
    )

    $State = switch ($Percent)
    {
        0       { 'Enabled' }
        100     { 'Disabled' }
        Default { "$Percent%" }
    }

    Write-Verbose -Message "Setting 'Energy Saver LowerBrightness' to '$State' ..."
    powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Percent
    powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_ENERGYSAVER ESBRIGHTNESS $Percent
}

function Enable-EnergySaverLowerBrightness
{
    Set-EnergySaverLowerBrightness -Percent 70
}

function Disable-EnergySaverLowerBrightness
{
    Set-EnergySaverLowerBrightness -Percent 100
}

#endregion power (& battery)

#=======================================
## storage
#=======================================
#region storage

#===================
### storage sense
#===================
# cleanup of temporary files
#-------------------
# gpo\ computer config > administrative tpl > system > storage sense
#   allow storage sense temporary files cleanup
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 | off: 0 (default)
$StorageSenseCleanupTempFiles = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\StorageSense",
    "Entries" : [
      {
        "Name"  : "AllowStorageSenseTemporaryFilesCleanup",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy",
    "Entries" : [
      {
        "Name"  : "04",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatic User content cleanup
#-------------------
# gpo\ computer config > administrative tpl > system > storage sense
#   allow storage sense
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 | off: 0 (default)
$StorageSenseAutoCleanupUserContent = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\StorageSense",
    "Entries" : [
      {
        "Name"  : "AllowStorageSenseGlobal",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\StorageSense\\Parameters\\StoragePolicy",
    "Entries" : [
      {
        "Name"  : "01",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion storage

#=======================================
## nearby sharing
#=======================================
#region nearby sharing

# nearby sharing
#-------------------
# For GPO see $WindowsSharedExperienceGPO (tweaks > miscellaneous > windows shared experience).
# If disabled, 'SettingsPage\NearShareChannelUserAuthzPolicy' value does not matter.
# If enabled, 'SettingsPage\BluetoothLastDisabledNearShare' value does not matter ?

# off: 0 (default) | my devices only: 1 | everyone nearby: 2
$NearbySharing = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CDP",
    "Entries" : [
      {
        "Name"  : "NearShareChannelUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "CdpSessionUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CDP\\SettingsPage",
    "Entries" : [
      {
        "Name"  : "BluetoothLastDisabledNearShare",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "NearShareChannelUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# save files I receive to
#-------------------
# default location: delete (default)
$NearbySharingDownloadLocation = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CDP",
    "Entries" : [
      {
        "RemoveEntry" : true,
        "Name"  : "NearShareFileSaveLocation",
        "Value" : "X:\\CustomLocation",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion nearby sharing

#=======================================
## multitasking
#=======================================
#region multitasking

# show tabs from apps when snapping or pressing Alt+Tab
#-------------------
# 20 most recent tabs: 0 | 5 most recent tabs: 1
# 3 most recent tabs: 2 (default) | Don't show tabs: 3
$MultitaskingShowTabsFromApps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "MultiTaskingAltTabFilter",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# title bar window shake
#-------------------
# gpo\ user config > administrative tpl > desktop
#   turn off Aero shake window minimizing mouse gesture
# gpo\ not configured: delete (default) | off: 1
# user\ on: 0 | off: 1 (default)
$MultitaskingTitleBarShaking = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoWindowMinimizingShortcuts",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "DisallowShaking",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### snap windows
#===================
# snap windows
# when I snap a window, suggest what I can snap next to it
# show snap layouts when I hover a window's maximize button
# show snap layouts when I drag a window to the top of my screen
# show my snapped windows when I hover taskbar apps, in Task View, and when I press Alt+Tab
# when I drag a window, let me snap it without dragging all the way to the screen edge
#-------------------
# on: 1 (default) | off: 0
$MultitaskingSnapWindows = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "WindowArrangementActive",
        "Value" : "1",
        "Type"  : "String"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "SnapAssist",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableSnapAssistFlyout",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableSnapBar",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableTaskGroups",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DITest",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### desktops
#===================
# on the taskbar, show all the open windows
# show all open windows when I press Alt+Tab
#-------------------
# On all desktops: 0 | Only on the desktop I'm using: 1 (default)
$MultitaskingDesktopsShowOpenWindows = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "VirtualDesktopTaskbarFilter",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "VirtualDesktopAltTabFilter",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion multitasking

#=======================================
## for developers
#=======================================
#region for developers

# end task
#-------------------
# on: 1 | off: 0 (default)
$ForDevelopersEndTaskInTaskbar = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced\\TaskbarDeveloperSettings",
    "Entries" : [
      {
        "Name"  : "TaskbarEndTask",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# enable sudo
#-------------------
# in a new window: forceNewWindow | with input disabled: disableInput | inline: normal | disabled: disable (default)
function Set-SudoCommand
{
    <#
    .SYNTAX
        Set-SudoCommand [-State] {forceNewWindow | disableInput | normal | disable} [<CommonParameters>]

    .EXAMPLE
        PS> Set-SudoCommand -State 'normal'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(
            'forceNewWindow',
            'disableInput',
            'normal',
            'disable')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Sudo Command' to '$State' ..."
    sudo config --enable $State | Out-Null
}

#endregion for developers

#=======================================
## troubleshoot
#=======================================
#region troubleshoot

# recommended troubleshooter preference
#-------------------
# Don't run any: 1 | Ask me before running: 2 (default)
# Run automatically, then notify me: 3 | Run automatically, don't notify me: 4
$Troubleshoot = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsMitigation",
    "Entries" : [
      {
        "Name"  : "UserPreference",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion troubleshoot

#=======================================
## projecting to this PC
#=======================================
#region projecting to this PC

# projecting to this PC
#-------------------
# gpo\ computer config > administrative tpl > windows components > connect
#   don't allow this PC to be projected to
# not configured: delete (default) | off: 1
# off: The PC isn't discoverable unless Wireless Display app is manually launched
$ProjectingToThisPC = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Connect",
    "Entries" : [
      {
        "Name"  : "AllowProjectionToPC",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# some Windows and Android devices can project to this PC when you say it's OK
#-------------------
# available everywhere on secure networks: 1 | available everywhere: 0 1 | always off: 0 (default)
$ProjectingToThisPCAvailability = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\MiracastReceiver",
    "Entries" : [
      {
        "Name"  : "NetworkQualificationEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\PlayToReceiver",
    "Entries" : [
      {
        "Name"  : "AutoEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# ask to project to this PC
#-------------------
# First time only: 1 | Every time a connection is requested: 2 (default)
$ProjectingToThisPCAskToProject = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\MiracastReceiver",
    "Entries" : [
      {
        "Name"  : "ConsentToast",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# require PIN for pairing
#-------------------
# gpo\ computer config > administrative tpl > windows components > connect
#   require pin for pairing
# gpo\ not configured: delete (default) | Never: 0 | First Time: 1 | Always: 2
# user\ Never: 1 2 (default) | First Time: 2 delete | Always: 3 delete
$ProjectingToThisPCRequirePIN = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Connect",
    "Entries" : [
      {
        "Name"  : "RequirePinForPairing",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\MiracastReceiver",
    "Entries" : [
      {
        "Name"  : "Primary Authorization Method",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "RemoveEntry" : true,
        "Name"  : "Secondary Authorization Method",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# this PC can be discovered for projection only when it's plugged into a power source
#-------------------
# on: 1 (default) | off: 0
$ProjectingToThisPCOnlyWhenPluggedOnAC = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\MiracastReceiver",
    "Entries" : [
      {
        "Name"  : "EnabledOnACOnly",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion projecting to this PC

#=======================================
## remote desktop
#=======================================
#region remote desktop

# remote desktop
#-------------------
# gpo\ computer config > administrative tpl > remote desktop services > remote desktop session host > connections
#   allow users to connect remotely by using remote desktop services
# gpo\ not configured: delete (default) | on: 0 | off: 1
# user\ on: fDenyTS 0, updateRD 1 | off: fDenyTS 1, updateRD 0 (default)
$RemoteDesktop = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows NT\\Terminal Services",
    "Entries" : [
      {
        "Name"  : "fDenyTSConnections",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Terminal Server",
    "Entries" : [
      {
        "Name"  : "fDenyTSConnections",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "updateRDStatus",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# require devices to use Network Level Authentication to connect
#-------------------
# on: 1 (default) | off: 0
$RemoteDesktopNetworkLevelAuthentication = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp",
    "Entries" : [
      {
        "Name"  : "UserAuthentication",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# remote desktop port
#-------------------
# default: 3389
$RemoteDesktopPort = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Terminal Server\\WinStations\\RDP-Tcp",
    "Entries" : [
      {
        "Name"  : "PortNumber",
        "Value" : "3389",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion remote desktop

#=======================================
## clipboard
#=======================================
#region clipboard

# clipboard history
#-------------------
# gpo\ computer config > administrative tpl > system > OS policies
#   allow clipboard history
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 | off: 0 (default)
$ClipboardHistory = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "AllowClipboardHistory",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Clipboard",
    "Entries" : [
      {
        "Name"  : "EnableClipboardHistory",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# sync across your devices
#-------------------
# gpo\ computer config > administrative tpl > system > OS policies
#   allow clipboard synchronization across devices
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 | off: 0 (default)
# AutomaticUpload\ automatically sync text I copy: 1 | manually sync text that I copy: 0
$ClipboardSyncAcrossDevices = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "AllowCrossDeviceClipboard",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Clipboard",
    "Entries" : [
      {
        "Name"  : "EnableCloudClipboard",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "CloudClipboardAutomaticUpload",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# suggested actions
#-------------------
# on: 0 (default) | off: 1
$ClipboardSuggestedActions = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SmartActionPlatform\\SmartClipboard",
    "Entries" : [
      {
        "Name"  : "Disabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion clipboard

#=======================================
## optional features
#=======================================
#region optional features

#===================
### installed features
#===================
function Export-InstalledWindowsCapabilitiesNames
{
    $LogFilePath = "$PSScriptRoot\windows_capabilities_default.txt"
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

function Remove-WinCapability
{
    <#
    .SYNTAX
        Remove-WinCapability [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Remove-WinCapability -Name 'Print.Fax.Scan'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name
    )

    begin
    {
        $WinCapabilities = Get-WindowsCapability -Online -Verbose:$false
    }

    process
    {
        $WinCapability = $WinCapabilities |
            Where-Object -FilterScript {
                $_.Name -like "$Name*" -and
                $_.State -eq 'Installed'
            }

        if ($WinCapability)
        {
            Write-Verbose -Message "Removing $Name ..."
            $WinCapability | Remove-WindowsCapability -Online -Verbose:$false | Out-Null
        }
        else
        {
            Write-Verbose -Message "$Name is not installed"
        }
    }
}

$ExtendedThemeContent          = 'Microsoft.Wallpapers.Extended'
$FacialRecognitionWindowsHello = 'Hello.Face'
$InternetExplorerMode          = 'Browser.InternetExplorer'
$MathRecognizer                = 'MathRecognizer'
$NotepadSystem                 = 'Microsoft.Windows.Notepad.System'
$OneSync                       = 'OneCoreUAP.OneSync'
$OpenSSHClient                 = 'OpenSSH.Client'
$PrintManagement               = 'Print.Management.Console'
$StepsRecorder                 = 'App.StepsRecorder'
$VBScript                      = 'VBSCRIPT' # might be required by some programs installer
$WindowsFaxAndScan             = 'Print.Fax.Scan'
$WindowsMediaPlayerLegacy      = 'Media.WindowsMediaPlayer' # might be required by some games
$WindowsPowerShellISE          = 'Microsoft.Windows.PowerShell.ISE'
$WMIC                          = 'WMIC'
$WordPad                       = 'Microsoft.Windows.WordPad'
$XpsViewer                     = 'XPS.Viewer'

#===================
### languages
#===================
# settings > time & language > language & region
# preferred languages > 3 dots on language > language options

function Remove-OptionalLanguageFeature
{
    <#
    .SYNTAX
        Remove-OptionalLanguageFeature [-Name] <string> [<CommonParameters>]

    .EXAMPLE
        PS> Remove-OptionalLanguageFeature -Name 'Handwriting'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name
    )

    begin
    {
        $WinPackages = Get-WindowsPackage -Online -Verbose:$false
    }

    process
    {
        $PackageName = $WinPackages |
            Where-Object -FilterScript {
                $_.PackageName -like "*LanguageFeatures-$Name*" -and
                $_.PackageState -eq 'Installed'
            }

        if ($PackageName)
        {
            $WindowsPackageOptions = @{
                NoRestart     = $true
                Verbose       = $false
                WarningAction = 'SilentlyContinue'
            }

            Write-Verbose -Message "Removing LanguageFeatures-$Name ..."
            $PackageName | Remove-WindowsPackage -Online @WindowsPackageOptions | Out-Null
        }
        else
        {
            Write-Verbose -Message "LanguageFeatures-$Name is not installed"
        }
    }
}

# e.g. Microsoft-Windows-LanguageFeatures-Basic-en-us-Package~31bf3856ad364e35~amd64~~10.0.22621.3007
# Specify the language if you have more than one installed (e.g. $BasicTypingEnglish = 'Basic-en-us').

# Basic Typing must be removed in last.
# Doesn't work for Windows 10 (features will be reinstalled).
$BasicTyping  = 'Basic'
$Handwriting  = 'Handwriting'
$OCR          = 'OCR'
$Speech       = 'Speech'
$TextToSpeech = 'TextToSpeech'

#===================
### more Windows features
#===================
function Export-EnabledWindowsOptionalFeaturesNames
{
    $LogFilePath = "$PSScriptRoot\windows_optional_features_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Enabled Windows Optional Features Names ...'

        Get-WindowsOptionalFeature -Online -Verbose:$false |
            Where-Object -Property 'State' -EQ -Value 'Enabled' |
            Select-Object -ExpandProperty 'FeatureName' |
            Sort-Object |
            Out-File -FilePath $LogFilePath
    }
}

function Set-WindowsOptionalFeature
{
    <#
    .SYNTAX
        Set-WindowsOptionalFeature [-Name] <string> [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> $FeaturesToRemove = @(
                'MediaPlayback'
                'WorkFolders-Client'
            )
        PS> $FeaturesToRemove | Set-WindowsOptionalFeature -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    begin
    {
        $WinPackages = Get-WindowsOptionalFeature -Online -Verbose:$false
    }

    process
    {
        $WinOptionalFeature = $WinPackages |
            Where-Object -FilterScript {
                $_.FeatureName -eq $Name -and
                $_.State -ne $State
            }

        if ($WinOptionalFeature)
        {
            $OptionalFeatureOptions = @{
                NoRestart     = $true
                Verbose       = $false
                WarningAction = 'SilentlyContinue'
            }

            switch ($State)
            {
                'Enabled'
                {
                    Write-Verbose -Message "Enabling $Name ..."
                    $WinOptionalFeature | Enable-WindowsOptionalFeature -Online -All @OptionalFeatureOptions | Out-Null
                }
                'Disabled'
                {
                    Write-Verbose -Message "Disabling $Name ..."
                    $WinOptionalFeature | Disable-WindowsOptionalFeature -Online @OptionalFeatureOptions | Out-Null
                }
            }
        }
        else
        {
            Write-Verbose -Message "$Name is already '$State'"
        }
    }
}

# If disabling a feature, remove 'MainFeature' after removing a subfeature.

$DotNetFramework35 = @{
    MainFeature                          = 'NetFx3'
}
$DotNetFramework48 = @{
    MainFeature                          = 'NetFx4-AdvSrvs'
    WcfServices = @{
        MainFeature                      = 'WCF-Services45'
        TcpPortSharing                   = 'WCF-TCP-PortSharing45'
    }
}
$MediaFeatures = @{
    MainFeature                         = 'MediaPlayback'
    WindowsMediaPlayerLegacy            = 'WindowsMediaPlayer'
}
$MicrosoftRemoteDesktopConnection        = 'Microsoft-RemoteDesktopConnection' # same as: mstsc.exe /uninstall
$MicrosoftXpsDocumentWriter              = 'Printing-XPSServices-Features'
$PrintAndDocumentServices = @{ # printer in local network (or usb) do not need this feature
    MainFeature                          = 'Printing-Foundation-Features'
    InternetPrintingClient               = 'Printing-Foundation-InternetPrinting-Client'
}
$RemoteDifferentialCompressionApiSupport = 'MSRDC-Infrastructure'
$SmbDirect                               = 'SmbDirect'
$WindowsPowerShell2 = @{
    MainFeature                          = 'MicrosoftWindowsPowerShellV2'
    WindowsPowerShell2Engine             = 'MicrosoftWindowsPowerShellV2Root'
}
$WindowsRecall                           = 'Recall'
$WindowsSandbox                          = 'Containers-DisposableClientVM'
$WorkFoldersClient                       = 'WorkFolders-Client'

#endregion optional features

#endregion settings > system


#==============================================================================
#                       settings > bluetooth & devices
#==============================================================================
#region settings > bluetooth & devices

#=======================================
## devices
#=======================================
#region devices

# show notifications to connect using Swift Pair
#-------------------
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 (default) | off: 0
$DevicesNotificationsConnectSwiftPair = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\PolicyManager\\default\\Bluetooth\\AllowPromptedProximalConnections",
    "Entries" : [
      {
        "Name"  : "value",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Bluetooth",
    "Entries" : [
      {
        "Name"  : "QuickPair",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# download over metered connections (device software (drivers, info, and apps)
#-------------------
# on: 1 | off: 0 (default)
$DevicesDownloadOverMetered = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\DeviceSetup",
    "Entries" : [
      {
        "Name"  : "CostedNetworkPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# bluetooth devices discovery
#-------------------
# default: 0 (default) | advanced: 1
$DevicesBluetoothDiscovery = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Bluetooth",
    "Entries" : [
      {
        "Name"  : "AdvancedDiscoveryMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion devices

#=======================================
## printers & scanners
#=======================================
#region printers & scanners

# let Windows manage my default printer
#-------------------
# on: 0 (default) | off: 1
$PrintersAndScannersDefaultPrinter = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows NT\\CurrentVersion\\Windows",
    "Entries" : [
      {
        "Name"  : "LegacyDefaultPrinterMode",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# download drivers and device software over metered connections
#-------------------
# See $DevicesDownloadOverMetered (settings > bluetooth & devices > devices).

#endregion printers & scanners

#=======================================
## mobile devices
#=======================================
#region mobile devices

# allow this PC to access your mobile devices
#-------------------
# on: 1 | off: 0 (default)
$MobileDevicesAccessThisPC = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Mobility",
    "Entries" : [
      {
        "Name"  : "CrossDeviceEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# phone link
#-------------------
# gpo\ computer config > administrative tpl > system > group policy
#   phone-PC linking on this device
# gpo\ not configured: delete (default) | off: 0
# user\ on: 1 | off: 0 (default)
$MobileDevicesPhoneLink = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableMmx",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Mobility",
    "Entries" : [
      {
        "Name"  : "PhoneLinkEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show me suggestions for using my mobile device with Windows
#-------------------
# on: 1 (default) | off: 0
$MobileDevicesPhoneLinkUsageSuggestions = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Mobility",
    "Entries" : [
      {
        "Name"  : "OptedIn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion mobile devices

#=======================================
## mouse
#=======================================
#region mouse

# primary mouse button
#-------------------
# left: 0 (default) | right: 1
$MousePrimaryButton = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Mouse",
    "Entries" : [
      {
        "Name"  : "SwapMouseButtons",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# mouse pointer speed
#-------------------
# default: 10 (range 1-20)
$MousePointerSpeed = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Mouse",
    "Entries" : [
      {
        "Name"  : "MouseSensitivity",
        "Value" : "10",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# enhance pointer precision
#-------------------
# on: 1 6 10 (default) | off: 0
$MouseEnhancedPointerPrecision = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Mouse",
    "Entries" : [
      {
        "Name"  : "MouseSpeed",
        "Value" : "0",
        "Type"  : "String"
      },
      {
        "Name"  : "MouseThreshold1",
        "Value" : "0",
        "Type"  : "String"
      },
      {
        "Name"  : "MouseThreshold2",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# roll the mouse wheel to scroll
# lines to scroll at a time
#-------------------
# multiple lines at times: 3 (default) (range 1-100) | one screen at a time: -1
$MouseWheelScroll = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "WheelScrollLines",
        "Value" : "3",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# scroll inactive windows when hovering over them
#-------------------
# on: 2 (default) | off: 0
$MouseScrollInactiveWindows = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "MouseWheelRouting",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# scrolling direction
#-------------------
# down motion scrolls down: 0 (default) | down motion scrolls up: 1
$MouseScrollingDirection = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Mouse",
    "Entries" : [
      {
        "Name"  : "ReverseMouseWheelDirection",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion mouse

#=======================================
## touchpad
#=======================================
#region touchpad

# touchpad
#-------------------
# on: 1 (default) | off: 0
$Touchpad = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad\\Status",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# leave touchpad on when a mouse is connected
#-------------------
# on: 1 (default) | off: 0
$TouchpadWhenMouseConnected = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "LeaveOnWithMouse",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# cursor speed
#-------------------
# default: 10 (range 2-20)
$TouchpadCursorSpeed = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "CursorSpeed",
        "Value" : "10",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### taps
#===================
# touchpad sensitivity
#-------------------
# Most sensitive: 0 | High sensitivity: 1 | Medium sensitivity: 2 (default) | Low sensitivity: 3
$TouchpadSensitivity = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "AAPThreshold",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# tap with a single finger to single-click
# tap with two fingers to right-click
# tap twice and drag to multi-select
# press the lower right corner of the touchpad to right-click
#-------------------
# on: 1 (default) | off: 0
$TouchpadTaps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "TapsEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "TwoFingerTapEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "TapAndDrag",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "RightClickZoneEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### scroll & zoom
#===================
# drag two fingers to scroll
#-------------------
# on: 1 (default) | off: 0
$TouchpadDragTwoFingersToScroll = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "PanEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# scrolling direction
#-------------------
# Down motion scrolls up: 0 (default) | Down motion scrolls down: 1
$TouchpadScrollingDirection = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "ScrollDirection",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# pinch to zoom
#-------------------
# on: 1 (default) | off: 0
$TouchpadPinchToZoom = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PrecisionTouchPad",
    "Entries" : [
      {
        "Name"  : "ZoomEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion touchpad

#=======================================
## pen & windows ink
#=======================================
#region pen & windows ink

# gpo\ computer config > administrative tpl > windows components > windows ink workspace
#   allow windows ink workspace
# not configured: delete (default) | on, disallow above lock: 1 | on: 2 | off: 0 (also remove setting from the GUI)
$PenAndWindowsInkGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\WindowsInkWorkspace",
    "Entries" : [
      {
        "Name"  : "AllowWindowsInkWorkspace",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion pen & windows ink

#=======================================
## autoplay
#=======================================
#region autoplay

# use AutoPlay for all media and devices
#-------------------
# gpo\ computer config > administrative tpl > windows components > autoPlay policies
#   turn off autoplay
#   disallow autoplay for non-volume devices (MTP devices like cameras or phones)
# gpo\ not configured: delete (default) | off: 255 (all drives), 181 (CD-ROM and removable media drives)
# gpo non-volume devices\ not configured: delete (default) | off: 1
# user\ on: 0 (default) | off: 1
$AutoPlay = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoDriveTypeAutoRun",
        "Value" : "255",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoAutoplayfornonVolume",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\AutoplayHandlers",
    "Entries" : [
      {
        "Name"  : "DisableAutoplay",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion autoplay

#=======================================
## usb
#=======================================
#region usb

# connection notifications (if issues with usb)
#-------------------
# on: 1 (default) | off: 0
$UsbNotificationIssues = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Shell\\USB",
    "Entries" : [
      {
        "Name"  : "NotifyOnUsbErrors",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# usb battery saver
#-------------------
# on: 1 (default) | off: 0
$UsbBatterySaver = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\USB\\AutomaticSurpriseRemoval",
    "Entries" : [
      {
        "Name"  : "AttemptRecoveryFromUsbPowerDrain",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show a notification if this PC is charging slowly over USB
#-------------------
# on: 1 (default) | off: 0
$UsbNotificationChargingSlowly = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Shell\\USB",
    "Entries" : [
      {
        "Name"  : "NotifyOnWeakCharger",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion usb

#endregion settings > bluetooth & devices


#==============================================================================
#                        settings > network & internet
#==============================================================================
#region settings > network & internet

#=======================================
## ethernet or wi-fi
#=======================================
#region ethernet or wi-fi

#===================
### properties
#===================
# network profile type
#-------------------
# Change 'Wi-Fi', 'Ethernet', and all currently connected network.

# Public (default) | Private | DomainAuthenticated
function Set-ConnectedNetworkToPrivate
{
    Write-Verbose -Message "Setting 'Connected Network' To 'Private' ..."
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory 'Private'
}

#endregion ethernet or wi-fi

#=======================================
## proxy
#=======================================
#region proxy

# See also $WPADProtocol (tweaks > network > Web Proxy Auto-Discovery protocol (WPAD)).

# automatically detect settings
#-------------------
# 9th byte, 4th bit\ on: 1 (default) | off: 0
# 9th byte value\ on: 9 (default) | off: 1
$AutoDetectSettings = $false
$ProxyPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Internet Settings\Connections'
$ProxyByteValue = (Get-ItemProperty -Path $ProxyPath).DefaultConnectionSettings
$AutoDetectSettingsBitMask = 8
$ProxyByteValue[8] = $AutoDetectSettings ? $ProxyByteValue[8] -bor $AutoDetectSettingsBitMask :
                                           $ProxyByteValue[8] -band -bnot $AutoDetectSettingsBitMask
#$ProxyByteValue[8] = $AutoDetectSettings ? 9 : 1
$ProxyByteValue[4] = $ProxyByteValue[4] -eq 255 ? 2 : $ProxyByteValue[4] + 1
$ProxyAutoDetectSettings = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\Connections",
    "Entries" : [
      {
        "Name"  : "DefaultConnectionSettings",
        "Value" : "$ProxyByteValue",
        "Type"  : "Binary"
      }
    ]
  }
]'.Replace('$ProxyByteValue', $ProxyByteValue) | ConvertFrom-Json

#endregion proxy

#=======================================
## advanced network settings
#=======================================
#region advanced network settings

# See also 'tweaks > network' for protocols configuration.

#===================
### ethernet or wi-fi
#===================
# view additional properties
#-------------------
# DNS server assignment

[regex]$MatchComment = '(?m) #.*$'
$DnsProviders = '{
    "Adguard": {
        "Default": { # Ads, Trackers, Malware
            "Doh": "https://dns.adguard-dns.com/dns-query",
            "IPv4": [
                "94.140.14.14",
                "94.140.15.15"
            ],
            "IPv6": [
                "2a10:50c0::ad1:ff",
                "2a10:50c0::ad2:ff"
            ]
        },
        "Unfiltered": {
            "Doh": "https://unfiltered.adguard-dns.com/dns-query",
            "IPv4": [
                "94.140.14.140",
                "94.140.14.141"
            ],
            "IPv6": [
                "2a10:50c0::1:ff",
                "2a10:50c0::2:ff"
            ]
        },
        "Family": { # Ads, Trackers, Malware, Adult
            "Doh": "https://family.adguard-dns.com/dns-query",
            "IPv4": [
                "94.140.14.15",
                "94.140.15.16"
            ],
            "IPv6": [
                "2a10:50c0::bad1:ff",
                "2a10:50c0::bad2:ff"
            ]
        }
    },
    "Cloudflare": {
        "Default": { # Unfiltered
            "Doh": "https://cloudflare-dns.com/dns-query",
            "IPv4": [
                "1.1.1.1",
                "1.0.0.1"
            ],
            "IPv6": [
                "2606:4700:4700::1111",
                "2606:4700:4700::1001"
            ]
        },
        "Security": { # Malware
            "Doh": "https://security.cloudflare-dns.com/dns-query",
            "IPv4": [
                "1.1.1.2",
                "1.0.0.2"
            ],
            "IPv6": [
                "2606:4700:4700::1112",
                "2606:4700:4700::1002"
            ]
        },
        "Family": { # Malware, Adult
            "Doh": "https://family.cloudflare-dns.com/dns-query",
            "IPv4": [
                "1.1.1.3",
                "1.0.0.3"
            ],
            "IPv6": [
                "2606:4700:4700::1113",
                "2606:4700:4700::1003"
            ]
        }
    },
    "Mullvad": { # does not support unencrypted DNS
        "Default": { # Unfiltered
            "Doh": "https://dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.2"
            ],
            "IPv6": [
                "2a07:e340::2"
            ]
        },
        "Adblock": { # Ads, Trackers
            "Doh": "https://adblock.dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.3"
            ],
            "IPv6": [
                "2a07:e340::3"
            ]
        },
        "Base": { # Ads, Trackers, Malware
            "Doh": "https://base.dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.4"
            ],
            "IPv6": [
                "2a07:e340::4"
            ]
        },
        "Extended": { # Ads, Trackers, Malware, Social media
            "Doh": "https://extended.dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.5"
            ],
            "IPv6": [
                "2a07:e340::5"
            ]
        },
        "Family": { # Ads, Trackers, Malware, Adult, Gambling
            "Doh": "https://family.dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.6"
            ],
            "IPv6": [
                "2a07:e340::6"
            ]
        },
        "All": { # Ads, Trackers, Malware, Adult, Gambling, Social media
            "Doh": "https://all.dns.mullvad.net/dns-query",
            "IPv4": [
                "194.242.2.9"
            ],
            "IPv6": [
                "2a07:e340::9"
            ]
        }
    },
    "Quad9": {
        "Default": { # Malware
            "Doh": "https://dns.quad9.net/dns-query",
            "IPv4": [
                "9.9.9.9",
                "149.112.112.112"
            ],
            "IPv6": [
                "2620:fe::fe",
                "2620:fe::9"
            ]
        },
        "Unfiltered": {
            "Doh": "https://dns10.quad9.net/dns-query",
            "IPv4": [
                "9.9.9.10",
                "149.112.112.10"
            ],
            "IPv6": [
                "2620:fe::10",
                "2620:fe::fe:10"
            ]
        }
    }
}' -replace $MatchComment | ConvertFrom-Json

function Set-DnsProvider
{
    <#
    .SYNTAX
        Set-DnsProvider -ResetServerAddresses [<CommonParameters>]

        Set-DnsProvider -Adguard {Default | Unfiltered | Family} [-FallbackToPlaintext] [<CommonParameters>]

        Set-DnsProvider -Cloudflare {Default | Security | Family} [-FallbackToPlaintext] [<CommonParameters>]

        Set-DnsProvider -Mullvad {Default | Adblock | Base | Extended | Family | All} [<CommonParameters>]

        Set-DnsProvider -Quad9 {Default | Unfiltered} [-FallbackToPlaintext] [<CommonParameters>]

    .EXAMPLE
        PS> Set-DnsProvider -Cloudflare 'Family'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            ParameterSetName = 'Reset',
            Mandatory)]
        [switch]
        $ResetServerAddresses,

        [Parameter(ParameterSetName = 'Adguard')]
        [Parameter(ParameterSetName = 'Cloudflare')]
        [Parameter(ParameterSetName = 'Quad9')]
        [switch]
        $FallbackToPlaintext,

        [Parameter(
            ParameterSetName = 'Adguard',
            Mandatory)]
        [ValidateSet(
            'Default',
            'Unfiltered',
            'Family')]
        [string]
        $Adguard,

        [Parameter(
            ParameterSetName = 'Cloudflare',
            Mandatory)]
        [ValidateSet(
            'Default',
            'Security',
            'Family')]
        [string]
        $Cloudflare,

        [Parameter(
            ParameterSetName = 'Mullvad',
            Mandatory)]
        [ValidateSet(
            'Default',
            'Adblock',
            'Base',
            'Extended',
            'Family',
            'All')]
        [string]
        $Mullvad,

        [Parameter(
            ParameterSetName = 'Quad9',
            Mandatory)]
        [ValidateSet(
            'Default',
            'Unfiltered')]
        [string]
        $Quad9
    )

    $NetAdapters = Get-NetAdapter -Physical | Where-Object -Property 'Status' -EQ -Value 'Up'

    $Provider = $PSCmdlet.ParameterSetName
    $Server = switch ($Provider)
	{
        'Adguard'    { $Adguard }
        'Cloudflare' { $Cloudflare }
        'Mullvad'    { $Mullvad }
        'Quad9'      { $Quad9 }
    }

    $RegPath = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Dnscache\InterfaceSpecificParameters\'
    $RegDohIPv4 = '\DohInterfaceSettings\Doh\'
    $RegDohIPv6 = '\DohInterfaceSettings\Doh6\'

    $DohTpl = $DnsProviders.$Provider.$Server.Doh
    $IPv4 = $DnsProviders.$Provider.$Server.IPv4
    $IPv6 = $DnsProviders.$Provider.$Server.IPv6

    foreach ($NetAdapter in $NetAdapters)
    {
        if ($ResetServerAddresses)
        {
            Set-DnsClientServerAddress -InterfaceAlias $NetAdapter.InterfaceAlias -ResetServerAddresses
            Continue
        }

        Set-DnsClientServerAddress -InterfaceAlias $NetAdapter.InterfaceAlias -ServerAddresses $IPv4, $IPv6

        $InterfaceGuid = $NetAdapter.InterfaceGuid
        $RegIPs= @(
            $IPv4.foreach({ "$RegPath\$InterfaceGuid\$RegDohIPv4\$_" })
            $IPv6.foreach({ "$RegPath\$InterfaceGuid\$RegDohIPv6\$_" })
        )
        foreach ($RegIP in $RegIPs)
        {
		    if (-not (Test-Path -Path $RegIP))
		    {
			    New-Item -Path $RegIP -Force | Out-Null
		    }
            # To use automatic template, the DoH template must be registered in the system.
            # See Get-DnsClientDohServerAddress and Add-DnsClientDohServerAddress.
            # template\ Automatic: 1 (with fallback: 5) | Manual: 2 (with fallback: 6)
            $DohFlags = 2
            if ($FallbackToPlaintext)
            {
                $DohFlags += 4
            }
            Set-ItemProperty -Path $RegIP -Name 'DohFlags' -Value $DohFlags -Type 'QWord' | Out-Null
            Set-ItemProperty -Path $RegIP -Name 'DohTemplate' -Value $DohTpl -Type 'String' | Out-Null
        }
    }

    Clear-DnsClientCache
}

#endregion advanced network settings

#endregion settings > network & internet


#==============================================================================
#                         settings > personnalization
#==============================================================================
#region settings > personnalization

#=======================================
## background
#=======================================
#region background

# personalize your background
#-------------------
# Default images location: C:\Windows\Web\Wallpaper
# ThemeA: Glow, ThemeB: Captured Motion, ThemeC: Sunrive, ThemeD: Flow
$BackgroundWallpaper = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "WallPaper",
        "Value" : "$env:SystemDrive\\Windows\\Web\\Wallpaper\\ThemeC\\img28.jpg",
        "Type"  : "String"
      }
    ]
  }
]'.Replace('$env:SystemDrive', $env:SystemDrive) | ConvertFrom-Json

# choose a fit for your desktop image
#-------------------
# fill: 10 (default) | fit: 6 | stretch: 2 | span: 22
# tile: 0 (+ "TileWallpaper": 1) | center: 0 (+ "TileWallpaper": 0)
$BackgroundWallpaperStyle = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "WallpaperStyle",
        "Value" : "10",
        "Type"  : "String"
      },
      {
        "Name"  : "TileWallpaper",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion background

#=======================================
## colors
#=======================================
#region colors

# choose your mode
#-------------------
# light: 1 (default) | dark: 0
$ColorsMode = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
    "Entries" : [
      {
        "Name"  : "AppsUseLightTheme",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SystemUsesLightTheme",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# transparency effects
#-------------------
# on: 1 (default) | off: 0
$ColorsTransparency = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
    "Entries" : [
      {
        "Name"  : "EnableTransparency",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# accent color
#-------------------
# manual: 0 | automatic: 1 (default)
# default manual color: blue (#0078D4)
$ColorsAccentColor = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Desktop",
    "Entries" : [
      {
        "Name"  : "AutoColorization",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show accent color on Start and taskbar (requires dark mode enabled)
#-------------------
# on: 1 | off: 0 (default)
$ColorsAccentColorOnStartAndTaskBar = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Themes\\Personalize",
    "Entries" : [
      {
        "Name"  : "ColorPrevalence",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show accent color on title bars and windows borders
#-------------------
# on: 1 | off: 0 (default)
$ColorsAccentColorOnTitleAndBorders = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\DWM",
    "Entries" : [
      {
        "Name"  : "ColorPrevalence",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion colors

#=======================================
## themes
#=======================================
#region themes

#===================
### desktop icon settings
#===================
# desktop icons
#-------------------
# on: 0 | off: 1
# entries order: Computer, User's Files, Network, Recycle Bin, Control Panel
$ThemesDesktopIcons = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\HideDesktopIcons\\NewStartPanel",
    "Entries" : [
      {
        "Name"  : "{20D04FE0-3AEA-1069-A2D8-08002B30309D}",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "{59031a47-3f72-44a7-89c5-5595fe6b30ee}",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "{645FF040-5081-101B-9F08-00AA002F954E}",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\HideDesktopIcons\\ClassicStartMenu",
    "Entries" : [
    ]
  }
]' | ConvertFrom-Json
$ThemesDesktopIcons[1].Entries = $ThemesDesktopIcons[0].Entries

# allow themes to change desktop icons
#-------------------
# on: 1 (default) | off: 0
$ThemesChangesDesktopIcons = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Themes",
    "Entries" : [
      {
        "Name"  : "ThemeChangesDesktopIcons",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion themes

#=======================================
## dynamic lighting
#=======================================
#region dynamic lighting

# use dynamic lighting on my device
#-------------------
# on: 1 (default) | off: 0
$DynamicLighting = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Lighting",
    "Entries" : [
      {
        "Name"  : "AmbientLightingEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# compatible apps in the foreground always control lighting
#-------------------
# on: 1 (default) | off: 0
$DynamicLightingControlledByForegroundApp = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Lighting",
    "Entries" : [
      {
        "Name"  : "ControlledByForegroundApp",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion dynamic lighting

#=======================================
## lock screen
#=======================================
#region lock screen

# personalize your lock screen
#-------------------
# Default images location: C:\Windows\Web\Screen

# get fun facts, tips, tricks, and more on your lock screen
#-------------------
# on: 1 (default) | off: 0
$LockScreenFunFactsTipsTricks = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
    "Entries" : [
      {
        "Name"  : "RotatingLockScreenEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "RotatingLockScreenOverlayEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SubscribedContent-338387Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show the lock screen background picture on the sign-in screen
#-------------------
# gpo\ not configured: delete (default) | off: 1 (also remove setting from the GUI)
$LockScreenLogonBackgroundImageGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "DisableLogonBackgroundImage",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

<#
# owner: SYSTEM | full control: SYSTEM
# Requested registry access is not allowed.
# user\ on: 0 (default) | off: 1
$UserSid = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
$PersonnalizationLockScreenLogonBackgroundImage = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\SystemProtectedUserData\\$UserSid\\AnyoneRead\\LockScreen",
    "Entries" : [
      {
        "Name"  : "HideLogonBackgroundImage",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]'.Replace('$UserSid', $UserSid) | ConvertFrom-Json
#>

#endregion lock screen

#=======================================
## start
#=======================================
#region start

# layout
#-------------------
# default: 0 (default) | more pins: 1 | more recommendations: 2
$StartLayout = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Start_Layout",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show recently added apps
#-------------------
# gpo\ computer config > administrative tpl > start menu and taskbar
#   remove "recently added" list from start menu
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$StartRecentlyAddedApps = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "HideRecentlyAddedApps",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Start",
    "Entries" : [
      {
        "Name"  : "ShowRecentList",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show most used apps
#-------------------
# Need: privacy > general > let Windows improve Start and search results by tracking app launches

# gpo\ computer config > administrative tpl > start menu and taskbar
#   show or hide "most used" list from start menu
# gpo\ not configured: delete (default) | on: 1 | off: 2
# user\ on: 1 (default) | off: 0
$StartMostUsedApps = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "ShowOrHideMostUsedApps",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Start",
    "Entries" : [
      {
        "Name"  : "ShowFrequentList",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show recommended files in Start, recent files in File Explorer, and items in Jump Lists
#-------------------
# gpo\ computer config > administrative tpl > start menu and taskbar
#   do not keep history of recently opened documents
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$StartRecentlyOpenedItems = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "RemoveEntry" : true,
        "Name"  : "NoRecentDocsHistory",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Start_TrackDocs",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show recommendations for tips, shortcuts, new apps, and more
#-------------------
# on: 1 (default) | off: 0
$StartRecommendations = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Start_IrisRecommendations",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show account-related notifications
#-------------------
# on: 1 (default) | off: 0
$StartAccountRelatedNotifications = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Start_AccountNotifications",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# folders (choose which folders appear on Start next to the Power button)
#-------------------
# Windows 11 only (Win10 use different values & logic to build the binary data).
# only Power button: empty value (default)
$StartButtonSettings       = '86,08,73,52,aa,51,43,42,9f,7b,27,76,58,46,59,d4'
$StartButtonFileExplorer   = 'bc,24,8a,14,0c,d6,89,42,a0,80,6e,d9,bb,a2,48,82'
$StartButtonDocuments      = 'ce,d5,34,2d,5a,fa,43,45,82,f2,22,e6,ea,f7,77,3c'
$StartButtonDownloads      = '2f,b3,67,e3,de,89,55,43,bf,ce,61,f3,7b,18,a9,37'
$StartButtonMusic          = '20,06,0b,b0,51,7f,32,4c,aa,1e,34,cc,54,7f,73,15'
$StartButtonPictures       = 'a0,07,3f,38,0a,e8,80,4c,b0,5a,86,db,84,5d,bc,4d'
$StartButtonVideos         = 'c5,a5,b3,42,86,7d,f4,42,80,a4,93,fa,ca,7a,88,b5'
$StartButtonNetwork        = '44,81,75,fe,0d,08,ae,42,8b,da,34,ed,97,b6,63,94'
$StartButtonPersonalFolder = '4a,b0,bd,74,4a,f9,68,4f,8b,d6,43,98,07,1d,a8,bc'

$StartFoldersChoice = @(
    $StartButtonSettings
    $StartButtonFileExplorer
   #$StartButtonDocuments
   #$StartButtonDownloads
   #$StartButtonMusic
   #$StartButtonPictures
   #$StartButtonVideos
   #$StartButtonNetwork
   #$StartButtonPersonalFolder
)
$StartFolders = $StartFoldersChoice | Join-String -Separator ','
$StartFoldersByteValue = $StartFolders.Split(',') | ForEach-Object -Process { [byte]"0x$_" }

$StartFoldersNextPowerButton = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Start",
    "Entries" : [
      {
        "Name"  : "VisiblePlaces",
        "Value" : "$StartFoldersByteValue",
        "Type"  : "Binary"
      }
    ]
  }
]'.Replace('$StartFoldersByteValue', $StartFoldersByteValue) | ConvertFrom-Json

# show mobile device in Start
#-------------------
# on: 1 | off: 0 (default)
$StartMobileDeviceInStart = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Start\\Companions\\Microsoft.YourPhone_*",
    "Entries" : [
      {
        "Name"  : "IsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion start

#=======================================
## taskbar
#=======================================
#region taskbar

#===================
### taskbar items
#===================
# search
#-------------------
# gpo\ computer config > administrative tpl > windows components > search
#   configures search on the taskbar
# gpo\ not configured: delete (default) | value: see user\ below
# user\ hide: 0 | search icon only: 1 | search box: 2 (default) | search icon and label: 3
$TaskbarSearchButton = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search",
    "Entries" : [
      {
        "Name"  : "SearchOnTaskbarMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Search",
    "Entries" : [
      {
        "Name"  : "SearchboxTaskbarMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# copilot | old, Copilot is now an app
#-------------------
# on: 1 (default) | off: 0
$TaskbarCopilotButton = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowCopilotButton",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# task view
#-------------------
# gpo\ computer config > administrative tpl > start menu and taskbar
#   hide the taskview button
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$TaskbarTaskViewButton = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "HideTaskViewButton",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowTaskViewButton",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

<#
# widgets
#-------------------
# UCPD filter driver prevent the modification of this registry key.
# Requested registry access is not allowed.
# on: 1 (default) | off: 0
$TaskbarWidgetsButton = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarDa",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json
#>

# chat (Microsoft Teams) | old
#-------------------
# gpo\ computer config > administrative tpl > windows components > chat
#   configures the Chat icon on the taskbar
# gpo\ not configured: delete (default) | off: 3
# user\ on: 1 (default) | off: 0
$TaskbarChatButton = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Chat",
    "Entries" : [
      {
        "Name"  : "ChatIcon",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarMn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### system tray icons
#===================
# pen menu
#-------------------
# on: 1 (default) | off: 0
$TaskbarTrayIconsPenMenu = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\PenWorkspace",
    "Entries" : [
      {
        "Name"  : "PenWorkspaceButtonDesiredVisibility",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# touch keyboard
#-------------------
# never: 0 | always: 1 (default) | when no keyboard attached: 2
$TaskbarTrayIconsTouchKeyboard = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\TabletTip\\1.7",
    "Entries" : [
      {
        "Name"  : "TipbandDesiredVisibility",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# virtual touchpad
#-------------------
# on: 1 | off: 0 (default)
$TaskbarTrayIconsVirtualTouchpad = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Touchpad",
    "Entries" : [
      {
        "Name"  : "TouchpadDesiredVisibility",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### other system tray icons
#===================
# hidden icon menu
#-------------------
# If turned off, don't forget to manually turn on icons you want to be visible.

# on: 1 (default) | off: 0
$TaskbarTrayIconsHiddenIconMenu = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\CurrentVersion\\TrayNotify",
    "Entries" : [
      {
        "Name"  : "SystemTrayChevronVisibility",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### taskbar behaviors
#===================
# taskbar alignment
#-------------------
# center: 1 (default) | left: 0
$TaskbarAlignment = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarAl",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatically hide the taskbar
#-------------------
# 9th byte, first bit\ on: 1 | off: 0 (default)
# 9th byte value\ on: 123 (hex: 7b) | off: 122 (hex: 7a) (default)
$AutoHideTaskbar = $false
$AutoHidePath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
$AutoHideByteValue = (Get-ItemProperty -Path $AutoHidePath).Settings
$AutoHideBitMask = 1
$AutoHideByteValue[8] = $AutoHideTaskbar ? $AutoHideByteValue[8] -bor $AutoHideBitMask :
                                           $AutoHideByteValue[8] -band -bnot $AutoHideBitMask
#$AutoHideByteValue[8] = $AutoHideTaskbar ? 123 : 122
$TaskbarAutoHide = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\StuckRects3",
    "Entries" : [
      {
        "Name"  : "Settings",
        "Value" : "$AutoHideByteValue",
        "Type"  : "Binary"
      }
    ]
  }
]'.Replace('$AutoHideByteValue', $AutoHideByteValue) | ConvertFrom-Json

# show badges on taskbar apps
#-------------------
# on: 1 (default) | off: 0
$TaskbarBadges = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarBadges",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show flashing on taskbar apps
#-------------------
# on: 1 (default) | off: 0
$TaskbarFlashing = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarFlashing",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show my taskbar on all displays
#-------------------
# gpo\ user config > administrative tpl > start menu and taskbar
#   do not allow taskbars on more than one display
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 | off: 0 (default)
$TaskbarOnAllDisplays = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\Explorer",
    "Entries" : [
      {
        "Name"  : "TaskbarNoMultimon",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "MMTaskbarEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# when using multiple displays, show my taskbar apps on
#-------------------
# Need "MMTaskbarEnabled" enabled.

# all taskbars: 0 (default)
# main taskbar and taskbar where window is open: 1
# taskbar where window is open: 2
$TaskbarMultipleDisplaysTaskbarAppsVisibility = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "MMTaskbarMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# share any window from my taskbar
#-------------------
# on: 1 (default) | off: 0
$TaskbarShareWindow = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarSn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# select the far corner of the taskbar to show the desktop
#-------------------
# on: 1 (default) | off: 0
$TaskbarFarCornerShowDesktop = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarSd",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# combine taskbar buttons and hide labels
# combine taskbar buttons and hide labels on other taskbars
#-------------------
# gpo\ user config > administrative tpl > start menu and taskbar
#   prevent grouping of taskbar items
# gpo\ not configured: delete (default) | off: 1
# user\ always: 0 (default) | when taskbar is full: 1 | never: 2
$TaskbarCombineButtonsAndHideLabels = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Policies\\Explorer",
    "Entries" : [
      {
        "Name"  : "NoTaskGrouping",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "TaskbarGlomLevel",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "MMTaskbarGlomLevel",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show hover cards for inactive and pinned taskbar apps
#-------------------
# on: 1 (default) | off: 0
$TaskbarHoverCardsInactiveApps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "JumplistOnHover",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion taskbar

#=======================================
## device usage
#=======================================
#region device usage

# on: 1 | off: 0 (default)
function New-DeviceUsageRegData
{
    <#
    .SYNTAX
        New-DeviceUsageRegData [-Key] <string> [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> $DeviceUsageDevelopment = New-DeviceUsageRegData -Key 'developer' -State 'Disabled'
        PS> $DeviceUsageDevelopment | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Key,

        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    $NewData = '[
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CloudExperienceHost\\Intent\\",
        "Entries" : [
          {
            "Name"  : "Intent",
            "Value" : "",
            "Type"  : "DWord"
          },
          {
            "Name"  : "Priority",
            "Value" : "0",
            "Type"  : "DWord"
          }
        ]
      }
    ]' | ConvertFrom-Json

    $NewData.Path += $Key
    $NewData.Entries[0].Value = $State -eq 'Enabled' ? 1 : 0
    $NewData
}

# If at least one 'Device Usage' option is enabled, this entry must be enabled.
$DeviceUsageConsent = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CloudExperienceHost\\Intent\\OffDeviceConsent",
    "Entries" : [
      {
        "Name"  : "accepted",
        "Value" : "",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

$DeviceUsageOption = @{
    Disabled = @(
        'developer'     # development
        'gaming'        # gaming
        'family'        # family
        'creative'      # creativity
        'schoolwork'    # school
        'entertainment' # entertainment
        'business'      # business
    )
    Enabled = @(
    )
}

$DeviceUsage = $DeviceUsageOption.GetEnumerator() |
    ForEach-Object -Process {
        foreach ($Item in $_.Value)
        {
            New-DeviceUsageRegData -Key $Item -State $_.Key
        }
    }

$DeviceUsageConsent.Entries[0].Value = $DeviceUsageOption.Enabled.Count ? 1 : 0
$DeviceUsage += $DeviceUsageConsent

#endregion device usage

#endregion settings > personnalization


#==============================================================================
#                               settings > apps
#==============================================================================
#region settings > apps

#=======================================
## advanced app settings
#=======================================
#region advanced app settings

# choose where to get apps
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows defender smartScreen > explorer
#   configure app install control
# gpo\ not configured: delete (default) | on: 1 + string value (see user\ below)
# user\ Anywhere (default) | Recommendations | PreferStore | StoreOnly
$AdvancedSettingsWhereGetApps = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows Defender\\SmartScreen",
    "Entries" : [
      {
        "Name"  : "ConfigureAppInstallControlEnabled",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ConfigureAppInstallControl",
        "Value" : "Anywhere",
        "Type"  : "String"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "AicEnabled",
        "Value" : "Anywhere",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# share across devices
#-------------------
# For GPO see $WindowsSharedExperienceGPO (tweaks > miscellaneous > windows shared experience).
# If disabled, 'SettingsPage\RomeSdkChannelUserAuthzPolicy' value does not matter.

# off: 0 | my devices only: 1 (default) | everyone nearby: 2
$AdvancedSettingsShareAcrossDevices = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CDP",
    "Entries" : [
      {
        "Name"  : "CdpSessionUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "RomeSdkChannelUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CDP\\SettingsPage",
    "Entries" : [
      {
        "Name"  : "RomeSdkChannelUserAuthzPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# archive apps
#-------------------
# To apply to all users, replace '$UserSid' with '*' in the Path.

# gpo\ computer config > administrative tpl > windows components > app package deployment
#   archive infrequently used apps
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 (default) | off: 0
$UserSid = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
$AdvancedSettingsArchiveApps = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Appx",
    "Entries" : [
      {
        "Name"  : "AllowAutomaticAppArchiving",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\InstallService\\Stubification\\$UserSid",
    "Entries" : [
      {
        "Name"  : "EnableAppOffloading",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]'.Replace('$UserSid', $UserSid) | ConvertFrom-Json

#endregion advanced app settings

#=======================================
## offline maps
#=======================================
#region offline maps

# metered connection
#-------------------
# on: 0 | off: 1 (default)
$OfflineMapsMeteredConnection = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\Maps",
    "Entries" : [
      {
        "Name"  : "UpdateOnlyOnWifi",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# maps update
#-------------------
# gpo\ computer config > administrative tpl > windows components > maps
#   turn off automatic download and update of map data
#   turn off unsolicited network traffic on the Offline Maps settings page
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 (default) | off: 0
$OfflineMapsAutoUpdate = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Maps",
    "Entries" : [
      {
        "Name"  : "AutoDownloadAndUpdateMapData",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AllowUntriggeredNetworkTrafficOnSettingsPage",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\Maps",
    "Entries" : [
      {
        "Name"  : "AutoUpdateEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion offline maps

#=======================================
## apps for websites
#=======================================
#region apps for websites

# open links in an app instead of a browser
#-------------------
# gpo\ computer config > administrative tpl > system > group policy
#   configure web-to-app linking with app URL handlers
# not configured: delete (default) | off: 0
$OpenLinksInAppGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableAppUriHandlers",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion apps for websites

#endregion settings > apps


#==============================================================================
#                             settings > accounts
#==============================================================================
#region settings > accounts

#=======================================
## your info
#=======================================
#region your info

# account setting
#-------------------
# gpo\ computer config > windows settings > security settings > local policies > security options
#   accounts: block Microsoft accounts
# not configured: delete (default)
# users can't add Microsoft accounts: 1
# users can't add or log on with Microsoft accounts: 3
$YourInfoAccountSettingGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
    "Entries" : [
      {
        "Name"  : "NoConnectedUser",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion your info

#=======================================
## sign-in options
#=======================================
#region sign-in options

# biometrics
#-------------------
# If disabled, you'll see this message in the setting: 'something went wrong. try again later.'

# gpo\ computer config > administrative tpl > windows components > biometrics
#   allow the use of biometrics
# not configured: delete (default) | off: 0
$SignInBiometricsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Biometrics",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# sign in with an external camera or fingerprint reader
#-------------------
# on: 0 (default) | off: 1
$SignInExternalCameraOrFingerprint = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\WinBio",
    "Entries" : [
      {
        "Name"  : "SupportPeripheralsWithEnhancedSignInSecurity",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# for improved security, only allow Windows Hello sign-in for Microsoft accounts on this device
#-------------------
# Require a Microsoft account to have this option visible.

# on: 0 | off: 2 (default)
$SignInOnlyAllowWindowsHelloOnThisDevice = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\PasswordLess\\Device",
    "Entries" : [
      {
        "Name"  : "DevicePasswordLessBuildVersion",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# if you've been away, when should Windows require you to sign in again
#-------------------
# Only available if your account has a password.

function Test-ModernStandbySupport
{
    $PowercfgOutput = powercfg.exe /a
    $AvailableStates = $PowercfgOutput |
        Where-Object { -not [string]::IsNullOrWhiteSpace($_) } |
        Select-Object -First $PowercfgOutput.IndexOf("")
    $S0Support = $AvailableStates | Select-String -Pattern 'S0' -Quiet
    $S0Support
}

function Set-RequireSignInOnWakeUpModernStandby
{
    <#
    .SYNTAX
        Set-RequireSignInOnWakeUpModernStandby [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-RequireSignInOnWakeUpModernStandby -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    # Never: 4294967295 (hex: ffffffff) | Every Time: 0 (default)
    # 1 minute: 60 | 3 minutes: 180 | 5 minutes: 300 | 15 minutes: 900
    $Value = $State -eq 'Enabled' ? '0' : '4294967295'
    $SignInRequiredOnWakeUpModernStandby = '[
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Control Panel\\Desktop",
        "Entries" : [
          {
            "Name"  : "DelayLockInterval",
            "Value" : "$Value",
            "Type"  : "DWord"
          }
        ]
      }
    ]'.Replace('$Value', $Value) | ConvertFrom-Json

    Set-RegistryEntry -InputObject $SignInRequiredOnWakeUpModernStandby -Verbose:$false
}

function Set-RequireSignInOnWakeUpNotModernStandby
{
    <#
    .SYNTAX
        Set-RequireSignInOnWakeUpNotModernStandby [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-RequireSignInOnWakeUpNotModernStandby -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    # gpo\ computer config > administrative tpl > windows components > system > power management > sleep settings
    #   require a password when a computer wakes (plugged in)
    #   require a password when a computer wakes (on battery)
    # gpo\ not configured: delete (default) | on: 1 | off: 0
    $Value = $State -eq 'Enabled' ? 1 : 0
    $SignInRequiredOnWakeUpNotModernStandby = '[
      {
        "SkipKey" : true,
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Policies\\Microsoft\\Power\\PowerSettings\\0e796bdb-100d-47d6-a2d5-f7d2daa51f51",
        "Entries" : [
          {
            "Name"  : "ACSettingIndex",
            "Value" : "$Value",
            "Type"  : "DWord"
          },
          {
            "Name"  : "DCSettingIndex",
            "Value" : "$Value",
            "Type"  : "DWord"
          }
        ]
      }
    ]'.Replace('$Value', $Value) | ConvertFrom-Json

    Set-RegistryEntry -InputObject $SignInRequiredOnWakeUpNotModernStandby -Verbose:$false

    # user\ Never: 0 | When PC wakes up from sleep: 1 (default)
    powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_NONE CONSOLELOCK $Value
    powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_NONE CONSOLELOCK $Value
}

function Set-RequireSignInOnWakeUp
{
    <#
    .SYNTAX
        Set-RequireSignInOnWakeUp [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-RequireSignInOnWakeUp -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Require Sign-In On WakeUp' to '$State' ..."
    if (Test-ModernStandbySupport)
    {
        Set-RequireSignInOnWakeUpModernStandby -State $State
    }
    else
    {
        Set-RequireSignInOnWakeUpNotModernStandby -State $State
    }
}

function Enable-RequireSignInOnWakeUp
{
    Set-RequireSignInOnWakeUp -State 'Enabled'
}

function Disable-RequireSignInOnWakeUp
{
    Set-RequireSignInOnWakeUp -State 'Disabled'
}

# dynamic lock: allow Windows to automatically lock your device when you're away
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows hello for business
#   configure dynamic lock factors
# gpo\ not configured: delete (default) | on: 1 + Plugins | off: 0
# user\ on: 1 | off: 0 (default)
$PluginsDefaultValue = "
<rule schemaVersion='1.0'>
    <signal type='bluetooth' scenario='Dynamic Lock' classOfDevice='512' rssiMin='-10' rssiMaxDelta='-10'/>
</rule>"
$SignInDynamicLock = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\PassportForWork\\DynamicLock",
    "Entries" : [
      {
        "Name"  : "DynamicLock",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "RemoveEntry" : true,
        "Name"  : "Plugins",
        "Value" : "$PluginsDefaultValue",
        "Type"  : "String"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon",
    "Entries" : [
      {
        "Name"  : "EnableGoodbye",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]'.Replace('$PluginsDefaultValue', $PluginsDefaultValue) | ConvertFrom-Json

# automatically save my restartable apps and restart them when I sign back in
#-------------------
# on: 1 (default) | off: 0
$SignInRestartApps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon",
    "Entries" : [
      {
        "Name"  : "RestartApps",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show account details such as my email address on the sign-in screen
#-------------------
# gpo\ computer config > administrative tpl > system > logon
#   block user from showing account details on sign-in
# not configured: delete (default) | off: 1
$SignInShowAccountDetailsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "BlockUserFromShowingAccountDetailsOnSignin",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

<#
# owner: SYSTEM | full control: SYSTEM
# Requested registry access is not allowed.
# user\ on: 1 | off: 0 (default)
$UserSid = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
$AccountsSignInShowAccountDetails = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\SystemProtectedUserData\\$UserSid\\AnyoneRead\\Logon",
    "Entries" : [
      {
        "Name"  : "ShowEmail",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]'.Replace('$UserSid', $UserSid) | ConvertFrom-Json
#>

# use my sign-in info to automatically finish setting up after an update
#-------------------
# To apply to all users, replace '$UserSid' with '*' in the Path.

# gpo\ computer config > administrative tpl > windows components > windows logon options
#   sign-in and lock last interactive user automatically after a restart
# gpo\ not configured: delete (default) | on: 0 | off: 1
# user\ on: 0 (default) | off: 1
$UserSid = (Get-LocalUser -Name (Get-LoggedUserUsername)).SID.Value
$SignInAutoSettingAfterUpdate = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\System",
    "Entries" : [
      {
        "Name"  : "DisableAutomaticRestartSignOn",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion\\Winlogon\\UserARSO\\$UserSid",
    "Entries" : [
      {
        "Name"  : "OptOut",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]'.Replace('$UserSid', $UserSid) | ConvertFrom-Json

#endregion sign-in options

#endregion settings > accounts


#==============================================================================
#                         settings > time & language
#==============================================================================
#region settings > time & language

#=======================================
## date & time
#=======================================
#region date & time

# set time zone automatically
#-------------------
# Already disabled if location permission is off.

# on: 3 (default) | off: 4
$DateAndTimeAutoTimeZone = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\tzautoupdate",
    "Entries" : [
      {
        "Name"  : "Start",
        "Value" : "4",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# set time automatically
#-------------------
# on: NTP 3 (default) | off: NoSync 4
$DateAndTimeAutoTime = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\W32Time\\Parameters",
    "Entries" : [
      {
        "Name"  : "Type",
        "Value" : "NTP",
        "Type"  : "String"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Services\\W32Time",
    "Entries" : [
      {
        "Name"  : "Start",
        "Value" : "3",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show time and date in the System tray
#-------------------
# on: 1 (default) | off: 0
$DateAndTimeShowInSystemTray = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowSystrayDateTimeValueName",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show abbreviated time and date
#-------------------
# on: 1 | off: 0 (default)
$DateAndTimeShowAbbreviatedTimeAndDate = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowShortenedDateTime",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show seconds in system tray clock (uses more power)
#-------------------
# on: 1 | off: 0 (default)
$DateAndTimeShowSecondsInSystemTray = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "ShowSecondsInSystemClock",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# internet time (NTP server)
#-------------------
# control panel (icons view) > date and time > internet time (timedate.cpl)

function Set-NtpServer
{
    <#
    .SYNTAX
        Set-NtpServer [-Value] <String> [<CommonParameters>]

    .EXAMPLE
        PS> Set-NtpServer -Value 'time.windows.com'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Value
    )

    Write-Verbose -Message "Setting 'NTP server' to '$Value' ..."

    Start-Service -Name 'W32Time'
    w32tm.exe /config /syncfromflags:manual /manualpeerlist:"$Value" /update | Out-Null
}

function Set-NtpServerToPoolNtpOrg
{
    Set-NtpServer -Value '0.pool.ntp.org 1.pool.ntp.org 2.pool.ntp.org 3.pool.ntp.org'
}

#endregion date & time

#=======================================
## language & region
#=======================================
#region language & region

#===================
### regional format
#===================
# first day of week
#-------------------
# Monday: 0
$LanguageAndRegionFormatFirstDayOfWeek = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\International",
    "Entries" : [
      {
        "Name"  : "iFirstDayOfWeek",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# short date
#-------------------
# e.g. 05-Apr-17: dd-MMM-yy
$LanguageAndRegionFormatShortDate = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\International",
    "Entries" : [
      {
        "Name"  : "sShortDate",
        "Value" : "dd-MMM-yy",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### administrative language settings
#===================
# change system locale > Beta: Use Unicode UTF-8 for worldwide language support
#-------------------
# default e.g. USA: 1252 1000 437 | UTF-8: 65001
$LanguageSettingsUTF8SystemWide = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SYSTEM\\CurrentControlSet\\Control\\Nls\\CodePage",
    "Entries" : [
      {
        "Name"  : "ACP",
        "Value" : "65001",
        "Type"  : "String"
      },
      {
        "Name"  : "MACCP",
        "Value" : "65001",
        "Type"  : "String"
      },
      {
        "Name"  : "OEMCP",
        "Value" : "65001",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion language & region

#=======================================
## typing
#=======================================
#region typing

# show text suggestions when typing on the software keyboard
# Only works in Windows 10 ? (setting not present in Windows 11)
#-------------------
# on: 1 (default) | off: 0
$TypingTextSuggestionsSoftwareKeyboard = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\TabletTip\\1.7",
    "Entries" : [
      {
        "Name"  : "EnableTextPrediction",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show text suggestions when typing on the physical keyboard
# multilingual text suggestions
#-------------------
# on: 1 | off: 0 (default)
$TypingTextSuggestionsPhysicalKeyboard = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Input\\Settings",
    "Entries" : [
      {
        "Name"  : "EnableHwkbTextPrediction",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "MultilingualEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# autocorrect misspelled words
# highlight misspelled words
#-------------------
# on: 1 (default) | off: 0
$TypingMisspelledWords = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\TabletTip\\1.7",
    "Entries" : [
      {
        "Name"  : "EnableAutocorrection",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "EnableSpellchecking",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# typing insights
#-------------------
# on: 1 (default) | off: 0
$TypingInsights = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Input\\Settings",
    "Entries" : [
      {
        "Name"  : "InsightsEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# advanced keyboard settings
#-------------------
# input language hot keys > between input languages
# not assigned: 3 ('win + space' not affected)
$TypingAdvancedInputLanguageHotKeys = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Keyboard Layout\\Toggle",
    "Entries" : [
      {
        "Name"  : "Hotkey",
        "Value" : "3",
        "Type"  : "String"
      },
      {
        "Name"  : "Language Hotkey",
        "Value" : "3",
        "Type"  : "String"
      },
      {
        "Name"  : "Layout Hotkey",
        "Value" : "3",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion typing

#endregion settings > time & language


#==============================================================================
#                              settings > gaming
#==============================================================================
#region settings > gaming

#=======================================
## gameDVR
#=======================================
#region gameDVR

# See also $FullscreenOptimizations (tweaks > miscellaneous > fullscreen optimizations).

# game recording
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows game recording and broadcasting
#   enables or disables Windows game recording and broadcasting
# gpo\ not configured: delete (default) | off: 0
# PolicyManager\ on: 1 (default) | off: 0
# user\ on: 1 (default) | off: 0
$GameDVR = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\GameDVR",
    "Entries" : [
      {
        "Name"  : "AllowgameDVR",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\PolicyManager\\default\\ApplicationManagement\\AllowGameDVR",
    "Entries" : [
      {
        "Name"  : "value",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR",
    "Entries" : [
      {
        "Name"  : "AppCaptureEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "System\\GameConfigStore",
    "Entries" : [
      {
        "Name"  : "GameDVR_Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion gameDVR

#=======================================
## game bar
#=======================================
#region game bar

# allow your controller to open Game Bar
#-------------------
# on: 1 | off: 0 (default)
$GameBarOpenWithController = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\GameBar",
    "Entries" : [
      {
        "Name"  : "UseNexusForGameBarEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion game bar

#=======================================
## captures
#=======================================
#region captures

# record what happened
#-------------------
# on: 1 | off: 0 (default)
$CapturesRecordWhatHappened = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\GameDVR",
    "Entries" : [
      {
        "Name"  : "HistoricalCaptureEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion captures

#=======================================
## game mode
#=======================================
#region game mode

# game mode
#-------------------
# on: 1 (default) | off: 0
$GameMode = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\GameBar",
    "Entries" : [
      {
        "Name"  : "AutoGameModeEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion game mode

#endregion settings > gaming


#==============================================================================
#                          settings > accessibility
#==============================================================================
#region settings > accessibility

#=======================================
## visual effects
#=======================================
#region visual effects

# always show scrollbars
#-------------------
# on: 0 | off: 1 (default)
$VisualEffectsAlwaysShowScrollbars = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility",
    "Entries" : [
      {
        "Name"  : "DynamicScrollbars",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# transparency effects
#-------------------
# See $ColorsTransparency (settings > personnalization > colors)

# animation effects
# See also $VisualEffectsMode (tweaks > system properties > advanced).
#-------------------
# default: on
# off: disable the following effects:
# (The GUI toggle will be 'on' if at least one of these effects is enabled)
#   Animate controls and elements inside windows
#   Animate windows when minimizing and maximizing
#   Fade or slide menus into view
#   Fade or slide ToolTips into view
#   Fade out menu items after clicking
#   Slide open combo boxes
#   Smooth-scroll list boxes
function Set-VisualEffectsAnimationEffects
{
    <#
    .SYNTAX
        Set-VisualEffectsAnimationEffects [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-VisualEffectsAnimationEffects -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    $AccessibilityVisualEffectsAnimationEffects = $VisualEffectsCustomPart1 |
        Where-Object -FilterScript { $_.Name -notlike 'Show shadows*' }

    $SystemPropertiesVisualEffectsMinMaxAnimate = $VisualEffectsCustomPart2 |
        Where-Object -FilterScript { $_.Entries[0].Name -eq 'MinAnimate' }

    switch ($State)
    {
        'Enabled'
        {
            $AccessibilityVisualEffectsAnimationEffects.ForEach({ $_.State = 'Enabled' })
            $SystemPropertiesVisualEffectsMinMaxAnimate.Entries[0].Value = '1'
        }
        'Disabled'
        {
            $AccessibilityVisualEffectsAnimationEffects.ForEach({ $_.State = 'Disabled' })
            $SystemPropertiesVisualEffectsMinMaxAnimate.Entries[0].Value = '0'
        }
    }

    Write-Verbose -Message "Setting 'Animation Effects' to '$State' ..."
    $AccessibilityVisualEffectsAnimationEffects | Set-SystemPropertiesVisualEffects -Verbose:$false
    $SystemPropertiesVisualEffectsMinMaxAnimate | Set-RegistryEntry -Verbose:$false
}

function Enable-VisualEffectsAnimationEffects
{
    Set-VisualEffectsAnimationEffects -State 'Enabled'
}

function Disable-VisualEffectsAnimationEffects
{
    Set-VisualEffectsAnimationEffects -State 'Disabled'
}

# dismiss notifications after this amount of time
#-------------------
# value are in second
# default (and minimum): 5
$VisualEffectsDismissNotificationsTimeout = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility",
    "Entries" : [
      {
        "Name"  : "MessageDuration",
        "Value" : "5",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion visual effects

#=======================================
## contrast themes
#=======================================
#region contrast themes

# keyboard shorcut for contrast themes
#-------------------
# control panel (icons view) > ease of access center > make the computer easier to see
# (control.exe /name Microsoft.EaseOfAccessCenter /page pageKeyboardEasierToUse)
#   turn on or off High Contrast when left ALT + left SHIFT + PRINT SCREEN is pressed
#     display a warning message when turning a setting on
#     make a sound when turning a setting on or off
# on: depends (default) | off: 0
$ContrastThemesKeyboardShorcut = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility\\HighContrast",
    "Entries" : [
      {
        "Name"  : "Flags",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion contrast themes

#=======================================
## narrator
#=======================================
#region narrator

# keyboard shorcut for Narrator
#-------------------
# on: 1 (default) | off: 0
$NarratorKeyboardShorcut = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Narrator\\NoRoam",
    "Entries" : [
      {
        "Name"  : "WinEnterLaunchEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatically send diagnostic and performance data
#-------------------
# on: 1 | off: 0 (default)
$NarratorDiagnosticAndPerformanceData = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Narrator\\NoRoam",
    "Entries" : [
      {
        "Name"  : "DetailedFeedback",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion narrator

#=======================================
## speech
#=======================================
#region speech

function Add-HotkeyToDisable
{
    <#
    .SYNTAX
        Add-HotkeyToDisable [-Hotkey] <string> [-OverrideValue] [<CommonParameters>]

    .DESCRIPTION
        Disable a specific 'Windows + key' shortcut.
        Also disable any combinaison of 'Windows + any + key'.

    .EXAMPLE
        PS> Add-HotkeyToDisable -Hotkey 'XYZ'
        ('DisabledHotkeys' == 'XYZ' + any already existing key)

    .EXAMPLE
        PS> Add-HotkeyToDisable -Hotkey 'XY' -OverrideValue
        ('DisabledHotkeys' == 'XY')
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidatePattern("^[A-Za-z]+$")]
        [string]
        $Hotkey,

        [switch]
        $OverrideValue
    )

    $DisabledHotkeysProperties = @{
        Path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Name = 'DisabledHotkeys'
        Type = 'String'
    }
    $DisabledHotkeys = (Get-ItemProperty $DisabledHotkeysProperties.Path).($DisabledHotkeysProperties.Name)

    if ($null -eq $DisabledHotkeys)
    {
        Set-ItemProperty @DisabledHotkeysProperties -Value '' | Out-Null
        $DisabledHotkeys = ''
    }
    else
    {
        $DisabledHotkeys = $OverrideValue ? '' : $DisabledHotkeys.ToUpper()
    }

    foreach ($Key in $Hotkey.ToUpper().ToCharArray())
    {
        if (-not $DisabledHotkeys.Contains($Key))
        {
            $DisabledHotkeys += $Key
        }
    }

    Set-ItemProperty @DisabledHotkeysProperties -Value $DisabledHotkeys | Out-Null
}

# voice typing shortcut (Win + H)
#-------------------
# default: on
function Disable-VoiceTypingShorcut
{
    Write-Verbose -Message 'Disabling Voice Typing shortcut (Win + H) ...'
    Add-HotkeyToDisable -Hotkey 'H'
}

#endregion speech

#=======================================
## keyboard
#=======================================
#region keyboard

# sticky keys
#-------------------
# on: depends (default) | off: 0
$KeyboardStickyKeys = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility\\StickyKeys",
    "Entries" : [
      {
        "Name"  : "Flags",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# filter keys
#-------------------
# on: depends (default) | off: 0
$KeyboardFilterKeys = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility\\Keyboard Response",
    "Entries" : [
      {
        "Name"  : "Flags",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# toggle keys
#-------------------
# on: depends (default) | off: 0
$KeyboardToggleKeys = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility\\ToggleKeys",
    "Entries" : [
      {
        "Name"  : "Flags",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# use the Print screen key to open screen capture
#-------------------
# on: 1 (default) | off: 0
$KeyboardPrintKeyOpenScreenCapture = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Keyboard",
    "Entries" : [
      {
        "Name"  : "PrintScreenKeyForSnippingEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion keyboard

#=======================================
## mouse
#=======================================
#region mouse

# mouse keys
#-------------------
# on: depends (default) | off: 0
$MouseKeys = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\Accessibility\\MouseKeys",
    "Entries" : [
      {
        "Name"  : "Flags",
        "Value" : "0",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion mouse

#endregion settings > accessibility


#==============================================================================
#                      windows security (aka defender)
#==============================================================================
#region windows security

#=======================================
## virus & threat protection
#=======================================
#region virus & threat protection

#===================
### virus & threat protection settings
#===================
# cloud-delivered protection
#-------------------
# user\ Disabled | Basic | Advanced (default)
function Enable-DefenderThreatProtectionCloudDelivered
{
    Write-Verbose -Message "Setting Defender ThreatProtection CloudDelivered to 'Advanced' ..."
    Set-MpPreference -MAPSReporting 'Advanced'
}

function Disable-DefenderThreatProtectionCloudDelivered
{
    Write-Verbose -Message "Setting Defender ThreatProtection CloudDelivered to 'Disabled' ..."
    Set-MpPreference -MAPSReporting 'Disabled'
}

# gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > MAPS
#   join Microsoft MAPS
# not configured: delete (default) | Basic: 1 | Advanced: 2 | off: 0
$DefenderThreatProtectionCloudDeliveredGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Spynet",
    "Entries" : [
      {
        "Name"  : "SpynetReporting",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# automatic sample submission
#-------------------
# user\ AlwaysPrompt | SendSafeSamples (default) | NeverSend | SendAllSamples
function Enable-DefenderThreatProtectionSampleSubmission
{
    Write-Verbose -Message "Setting Defender ThreatProtection SampleSubmission to 'SendSafeSamples' ..."
    Set-MpPreference -SubmitSamplesConsent 'SendSafeSamples'
}

function Disable-DefenderThreatProtectionSampleSubmission
{
    Write-Verbose -Message "Setting Defender ThreatProtection SampleSubmission to 'NeverSend' ..."
    Set-MpPreference -SubmitSamplesConsent 'NeverSend'
}

# gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > MAPS
#   send file samples when further analysis is required
# not configured: delete (default) | Always Prompt: 0 | Send Safe Samples: 1 | Never Send: 2 | Send All Samples: 3
$DefenderThreatProtectionSampleSubmissionGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Spynet",
    "Entries" : [
      {
        "Name"  : "SubmitSamplesConsent",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion virus & threat protection

#=======================================
## app & browser control
#=======================================
#region app & browser control

#===================
### reputation-based protection
#===================
# check apps and files
#-------------------
# gpo\ computer config > administrative tpl > windows components > file explorer
#      computer config > administrative tpl > windows components > windows defender smartscreen > explorer
#   configure Windows Defender SmartScreen
# not configured: delete (default) | on: 1 + Block or Warn | off: 0
$DefenderCheckAppsAndFilesGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableSmartScreen",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "RemoveEntry" : true,
        "Name"  : "ShellSmartScreenLevel",
        "Value" : "Block",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# user\ on: Warn (default) | off: Off
$DefenderCheckAppsAndFiles = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Explorer",
    "Entries" : [
      {
        "Name"  : "SmartScreenEnabled",
        "Value" : "Off",
        "Type"  : "String"
      }
    ]
  }
]' | ConvertFrom-Json

# smartscreen for microsoft edge
# If Microsoft Edge is removed/uninstalled, this key is also removed and the setting is locked to 'on' in the GUI.
# Let's recreate it to be able to toggle off the setting (even if it probably doesn't matter as Edge is gone).
#-------------------
# on: 1 (default) | off: 0
$DefenderSmartScreenEdge = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Classes\\Local Settings\\Software\\Microsoft\\Windows\\CurrentVersion\\AppContainer\\Storage\\microsoft.microsoftedge_8wekyb3d8bbwe\\MicrosoftEdge\\PhishingFilter",
    "Entries" : [
      {
        "Name"  : "EnabledV9",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# phishing protection
#-------------------
# If you configure the Group Policy to off (disabled) and you also disable the related service (webthreatdefsvc):
# The message 'This setting is managed by your administrator.' will not appears and the setting will not be grayed out.

# gpo\ computer config > administrative tpl > windows components > windows defender smartscreen > enhanced phishing protection
#   automatic data collection
#   notify malicious
#   notify passwords reuse
#   notify unsafe app
#   service enabled
# not configured: delete (default) | on: 1 | off: 0
$DefenderPhishingProtectionGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WTDS\\Components",
    "Entries" : [
      {
        "Name"  : "CaptureThreatWindow",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "NotifyMalicious",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "NotifyPasswordReuse",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "NotifyUnsafeApp",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ServiceEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

<#
# Requested registry access is not allowed.
# user\ on: 1 (default) | off: 0
$DefenderPhishingProtection = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\WTDS\\Components",
    "Entries" : [
      {
        "Name"  : "ServiceEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json
#>

# potentially unwanted app blocking
#-------------------
# user\ Disabled | Enabled (default) | AuditMode
function Enable-DefenderUnwantedAppBlocking
{
    Write-Verbose -Message "Setting Defender Unwanted App Blocking to 'Enabled' ..."
    Set-MpPreference -PUAProtection 'Enabled'
}

function Disable-DefenderUnwantedAppBlocking
{
    Write-Verbose -Message "Setting Defender Unwanted App Blocking to 'Disabled' ..."
    Set-MpPreference -PUAProtection 'Disabled'
}

# gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus
#   configure detection for potentially unwanted applications
# not configured: delete (default) | on: 1 | off: 0 | AuditMode: 2
$DefenderUnwantedAppBlockingGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows Defender",
    "Entries" : [
      {
        "Name"  : "PUAProtection",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# smartscreen for microsoft store apps
#-------------------
# on: 1 (default) | off: 0
$DefenderSmartScreenStoreApps = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\AppHost",
    "Entries" : [
      {
        "Name"  : "EnableWebContentEvaluation",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "PreventOverride",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion app & browser control

#=======================================
## notifications
#=======================================
#region notifications

#===================
### virus & threat protection
#===================
# recent activity and scan results
#-------------------
# on: 0 (default) | off: 1
$DefenderNotificationsThreatProtectionRecentActivityAndScanResults = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows Defender Security Center\\Virus and threat protection",
    "Entries" : [
      {
        "Name"  : "SummaryNotificationDisabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#===================
### account protection
#===================
# get account protection notifications
#   problems with Windows Hello
#   problems with Dynamic lock
#-------------------
# on: 0 (default) | off: 1
$DefenderNotificationsAccountProtectionWindowsHelloAndDynamicLock = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows Defender Security Center\\Account protection",
    "Entries" : [
      {
        "Name"  : "DisableNotifications",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableWindowsHelloNotifications",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "DisableDynamiclockNotifications",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion notifications

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

# gpo\ computer config > administrative tpl > windows components > microsoft defender antivirus > reporting
#   configure Watson events
# not configured: delete (default) | off: 1
$DefenderReportingWatsonEventsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows Defender\\Reporting",
    "Entries" : [
      {
        "Name"  : "DisableGenericRePorts",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion miscellaneous

#endregion windows security


#==============================================================================
#                       settings > privacy & security
#==============================================================================
#region settings > privacy & security

#=======================================
## security
#=======================================
#region security

#===================
### find my device
#===================
# gpo\ computer config > administrative tpl > windows components > find my device
#   turn on/off find my device
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 (default) | off: 0
$PrivacyFindMyDevice = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\FindMyDevice",
    "Entries" : [
      {
        "Name"  : "AllowFindMyDevice",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\MdmCommon\\SettingValues",
    "Entries" : [
      {
        "Name"  : "LocationSyncEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion security

#=======================================
## windows permissions
#=======================================
#region windows permissions

#===================
### general
#===================
#region general

# let apps show me personalized ads by using my advertising ID
#-------------------
# gpo\ computer config > administrative tpl > system > user profiles
#   turn off the advertising ID
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$PrivacyGeneralUsingAdvertisingID = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\AdvertisingInfo",
    "Entries" : [
      {
        "Name"  : "DisabledByGroupPolicy",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\AdvertisingInfo",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# let websites show me locally relevant content by accessing my language list
#-------------------
# on: 0 (default) | off: 1
$PrivacyGeneralAccessingLanguageList = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Control Panel\\International\\User Profile",
    "Entries" : [
      {
        "Name"  : "HttpAcceptLanguageOptOut",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# let Windows improve Start and search results by tracking app launches
#-------------------
# gpo\ user config > administrative tpl > windows components > edge UI
#   turn off tracking of app usage
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$PrivacyGeneralTrackingAppLaunches = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\EdgeUI",
    "Entries" : [
      {
        "Name"  : "DisableMFUTracking",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced",
    "Entries" : [
      {
        "Name"  : "Start_TrackProgs",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show me suggested content in the Settings app
#-------------------
# gpo\ user config > administrative tpl > windows components > cloud content
#   turn off Windows spotlight on Settings
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$PrivacyGeneralTipsInSettingsApp = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableWindowsSpotlightOnSettings",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\ContentDeliveryManager",
    "Entries" : [
      {
        "Name"  : "SubscribedContent-338393Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SubscribedContent-353694Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "SubscribedContent-353696Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show me notifications in the Settings app
#-------------------
# on: 1 (default) | off: 0
$PrivacyGeneralNotificationssInSettingsApp = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SystemSettings\\AccountNotifications",
    "Entries" : [
      {
        "Name"  : "EnableAccountNotifications",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion general

#===================
### recall & snapshots
#===================
#region recall & snapshots

# save snapshots
#-------------------
# Not sure about 'TurnOffSavingSnapshots' entry.

# gpo\ computer config > administrative tpl > windows components > windowsAI
#   turn off saving snapshots for Windows
# not configured: delete (default) | off: 1
$PrivacyRecallSnapshotsGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsAI",
    "Entries" : [
      {
        "Name"  : "DisableAIDataAnalysis",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "TurnOffSavingSnapshots",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion recall & snapshots

#===================
### speech
#===================
#region speech

# online speech recognition
# start/stop contributing my voice clips
#-------------------
# gpo\ computer config > administrative tpl > control panel > regional and language options
#   allow users to enable online speech recognition services
# gpo\ not configured: delete (default) | off: 0
# user\ on: 1 (default HasAccepted) | off: 0 (default LoggingAllowed)
$PrivacySpeech = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\InputPersonalization",
    "Entries" : [
      {
        "Name"  : "AllowInputPersonalization",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Speech_OneCore\\Settings\\OnlineSpeechPrivacy",
    "Entries" : [
      {
        "Name"  : "HasAccepted",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Speech_OneCore\\Settings\\OnlineSpeechLogging",
    "Entries" : [
      {
        "Name"  : "LoggingAllowed",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion speech

#===================
### inking & typing personalization
#===================
#region inking & typing personalization

# custom inking and typing dictionary
#-------------------
# on: 1 + RestrictImplicit 0 (default) | off: 0 + RestrictImplicit 1
$PrivacyInkingAndTypingPersonalization = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\InputPersonalization",
    "Entries" : [
      {
        "Name"  : "RestrictImplicitTextCollection",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "RestrictImplicitInkCollection",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\InputPersonalization\\TrainedDataStore",
    "Entries" : [
      {
        "Name"  : "HarvestContacts",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Personalization\\Settings",
    "Entries" : [
      {
        "Name"  : "AcceptedPrivacyPolicy",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CPSS\\Store\\InkingAndTypingPersonalization",
    "Entries" : [
      {
        "Name"  : "Value",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion inking & typing personalization

#===================
### diagnostics & feedback
#===================
#region diagnostics & feedback

# diagnostic data
#-------------------
# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   allow diagnostic data
# gpo\ not configured: delete (default) | value: see user\ below
# user\
# Send optional diagnostic data: 3 (default)
# Only Send Required Diagnostic Data: 1
# off: 0 (only supported on Enterprise, Education, and Server editions)
$PrivacyDiagnosticData = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "AllowTelemetry",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Diagnostics\\DiagTrack",
    "Entries" : [
      {
        "Name"  : "ShowedToastAtLevel",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\DataCollection",
    "Entries" : [
      {
        "Name"  : "AllowTelemetry",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "MaxTelemetryAllowed",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# improve inking and typing
#-------------------
# gpo\ computer config > administrative tpl > windows components > text input
#   improve inking and typing recognition
# gpo\ not configured: delete (default) | off: 0
# user\ on: 1 (default) | off: 0
$PrivacyDiagnosticInkingAndTyping = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Policies\\TextInput",
    "Entries" : [
      {
        "Name"  : "AllowLinguisticDataCollection",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Input\\TIPC",
    "Entries" : [
      {
        "Name"  : "Enabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# tailored experiences
#-------------------
# gpo\ user config > administrative tpl > windows components > cloud content
#   do not use diagnostic data for tailored experiences
# gpo\ not configured: delete (default) | off: 1
# user\ on: 1 (default) | off: 0
$PrivacyiagnosticTailoredExperiences = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Policies\\Microsoft\\Windows\\CloudContent",
    "Entries" : [
      {
        "Name"  : "DisableTailoredExperiencesWithDiagnosticData",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Privacy",
    "Entries" : [
      {
        "Name"  : "TailoredExperiencesWithDiagnosticDataEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# view diagnostic data
#-------------------
# Requires DiagTrack service running.

# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   disable diagnostic data viewer
# gpo\ not configured: delete (default) | off: 1 + EnableEventTranscript 0
# user\ on: 1 | off: 0 (default)
$PrivacyiDagnosticViewData = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "DisableDiagnosticDataViewer",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Diagnostics\\DiagTrack\\EventTranscriptKey",
    "Entries" : [
      {
        "Name"  : "EnableEventTranscript",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# delete diagnostic data
#-------------------
# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   disable deleting diagnostic data
# not configured: delete (default) | off: 1
$PrivacyDiagnosticDeleteDataGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "RemoveEntry" : true,
        "Name"  : "DisableDeviceDelete",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# feedback frequency
#-------------------
# gpo\ computer config > administrative tpl > windows components > data collection and preview builds
#   do not show feedback notifications
# gpo\ not configured: delete (default) | off: 1 (also remove setting from the GUI)
# user\
# Automatically: delete (default)
# Always: NumberOfSIUFInPeriod 100000000 + PeriodInNanoSeconds delete
# Once a day: NumberOfSIUFInPeriod 1 + PeriodInNanoSeconds 864000000000
# Once a week: NumberOfSIUFInPeriod 1 + PeriodInNanoSeconds 6048000000000
# Never: NumberOfSIUFInPeriod 0 + PeriodInNanoSeconds 0 or delete
$PrivacyDiagnosticFeedbackFrequency = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DataCollection",
    "Entries" : [
      {
        "Name"  : "DoNotShowFeedbackNotifications",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Siuf\\Rules",
    "Entries" : [
      {
        "Name"  : "NumberOfSIUFInPeriod",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "PeriodInNanoSeconds",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion diagnostics & feedback

#===================
### activity history
#===================
#region activity history

# store my activity history on this device
# store my activity history to Microsoft | old
#-------------------
# gpo\ computer config > administrative tpl > system > os policies
#   enables activity feed
#   allow publishing of user activities
#   allow upload of user activities
# not configured: delete (default) | off: 0
$PrivacyActivityHistoryGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\System",
    "Entries" : [
      {
        "Name"  : "EnableActivityFeed",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "PublishUserActivities",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "UploadUserActivities",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# user\ on: 0 (default) | off: 1
function Set-PrivacyActivityHistory
{
    <#
    .SYNTAX
        Set-PrivacyActivityHistory [-State] {Enabled | Disabled} [<CommonParameters>]

    .EXAMPLE
        PS> Set-PrivacyActivityHistory -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Enabled', 'Disabled')]
        [string]
        $State
    )

    Write-Verbose -Message "Setting 'Privacy Activity History' to '$State' ..."

    $CDPUserSettingsFile = "$((Get-LoggedUserEnvVariable).LOCALAPPDATA)\ConnectedDevicesPlatform\CDPGlobalSettings.cdp"
    $CDPUserSettings = Get-Content -Raw -Path $CDPUserSettingsFile | ConvertFrom-Json -AsHashtable

    $CDPUserSettings.AfcPrivacySettings.PublishUserActivity = $State -eq 'Enabled' ? 0 : 1
    $CDPUserSettings.AfcPrivacySettings.UploadUserActivity = $State -eq 'Enabled' ? 0 : 1

    $CDPUserSettings | ConvertTo-Json -Depth 42 | Out-File -FilePath $CDPUserSettingsFile
}

function Enable-PrivacyActivityHistory
{
    Set-PrivacyActivityHistory -State 'Enabled'
}

function Disable-PrivacyActivityHistory
{
    Set-PrivacyActivityHistory -State 'Disabled'
}

#endregion activity history

#===================
### search permissions
#===================
#region search permissions

# safesearch
#-------------------
# Moderate: 1 (default) | Strict: 2 | off: 0
$PrivacySearchPermissionsSafesearch = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings",
    "Entries" : [
      {
        "Name"  : "SafeSearchMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# cloud content search:
#   microsoft account
#   work or school account
#-------------------
# gpo\ computer config > administrative tpl > windows components > search
#   allow cloud search
# gpo\ not configured: delete (default) | on: 1 (enable 'work or school account') | off: 0 (disable both)
# user\ on: 1 (default) | off: 0
$PrivacySearchPermissionsCloudContent = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search",
    "Entries" : [
      {
        "Name"  : "AllowCloudSearch",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings",
    "Entries" : [
      {
        "Name"  : "IsMSACloudSearchEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "IsAADCloudSearchEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# search history in this device
#-------------------
# on: 1 (default) | off: 0
$PrivacySearchPermissionsSearchHistory = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings",
    "Entries" : [
      {
        "Name"  : "IsDeviceSearchHistoryEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# show search highlights
#-------------------
# Disabled by $BingSearchStartMenu (applications > appx & provisioned packages > bing search in start menu).

# gpo\ computer config > administrative tpl > windows components > search
#   allow search highlights
# gpo\ not configured: delete (default) | off: 0
# user\ on: 1 (default) | off: 0
$PrivacySearchPermissionsSearchHighlights = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\Windows Search",
    "Entries" : [
      {
        "Name"  : "EnableDynamicContentInWSB",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\SearchSettings",
    "Entries" : [
      {
        "Name"  : "IsDynamicSearchBoxEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion search permissions

#===================
### searching windows
#===================
#region searching windows

<#
# owner: SYSTEM | full control: TrustedInstaller | setValue: SYSTEM
# Requested registry access is not allowed.
# respect power settings when indexing | old
#-------------------
# on: 1 (default) | off: 0
$PrivacySearchingWindowsRespectPowerSettings = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows Search\\Gather\\Windows\\SystemIndex",
    "Entries" : [
      {
        "Name"  : "RespectPowerModes",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json
#>

# find my files
#-------------------
# classic: 0 (default) | enhanced: 1
$PrivacySearchingWindowsFindMyFiles = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\Windows Search",
    "Entries" : [
      {
        "Name"  : "EnableFindMyFiles",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion searching windows

#endregion windows permissions

#=======================================
## app permissions
#=======================================
#region app permissions

#===================
### helper functions
#===================
#region helper functions

# gpo\ computer config > administrative tpl > windows components > app privacy
#   let Windows apps [...]
# not configured: delete (default) | on: 1 | off: 2
function New-AppPermissionsGroupPolicyRegData
{
    <#
    .SYNTAX
        New-AppPermissionsGroupPolicyRegData [-Name] <string> [-Value] <string> [<CommonParameters>]

    .EXAMPLE
        PS> $PrivacyCamera = New-AppPermissionsGroupPolicyRegData -Name 'LetAppsAccessCamera' -Value '2'
        PS> $PrivacyCamera | Set-RegistryEntry
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [Parameter(Mandatory)]
        [string]
        $Value
    )

    $NewData = '[
      {
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\AppPrivacy",
        "Entries" : [
          {
            "Name"  : "",
            "Value" : "",
            "Type"  : "DWord"
          },
          {
            "Name"  : "_UserInControlOfTheseApps",
            "Value" : "",
            "Type"  : "MultiString"
          },
          {
            "Name"  : "_ForceAllowTheseApps",
            "Value" : "",
            "Type"  : "MultiString"
          },
          {
            "Name"  : "_ForceDenyTheseApps",
            "Value" : "",
            "Type"  : "MultiString"
          }
        ]
      }
    ]' | ConvertFrom-Json

    $NewData.Entries[0].Value = $Value
    foreach ($Entry in $NewData.Entries)
    {
        $Entry.Name = $Name + $Entry.Name
    }
    $NewData
}

# user\ on: Allow (default) | off: Deny
function New-AppPermissionsUserRegData
{
    <#
    .SYNTAX
        New-AppPermissionsUserRegData [-Key] <string> [-Value] <string> [<CommonParameters>]

    .EXAMPLE
        PS> $PrivacyCamera = New-AppPermissionsUserRegData -Key 'webcam' -Value 'Deny'
        PS> $PrivacyCamera | Set-RegistryEntry

    .NOTES
        'HKEY_LOCAL_MACHINE' is for the main toggle. e.g. Camera access
        'HKEY_CURRENT_USER' is for the application toggle. e.g. Let apps access your camera
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Key,

        [Parameter(Mandatory)]
        [string]
        $Value
    )

    $NewData = '[
      {
        "Hive"    : "HKEY_LOCAL_MACHINE",
        "Path"    : "SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\",
        "Entries" : [
          {
            "Name"  : "Value",
            "Value" : "",
            "Type"  : "String"
          }
        ]
      },
      {
        "Hive"    : "HKEY_CURRENT_USER",
        "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\",
        "Entries" : [
          {
            "Name"  : "Value",
            "Value" : "",
            "Type"  : "String"
          }
        ]
      }
    ]' | ConvertFrom-Json

    foreach ($Item in $NewData)
    {
        $Item.Path += $Key
        $Item.Entries[0].Value = $Value
    }
    $NewData
}

#endregion helper functions

#===================
### location
#===================
#region location

# See also $LocationAndSensorsGPO (tweaks > miscellaneous > location and sensors).

$LocationGPO = @{
    Name  = 'LetAppsAccessLocation'
    Value = '2'
}
$LocationUser = @{
    Key   = 'location'
    Value = 'Deny'
}

$PrivacyLocation = @(
    #New-AppPermissionsGroupPolicyRegData @LocationGPO
    New-AppPermissionsUserRegData @LocationUser
)

# allow location override
#-------------------
# on: 1 (default) | off: 0
$PrivacyLocationAllowOverride = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CPSS\\Store\\UserLocationOverridePrivacySetting",
    "Entries" : [
      {
        "Name"  : "Value",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# notify when apps request location
#-------------------
# on: 1 (default) | off: 0
$PrivacyLocationNotifyAppsRequest = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\CapabilityAccessManager\\ConsentStore\\location",
    "Entries" : [
      {
        "Name"  : "ShowGlobalPrompts",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion location

#===================
### camera
#===================
#region camera

$CameraGPO = @{
    Name  = 'LetAppsAccessCamera'
    Value = '2'
}
$CameraUser = @{
    Key   = 'webcam'
    Value = 'Deny'
}

$PrivacyCamera = @(
    #New-AppPermissionsGroupPolicyRegData @CameraGPO
    New-AppPermissionsUserRegData @CameraUser
)

#endregion camera

#===================
### microphone
#===================
#region microphone

$MicrophoneGPO = @{
    Name  = 'LetAppsAccessMicrophone'
    Value = '2'
}
$MicrophoneUser = @{
    Key   = 'microphone'
    Value = 'Deny'
}

$PrivacyMicrophone = @(
    #New-AppPermissionsGroupPolicyRegData @MicrophoneGPO
    New-AppPermissionsUserRegData @MicrophoneUser
)

#endregion microphone

#===================
### voice activation
#===================
#region activation

$PrivacyVoiceActivation = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\AppPrivacy",
    "Entries" : [
      {
        "Name"  : "LetAppsActivateWithVoice",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "LetAppsActivateWithVoiceAboveLock",
        "Value" : "2",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Speech_OneCore\\Settings\\VoiceActivation\\UserPreferenceForAllApps",
    "Entries" : [
      {
        "Name"  : "AgentActivationEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AgentActivationLastUsed",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "AgentActivationOnLockScreenEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion activation

#===================
### notification
#===================
#region notification

$NotificationGPO = @{
    Name  = 'LetAppsAccessNotifications'
    Value = '2'
}
$NotificationUser = @{
    Key   = 'userNotificationListener'
    Value = 'Deny'
}

$PrivacyNotification = @(
    #New-AppPermissionsGroupPolicyRegData @NotificationGPO
    New-AppPermissionsUserRegData @NotificationUser
)

#endregion notification

#===================
### account info
#===================
#region account info

$AccountInfoGPO = @{
    Name  = 'LetAppsAccessAccountInfo'
    Value = '2'
}
$AccountInfoUser = @{
    Key   = 'userAccountInformation'
    Value = 'Deny'
}

$PrivacyAccountInfo = @(
    #New-AppPermissionsGroupPolicyRegData @AccountInfoGPO
    New-AppPermissionsUserRegData @AccountInfoUser
)

#endregion account info

#===================
### contacts
#===================
#region contacts

$ContactsGPO = @{
    Name  = 'LetAppsAccessContacts'
    Value = '2'
}
$ContactsUser = @{
    Key   = 'contacts'
    Value = 'Deny'
}

$PrivacyContacts = @(
    #New-AppPermissionsGroupPolicyRegData @ContactsGPO
    New-AppPermissionsUserRegData @ContactsUser
)

#endregion contacts

#===================
### calendar
#===================
#region calendar

$CalendarGPO = @{
    Name  = 'LetAppsAccessCalendar'
    Value = '2'
}
$CalendarUser = @{
    Key   = 'appointments'
    Value = 'Deny'
}

$PrivacyCalendar = @(
    #New-AppPermissionsGroupPolicyRegData @CalendarGPO
    New-AppPermissionsUserRegData @CalendarUser
)

#endregion calendar

#===================
### phone calls
#===================
#region phone calls

$PhoneCallsGPO = @{
    Name  = 'LetAppsAccessPhone'
    Value = '2'
}
$PhoneCallsUser = @{
    Key   = 'phoneCall'
    Value = 'Deny'
}

$PrivacyPhoneCalls = @(
    #New-AppPermissionsGroupPolicyRegData @PhoneCallsGPO
    New-AppPermissionsUserRegData @PhoneCallsUser
)

#endregion phone calls

#===================
### call history
#===================
#region call history

$CallHistoryGPO = @{
    Name  = 'LetAppsAccessCallHistory'
    Value = '2'
}
$CallHistoryUser = @{
    Key   = 'phoneCallHistory'
    Value = 'Deny'
}

$PrivacyCallHistory = @(
    #New-AppPermissionsGroupPolicyRegData @CallHistoryGPO
    New-AppPermissionsUserRegData @CallHistoryUser
)

#endregion call history

#===================
### email
#===================
#region email

$EmailGPO = @{
    Name  = 'LetAppsAccessEmail'
    Value = '2'
}
$EmailUser = @{
    Key   = 'email'
    Value = 'Deny'
}

$PrivacyEmail = @(
    #New-AppPermissionsGroupPolicyRegData @EmailGPO
    New-AppPermissionsUserRegData @EmailUser
)

#endregion email

#===================
### tasks
#===================
#region tasks

$TasksGPO = @{
    Name  = 'LetAppsAccessTasks'
    Value = '2'
}
$TasksUser = @{
    Key   = 'userDataTasks'
    Value = 'Deny'
}

$PrivacyTasks = @(
    #New-AppPermissionsGroupPolicyRegData @TasksGPO
    New-AppPermissionsUserRegData @TasksUser
)

#endregion tasks

#===================
### messaging
#===================
#region messaging

$MessagingGPO = @{
    Name  = 'LetAppsAccessMessaging'
    Value = '2'
}
$MessagingUser = @{
    Key   = 'chat'
    Value = 'Deny'
}

$PrivacyMessaging = @(
    #New-AppPermissionsGroupPolicyRegData @MessagingGPO
    New-AppPermissionsUserRegData @MessagingUser
)

#endregion messaging

#===================
### radios
#===================
#region radios

$RadiosGPO = @{
    Name  = 'LetAppsAccessRadios'
    Value = '2'
}
$RadiosUser = @{
    Key   = 'radios'
    Value = 'Deny'
}

$PrivacyRadios = @(
    #New-AppPermissionsGroupPolicyRegData @RadiosGPO
    New-AppPermissionsUserRegData @RadiosUser
)

#endregion radios

#===================
### others devices
#===================
#region others devices

# communicate with unpaired devices
$OthersDevicesSyncWithUnpairedDevicesGPO = @{
    Name  = 'LetAppsSyncWithDevices'
    Value = '2'
}
$OthersDevicesSyncWithUnpairedDevicesUserWin10 = @{
    Key   = 'bluetoothSync'
    Value = 'Deny'
}

# on: 1 (default) | off: 0
$OthersDevicesSyncWithUnpairedDevicesUser = '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\Privacy",
    "Entries" : [
      {
        "Name"  : "TailoredExperiencesWithDiagnosticDataEnabled",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

$PrivacyOthersDevices = @(
    #New-AppPermissionsGroupPolicyRegData @OthersDevicesSyncWithUnpairedDevicesGPO
    New-AppPermissionsUserRegData @OthersDevicesSyncWithUnpairedDevicesUserWin10
    $OthersDevicesSyncWithUnpairedDevicesUser
)

# use trusted devices
$OthersDevicesUseTrustedDevicesGPO = @{
    Name  = 'LetAppsAccessTrustedDevices'
    Value = '2'
}

$PrivacyOthersDevicesUseTrustedDevicesGPO = New-AppPermissionsGroupPolicyRegData @OthersDevicesUseTrustedDevicesGPO

#endregion others devices

#===================
### app diagnostics
#===================
#region app diagnostics

$AppDiagnosticsGPO = @{
    Name  = 'LetAppsGetDiagnosticInfo'
    Value = '2'
}
$AppDiagnosticsUser = @{
    Key   = 'appDiagnostics'
    Value = 'Deny'
}

$PrivacyAppDiagnostics = @(
    #New-AppPermissionsGroupPolicyRegData @AppDiagnosticsGPO
    New-AppPermissionsUserRegData @AppDiagnosticsUser
)

#endregion app diagnostics

#===================
### documents
#===================
#region documents

$DocumentsUser = @{
    Key   = 'documentsLibrary'
    Value = 'Deny'
}

$PrivacyDocuments = New-AppPermissionsUserRegData @DocumentsUser

#endregion documents

#===================
### downloads folder
#===================
#region downloads folder

$DownloadsFolderUser = @{
    Key   = 'downloadsFolder'
    Value = 'Deny'
}

$PrivacyDownloadsFolder = New-AppPermissionsUserRegData @DownloadsFolderUser

#endregion downloads folder

#===================
### music library
#===================
#region music library

$MusicLibraryUser = @{
    Key   = 'musicLibrary'
    Value = 'Deny'
}

$PrivacyMusicLibrary = New-AppPermissionsUserRegData @MusicLibraryUser

#endregion music library

#===================
### pictures
#===================
#region pictures

$PicturesUser = @{
    Key   = 'picturesLibrary'
    Value = 'Deny'
}

$PrivacyPictures = New-AppPermissionsUserRegData @PicturesUser

#endregion pictures

#===================
### videos
#===================
#region videos

$VideosUser = @{
    Key   = 'videosLibrary'
    Value = 'Deny'
}

$PrivacyVideos = New-AppPermissionsUserRegData @VideosUser

#endregion videos

#===================
### file system
#===================
#region file system

$FileSystemUser = @{
    Key   = 'broadFileSystemAccess'
    Value = 'Deny'
}

$PrivacyFileSystem = New-AppPermissionsUserRegData @FileSystemUser

#endregion file system

#===================
### screenshot borders
#===================
#region screenshot borders

$ScreenshotBordersGPO = @{
    Name  = 'LetAppsAccessGraphicsCaptureWithoutBorder'
    Value = '2'
}
$ScreenshotBordersUser = @{
    Key   = 'graphicsCaptureWithoutBorder'
    Value = 'Deny'
}

$PrivacyScreenshotBorders = @(
    #New-AppPermissionsGroupPolicyRegData @ScreenshotBordersGPO
    New-AppPermissionsUserRegData @ScreenshotBordersUser
)

#endregion screenshot borders

#===================
### screenshots and screen recording
#===================
#region screenshots and screen recording

$ScreenshotsAndScreenRecordingGPO = @{
    Name  = 'LetAppsAccessGraphicsCaptureProgrammatic'
    Value = '2'
}
$ScreenshotsAndScreenRecordingUser = @{
    Key   = 'graphicsCaptureProgrammatic'
    Value = 'Deny'
}

$PrivacyScreenshotsAndScreenRecording = @(
    #New-AppPermissionsGroupPolicyRegData @ScreenshotsAndScreenRecordingGPO
    New-AppPermissionsUserRegData @ScreenshotsAndScreenRecordingUser
)

#endregion screenshots and screen recording

#===================
### generative AI
#===================
#region generative AI

$GenerativeAIGPO = @{
    Name  = 'LetAppsAccessGenerativeAI'
    Value = '2'
}
$GenerativeAIUser = @{
    Key   = 'generativeAI'
    Value = 'Deny'
}

$PrivacyGenerativeAI = @(
    #New-AppPermissionsGroupPolicyRegData @GenerativeAIGPO
    New-AppPermissionsUserRegData @GenerativeAIUser
)

#endregion generative AI

#===================
### eye tracker
#===================
#region eye tracker

$EyeTrackerGPO = @{
    Name  = 'LetAppsAccessGazeInput'
    Value = '2'
}
$EyeTrackerUser = @{
    Key   = 'gazeInput'
    Value = 'Deny'
}

$PrivacyEyeTracker = @(
    #New-AppPermissionsGroupPolicyRegData @EyeTrackerGPO
    New-AppPermissionsUserRegData @EyeTrackerUser
)

#endregion eye tracker

#===================
### motion
#===================
#region motion

$MotionGPO = @{
    Name  = 'LetAppsAccessMotion'
    Value = '2'
}
$MotionUser = @{
    Key   = 'activity'
    Value = 'Deny'
}

$PrivacyMotion = @(
    #New-AppPermissionsGroupPolicyRegData @MotionGPO
    New-AppPermissionsUserRegData @MotionUser
)

#endregion motion

#===================
### presence sensing
#===================
#region presence sensing

$PresenceSensingGPO = @{
    Name  = 'LetAppsAccessHumanPresence'
    Value = '2'
}
$PresenceSensingUser = @{
    Key   = 'humanPresence'
    Value = 'Deny'
}

$PrivacyPresenceSensing = @(
    #New-AppPermissionsGroupPolicyRegData @PresenceSensingGPO
    New-AppPermissionsUserRegData @PresenceSensingUser
)

#endregion presence sensing

#===================
### user movement
#===================
#region user movement

$UserMovementBackgroundGPO = @{
    Name  = 'LetAppsAccessBackgroundSpatialPerception'
    Value = '2'
}
$UserMovementBackgroundUser = @{
    Key   = 'backgroundSpatialPerception'
    Value = 'Deny'
}
$UserMovementUser = @{
    Key   = 'spatialPerception'
    Value = 'Deny'
}

$PrivacyUserMovement = @(
    #New-AppPermissionsGroupPolicyRegData @UserMovementBackgroundGPO
    New-AppPermissionsUserRegData @UserMovementBackgroundUser
    New-AppPermissionsUserRegData @UserMovementUser
)

#endregion user movement

#===================
### background apps
#===================
#region background apps

<#
Applies only to the apps installed from Microsoft Store (e.g. Calculator, Photos, Notepad, ...).
If disabled, it will also disable Windows Spotlight.
#>

$BackgroundAppsGPO = @{
    Name  = 'LetAppsRunInBackground'
    Value = '2'
}

$PrivacyBackgroundAppsGPO = @(
    New-AppPermissionsGroupPolicyRegData @BackgroundAppsGPO
)

# on: 0 (default) | off: 1
$PrivacyBackgroundAppsGPO += '[
  {
    "Hive"    : "HKEY_CURRENT_USER",
    "Path"    : "Software\\Microsoft\\Windows\\CurrentVersion\\BackgroundAccessApplications",
    "Entries" : [
      {
        "Name"  : "GlobalUserDisabled",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion background apps

#===================
### cellular data
#===================
#region cellular data

# gpo\ computer config > administrative tpl > network > wwan service
#   let Windows apps access cellular data
# not configured: delete (default) | on: 1 | off: 2
$CellularDataGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WwanSvc\\CellularDataAccess",
    "Entries" : [
      {
        "Name"  : "LetAppsAccessCellularData",
        "Value" : "2",
        "Type"  : "DWord"
      },
      {
        "Name"  : "LetAppsAccessCellularData_UserInControlOfTheseApps",
        "Value" : "",
        "Type"  : "MultiString"
      },
      {
        "Name"  : "LetAppsAccessCellularData_ForceAllowTheseApps",
        "Value" : "",
        "Type"  : "MultiString"
      },
      {
        "Name"  : "LetAppsAccessCellularData_ForceDenyTheseApps",
        "Value" : "",
        "Type"  : "MultiString"
      }
    ]
  }
]' | ConvertFrom-Json

$CellularDataUser = @{
    Key   = 'cellularData'
    Value = 'Deny'
}

$PrivacyCellularData = @(
    #$CellularDataGPO
    New-AppPermissionsUserRegData @CellularDataUser
)

#endregion cellular data

#===================
### take screenshots of various windows or displays (Recall)
#===================
#region take screenshots

$TakeScreenshotsOfVariousWindowsGPO = @{
    Name  = 'LetAppsAccessGraphicsCaptureProgrammatic'
    Value = '2'
}

$PrivacyTakeScreenshotsOfVariousWindowsGPO = @(
    New-AppPermissionsGroupPolicyRegData @TakeScreenshotsOfVariousWindowsGPO
)

#endregion take screenshots

#endregion app permissions

#endregion settings > privacy & security


#==============================================================================
#                          settings > windows update
#==============================================================================
#region settings > windows update

# get the latest updates as soon as they are available
#-------------------
# on: 1 | off: 0 (default)
$WinUpdateGetLatestWhenAvailable = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "IsContinuousInnovationOptedIn",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# pause updates
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
#   remove access to 'pause updates' feature
# not configured: delete (default) | off: 1
$WinUpdatePauseUpdatesGPO = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate",
    "Entries" : [
      {
        "Name"  : "SetDisablePauseUXAccess",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#=======================================
## advanced options
#=======================================
#region advanced options

# receive updates for other Microsoft products
#-------------------
# on: 1 (default) | off: 0
$WinUpdateOtherMicrosoftProducts = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "AllowMUUpdateService",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# get me up to date (restart as soon as possible)
#-------------------
# gpo\ see $WinUpdateNotifyRestart below (notify me when a restart is required to finish updating).
# user\ on: 1 | off: 0 (default)
$WinUpdateRestartAsap = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "IsExpedited",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# download updates over metered connections
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
#   allow updates to be downloaded automatically over metered connections
# gpo\ not configured: delete (default) | on: 1 | off: 0
# user\ on: 1 | off: 0 (default)
$WinUpdateMeteredConnection = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate",
    "Entries" : [
      {
        "Name"  : "AllowAutoWindowsUpdateDownloadOverMeteredNetwork",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "AllowAutoWindowsUpdateDownloadOverMeteredNetwork",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# notify me when a restart is required to finish updating
#-------------------
# gpo\ computer config > administrative tpl > windows components > windows update > legacy policies
#   turn off auto-restart notifications for update installations
# gpo\ not configured: delete (default) | off: 1 (also disable 'get me up to date')
# user\ on: 1 | off: 0 (default)
$WinUpdateNotifyRestart = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate",
    "Entries" : [
      {
        "Name"  : "SetAutoRestartNotificationDisable",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "RestartNotificationsAllowed2",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# active hours
#-------------------
# Values use 24H clock format.

# gpo\ computer config > administrative tpl > windows components > windows update > manage end user experience
#   turn off auto-restart for updates during active hours
# gpo\ not configured: delete (default) | Manually: 1 + define ActiveHours
# gpo\ if enabled, remove the setting from the page and disable 'get me up to date'
# user\ Automatically: 1 (default) | Manually: 0 + define ActiveHours
$WinUpdateActiveHours = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\WindowsUpdate",
    "Entries" : [
      {
        "Name"  : "SetActiveHours",
        "Value" : "1",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ActiveHoursStart",
        "Value" : "7",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ActiveHoursEnd",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsUpdate\\UX\\Settings",
    "Entries" : [
      {
        "Name"  : "SmartActiveHoursState",
        "Value" : "0",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ActiveHoursStart",
        "Value" : "7",
        "Type"  : "DWord"
      },
      {
        "Name"  : "ActiveHoursEnd",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

# delivery optimization: allow downloads from other PCs
#-------------------
# gpo\ computer config > administrative tpl > windows components > delivery optimization
#   download mode
# gpo\ not configured: delete (default) | value: see user\ below (see also gpo for more options)
# user\ off: 0 | devices on my local network: 1 (default) | devices on the internet and my local network: 3
$WinUpdateDeliveryOptimization = '[
  {
    "SkipKey" : true,
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Policies\\Microsoft\\Windows\\DeliveryOptimization",
    "Entries" : [
      {
        "Name"  : "DODownloadMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  },
  {
    "Hive"    : "HKEY_USERS",
    "Path"    : "S-1-5-20\\Software\\Microsoft\\Windows\\CurrentVersion\\DeliveryOptimization\\Settings",
    "Entries" : [
      {
        "Name"  : "DownloadMode",
        "Value" : "0",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion advanced options

#=======================================
## windows insider program
#=======================================
#region windows insider program

# setting page
#-------------------
# on: delete (default) | off: 1
$WinUpdateInsiderProgramSettingPage = '[
  {
    "Hive"    : "HKEY_LOCAL_MACHINE",
    "Path"    : "SOFTWARE\\Microsoft\\WindowsSelfHost\\UI\\Visibility",
    "Entries" : [
      {
        "Name"  : "HideInsiderPage",
        "Value" : "1",
        "Type"  : "DWord"
      }
    ]
  }
]' | ConvertFrom-Json

#endregion windows insider program

#endregion settings > windows update

#endregion windows settings app


#=================================================================================================================
#                                           services & scheduled tasks
#=================================================================================================================
#region services & scheduled tasks

#==============================================================================
#                                  services
#==============================================================================
#region services

<#
Lower process count is not the only thing that matter.
Two important metrics to also look at are 'Cycles Delta' and 'Context Switches Delta'.
You can use 'Process Explorer' to check these metrics.
#>

#=======================================
## helper functions
#=======================================
#region helper functions

function Export-DefaultServicesStartupType
{
    $LogFilePath = "$PSScriptRoot\windows_services_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Default Services StartupType ...'

        $CurrentLUID = (Get-Service -Name 'WpnUserService_*').Name.Replace('WpnUserService', '')
        (Get-Service -ErrorAction 'SilentlyContinue' |
            ForEach-Object -Process {
                $NewProperty = @{
                    InputObject       = $_
                    NotePropertyName  = 'DefaultType'
                    NotePropertyValue = $_.StartupType
                }
                Add-Member @NewProperty -PassThru
            } |
            Sort-Object -Property 'DisplayName' |
            Select-Object -Property 'DisplayName', 'ServiceName', 'StartupType', 'DefaultType' |
            ConvertTo-Json -EnumsAsStrings).Replace($CurrentLUID, '') |
            Out-File -FilePath $LogFilePath
    }
}

function Export-DefaultSystemDriversStartupType
{
    $LogFilePath = "$PSScriptRoot\windows_system_drivers_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Default System Drivers StartupType ...'

        Get-CimInstance -ClassName 'Win32_SystemDriver' -Verbose:$false |
            ForEach-Object -Process {
                $StartMode = $_.StartMode.Replace("Auto", "Automatic")
                $NewProperties = @{
                    InputObject = $_
                    NotePropertyMembers = @{
                        ServiceName = $_.Name
                        StartupType = $StartMode
                        DefaultType = $StartMode
                    }
                }
                Add-Member @NewProperties -PassThru
            } |
            Sort-Object -Property 'DisplayName' |
            Select-Object -Property 'DisplayName', 'ServiceName', 'StartupType', 'DefaultType' |
            ConvertTo-Json |
            Out-File -FilePath $LogFilePath
    }
}

function Set-ServiceStartupType
{
    <#
    .SYNTAX
        Set-ServiceStartupType [-InputObject] <ServiceStartupType> [-RestoreDefault] [<CommonParameters>]

    .EXAMPLE
        PS> $ServicesBackupFile = "X:\Backup\windows_services_default.txt"
        PS> $ServicesBackup = Get-Content -Raw -Path $ServicesBackupFile | ConvertFrom-Json
        PS> $ServicesBackup | Set-ServiceStartupType -RestoreDefault

    .EXAMPLE
        PS> $Xbox = '[
              {
                "DisplayName": "Xbox Live Game Save",
                "ServiceName": "XblGameSave",
                "StartupType": "Disabled",
                "DefaultType": "Manual",
                "Comment"    : "some comment"
              }
            ]' | ConvertFrom-Json
        PS> $Xbox | Set-ServiceStartupType
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [ServiceStartupType]
        $InputObject,

        [switch]
        $RestoreDefault
    )

    begin
    {
        class ServiceStartupType
        {
            [string] $DisplayName
            [string] $ServiceName
            [string] $StartupType
            [string] $DefaultType
            [string] $Comment
        }

        $RegistryStartValue = @{
            Boot                  = '0'
            System                = '1'
            AutomaticDelayedStart = '2'
            Automatic             = '2'
            Manual                = '3'
            Disabled              = '4'
        }

        $ServiceTemplate = '{
          "Hive"    : "HKEY_LOCAL_MACHINE",
          "Path"    : "SYSTEM\\CurrentControlSet\\Services",
          "Entries" : [
            {
              "Name"  : "Start",
              "Value" : "",
              "Type"  : "DWord"
            },
            {
              "Name"  : "DelayedAutostart",
              "Value" : "",
              "Type"  : "DWord"
            }
          ]
        }' | ConvertFrom-Json
    }

    process
    {
        $Name = $InputObject.ServiceName
        $DisplayName = $InputObject.DisplayName
        $StartupType = $RestoreDefault ? $InputObject.DefaultType : $InputObject.StartupType

        $CurrentStartupType = (Get-Service -Name $Name -ErrorAction 'SilentlyContinue').StartupType

        if (-not $CurrentStartupType)
        {
            Write-Verbose -Message "Service '$DisplayName ($Name)' not found"
        }
        elseif ($CurrentStartupType -eq $StartupType)
        {
            Write-Verbose -Message "'$DisplayName ($Name)' is already set to '$StartupType'"
        }
        else
        {
            Write-Verbose -Message "Setting '$DisplayName ($Name)' to '$StartupType' ..."

            # Some services cannot be changed:
            #   with services.msc (this include Set-Service) (grayed out or Access is denied).
            #   with registry editing (Access is denied).
            #   with neither services.msc or registry editing (Access is denied).
            #
            # "Access is denied" means that SYSTEM and/or TrustedInstaller privileges are required.
            try
            {
                Set-Service -Name $Name -StartupType $StartupType -ErrorAction 'Stop'
            }
            catch
            {
                Write-Verbose -Message "    cannot be changed with 'Set-Service': using registry editing ..."

                $ServiceProperties = @{
                    Hive    = $ServiceTemplate.Hive
                    Path    = "$($ServiceTemplate.Path)\$Name"
                    Entries = $ServiceTemplate.Entries
                }
                $ServiceProperties.Entries[0].Value = $RegistryStartValue.$StartupType
                $ServiceProperties.Entries[1].Value = $StartupType -eq 'AutomaticDelayedStart' ? 1 : 0
                Set-RegistryEntry -InputObject $ServiceProperties -Verbose:$false
            }
        }
    }
}

#endregion helper functions

#=======================================
## filter driver
#=======================================
#region filter driver

<#
To list currently registered (loaded) filters:
fltMC.exe filters

To list all filters:
Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\*' |
    Where-Object -Property 'Group' -like -Value 'FSFilter*' |
    Select-Object -Property 'PSChildName', 'Group', 'Start'
#>

$UserChoiceProtectionDriver = '[
  {
    "DisplayName": "userChoice Protection Driver",
    "ServiceName": "UCPD",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "block access to UserChoice Registry keys.
                    i.e. default web browser, PDF Viewer, image editor, DeviceRegion, ..."
  }
]' | ConvertFrom-Json

#endregion filter driver

#=======================================
## system driver
#=======================================
#region system driver

<#
all apps > windows tools > system information > software environment > system drivers (msinfo32.exe)
Can also be listed with: Get-CimInstance -ClassName 'Win32_SystemDriver'.

Not listed by 'Get-Service' but can be queried if the name is provided. e.g. Get-Service -Name 'NetBIOS'.
#>

#===================
### network protocol
#===================
# See also 'tweaks > network' if you want to disable these network protocols without disabling the drivers.

$BridgeDriver = '[
  {
    "DisplayName": "Bridge Driver",
    "ServiceName": "l2bridge",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

$NetBiosDriver = '[
  {
    "DisplayName": "NetBIOS Interface",
    "ServiceName": "NetBIOS",
    "StartupType": "Disabled",
    "DefaultType": "System"
  },
  {
    "DisplayName": "netbt",
    "ServiceName": "NetBT",
    "StartupType": "Disabled",
    "DefaultType": "System",
    "Comment"    : "NetBios over TCP/IP."
  }
]' | ConvertFrom-Json

$LldpDriver = '[
  {
    "DisplayName": "Microsoft Link-Layer Discovery Protocol",
    "ServiceName": "MsLldp",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  }
]' | ConvertFrom-Json

$LltdDriver = '[
  {
    "DisplayName": "Link-Layer Topology Discovery Mapper I/O Driver",
    "ServiceName": "lltdio",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Link-Layer Topology Discovery Responder",
    "ServiceName": "rspndr",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  }
]' | ConvertFrom-Json

$MicrosoftNetworkAdapterMultiplexorDriver = '[
  {
    "DisplayName": "Microsoft Network Adapter Multiplexor Protocol",
    "ServiceName": "NdisImPlatform",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

$QosPacketSchedulerDriver = '[
  {
    "DisplayName": "QoS Packet Scheduler",
    "ServiceName": "Psched",
    "StartupType": "Disabled",
    "DefaultType": "System"
  }
]' | ConvertFrom-Json

#===================
### miscellaneous
#===================

$BitLockerDriver = '[
  {
    "DisplayName": "BitLocker Drive Encryption Filter Driver",
    "ServiceName": "fvevol",
    "StartupType": "Disabled",
    "DefaultType": "Boot"
  }
]' | ConvertFrom-Json

$OfflineFilesDriver = '[
  {
    "DisplayName": "Offline Files Driver",
    "ServiceName": "CSC",
    "StartupType": "Disabled",
    "DefaultType": "System"
  }
]' | ConvertFrom-Json

$NetworkDataUsageDriver = '[
  {
    "DisplayName": "Windows Network Data Usage Monitoring Driver",
    "ServiceName": "Ndu",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  }
]' | ConvertFrom-Json

#endregion system driver

#=======================================
## autoplay
#=======================================
#region autoplay

$AutoplayAndAutorunSvc = '[
  {
    "DisplayName": "Shell Hardware Detection",
    "ServiceName": "ShellHWDetection",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "autoplay & autorun.
                    settings > bluetooth & devices > autoplay.
                    seems to be needed by bitlocker ?"
  }
]' | ConvertFrom-Json

#endregion autoplay

#=======================================
## bluetooth
#=======================================
#region bluetooth

$BluetoothSvc = '[
  {
    "DisplayName": "Bluetooth Support Service",
    "ServiceName": "bthserv",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "bluetooth devices discovery."
  },
  {
    "DisplayName": "Bluetooth User Support Service",
    "ServiceName": "BluetoothUserService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

$BluetoothAndCastSvc = '[
  {
    "DisplayName": "Device Association Service",
    "ServiceName": "DeviceAssociationService",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "needed by bluetooth.
                    needed by Miracast (action center > cast).
                    if disabled, open an overrun warning message when cast icon is clicked.
                    pairing with wired/wireless devices."
  },
  {
    "DisplayName": "DeviceAssociationBroker",
    "ServiceName": "DeviceAssociationBrokerSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    enables apps to pair devices.
                    needed only for gamepads-Xbox ?"
  },
  {
    "DisplayName": "DevicesFlow",
    "ServiceName": "DevicesFlowUserSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "on 24H2+, DO NOT DISABLE. needed by action center.
                    connect/pair WiFi displays and Bluetooth devices."
  }
]' | ConvertFrom-Json

$BluetoothAudioSvc = '[
  {
    "DisplayName": "AVCTP service",
    "ServiceName": "BthAvctpSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed for audio bluetooth/wireless devices."
  },
  {
    "DisplayName": "Bluetooth Audio Gateway Service",
    "ServiceName": "BTAGService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion bluetooth

#=======================================
## cast and project
#=======================================
#region cast and project

# Not included in 'script configuration > services & scheduled tasks'.
$CastAndProjectSvc = '[
  {
    "DisplayName": "DevicePicker",
    "ServiceName": "DevicePickerUserSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "Manage Miracast, DLNA, and DIAL UI."
  },
  {
    "DisplayName": "Wi-Fi Direct Services Connection Manager Service",
    "ServiceName": "WFDSConMgrSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "wireless display and docking.
                    needed by action center > cast & project.
                    if disabled and Cast icon is cliked, break action center (on Win11 23H4).
                    if that happens, you need to open services and set back to Manual.
                    (on Win11 23H2, break action center functionality if Cast icon is not hidden)."
  }
]' | ConvertFrom-Json

#endregion cast and project

#=======================================
## deprecated
#=======================================
#region deprecated

$DeprecatedSvc = '[
  {
    "DisplayName": "ActiveX Installer (AxInstSV)",
    "ServiceName": "AxInstSV",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Internet Explorer related."
  },
  {
    "DisplayName": "AllJoyn Router Service",
    "ServiceName": "AJRouter",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Internet of Things related."
  },
  {
    "DisplayName": "Application Layer Gateway Service",
    "ServiceName": "ALG",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "plug-ins support for Internet connection sharing."
  },
  {
    "DisplayName": "Sync Host",
    "ServiceName": "OneSyncSvc",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart"
  },
  {
    "DisplayName": "WebClient",
    "ServiceName": "WebClient",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "WebDAV."
  }
]' | ConvertFrom-Json

#endregion deprecated

#=======================================
## hyper-v
#=======================================
#region hyper-v

$HyperVSvc = '[
  {
    "DisplayName": "HV Host Service",
    "ServiceName": "HvHost",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Data Exchange Service",
    "ServiceName": "vmickvpexchange",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Guest Service Interface",
    "ServiceName": "vmicguestinterface",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Guest Shutdown Service",
    "ServiceName": "vmicshutdown",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Heartbeat Service",
    "ServiceName": "vmicheartbeat",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V PowerShell Direct Service",
    "ServiceName": "vmicvmsession",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Remote Desktop Virtualization Service",
    "ServiceName": "vmicrdv",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Time Synchronization Service",
    "ServiceName": "vmictimesync",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Hyper-V Volume Shadow Copy Requestor",
    "ServiceName": "vmicvss",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion hyper-v

#=======================================
## microsoft edge
#=======================================
#region microsoft edge

$MicrosoftEdgeSvc = '[
  {
    "DisplayName": "Microsoft Edge Elevation Service (MicrosoftEdgeElevationService)",
    "ServiceName": "MicrosoftEdgeElevationService",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Microsoft Edge Update Service (edgeupdate)",
    "ServiceName": "edgeupdate",
    "StartupType": "Manual",
    "DefaultType": "AutomaticDelayedStart"
  },
  {
    "DisplayName": "Microsoft Edge Update Service (edgeupdatem)",
    "ServiceName": "edgeupdatem",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion microsoft edge

#=======================================
## microsoft office
#=======================================
#region microsoft office

$MicrosoftOfficeSvc = '[
  {
    "DisplayName": "Microsoft Office Click-to-Run Service",
    "ServiceName": "ClickToRunSvc",
    "StartupType": "Manual",
    "DefaultType": "Automatic",
    "Comment"    : "if tasks are not disabled or modified, will still be launched at startup.
                    slow down first startup (Office apps need this service running).
                    left to Automatic if daily use of Office."
  }
]' | ConvertFrom-Json

#endregion microsoft office

#=======================================
## microsoft store
#=======================================
#region microsoft store

$MicrosoftStoreSvc = '[
  {
    "DisplayName": "AppX Deployment Service (AppXSVC)",
    "ServiceName": "AppXSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    infrastructure support for deploying Store applications."
  },
  {
    "DisplayName": "Capability Access Manager Service",
    "ServiceName": "camsvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "manages UWP apps access."
  },
  {
    "DisplayName": "Client License Service (ClipSVC)",
    "ServiceName": "ClipSVC",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    infrastructure support for the Microsoft Store."
  },
  {
    "DisplayName": "Microsoft Account Sign-in Assistant",
    "ServiceName": "wlidsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed if using microsoft account to log in to computer.
                    needed to install new apps from microsoft store.
                    needed to create new user account.
                    not needed to auto-update already installed apps."
  },
  {
    "DisplayName": "Microsoft Store Install Service",
    "ServiceName": "InstallService",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows License Manager Service",
    "ServiceName": "LicenseManager",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "needed by Windows Photos (and probably more Store apps)."
  },
  {
    "DisplayName": "Windows PushToInstall Service",
    "ServiceName": "PushToInstall",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "install Store apps remotely."
  }
]' | ConvertFrom-Json

#endregion microsoft store

#=======================================
## network
#=======================================
#region network

$NetworkSvc = '[
  {
    "DisplayName": "Distributed Link Tracking Client",
    "ServiceName": "TrkWks",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with registry editing."
  },
  {
    "DisplayName": "Internet Connection Sharing (ICS)",
    "ServiceName": "SharedAccess",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed by Microsoft Defender Application Guard.
                    needed by Mobile hotspot.
                    needed by WSL2.
                    even if Disabled, will be set to Manual and running if WSL2 is launched."
  },
  {
    "DisplayName": "Kerberos Local Key Distribution Center",
    "ServiceName": "LocalKdc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Microsoft iSCSI Initiator Service",
    "ServiceName": "MSiSCSI",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Netlogon",
    "ServiceName": "Netlogon",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "authentication for domain network."
  },
  {
    "DisplayName": "Network Connectivity Assistant",
    "ServiceName": "NcaSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Offline Files",
    "ServiceName": "CscService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Peer Name Resolution Protocol",
    "ServiceName": "PNRPsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "remote assistance."
  },
  {
    "DisplayName": "Peer Networking Grouping",
    "ServiceName": "p2psvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "HomeGroup."
  },
  {
    "DisplayName": "Peer Networking Identity Manager",
    "ServiceName": "p2pimsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "remote assistance and HomeGroup."
  },
  {
    "DisplayName": "PNRP Machine Name Publication Service",
    "ServiceName": "PNRPAutoReg",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "network DNS resolution (P2P)."
  },
  {
    "DisplayName": "SNMP Trap",
    "ServiceName": "SNMPTrap",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "old/legacy protocol."
  },
  {
    "DisplayName": "TCP/IP NetBIOS Helper",
    "ServiceName": "lmhosts",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "old/legacy protocol."
  }
]' | ConvertFrom-Json

#endregion network

#=======================================
## network discovery
#=======================================
#region network discovery

# settings > network & internet > advanced network settings > advanced sharing settings

$NetworkDiscoverySvc = '[
  {
    "DisplayName": "Function Discovery Resource Publication",
    "ServiceName": "FDResPub",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Function Discovery Provider Host",
    "ServiceName": "fdPHost",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network Connected Devices Auto-Setup",
    "ServiceName": "NcdAutoSetup",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "SSDP Discovery",
    "ServiceName": "SSDPSRV",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "UPnP Device Host",
    "ServiceName": "upnphost",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

$FileAndPrinterSharingSvc = '[
  {
    "DisplayName": "Server",
    "ServiceName": "LanmanServer",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "file and printer sharing (SMB server)."
  },
  {
    "DisplayName": "Workstation",
    "ServiceName": "LanmanWorkstation",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "connect to remote computer/server.
                    file and printer sharing (SMB client)."
  }
]' | ConvertFrom-Json

$PrinterSvc = '[
  {
    "DisplayName": "Print Device Configuration Service",
    "ServiceName": "PrintDeviceConfigurationService",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed by Windows protected print mode.
                    settings > bluetooth & devices > printers & scanners."
  },
  {
    "DisplayName": "Print Spooler",
    "ServiceName": "Spooler",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Printer Extensions and Notifications",
    "ServiceName": "PrintNotify",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "PrintScanBrokerService",
    "ServiceName": "PrintScanBrokerService",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "probably related to Windows protected print mode"
  },
  {
    "DisplayName": "PrintWorkflow",
    "ServiceName": "PrintWorkflowUserSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    needed by some apps ? can print with adobe reader without this service."
  }
]' | ConvertFrom-Json

#endregion network discovery

#=======================================
## remote desktop
#=======================================
#region remote desktop

$RemoteDesktopSvc = '[
  {
    "DisplayName": "Remote Desktop Configuration",
    "ServiceName": "SessionEnv",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Remote Desktop Services",
    "ServiceName": "TermService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Remote Desktop Services UserMode Port Redirector",
    "ServiceName": "UmRdpService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Remote Registry",
    "ServiceName": "RemoteRegistry",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Routing and Remote Access",
    "ServiceName": "RemoteAccess",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  }
]' | ConvertFrom-Json

#endregion remote desktop

#=======================================
## sensor
#=======================================
#region sensor

$SensorSvc = '[
  {
    "DisplayName": "Sensor Data Service",
    "ServiceName": "SensorDataService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Sensor Monitoring Service",
    "ServiceName": "SensrSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Sensor Service",
    "ServiceName": "SensorService",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "manages different sensors functionality.
                    if disabled on laptop, break/crash settings > system > power & battery.
                    do not disable on laptop."
  }
]' | ConvertFrom-Json

#endregion sensor

#=======================================
## smart card
#=======================================
#region smart card

$SmartCardSvc = '[
  {
    "DisplayName": "Certificate Propagation",
    "ServiceName": "CertPropSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Smart Card",
    "ServiceName": "SCardSvr",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Smart Card Device Enumeration Service",
    "ServiceName": "ScDeviceEnum",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Smart Card Removal Policy",
    "ServiceName": "SCPolicySvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

$VirtualSmartCardSvc = '[
  {
    "DisplayName": "Microsoft Passport",
    "ServiceName": "NgcSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Microsoft Passport Container",
    "ServiceName": "NgcCtnrSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  }
]' | ConvertFrom-Json

#endregion smart card

#=======================================
## telemetry: diagnostic and usage
#=======================================
#region telemetry: diagnostic and usage

$TelemetryDiagUsageSvc = '[
  {
    "DisplayName": "Connected User Experiences and Telemetry",
    "ServiceName": "DiagTrack",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Diagnostic Execution Service",
    "ServiceName": "diagsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Device Management Wireless Application Protocol (WAP) Push message Routing Service",
    "ServiceName": "dmwappushservice",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Inventory and Compatibility Appraisal service",
    "ServiceName": "InventorySvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "aka compattelrunner in windows 10."
  },
  {
    "DisplayName": "Microsoft (R) Diagnostics Hub Standard Collector Service",
    "ServiceName": "diagnosticshub.standardcollector.service",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Problem Reports Control Panel Support",
    "ServiceName": "wercplsupport",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Program Compatibility Assistant Service",
    "ServiceName": "PcaSvc",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart"
  },
  {
    "DisplayName": "Windows Error Reporting Service",
    "ServiceName": "WerSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion telemetry: diagnostic and usage

#=======================================
## troubleshooting: diagnostic and usage
#=======================================
#region troubleshooting: diagnostic and usage

# Could be considered as telemetry.

$TroubleshootingDiagUsageSvc = '[
  {
    "DisplayName": "Data Usage",
    "ServiceName": "DusmSvc",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "need DPS service running.
                    disable/break:
                    task manager > app history.
                    settings > network & internet > top banner.
                    settings > network & internet > advanced network settngs > data usage (& limit).
                    settings > system > power > top banner battery levels.
                    settings > system > power > battery usage."
  },
  {
    "DisplayName": "Diagnostic Policy Service",
    "ServiceName": "DPS",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with registry editing.
                    disable/break: task manager > processes > network column.
                    network activity will not update and stay at 0 Mbps."
  },
  {
    "DisplayName": "Diagnostic Service Host",
    "ServiceName": "WdiServiceHost",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with registry editing."
  },
  {
    "DisplayName": "Diagnostic System Host",
    "ServiceName": "WdiSystemHost",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with registry editing."
  },
  {
    "DisplayName": "Recommended Troubleshooting Service",
    "ServiceName": "TroubleshootingSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion troubleshooting: diagnostic and usage

#=======================================
## virtual reality
#=======================================
#region virtual reality

$VirtualRealitySvc = '[
  {
    "DisplayName": "Spatial Data Service",
    "ServiceName": "SharedRealitySvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Volumetric Audio Compositor Service",
    "ServiceName": "VacSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Mixed Reality OpenXR Service",
    "ServiceName": "MixedRealityOpenXRSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Perception Service",
    "ServiceName": "spectrum",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Perception Simulation Service",
    "ServiceName": "perceptionsimulation",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion virtual reality

#=======================================
## vpn
#=======================================
#region vpn

$VpnSvc = '[
  {
    "DisplayName": "IKE and AuthIP IPsec Keying Modules",
    "ServiceName": "IKEEXT",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Remote Access Connection Manager",
    "ServiceName": "RasMan",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Secure Socket Tunneling Protocol Service",
    "ServiceName": "SstpSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

# Not included in 'script configuration > services & scheduled tasks'.
$ProxySvc = '[
  {
    "DisplayName": "WinHTTP Web Proxy Auto-Discovery Service",
    "ServiceName": "WinHttpAutoProxySvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    on 24H2+, required by Windows Connection Manager (Wcmsvc) service.
                    needed for vpn & proxy server.
                    settings > network & internet > proxy."
  }
]' | ConvertFrom-Json

#endregion vpn

#=======================================
## webcam
#=======================================
#region webcam

$WebcamSvc = '[
  {
    "DisplayName": "Windows Camera Frame Server",
    "ServiceName": "FrameServer",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "e.g. Microsoft Teams, Skype, or Camera app."
  },
  {
    "DisplayName": "Windows Camera Frame Server Monitor",
    "ServiceName": "FrameServerMonitor",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "e.g. Microsoft Teams, Skype, or Camera app."
  }
]' | ConvertFrom-Json

#endregion webcam

#=======================================
## windows backup & system restore
#=======================================
#region windows backup & system restore

$WindowsBackupAndSystemRestoreSvc = '[
  {
    "DisplayName": "Block Level Backup Engine Service",
    "ServiceName": "wbengine",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "File History Service",
    "ServiceName": "fhsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Microsoft Software Shadow Copy Provider",
    "ServiceName": "swprv",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed by Windows Backup and System Restore."
  },
  {
    "DisplayName": "Volume Shadow Copy",
    "ServiceName": "VSS",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed by Windows Backup and System Restore."
  },
  {
    "DisplayName": "Windows Backup",
    "ServiceName": "SDRSVC",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion windows backup & system restore

#=======================================
## windows defender
#=======================================
#region windows defender

$WindowsDefenderPhishingProtectionSvc = '[
  {
    "DisplayName": "Web Threat Defense Service",
    "ServiceName": "webthreatdefsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Web Threat Defense User Service",
    "ServiceName": "webthreatdefusersvc",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  }
]' | ConvertFrom-Json

#endregion windows defender

#=======================================
## windows search
#=======================================
#region windows search

$WindowsSearchSvc = '[
  {
    "DisplayName": "Windows Search",
    "ServiceName": "WSearch",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "search indexing & files search in start menu.
                    search still available in file explorer (without index).
                    settings > privacy & security > searching windows."
  }
]' | ConvertFrom-Json

#endregion windows search

#=======================================
## windows subsystem for linux
#=======================================
#region windows subsystem for linux

$WSLSvc = '[
  {
    "DisplayName": "Hyper-V Host Compute Service",
    "ServiceName": "vmcompute",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed by WSL"
  },
  {
    "DisplayName": "P9RdrService",
    "ServiceName": "P9RdrService",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Plan 9 Redirector Service.
                    Enables trigger-starting plan9 file servers (supported by WSL)."
  },
  {
    "DisplayName": "Windows Subsystem for Linux",
    "ServiceName": "WslInstaller",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    left to Automatic if daily use of WSL.
                    seems to be removed in latest version."
  },
  {
    "DisplayName": "WSL Service",
    "ServiceName": "WSLService",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "left to Automatic if daily use of WSL."
  }
]' | ConvertFrom-Json

#endregion windows subsystem for linux

#=======================================
## xbox
#=======================================
#region xbox

$XboxSvc = '[
  {
    "DisplayName": "Xbox Accessory Management Service",
    "ServiceName": "XboxGipSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Xbox Live Auth Manager",
    "ServiceName": "XblAuthManager",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Xbox Live Game Save",
    "ServiceName": "XblGameSave",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Xbox Live Networking Service",
    "ServiceName": "XboxNetApiSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion xbox

#=======================================
## miscellaneous features
#=======================================
#region miscellaneous features

$MiscFeaturesSvc = '[
  {
    "DisplayName": "BitLocker Drive Encryption Service",
    "ServiceName": "BDESVC",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Clipboard User Service",
    "ServiceName": "cbdhsvc",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "clipboard multiple items (win + v).
                    settings > system > clipboard."
  },
  {
    "DisplayName": "Downloaded Maps Manager",
    "ServiceName": "MapsBroker",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "windows/bing maps.
                    settings > apps > offline maps."
  },
  {
    "DisplayName": "GameDVR and Broadcast User Service",
    "ServiceName": "BcastDVRUserService",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "game recording.
                    settings > gaming > captures."
  },
  {
    "DisplayName": "Geolocation Service",
    "ServiceName": "lfsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "settings > privacy & security > location."
  },
  {
    "DisplayName": "Now Playing Session Manager Service",
    "ServiceName": "NPSMSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "show the now playing media on the action center."
  },
  {
    "DisplayName": "Parental Controls",
    "ServiceName": "WpcMonSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "PenService",
    "ServiceName": "PenService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Phone Service",
    "ServiceName": "PhoneSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Phone Link and VoIP."
  },
  {
    "DisplayName": "Radio Management Service",
    "ServiceName": "RmSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "airplane mode."
  },
  {
    "DisplayName": "Windows Biometric Service",
    "ServiceName": "WbioSrvc",
    "StartupType": "Manual",
    "DefaultType": "Automatic",
    "Comment"    : "if disabled with device present, break/freeze settings > account > sign-in options.
                    default is Manual if no biometric device."
  },
  {
    "DisplayName": "Windows Mobile Hotspot Service",
    "ServiceName": "icssvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "settings > network & internet > mobile hotspot."
  }
]' | ConvertFrom-Json

#endregion miscellaneous features

#=======================================
## miscellaneous services
#=======================================
#region miscellaneous services

$MiscServices = '[
  {
    "DisplayName": "Application Identity",
    "ServiceName": "AppIDSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    needed by AppLocker."
  },
  {
    "DisplayName": "Agent Activation Runtime",
    "ServiceName": "AarSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "used by Cortana (audio driver-related process)."
  },
  {
    "DisplayName": "Application Management",
    "ServiceName": "AppMgmt",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "software deployed through Group Policy."
  },
  {
    "DisplayName": "AssignedAccessManager Service",
    "ServiceName": "AssignedAccessManagerSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Kiosk mode."
  },
  {
    "DisplayName": "BranchCache",
    "ServiceName": "PeerDistSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Windows Update sharing (downloads from other PCs)."
  },
  {
    "DisplayName": "CaptureService",
    "ServiceName": "CaptureService",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "needed by snipping tool.
                    screen capture functionality for apps using Windows.Graphics.Capture API."
  },
  {
    "DisplayName": "Cellular Time",
    "ServiceName": "autotimesvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "set time from mobile network."
  },
  {
    "DisplayName": "Cloud Backup and Restore Service",
    "ServiceName": "CloudBackupRestoreSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Connected Devices Platform Service",
    "ServiceName": "CDPSvc",
    "StartupType": "AutomaticDelayedStart",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "needed by Night Light.
                    needed by Nearby sharing."
  },
  {
    "DisplayName": "Connected Devices Platform User Service",
    "ServiceName": "CDPUserSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "needed to enable/disable Night Light.
                    needed by Nearby sharing.
                    connect, manage, and control connected devices.
                    (mobile, Xbox, HoloLens, or smart/IoT devices)."
  },
  {
    "DisplayName": "Contact Data",
    "ServiceName": "PimIndexMaintenanceSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "contact data indexing."
  },
  {
    "DisplayName": "Data Sharing Service",
    "ServiceName": "DsSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "telemetry related ?
                    needed by SMB related (e.g. file and printer sharing) ?"
  },
  {
    "DisplayName": "Delivery Optimization",
    "ServiceName": "DoSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    needed by windows update and microsoft store (not only delivery optimization).
                    even if disabled, will be set to Manual by windows update or microsoft store."
  },
  {
    "DisplayName": "Device Setup Manager",
    "ServiceName": "DsmSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "somehow similar to: prevent device metadata retrieval from the Internet.
                    see tweaks > system properties > hardware."
  },
  {
    "DisplayName": "DevQuery Background Discovery Broker",
    "ServiceName": "DevQueryBroker",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "enables apps to discover devices with a backgroud task.
                    periodically scans for devices and sends a notification to all apps
                    that have registered for device discovery events.
                    enable if problems with an app trying to discover a device."
  },
  {
    "DisplayName": "Device Management Enrollment Service",
    "ServiceName": "DmEnrollmentSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "access organization resources."
  },
  {
    "DisplayName": "Display Enhancement Service",
    "ServiceName": "DisplayEnhancementService",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "manages display enhancement (e.g. brightness control)."
  },
  {
    "DisplayName": "Display Policy Service",
    "ServiceName": "DispBrokerDesktopSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "local and remote displays.
                    required on 24H2+ for some things ?
                    if disabled, on VirtualBox, the auto resize window on startup is broken.
                    could probably broke some other things on bare metal install ?"
  },
  {
    "DisplayName": "Distributed Transaction Coordinator",
    "ServiceName": "MSDTC",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "coordinates transactions from multiple resource managers."
  },
  {
    "DisplayName": "Embedded Mode",
    "ServiceName": "embeddedmode",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    activate background applications (IoT related)."
  },
  {
    "DisplayName": "Encrypting File System (EFS)",
    "ServiceName": "EFS",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "encrypt/access files or folders on NTFS file system volumes.
                    files/folders > properties > advanced > encrypt contents to secure data."
  },
  {
    "DisplayName": "Enterprise App Management Service",
    "ServiceName": "EntAppSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "GraphicsPerfSvc",
    "ServiceName": "GraphicsPerfSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Human Interface Device Service",
    "ServiceName": "hidserv",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "enable if some (rare?) peripherals does not function correctly."
  },
  {
    "DisplayName": "IP Helper",
    "ServiceName": "iphlpsvc",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "deprecated.
                    needed by vpn ?"
  },
  {
    "DisplayName": "IP Translation Configuration Service",
    "ServiceName": "IpxlatCfgSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "translation from v4 to v6 and vice versa.
                    needed by vpn ?"
  },
  {
    "DisplayName": "IPsec Policy Agent",
    "ServiceName": "PolicyAgent",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "enforces IPsec policies (secpol.msc or netsh ipsec).
                    if using IPsec, you also need IKE and AuthIP IPsec Keying Modules."
  },
  {
    "DisplayName": "KtmRm for Distributed Transaction Coordinator",
    "ServiceName": "KtmRm",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "coordinates transactions between MSDTC and KTM."
  },
  {
    "DisplayName": "Language Experience Service",
    "ServiceName": "LxpSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "needed to install additional Windows languages."
  },
  {
    "DisplayName": "Link-Layer Topology Discovery Mapper",
    "ServiceName": "lltdsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "network map."
  },
  {
    "DisplayName": "MessagingService",
    "ServiceName": "MessagingService",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "text messaging and related functionality.
                    settings > privacy & security > messaging."
  },
  {
    "DisplayName": "Microsoft Cloud Identity Service",
    "ServiceName": "cloudidsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "tenant restrictions (cloud-policy based authorization control plane).
                    used in corporate environnement."
  },
  {
    "DisplayName": "Microsoft Storage Spaces SMP",
    "ServiceName": "smphost",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "group drives together to helps protect from drive failure.
                    settings > storage > advanced storage settings > storage spaces."
  },
  {
    "DisplayName": "Microsoft Windows SMS Router Service",
    "ServiceName": "SmsRouter",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Natural Authentication",
    "ServiceName": "NaturalAuthentication",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "device unlock (face recognition) and dynamic Lock."
  },
  {
    "DisplayName": "Payments and NFC/SE Manager",
    "ServiceName": "SEMgrSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Performance Logs & Alerts",
    "ServiceName": "pla",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "collects performance data from local or remote computers."
  },
  {
    "DisplayName": "Portable Device Enumerator Service",
    "ServiceName": "WPDBusEnum",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "enforces group policy for removable mass-storage devices."
  },
  {
    "DisplayName": "Quality Windows Audio Video Experience",
    "ServiceName": "QWAVE",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "VoIP."
  },
  {
    "DisplayName": "ReFS Dedup Service",
    "ServiceName": "refsdedupsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "ReFS data deduplication (custom storage related)."
  },
  {
    "DisplayName": "Remote Access Auto Connection Manager",
    "ServiceName": "RasAuto",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "connects to remote network (when apps using remote DNS/NetBIOS address)."
  },
  {
    "DisplayName": "Remote Procedure Call (RPC) Locator",
    "ServiceName": "RpcLocator",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "old/legacy service.
                    application compatibility for very old software."
  },
  {
    "DisplayName": "Retail Demo Service",
    "ServiceName": "RetailDemo",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Secondary Logon",
    "ServiceName": "seclogon",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "Run as different user (option in the extended context menu)."
  },
  {
    "DisplayName": "Still Image Acquisition Events",
    "ServiceName": "WiaRpc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "scanners and cameras."
  },
  {
    "DisplayName": "Storage Service",
    "ServiceName": "StorSvc",
    "StartupType": "Manual",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "needed by micosoft store (install/update apps) and storage sense.
                    needed to detect external usb drive ?
                    if disabled, break/crash:
                    settings > system > storage (no data, no auto clean up, no advanced settings)."
  },
  {
    "DisplayName": "Storage Tiers Management",
    "ServiceName": "TieringEngineService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "SysMain",
    "ServiceName": "SysMain",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "Superfetch and memory compression."
  },
  {
    "DisplayName": "Telephony",
    "ServiceName": "TapiSrv",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "VoIP."
  },
  {
    "DisplayName": "Themes",
    "ServiceName": "Themes",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "User Data Access",
    "ServiceName": "UserDataSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "contact info, calendars, messages, and other content."
  },
  {
    "DisplayName": "User Data Storage",
    "ServiceName": "UnistoreSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "contact info, calendars, messages, and other content."
  },
  {
    "DisplayName": "WalletService",
    "ServiceName": "WalletService",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Web Account Manager",
    "ServiceName": "TokenBroker",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "needed to load settings > account > sign-in options.
                    needed by microsoft store (only by apps that need login)."
  },
  {
    "DisplayName": "Windows Connect Now - Config Registrar",
    "ServiceName": "wcncsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "WPS protocol."
  },
  {
    "DisplayName": "Windows Event Collector",
    "ServiceName": "Wecsvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "events from remote sources."
  },
  {
    "DisplayName": "Windows Font Cache Service",
    "ServiceName": "FontCache",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Image Acquisition (WIA)",
    "ServiceName": "StiSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "scanners and cameras."
  },
  {
    "DisplayName": "Windows Insider Service",
    "ServiceName": "wisvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Media Player Network Sharing Service",
    "ServiceName": "WMPNetworkSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Modules Installer",
    "ServiceName": "TrustedInstaller",
    "StartupType": "Manual",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with registry editing.
                    default is Manual ?"
  },
  {
    "DisplayName": "Windows Presentation Foundation Font Cache 3.0.0.0",
    "ServiceName": "FontCache3.0.0.0",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Remote Management (WS-Management)",
    "ServiceName": "WinRM",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Work Folders",
    "ServiceName": "workfolderssvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "WWAN AutoConfig",
    "ServiceName": "WwanSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "mobile network connection.
                    default is probably Automatic if you got celluar modem device."
  },
  {
    "DisplayName": "WSAIFabricSvc",
    "ServiceName": "WSAIFabricSvc",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "probably an Azure AI-related thing."
  }
]' | ConvertFrom-Json

#endregion miscellaneous services

#=======================================
## others
#=======================================
#region others

# Untouched services.
# I didn't test to change these services (Could break (or not) Windows).
# Not included in 'script configuration > services & scheduled tasks'.
$OthersServices = '[
  {
    "DisplayName": "App Readiness",
    "ServiceName": "AppReadiness",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Application Information",
    "ServiceName": "Appinfo",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Auto Time Zone Updater",
    "ServiceName": "tzautoupdate",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Background Intelligent Transfer Service",
    "ServiceName": "BITS",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Background Tasks Infrastructure Service",
    "ServiceName": "BrokerInfrastructure",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Base Filtering Engine",
    "ServiceName": "BFE",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "CNG Key Isolation",
    "ServiceName": "KeyIso",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "COM+ Event System",
    "ServiceName": "EventSystem",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "COM+ System Application",
    "ServiceName": "COMSysApp",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "ConsentUX User Service",
    "ServiceName": "ConsentUxUserSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "CoreMessaging",
    "ServiceName": "CoreMessagingRegistrar",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Credential Manager",
    "ServiceName": "VaultSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "CredentialEnrollmentManagerUserSvc",
    "ServiceName": "CredentialEnrollmentManagerUserSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Cryptographic Services",
    "ServiceName": "CryptSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "DCOM Server Process Launcher",
    "ServiceName": "DcomLaunch",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Declared Configuration(DC) service",
    "ServiceName": "dcsvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Device Install Service",
    "ServiceName": "DeviceInstall",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "DHCP Client",
    "ServiceName": "Dhcp",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "DialogBlockingService",
    "ServiceName": "DialogBlockingService",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "DNS Client",
    "ServiceName": "Dnscache",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Extensible Authentication Protocol",
    "ServiceName": "EapHost",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "GameInput Service",
    "ServiceName": "GameInputSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Group Policy Client",
    "ServiceName": "gpsvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Host Network Service",
    "ServiceName": "hns",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Local Profile Assistant Service",
    "ServiceName": "wlpasvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Local Session Manager",
    "ServiceName": "LSM",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "McpManagementService",
    "ServiceName": "McpManagementService",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Microsoft App-V Client",
    "ServiceName": "AppVClient",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Microsoft Defender Antivirus Network Inspection Service",
    "ServiceName": "WdNisSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Microsoft Defender Antivirus Service",
    "ServiceName": "WinDefend",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Microsoft Defender Core Service",
    "ServiceName": "MDCoreSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Microsoft Keyboard Filter",
    "ServiceName": "MsKeyboardFilter",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Microsoft Update Health Service",
    "ServiceName": "uhssvc",
    "StartupType": "AutomaticDelayedStart",
    "DefaultType": "AutomaticDelayedStart"
  },
  {
    "DisplayName": "Net.Tcp Port Sharing Service",
    "ServiceName": "NetTcpPortSharing",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Network Connection Broker",
    "ServiceName": "NcbService",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network Connections",
    "ServiceName": "Netman",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network List Service",
    "ServiceName": "netprofm",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network Location Awareness",
    "ServiceName": "NlaSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network Setup Service",
    "ServiceName": "NetSetupSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Network Store Interface Service",
    "ServiceName": "nsi",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Network Virtualization Service",
    "ServiceName": "nvagent",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "OpenSSH Authentication Agent",
    "ServiceName": "ssh-agent",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Optimize drives",
    "ServiceName": "defragsvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Performance Counter DLL Host",
    "ServiceName": "PerfHost",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Plug and Play",
    "ServiceName": "PlugPlay",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Power",
    "ServiceName": "Power",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Remote Procedure Call (RPC)",
    "ServiceName": "RpcSs",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "RPC Endpoint Mapper",
    "ServiceName": "RpcEptMapper",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Security Accounts Manager",
    "ServiceName": "SamSs",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with registry editing."
  },
  {
    "DisplayName": "Security Center",
    "ServiceName": "wscsvc",
    "StartupType": "AutomaticDelayedStart",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Shared PC Account Manager",
    "ServiceName": "shpamsvc",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "Software Protection",
    "ServiceName": "sppsvc",
    "StartupType": "AutomaticDelayedStart",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Spot Verifier",
    "ServiceName": "svsvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "State Repository Service",
    "ServiceName": "StateRepository",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "System Event Notification Service",
    "ServiceName": "SENS",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "System Events Broker",
    "ServiceName": "SystemEventsBroker",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "System Guard Runtime Monitor Broker",
    "ServiceName": "SgrmBroker",
    "StartupType": "Disabled",
    "DefaultType": "Disabled",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Task Scheduler",
    "ServiceName": "Schedule",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Text Input Management Service",
    "ServiceName": "TextInputManagementService",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc.
                    DO NOT DISABLE (system will fail to boot)."
  },
  {
    "DisplayName": "Time Broker",
    "ServiceName": "TimeBrokerSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Udk User Service",
    "ServiceName": "UdkUserSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Update Orchestrator Service",
    "ServiceName": "UsoSvc",
    "StartupType": "AutomaticDelayedStart",
    "DefaultType": "AutomaticDelayedStart"
  },
  {
    "DisplayName": "User Experience Virtualization Service",
    "ServiceName": "UevAgentService",
    "StartupType": "Disabled",
    "DefaultType": "Disabled"
  },
  {
    "DisplayName": "User Manager",
    "ServiceName": "UserManager",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "User Profile Service",
    "ServiceName": "ProfSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Virtual Disk",
    "ServiceName": "vds",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "WaaSMedicSvc",
    "ServiceName": "WaaSMedicSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Warp JIT Service",
    "ServiceName": "WarpJITSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Audio",
    "ServiceName": "Audiosrv",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Audio Endpoint Builder",
    "ServiceName": "AudioEndpointBuilder",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Connection Manager",
    "ServiceName": "Wcmsvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Defender Advanced Threat Protection Service",
    "ServiceName": "Sense",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Windows Defender Firewall",
    "ServiceName": "mpssvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Windows Encryption Provider Host Service",
    "ServiceName": "WEPHOSTSVC",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Event Log",
    "ServiceName": "EventLog",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Installer",
    "ServiceName": "msiserver",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc."
  },
  {
    "DisplayName": "Windows Management Instrumentation",
    "ServiceName": "Winmgmt",
    "StartupType": "Automatic",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Windows Management Service",
    "ServiceName": "WManSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Push Notifications System Service",
    "ServiceName": "WpnService",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "on 24H2+, DO NOT DISABLE. needed by action center."
  },
  {
    "DisplayName": "Windows Push Notifications User Service",
    "ServiceName": "WpnUserService",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "DO NOT DISABLE. needed by action center."
  },
  {
    "DisplayName": "Windows Security Service",
    "ServiceName": "SecurityHealthService",
    "StartupType": "Manual",
    "DefaultType": "Manual",
    "Comment"    : "cannot be changed with services.msc.
                    cannot be changed with registry editing."
  },
  {
    "DisplayName": "Windows Time",
    "ServiceName": "W32Time",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Update",
    "ServiceName": "wuauserv",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Windows Virtual Audio Device Proxy Service",
    "ServiceName": "ApxSvc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "Wired AutoConfig",
    "ServiceName": "dot3svc",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  },
  {
    "DisplayName": "WLAN AutoConfig",
    "ServiceName": "WlanSvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "if no wireless device, default is Manual."
  },
  {
    "DisplayName": "WMI Performance Adapter",
    "ServiceName": "wmiApSrv",
    "StartupType": "Manual",
    "DefaultType": "Manual"
  }
]' | ConvertFrom-Json

#endregion others

#endregion services


#==============================================================================
#                            third-party services
#==============================================================================
#region third-party services

<#
Will be set back to 'DefaultType' on each app update.
Need to be reapplied (or automated) if desired.
#>

#=======================================
## adobe
#=======================================
$AdobeSvc = '[
  {
    "DisplayName": "Adobe Acrobat Update Service",
    "ServiceName": "AdobeARMservice",
    "StartupType": "Manual",
    "DefaultType": "Automatic",
    "Comment"    : "Adobe Acrobat check available update when the app is running even if this service is not running."
  }
]' | ConvertFrom-Json

#=======================================
## intel
#=======================================
$IntelSvc = '[
  {
    "DisplayName": "Intel(R) Capability Licensing Service TCP IP Interface",
    "ServiceName": "Intel(R) Capability Licensing Service TCP IP Interface",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "seems to be removed in latest version."
  },
  {
    "DisplayName": "Intel(R) Content Protection HDCP Service",
    "ServiceName": "cplspcon",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "drm related.
                    needed by Netflix, Amazon Prime Video, Disney+, or similar ?"
  },
  {
    "DisplayName": "Intel(R) Content Protection HECI Service",
    "ServiceName": "cphs",
    "StartupType": "Disabled",
    "DefaultType": "Manual",
    "Comment"    : "drm related.
                    needed for premium video playback (such as blu-Ray) ?
                    needed by some other platform with protected content ?"
  },
  {
    "DisplayName": "Intel(R) Dynamic Application Loader Host Interface Service",
    "ServiceName": "jhi_service",
    "StartupType": "Disabled",
    "DefaultType": "AutomaticDelayedStart",
    "Comment"    : "intel ME related."
  },
  {
    "DisplayName": "Intel(R) Dynamic Platform and Thermal Framework service",
    "ServiceName": "esifsvc",
    "StartupType": "Automatic",
    "DefaultType": "Automatic",
    "Comment"    : "safety service, not recommended to disable."
  },
  {
    "DisplayName": "Intel(R) Graphics Command Center Service",
    "ServiceName": "igccservice",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Intel(R) HD Graphics Control Panel Service",
    "ServiceName": "igfxCUIService2.0.0.0",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Intel(R) Management and Security Application Local Management Service",
    "ServiceName": "LMS",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "remote PC management."
  },
  {
    "DisplayName": "Intel(R) Management Engine WMI Provider Registration",
    "ServiceName": "WMIRegistrationService",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Intel(R) TPM Provisioning Service",
    "ServiceName": "Intel(R) TPM Provisioning Service",
    "StartupType": "Disabled",
    "DefaultType": "Automatic",
    "Comment"    : "needed by bitlocker and PIN/Hello logons ?"
  },
  {
    "DisplayName": "Thunderbolt(TM) Application Launcher",
    "ServiceName": "TbtHostControllerService",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  },
  {
    "DisplayName": "Thunderbolt(TM) Peer to Peer Shortcut",
    "ServiceName": "TbtP2pShortcutService",
    "StartupType": "Disabled",
    "DefaultType": "Automatic"
  }
]' | ConvertFrom-Json

#=======================================
## nvidia
#=======================================
$NvidiaSvc = '[
  {
    "DisplayName": "NVIDIA Display Container LS",
    "ServiceName": "NVDisplay.ContainerLocalSystem",
    "StartupType": "Manual",
    "DefaultType": "Automatic",
    "Comment"    : "needed for NVIDIA Control Panel (service must be running).
                    left to Automatic if you use a lot the Nvidia Control Panel.
                    enable when gaming ? needed for some driver features (probably not) ?"
  }
]' | ConvertFrom-Json

#endregion third-party services


#==============================================================================
#                               scheduled tasks
#==============================================================================
#region scheduled tasks

#=======================================
## helper functions
#=======================================
#region helper functions

function Export-DefaultScheduledTasksState
{
    $LogFilePath = "$PSScriptRoot\windows_scheduled_tasks_default.txt"
    if (-not (Test-Path -Path $LogFilePath))
    {
        Write-Verbose -Message 'Exporting Default Scheduled Tasks State ...'

        Get-ScheduledTask |
            Select-Object -Property 'TaskPath', 'TaskName', 'State' |
            Sort-Object -Property 'TaskPath' |
            ConvertTo-Json -EnumsAsStrings |
            Out-File -FilePath $LogFilePath
    }
}

function Disable-WinScheduledTask
{
    <#
    .SYNTAX
        Disable-WinScheduledTask [-InputObject] <ScheduledTask> [<CommonParameters>]

    .EXAMPLE
        PS> $FooBarTasks = '[
              {
                "TaskPath": "\\",
                "TaskName": [
                  "Foo Update Task",
                  "Foo Logging Task"
                ]
              },
              {
                "SkipTask": true,
                "TaskPath": "\\",
                "TaskName": [
                  "Bar Update Task"
                ],
                "Comment": "some comment"
              }
            ]' | ConvertFrom-Json
        PS> $FooBarTasks | Disable-WinScheduledTask
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(
            Mandatory,
            ValueFromPipeline)]
        [ScheduledTask]
        $InputObject
    )

    begin
    {
        class ScheduledTask
        {
            [bool] $SkipTask
            [string] $TaskPath
            [string[]] $TaskName
            [string] $Comment
        }

        $ScheduledTasks = Get-ScheduledTask
    }

    process
    {
        if ($InputObject.SkipTask)
        {
            return
        }

        if (-not $InputObject.TaskPath.EndsWith('\'))
        {
            $InputObject.TaskPath += '\'
        }

        foreach ($Task in $InputObject.TaskName)
        {
            $CurrentTask = $ScheduledTasks |
                Where-Object -FilterScript {
                    $_.TaskPath -eq $InputObject.TaskPath -and
                    $_.TaskName -eq $Task
                }

            if (-not $CurrentTask)
            {
                Write-Verbose -Message "Scheduled Task '$($InputObject.TaskPath)$Task' not found"
            }
            elseif ($CurrentTask.State -eq 'Disabled')
            {
                Write-Verbose -Message "'$($InputObject.TaskPath)$Task' is already 'Disabled'"
            }
            else
            {
                Write-Verbose -Message "Disabling '$($InputObject.TaskPath)$Task' ..."

                try
                {
                    $CurrentTask | Disable-ScheduledTask -ErrorAction 'Stop' | Out-Null
                }
                catch
                {
                    Write-Verbose -Message '    cannot be disabled: deleting task ...'
                    $CurrentTask | Unregister-ScheduledTask -Confirm:$false | Out-Null
                }
            }
        }
    }
}

#endregion helper functions

#=======================================
## filter driver
#=======================================
#region filter driver

$UcpdTask = '[
  {
    "TaskPath": "\\Microsoft\\Windows\\AppxDeploymentClient\\",
    "TaskName": [
      "UCPD velocity"
    ],
    "Comment": "re-enable userChoice Protection Driver (UCPD) service if it is disabled."
  }
]' | ConvertFrom-Json

#endregion filter driver

#=======================================
## adobe acrobat
#=======================================
#region adobe acrobat

$AdobeAcrobatTasks = '[
  {
    "TaskPath": "\\",
    "TaskName": [
      "Adobe Acrobat Update Task"
    ]
  }
]' | ConvertFrom-Json

#endregion adobe acrobat

#=======================================
## features
#=======================================
#region features

$FeaturesTasks = '[
  {
    "TaskPath": "\\Microsoft\\Windows\\AppListBackup\\",
    "TaskName": [
      "Backup",
      "BackupNonMaintenance"
    ]
  },
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\BitLocker\",
    "TaskName": [
      "BitLocker Encrypt All Drives",
      "BitLocker MDM policy Refresh"
    ],
    "Comment": "cannot be disabled.
                if you set SkipTask to false, these tasks will be deleted.
                not recommended in case you change your mind to use Bitlocker."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\CloudRestore\\",
    "TaskName": [
      "Backup",
      "Restore"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\FileHistory\\",
    "TaskName": [
      "File History (maintenance mode)"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Offline Files\\",
    "TaskName": [
      "Background Synchronization",
      "Logon Synchronization"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Flighting\\OneSettings\\",
    "TaskName": [
      "RefreshCache"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Maps\\",
    "TaskName": [
      "MapsToastTask",
      "MapsUpdateTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\PushToInstall\\",
    "TaskName": [
      "LoginCheck",
      "Registration"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Shell\\",
    "TaskName": [
      "FamilySafetyMonitor",
      "FamilySafetyRefreshTask",
      "IndexerAutomaticMaintenance"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\SystemRestore\\",
    "TaskName": [
      "SR"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Work Folders\\",
    "TaskName": [
      "Work Folders Logon Synchronization",
      "Work Folders Maintenance Work"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\XblGameSave\\",
    "TaskName": [
      "XblGameSaveTask"
    ]
  }
]' | ConvertFrom-Json

#endregion features

#=======================================
## microsoft edge
#=======================================
#region microsoft edge

$MicrosoftEdgeTasks = '[
  {
    "TaskPath": "\\",
    "TaskName": [
      "MicrosoftEdgeUpdateTaskMachineCore",
      "MicrosoftEdgeUpdateTaskMachineUA"
    ]
  }
]' | ConvertFrom-Json

#endregion microsoft edge

#=======================================
## microsoft office
#=======================================
#region microsoft office

$MicrosoftOfficeTasks = '[
  {
    "TaskPath": "\\Microsoft\\Office\\",
    "TaskName": [
      "Office Automatic Updates 2.0",
      "Office ClickToRun Service Monitor",
      "Office Feature Updates",
      "Office Feature Updates Logon"
    ]
  }
]' | ConvertFrom-Json

#endregion microsoft office

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

$MiscTasks = '[
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\Chkdsk\\",
    "TaskName": [
      "ProactiveScan"
    ],
    "Comment": "should be disabled ?"
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Data Integrity Scan\",
    "TaskName": [
      "Data Integrity Check And Scan",
      "Data Integrity Scan",
      "Data Integrity Scan for Crash Recovery"
    ],
    "Comment": "apply to ReFS volumes with integrity streams enabled."
  },
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\Defrag\\",
    "TaskName": [
      "ScheduledDefrag"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Diagnosis\\",
    "TaskName": [
      "RecommendedTroubleshootingScanner",
      "Scheduled"
    ]
  },
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\DiskCleanup\\",
    "TaskName": [
      "SilentCleanup"
    ],
    "Comment": "settings > system > storage > storage sense > cleanup of temporary files."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Input\\",
    "TaskName": [
      "InputSettingsRestoreDataAvailable",
      "LocalUserSyncDataAvailable",
      "MouseSyncDataAvailable",
      "PenSyncDataAvailable",
      "syncpensettings",
      "TouchpadSyncDataAvailable"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\International\\",
    "TaskName": [
      "Synchronize Language Settings"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\LanguageComponentsInstaller\\",
    "TaskName": [
      "Installation",
      "ReconcileLanguageResources",
      "Uninstallation"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\License Manager\\",
    "TaskName": [
      "TempSignedLicenseExchange"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Management\\Provisioning\\",
    "TaskName": [
      "Cellular",
      "Logon"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Windows Media Sharing\\",
    "TaskName": [
      "UpdateLibrary"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\MUI\\",
    "TaskName": [
      "LPRemove"
    ],
    "Comment": "cleanup unused language packs."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\NlaSvc\\",
    "TaskName": [
      "WiFiTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Ras\\",
    "TaskName": [
      "MobilityManager"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\RecoveryEnvironment\\",
    "TaskName": [
      "VerifyWinRE"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\ReFsDedupSvc\\",
    "TaskName": [
      "Initialization"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Registry\\",
    "TaskName": [
      "RegIdleBackup"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\RemoteAssistance\\",
    "TaskName": [
      "RemoteAssistanceTask"
    ]
  },
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\Servicing\\",
    "TaskName": [
      "StartComponentCleanup"
    ],
    "Comment": "clean Up the WinSxS Folder."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\SpacePort\\",
    "TaskName": [
      "SpaceAgentTask",
      "SpaceManagerTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Speech\\",
    "TaskName": [
      "SpeechModelDownloadTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Storage Tiers Management\\",
    "TaskName": [
      "Storage Tiers Management Initialization",
      "Storage Tiers Optimization"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Subscription\\",
    "TaskName": [
      "EnableLicenseAcquisition",
      "LicenseAcquisition"
    ],
    "Comment": "activation on Azure AD joined devices."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Sysmain\\",
    "TaskName": [
      "ResPriStaticDbSync",
      "WsSwapAssessmentTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Task Manager\\",
    "TaskName": [
      "Interactive"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\TextServicesFramework\\",
    "TaskName": [
      "MsCtfMonitor"
    ]
  },
  {
    "SkipTask": true,
    "TaskPath": "\\Microsoft\\Windows\\Time Synchronization\\",
    "TaskName": [
      "ForceSynchronizeTime",
      "SynchronizeTime"
    ],
    "Comment": "if disabled, will prevent Time Synchronization."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Time Zone\\",
    "TaskName": [
      "SynchronizeTimeZone"
    ],
    "Comment": "location is disabled, so Time Zone is already off."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\UPnP\\",
    "TaskName": [
      "UPnPHostConfig"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\User Profile Service\\",
    "TaskName": [
      "HiveUploadTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\WDI\\",
    "TaskName": [
      "ResolutionHost"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Windows Filtering Platform\\",
    "TaskName": [
      "BfeOnServiceStartTypeChange"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\WOF\\",
    "TaskName": [
      "WIM-Hash-Management",
      "WIM-Hash-Validation"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\WwanSvc\\",
    "TaskName": [
      "NotificationTask",
      "OobeDiscovery"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Printing\\",
    "TaskName": [
      "EduPrintProv",
      "PrinterCleanupTask",
      "PrintJobCleanupTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\WlanSvc\\",
    "TaskName": [
      "CDSSync"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\WCM\\",
    "TaskName": [
      "WiFiTask"
    ]
  }
]' | ConvertFrom-Json

#endregion miscellaneous

#=======================================
## telemetry
#=======================================
#region telemetry

$TelemetryTasks = '[
  {
    "TaskPath": "\\Microsoft\\Windows\\ApplicationData\\",
    "TaskName": [
      "appuriverifierdaily"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Application Experience\\",
    "TaskName": [
      "MareBackup",
      "Microsoft Compatibility Appraiser",
      "Microsoft Compatibility Appraiser Exp",
      "PcaPatchDbTask",
      "PcaWallpaperAppDetect",
      "ProgramDataUpdater",
      "SdbinstMergeDbTask",
      "StartupAppTask"
    ],
    "Comment": "SdbinstMergeDbTask cannot be disabled."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Autochk\\",
    "TaskName": [
      "Proxy"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\CloudExperienceHost\\",
    "TaskName": [
      "CreateObjectTask"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Customer Experience Improvement Program\\",
    "TaskName": [
      "Consolidator",
      "UsbCeip"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Device Information\\",
    "TaskName": [
      "Device",
      "Device User"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\DUSM\\",
    "TaskName": [
      "dusmtask"
    ],
    "Comment": "Data Usage Subscription Management."
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Feedback\\Siuf\\",
    "TaskName": [
      "DmClient",
      "DmClientOnScenarioDownload"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Flighting\\FeatureConfig\\",
    "TaskName": [
      "BootstrapUsageDataReporting",
      "ReconcileFeatures",
      "UsageDataFlushing",
      "UsageDataReporting"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\StateRepository\\",
    "TaskName": [
      "MaintenanceTasks"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Maintenance\\",
    "TaskName": [
      "WinSAT"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\NetTrace\\",
    "TaskName": [
      "GatherNetworkInfo"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\PI\\",
    "TaskName": [
      "Sqm-Tasks"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Windows Error Reporting\\",
    "TaskName": [
      "QueueReporting"
    ]
  }
]' | ConvertFrom-Json

#endregion telemetry

#=======================================
## telemetry diagnostic
#=======================================
#region telemetry diagnostic

$TelemetryDiagnosticTasks = '[
  {
    "TaskPath": "\\Microsoft\\Windows\\DiskDiagnostic\\",
    "TaskName": [
      "Microsoft-Windows-DiskDiagnosticDataCollector",
      "Microsoft-Windows-DiskDiagnosticResolver"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\DiskFootprint\\",
    "TaskName": [
      "Diagnostics"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\MemoryDiagnostic\\",
    "TaskName": [
      "ProcessMemoryDiagnosticEvents",
      "RunFullMemoryDiagnostic"
    ]
  },
  {
    "TaskPath": "\\Microsoft\\Windows\\Power Efficiency Diagnostics\\",
    "TaskName": [
      "AnalyzeSystem"
    ]
  }
]' | ConvertFrom-Json

#endregion telemetry diagnostic

#endregion scheduled tasks

#endregion services & scheduled tasks




#=================================================================================================================
#                                              script configuration
#=================================================================================================================
#region script configuration

#==============================================================================
#                              helper functions
#==============================================================================
#region helper functions

function Write-Section
{
    <#
    .SYNTAX
        Write-Section [-Name] <string> [-SubSection] [<CommonParameters>]

    .EXAMPLE
        PS> Write-Section -Name 'Setting File Explorer'
        # Setting File Explorer
        # ========================================
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string]
        $Name,

        [switch]
        $SubSection
    )

    $ColorOption = @{
        BackgroundColor = $SubSection ? 'Blue' : 'Cyan'
        ForegroundColor = 'Black'
        NoNewline       = $true
    }

    Write-Host
    Write-Host @ColorOption -Object "# $Name"
    Write-Host
    if (-not $SubSection)
    {
        Write-Host @ColorOption -Object '# ========================================'
        Write-Host
    }
}

function Set-Setting
{
    <#
    .SYNTAX
        Set-Setting [-Setting] <hashtable> [<CommonParameters>]

    .EXAMPLE
        PS> $MySettings = @{
                Foo = @(
                    $FooSetting1
                    $FooSetting2
                )
                Bar = @(
                    $BarSetting1
                    $BarSetting2
                )
            }
        PS> Set-Setting -Setting $MySettings

        # Foo
        [...]

        # Bar
        [...]

    .NOTES
        The settings must be compatible with 'Set-RegistryEntry'.
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [hashtable]
        $Setting
    )

    $Setting.GetEnumerator() |
        Where-Object -FilterScript { $_.Value.Count } |
        ForEach-Object -Process {
            Write-Section -Name $_.Name -SubSection
            $_.Value | Set-RegistryEntry
        }
}

#endregion helper functions


#==============================================================================
#                                   tweaks
#==============================================================================
#region tweaks

#=======================================
## action center
#=======================================
#region action center

function Set-ActionCenterQuickSettings
{
    Write-Section -Name 'Setting Action Center Settings'
    Set-ActionCenterLayout
}

#endregion action center

#=======================================
## drivers
#=======================================
#region drivers

$DriversSettings = @(
    #$DeviceInstallationDriversGPO
    $PrinterDriversDownloadOverHttpGPO
    #$WindowsUpdateDriversGPO
)

function Set-DriversSettings
{
    Write-Section -Name 'Setting Drivers Settings'
    $DriversSettings | Set-RegistryEntry
}

#endregion drivers

#=======================================
## event log
#=======================================
#region event log

function Set-EventLogDriveLocation
{
    Write-Section -Name 'Setting Event Log Location'
    Move-EventLogDriveLocation -Drive 'D:'
}

#endregion event log

#=======================================
## file explorer
#=======================================
#region file explorer

$FileExplorerSettings = @{
    General = @(
        $FileExplorerOpenTo
        $FileExplorerRecentlyUsedFiles
        $FileExplorerFrequentlyUsedFolders
        $FileExplorerFilesFromOfficeDotCom
    )
    View = @(
        $FileExplorerCompactView
        $FileExplorerItemCheckBoxes
        $FileExplorerFileNameExtensions
        $FileExplorerFolderMergeConflicts
        $FileExplorerHiddenItems
        $FileExplorerEncryptedOrCompressedNtfsFilesInColor
        $FileExplorerSyncProviderNotifications
        $FileExplorerSharingWizard
    )
    Miscellaneous = @(
        $FileExplorerGalleryShorcut
        $FileExplorerDuplicateDrives
        $FileExplorerIconCacheSize
        $FileExplorerFolderTypeDetection
    )
}

function Set-FileExplorerSettings
{
    Write-Section -Name 'Setting File Explorer'
    Set-Setting -Setting $FileExplorerSettings
}

#endregion file explorer

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

$MiscSettings = @(
    #$AutoLogin
    #$ClearRecentFilesOnExitGPO
    $CloudConfigDownloadGPO
    $ControlPanelEaseOfAccessCenterReadAndScan
    $CopyPasteMoreDetails
    #$FileHistoryGPO
    $FirstSigninAnimationGPO
    $FontStreamingGPO
    #$FullscreenOptimizations
    $HelpAndSupportFeedbackGPO
    $HelpTipsGPO
    $HomePageSettingVisibilityGPO
    $IndexingOfEncryptedFilesGPO
    $LocationAndSensorsGPO
    $LockScreenCameraAccessGPO
    $MessagingCloudSyncGPO
    #$NotificationNetworkUsageGPO
    $NumlockAtStartup
    $OnlineTipsInSettingsAppGPO
    $OpenWithDialogSearchAppInStoreGPO
    $PathLengthLimit
    #$PasswordRevealButtonGPO
    #$RecycleBinRemoveFilesImmediatelyGPO
    #$RecycleBinDeleteConfirmationDialogGPO
    #$ServiceHostSplitting
    #$ShortcutNameSuffix
    #$StartMenuRecommendedSection
    $SuggestedContent
    #$VerboseStartupShutdownGPO
    $WifiSenseGPO
    $WindowsExperimentation
    $WindowsHelpAndSupportF1Key
    $WindowsInputExperience
    $WindowsMediaDRMGPO
    $WindowsPrivacySettingsExperienceGPO
    #$WindowsSharedExperienceGPO
    #$WindowsSpotlightGPO
)

function Set-MiscellaneousSettings
{
    Write-Section -Name 'Setting Miscellaneous Settings'
    Disable-NTFSLastAccessTime
    Disable-PasswordExpiration
    #Disable-8Dot3FileName
    Move-CharacterMapShorcutToWindowsTools
    $MiscSettings | Set-RegistryEntry
}

#endregion miscellaneous

#=======================================
## network
#=======================================
#region network

$NetworkSettings = @(
    $IPSourceRouting
    $NetworkProtocolsIPv6Preference
    $NetworkProtocol6to4GPO
    $NetworkProtocolTeredoGPO
    $NetworkProtocolLltdGPO
    $NetworkProtocolLlmnrGPO
    $NetBIOSProtocol
    $SmartNameResolutionGPO
    $WPADProtocol
)

$NetworkProtocols = @(
    $NetworkProtocolsIPv6
    $NetworkProtocolLldp
    $NetworkProtocolLltd
    $NetworkProtocolBridgeDriver
    $NetworkProtocolQosPacketScheduler
    $NetworkProtocolsHyperVExtensibleVirtualSwitch
    $NetworkProtocolsIPv4
    $NetworkProtocolsMicrosoftNetworkAdapterMultiplexor
    #$NetworkProtocolSMB
)

function Set-NetworkSettingsAndProtocols
{
    Write-Section -Name 'Setting Network'
    Export-EnabledNetAdapterProtocolNames
    Block-CDPFirewallPort5040And5050
    Block-DCOMFirewallPort135
    Block-FirewallMiscInboundTCP
    Disable-IcmpRedirects
    Disable-NetworkTeredo
    Block-NetBiosFirewallPort137to139
    #Block-SMBFirewallPort445
    $NetworkSettings | Set-RegistryEntry
    $NetworkProtocols | Set-NetAdapterProtocol
}

#endregion network

#=======================================
## power options
#=======================================
#region power options

$PowerOptionsSettings = @(
    $FastStartup
)

function Set-PowerOptionsSettings
{
    Write-Section -Name 'Setting Power Options'
    Disable-Hibernate
    Set-SystemPowerHardDiskTimeout
    #Set-SystemPowerModernStandbyNetworkConnectivity
    $PowerOptionsSettings | Set-RegistryEntry
}

#endregion power options

#=======================================
## system properties
#=======================================
#region system properties

$SystemProperties = @{
    Hardware = @(
        #$HardwareAutoDownloadManufacturersApps
    )
    VisualEffects = @(
        $VisualEffectsMode
        $VisualEffectsCustomPart2
    )
    StartupAndRecovery = @(
        $SystemFailureAutoRestart
        $SystemFailureWriteDebugInfo
    )
    SystemProtection = @(
        #$SystemProtection
    )
    Remote = @(
        $RemoteAssistance
        $RemoteAssistanceOfferGPO
    )
}

function Set-SystemProperties
{
    Write-Section -Name 'Setting System Properties'

    Disable-AllDrivesAutoManagedPagingFile
    Set-DrivePagingFile -Drive "$env:SystemDrive" -InitialSize 512 -MaximumSize 512

    #Set-DataExecutionPrevention -State 'OptOut'

    Disable-PowerShellTelemetry
    Disable-DotNetTelemetry

    # To disable for all drives, uncomment $SystemProtection.
    #Disable-SystemDriveRestore

    $VisualEffectsCustomPart1 | Set-SystemPropertiesVisualEffects
    Set-Setting -Setting $SystemProperties
}

#endregion system properties

#=======================================
## telemetry
#=======================================
#region telemetry

$TelemetrySettings = @(
    $AppAndDeviceInventoryGPO
    $ApplicationCompatibilityGPO
    $CloudContentExperienceGPO
    $CustomerExperienceImprovementGPO
    $DiagnosticsAutoLogger
    $DiagnosticLogCollectionGPO
    $DumpCollectionGPO
    $ErrorReportingGPO
    $GroupPolicySettingsLoggingGPO
    $HandwritingTelemetryGPO
    $LicenseTelemetryGPO
    #$NvidiaTelemetry
)

function Set-TelemetrySettings
{
    Write-Section -Name 'Setting Telemetry'
    #Disable-NvidiaGameSessionTelemetry
    $TelemetrySettings | Set-RegistryEntry
}

#endregion telemetry

#endregion tweaks


#==============================================================================
#                                applications
#==============================================================================
#region applications

#=======================================
## installation
#=======================================
#region installation

$ApplicationsToInstall = @{
    Machine = @(
        # Development
            #$Git
            #$VSCode

        # Multimedia
            $VLC

        # Password Manager
            #$Bitwarden
            $KeePassXC

        # PDF Viewer
            $AcrobatReader
            #$SumatraPDF

        # Utilities
            $7zip
            #$qBittorrent

        # Web Browser
            $Brave
            #$Firefox

        # Microsoft Visual C++ Redistributable
            ${VisualCppRedist2015+}
            #$VisualCppRedist2013
            #$VisualCppRedist2012
            #$VisualCppRedist2010
            #$VisualCppRedist2008
            #$VisualCppRedist2005
    )
    User = @(
    )
    NoScope = @(
        # Web Browser
            $MullvadBrowser
    )
}

<#
You might have an error to auto update Brave when installing it with winget.
Launch Brave and open the 'About Brave' setting page (Menu > Help > About Brave).
If you have the following error:
An error occurred while checking for updates: Update check failed to start (error code 3: 0X80040154 -- system level).
This means that the 'Brave Updates Windows Services' has failed to install.
Go to the official website (https://brave.com/download/) to download Brave and install it again.
No need to uninstall Brave, just run the executable to update the existing installation.
#>

function Install-NewApplications
{
    Write-Section -Name 'Installing New Applications'
    #Install-WindowsSubsystemForLinux
    $ApplicationsToInstall.Machine | Install-Application -Scope 'Machine'
    #$ApplicationsToInstall.NoScope | Install-Application
    Remove-ApplicationDesktopShortcut
}

#endregion installation

#=======================================
## appx & provisioned packages
#=======================================
#region appx & provisioned packages

$ApplicationsToConfig = @(
    $BingSearchStartMenuGPO
    $CopilotGPO
    $CortanaGPO
    $MicrosoftStorePushToInstallGPO
    #$MicrosoftWindowsMsrtWindowsUpdateGPO
    $MicrosoftWindowsMsrtHeartbeatReportGPO
    $WidgetsGPO
)

$ApplicationsToRemove = @(
    $BingSearch
    #$Calculator
    $Camera
    $Clipchamp
    $Clock
    $Compatibility
    $Cortana
    $CrossDevice
    $DevHome
    #$Extensions
    $Family
    $FeedbackHub
    $GetHelp
    $Journal
    $MailAndCalendar
    $Maps
    $MediaPlayer
    $Microsoft365
    $MicrosoftCopilot
    $MicrosoftTeams
    $MoviesAndTV
    $News
    #$Notepad
    $Outlook
    #$Paint
    $People
    $PhoneLink
    #$Photos
    $PowerAutomate
    $QuickAssist
    #$SnippingTool
    $Solitaire
    $SoundRecorder
    $StickyNotes
    #$Terminal
    $Tips
    $Todo
    $Weather
    #$Whiteboard
    $Widgets
    $Xbox

    # Windows 10 Only
    $3DViewer
    $MixedRealityPortal
    $OneNote
    $Paint3D
    $Skype
    $Wallet
)

function Remove-DefaultAppxPackages
{
    Write-Section -Name 'Removing Default Appx & Provisioned Packages'

    Write-Section -Name 'configuration' -SubSection
    $ApplicationsToConfig | Set-RegistryEntry

    Write-Section -Name 'removal' -SubSection
    Export-DefaultAppxPackagesNames
    $ApplicationsToRemove | Remove-Package
    #Remove-MSRT
    Remove-OneDrive
    Remove-OneDriveAutoInstallationForNewUser
    #Remove-MicrosoftEdge
    Remove-StartMenuPromotedApps
    #Set-NewUserDefaultStartMenuLayout
}

#endregion appx & provisioned packages

#endregion applications


#==============================================================================
#                            applications settings
#==============================================================================
#region applications settings

#=======================================
## adobe acrobat reader
#=======================================
#region adobe acrobat reader

$AdobeAcrobatReaderSettings = @{
    Documents = @(
        $AdobeAcrobatDocumentsRememberToolsPaneState
        $AdobeAcrobatDocumentsSavedToolsPaneState
    )
    General = @(
        $AdobeAcrobatGeneralOnlineStorageOpenFiles
        $AdobeAcrobatGeneralOnlineStorageSaveFiles
        $AdobeAcrobatGeneralShowMessagesAtLaunch
        $AdobeAcrobatGeneralCrashReports
    )
    Javascript = @(
        $AdobeAcrobatJavascript
    )
    SecurityEnhanced = @(
        $AdobeAcrobatSecurityProtectedMode
        $AdobeAcrobatSecurityProtectedModeAppContainer
        $AdobeAcrobatSecurityProtectedView
        $AdobeAcrobatSecurityEnhancedSecurity
        $AdobeAcrobatSecurityTrustCertifiedDocuments
        $AdobeAcrobatSecurityTrustOSTrustedSites
    )
    TrustManager = @(
        $AdobeAcrobatTrustManagerPdfFileAttachmentsExternalApps
        $AdobeAcrobatTrustManagerPdfFileAttachments
    )
    Units = @(
        $AdobeAcrobatPageUnits
    )
    Miscellaneous = @(
        $AdobeAcrobatMiscHomePageTopBanner
        $AdobeAcrobatMiscFirstLaunchIntro
        $AdobeAcrobatMiscUpsell
        $AdobeAcrobatMiscUsageStatistics
        $AdobeAcrobatMiscOnlineServices
        $AdobeAcrobatMiscAdobeCloud
        $AdobeAcrobatMiscSharePoint
        $AdobeAcrobatMiscWebmail
    )
}

function Set-AdobeAcrobatReaderSettings
{
    Write-Section -Name 'Setting Adobe Acrobat Reader'
    Set-Setting -Setting $AdobeAcrobatReaderSettings
}

#endregion adobe acrobat reader

#=======================================
## microsoft edge
#=======================================
#region microsoft edge

$MicrosoftEdgeSettings = @(
    $MicrosoftEdgePrelaunch
    $MicrosoftEdgeStartupBoostAndBackground
    $MicrosoftEdgeBackgroundExtensionsAndApps
)

function Set-MicrosoftEdgeSettings
{
    Write-Section -Name 'Setting Microsoft Edge'
    $MicrosoftEdgeSettings | Set-RegistryEntry
}

#endregion microsoft edge

#=======================================
## microsoft office
#=======================================
#region microsoft office

$MicrosoftOfficeSettings = @{
    Options = @(
        $MicrosoftOfficeConnectedExperiences
        $MicrosoftOfficeLinkedinFeatures
        $MicrosoftOfficeStartScreen
    )
    Privacy = @(
        $MicrosoftOfficeCEIP
        $MicrosoftOfficeFeedback
        $MicrosoftOfficeLogging
        $MicrosoftOfficeTelemetry
    )
}

function Set-MicrosoftOfficeSettings
{
    Write-Section -Name 'Setting Microsoft Office'
    Set-Setting -Setting $MicrosoftOfficeSettings
}

#endregion microsoft office

#=======================================
## miscellaneous
#=======================================
#region miscellaneous

function Set-MiscellaneousApplicationsSettings
{
    Write-Section -Name 'Setting Miscellaneous Applications Settings'
    Set-BraveSettings
    Set-BraveDefaultBrowser
    #Set-GitSettings -Name 'John Doe' -Email 'johndoe@example.com'
    Set-KeePassXCSettings
    Set-VisualStudioCodeSettings
    Set-VLCSettings
    Set-WindowsTerminalSettings
}

#endregion miscellaneous

#endregion applications settings


#==============================================================================
#                                   ramdisk
#==============================================================================
#region ramdisk

function Set-RamDisk
{
    Write-Section -Name 'Setting Ram Disk'
    Install-OSFMount
    Set-RamDiskScriptsAndTasks
}

#endregion ramdisk


#==============================================================================
#                            windows settings app
#==============================================================================
#region windows settings app

#=======================================
## settings > system
#=======================================
#region system

$SystemSettings = @{
    Display = @(
        #$DisplayChangeBrightnessBasedOnContent
        $DisplayOptimizationsForWindowedGames
        $DisplayHardwareAcceleratedGPUScheduling
    )
    Sound = @(
        $SoundCommunicationsActivity
    )
    Notifications = @(
        $Notifications
        $NotificationsPlaySounds
        $NotificationsLockScreen
        $NotificationsRemindersAndIncomingVoIP
        $NotificationsBellIcon
        $NotificationsFromAppsAndOtherSenders
        $NotificationsWelcomeExperience
        $NotificationsFinishSettings
        $NotificationsTipsAndSuggestions
    )
    Power = @(
        $PowerEnergySaver
    )
    Storage = @(
        $StorageSenseCleanupTempFiles
        $StorageSenseAutoCleanupUserContent
    )
    NearbySharing = @(
        $NearbySharing
        #$NearbySharingDownloadLocation
    )
    Multitasking = @(
        $MultitaskingShowTabsFromApps
        $MultitaskingTitleBarShaking
        $MultitaskingSnapWindows
        $MultitaskingDesktopsShowOpenWindows
    )
    ForDevelopers = @(
        $ForDevelopersEndTaskInTaskbar
    )
    Troubleshoot = @(
        $Troubleshoot
    )
    ProjectingToThisPC = @(
        $ProjectingToThisPC
        $ProjectingToThisPCAvailability
        $ProjectingToThisPCAskToProject
        $ProjectingToThisPCRequirePIN
        $ProjectingToThisPCOnlyWhenPluggedOnAC
    )
    RemoteDesktop = @(
        $RemoteDesktop
        $RemoteDesktopNetworkLevelAuthentication
        #$RemoteDesktopPort
    )
    Clipboard = @(
        $ClipboardHistory
        $ClipboardSyncAcrossDevices
        $ClipboardSuggestedActions
    )
}

$SystemOptionalFeatures = @{
    WindowsCapabilities = @{
        Remove = @(
            $ExtendedThemeContent
            $FacialRecognitionWindowsHello
            $InternetExplorerMode
            $MathRecognizer
            $NotepadSystem
            $OneSync
            $OpenSSHClient
            $PrintManagement
            $StepsRecorder
            $VBScript
            $WindowsFaxAndScan
            $WindowsMediaPlayerLegacy
            $WindowsPowerShellISE
            $WMIC
            $WordPad
            $XpsViewer
        )
    }
    Languages = @{
        Remove = @(
            $Handwriting
            $OCR
            $Speech
            $TextToSpeech
            $BasicTyping
        )
    }
    MoreWindowsFeatures = @{
        Add = @(
            $DotNetFramework35.MainFeature
            #$WindowsSandbox
        )
        Remove = @(
            $DotNetFramework48.WcfServices.TcpPortSharing
            $DotNetFramework48.WcfServices.MainFeature
            $MediaFeatures.WindowsMediaPlayerLegacy
            $MediaFeatures.MainFeature
            $MicrosoftRemoteDesktopConnection
            $MicrosoftXpsDocumentWriter
            $PrintAndDocumentServices.InternetPrintingClient
            $PrintAndDocumentServices.MainFeature
            $RemoteDifferentialCompressionApiSupport
            $SmbDirect
            $WindowsPowerShell2.WindowsPowerShell2Engine
            $WindowsPowerShell2.MainFeature
            $WindowsRecall
            $WorkFoldersClient
        )
    }
}

function Set-SystemSettings
{
    Write-Section -Name 'Setting System'
    #Set-PowerMode -Name 'BestPowerEfficiency'
    Set-ScreenAndSleepTimeout
    #Set-EnergySaverAutoTurnOnAt -Percent 0
    #Disable-EnergySaverLowerBrightness
    #Set-SudoCommand -State 'normal'
    Set-Setting -Setting $SystemSettings
}

function Set-SystemOptionalFeatures
{
    Write-Section -Name 'Setting Optional Features'
    Export-InstalledWindowsCapabilitiesNames
    Export-EnabledWindowsOptionalFeaturesNames

    Write-Section -Name 'windows capabilities' -SubSection
    $SystemOptionalFeatures.WindowsCapabilities.Remove | Remove-WinCapability

    #Write-Section -Name 'languages' -SubSection
    #$SystemOptionalFeatures.Languages.Remove | Remove-OptionalLanguageFeature

    Write-Section -Name 'more windows features' -SubSection
    $SystemOptionalFeatures.MoreWindowsFeatures.Remove | Set-WindowsOptionalFeature -State 'Disabled'
    #$SystemOptionalFeatures.MoreWindowsFeatures.Add | Set-WindowsOptionalFeature -State 'Enabled'
}

#endregion system

#=======================================
## settings > bluetooth & devices
#=======================================
#region bluetooth & devices

$BluetoothAndDevicesSettings = @{
    Devices = @(
        $DevicesNotificationsConnectSwiftPair
        $DevicesDownloadOverMetered
        $DevicesBluetoothDiscovery
    )
    PrintersAndScanners = @(
        $PrintersAndScannersDefaultPrinter
    )
    MobileDevices = @(
        $MobileDevicesAccessThisPC
        $MobileDevicesPhoneLink
        $MobileDevicesPhoneLinkUsageSuggestions
    )
    Mouse = @(
        $MousePrimaryButton
        $MousePointerSpeed
        #$MouseEnhancedPointerPrecision
        $MouseWheelScroll
        $MouseScrollInactiveWindows
        $MouseScrollingDirection
    )
    Touchpad = @(
        $Touchpad
        $TouchpadWhenMouseConnected
        $TouchpadCursorSpeed
        $TouchpadSensitivity
        $TouchpadTaps
        $TouchpadDragTwoFingersToScroll
        $TouchpadScrollingDirection
        $TouchpadPinchToZoom
    )
    PenAndWindowsInk = @(
        $PenAndWindowsInkGPO
    )
    AutoPlay = @(
        #$AutoPlay
    )
    Usb = @(
        $UsbNotificationIssues
        $UsbBatterySaver
        $UsbNotificationChargingSlowly
    )
}

function Set-BluetoothAndDevicesSettings
{
    Write-Section -Name 'Setting Bluetooth & Devices'
    Set-Setting -Setting $BluetoothAndDevicesSettings
}

#endregion bluetooth & devices

#=======================================
## settings > network & internet
#=======================================
#region network & internet

$NetworkAndInternetSettings = @{
    Proxy = @(
        $ProxyAutoDetectSettings
    )
}

function Set-NetworkAndInternetSettings
{
    Write-Section -Name 'Setting Network & Internet'
    Set-ConnectedNetworkToPrivate
    Set-DnsProvider -Adguard 'Default'
    Set-Setting -Setting $NetworkAndInternetSettings
}

#endregion network & internet

#=======================================
## settings > personnalization
#=======================================
#region personnalization

$PersonnalizationSettings = @{
    Background = @(
        $BackgroundWallpaper
        $BackgroundWallpaperStyle
    )
    Colors = @(
        $ColorsMode
        $ColorsTransparency
        $ColorsAccentColor
        $ColorsAccentColorOnStartAndTaskBar
        $ColorsAccentColorOnTitleAndBorders
    )
    Themes = @(
        $ThemesDesktopIcons
        $ThemesChangesDesktopIcons
    )
    DynamicLighting = @(
        $DynamicLighting
        $DynamicLightingControlledByForegroundApp
    )
    LockScreen = @(
        $LockScreenFunFactsTipsTricks
        #$LockScreenLogonBackgroundImageGPO
    )
    Start = @(
        $StartLayout
        $StartRecentlyAddedApps
        $StartMostUsedApps
        $StartRecentlyOpenedItems
        $StartRecommendations
        $StartAccountRelatedNotifications
        $StartFoldersNextPowerButton
        $StartMobileDeviceInStart
    )
    Taskbar = @(
        $TaskbarSearchButton
        $TaskbarCopilotButton
        $TaskbarTaskViewButton
        $TaskbarChatButton
        $TaskbarTrayIconsPenMenu
        $TaskbarTrayIconsTouchKeyboard
        $TaskbarTrayIconsVirtualTouchpad
        $TaskbarTrayIconsHiddenIconMenu
        $TaskbarAlignment
        $TaskbarAutoHide
        $TaskbarBadges
        $TaskbarFlashing
        $TaskbarOnAllDisplays
        $TaskbarMultipleDisplaysTaskbarAppsVisibility
        $TaskbarShareWindow
        $TaskbarFarCornerShowDesktop
        $TaskbarCombineButtonsAndHideLabels
        $TaskbarHoverCardsInactiveApps
    )
    DeviceUsage = @(
        $DeviceUsage
    )
}

function Set-PersonnalizationSettings
{
    Write-Section -Name 'Setting Personnalization'
    Set-Setting -Setting $PersonnalizationSettings
}

#endregion personnalization

#=======================================
## settings > apps
#=======================================
#region apps

$AppsSettings = @{
    AdvancedSettings = @(
        $AdvancedSettingsWhereGetApps
        $AdvancedSettingsShareAcrossDevices
        $AdvancedSettingsArchiveApps
    )
    OfflineMaps = @(
        $OfflineMapsMeteredConnection
        $OfflineMapsAutoUpdate
    )
    AppsForWebsites = @(
        #$OpenLinksInAppGPO
    )
}

function Set-AppsSettings
{
    Write-Section -Name 'Setting Apps'
    Set-Setting -Setting $AppsSettings
}

#endregion apps

#=======================================
## settings > accounts
#=======================================
#region accounts

$AccountsSettings = @{
    YourInfo = @(
        #$YourInfoAccountSettingGPO
    )
    SignInOptions = @(
        #$SignInBiometricsGPO
        $SignInExternalCameraOrFingerprint
        $SignInOnlyAllowWindowsHelloOnThisDevice
        $SignInDynamicLock
        $SignInRestartApps
        #$SignInShowAccountDetailsGPO
        $SignInAutoSettingAfterUpdate
    )
}

function Set-AccountsSettings
{
    Write-Section -Name 'Setting Accounts'
    Disable-RequireSignInOnWakeUp
    Set-Setting -Setting $AccountsSettings
}

#endregion accounts

#=======================================
## settings > time & language
#=======================================
#region time & language

$TimeAndLanguageSettings = @{
    DateAndTime = @(
        $DateAndTimeAutoTimeZone
        $DateAndTimeAutoTime
        $DateAndTimeShowInSystemTray
        $DateAndTimeShowAbbreviatedTimeAndDate
        $DateAndTimeShowSecondsInSystemTray
    )
    LanguageAndRegion = @(
        $LanguageAndRegionFormatFirstDayOfWeek
        $LanguageAndRegionFormatShortDate
    )
    AdministrativeLanguageSettings = @(
        #$LanguageSettingsUTF8SystemWide
    )
    Typing = @(
        $TypingTextSuggestionsSoftwareKeyboard
        $TypingTextSuggestionsPhysicalKeyboard
        $TypingMisspelledWords
        $TypingInsights
        $TypingAdvancedInputLanguageHotKeys
    )
}

function Set-TimeAndLanguageSettings
{
    Write-Section -Name 'Setting Time & Language'
    #Set-NtpServerToPoolNtpOrg
    Set-Setting -Setting $TimeAndLanguageSettings
}

#endregion time & language

#=======================================
## settings > gaming
#=======================================
#region gaming

$GamingSettings = @{
    GameDVR = @(
        $GameDVR
    )
    GameBar = @(
        $GameBarOpenWithController
    )
    Captures = @(
        $CapturesRecordWhatHappened
    )
    GameMode = @(
        $GameMode
    )
}

function Set-GamingSettings
{
    Write-Section -Name 'Setting Gaming'
    Set-Setting -Setting $GamingSettings
}

#endregion gaming

#=======================================
## settings > accessibility
#=======================================
#region accessibility

$AccessibilitySettings = @{
    VisualEffects = @(
        $VisualEffectsAlwaysShowScrollbars
        $VisualEffectsDismissNotificationsTimeout
    )
    ContrastThemes = @(
        $ContrastThemesKeyboardShorcut
    )
    Narrator = @(
        $NarratorKeyboardShorcut
        $NarratorDiagnosticAndPerformanceData
    )
    Keyboard = @(
        $KeyboardStickyKeys
        $KeyboardFilterKeys
        $KeyboardToggleKeys
        $KeyboardPrintKeyOpenScreenCapture
    )
    Mouse = @(
        $MouseKeys
    )
}

function Set-AccessibilitySettings
{
    Write-Section -Name 'Setting Accessibility'
    #Disable-VisualEffectsAnimationEffects
    Disable-VoiceTypingShorcut
    Set-Setting -Setting $AccessibilitySettings
}

#endregion accessibility

#=======================================
## windows security (aka defender)
#=======================================
#region windows security

$DefenderSettingsVirusAndThreatGPO = @(
    $DefenderThreatProtectionCloudDeliveredGPO
    $DefenderThreatProtectionSampleSubmissionGPO
)

$DefenderSettingsAppAndBrowserGPO = @(
    $DefenderCheckAppsAndFilesGPO
    $DefenderPhishingProtectionGPO
    $DefenderUnwantedAppBlockingGPO
)
$DefenderSettingsAppAndBrowser = @(
    $DefenderCheckAppsAndFiles
    $DefenderSmartScreenEdge
    $DefenderSmartScreenStoreApps
)

$DefenderSettingsNotifications = @(
    $DefenderNotificationsThreatProtectionRecentActivityAndScanResults
    #$DefenderNotificationsAccountProtectionWindowsHelloAndDynamicLock
)

$DefenderSettingsMiscellaneous = @(
    $DefenderReportingWatsonEventsGPO
)

function Set-WindowsSecuritySettings
{
    Write-Section -Name 'Setting Windows Security'

    Write-Section -Name 'virus & threat protection' -SubSection
    #$DefenderSettingsVirusAndThreatGPO | Set-RegistryEntry
    #Disable-DefenderThreatProtectionCloudDelivered
    Disable-DefenderThreatProtectionSampleSubmission

    #Write-Section -Name 'app & browser control' -SubSection
    #$DefenderSettingsAppAndBrowserGPO | Set-RegistryEntry
    #Disable-DefenderUnwantedAppBlocking
    #$DefenderSettingsAppAndBrowser | Set-RegistryEntry

    Write-Section -Name 'notifications' -SubSection
    $DefenderSettingsNotifications | Set-RegistryEntry

    Write-Section -Name 'miscellaneous' -SubSection
    $DefenderSettingsMiscellaneous | Set-RegistryEntry
}

#endregion windows security

#=======================================
## settings > privacy & security
#=======================================
#region privacy & security

$PrivacySettings = @{
    FindMyDevice = @(
        $PrivacyFindMyDevice
    )
    General = @(
        $PrivacyGeneralUsingAdvertisingID
        $PrivacyGeneralAccessingLanguageList
        $PrivacyGeneralTrackingAppLaunches
        $PrivacyGeneralTipsInSettingsApp
        $PrivacyGeneralNotificationssInSettingsApp
    )
    RecallAndSnapshots = @(
        $PrivacyRecallSnapshotsGPO
    )
    Speech = @(
        $PrivacySpeech
    )
    InkAndTypingPersonalization = @(
        $PrivacyInkingAndTypingPersonalization
    )
    DiagnosticsAndFeedback = @(
        $PrivacyDiagnosticData
        $PrivacyDiagnosticInkingAndTyping
        $PrivacyiagnosticTailoredExperiences
        $PrivacyiDagnosticViewData
        #$PrivacyDiagnosticDeleteDataGPO
        $PrivacyDiagnosticFeedbackFrequency
    )
    ActivityHistory = @(
        #$PrivacyActivityHistoryGPO
    )
    SearchPermissions = @(
        $PrivacySearchPermissionsSafesearch
        $PrivacySearchPermissionsCloudContent
        $PrivacySearchPermissionsSearchHistory
        $PrivacySearchPermissionsSearchHighlights
    )
    SearchingWindows = @(
        $PrivacySearchingWindowsFindMyFiles
    )
    AppPermissions = @(
        $PrivacyLocation
        $PrivacyLocationAllowOverride
        $PrivacyLocationNotifyAppsRequest
        $PrivacyCamera
        $PrivacyMicrophone
        $PrivacyVoiceActivation
        $PrivacyNotification
        $PrivacyAccountInfo
        $PrivacyContacts
        $PrivacyCalendar
        $PrivacyPhoneCalls
        $PrivacyCallHistory
        $PrivacyEmail
        $PrivacyTasks
        $PrivacyMessaging
        $PrivacyRadios
        $PrivacyOthersDevices
        #$PrivacyOthersDevicesUseTrustedDevicesGPO
        $PrivacyAppDiagnostics
        $PrivacyDocuments
        $PrivacyDownloadsFolder
        $PrivacyMusicLibrary
        $PrivacyPictures
        $PrivacyVideos
        $PrivacyFileSystem
        $PrivacyScreenshotBorders
        $PrivacyScreenshotsAndScreenRecording
        $PrivacyGenerativeAI
        $PrivacyEyeTracker
        $PrivacyMotion
        $PrivacyPresenceSensing
        $PrivacyUserMovement
        #$PrivacyBackgroundAppsGPO
        $PrivacyCellularData
        #$PrivacyTakeScreenshotsOfVariousWindowsGPO
    )
}

function Set-PrivacySettings
{
    Write-Section -Name 'Setting Privacy & Security'
    Disable-PrivacyActivityHistory
    Set-Setting -Setting $PrivacySettings
}

#endregion privacy & security

#=======================================
## settings > windows update
#=======================================
#region windows update

$WindowsUpdateSettings = @{
    WindowsUpdate = @(
        $WinUpdateGetLatestWhenAvailable
        #$WinUpdatePauseUpdatesGPO
    )
    AdvancedOptions = @(
        $WinUpdateOtherMicrosoftProducts
        $WinUpdateRestartAsap
        $WinUpdateMeteredConnection
        $WinUpdateNotifyRestart
        $WinUpdateActiveHours
        $WinUpdateDeliveryOptimization
    )
    InsiderProgram = @(
        #$WinUpdateInsiderProgramSettingPage
    )
}

function Set-WindowsUpdateSettings
{
    Write-Section -Name 'Setting Windows Update'
    Set-Setting -Setting $WindowsUpdateSettings
}

#endregion windows update

#endregion windows settings app


#==============================================================================
#                         services & scheduled tasks
#==============================================================================
#region services & scheduled tasks

#=======================================
## services
#=======================================
#region services

$ServicesEntries = @{
    SystemDriver = @(
        #$UserChoiceProtectionDriver
        $BridgeDriver
        $NetBiosDriver
        $LldpDriver
        $LltdDriver
        $MicrosoftNetworkAdapterMultiplexorDriver
        $QosPacketSchedulerDriver
        $BitLockerDriver
        $OfflineFilesDriver
        $NetworkDataUsageDriver
    )
    Windows = @(
        #$AutoplayAndAutorunSvc
        #$BluetoothSvc
        #$BluetoothAndCastSvc
        #$BluetoothAudioSvc
        $DeprecatedSvc
        $HyperVSvc
        #$MicrosoftEdgeSvc
        #$MicrosoftOfficeSvc
        $MicrosoftStoreSvc
        $NetworkSvc
        #$NetworkDiscoverySvc
        $FileAndPrinterSharingSvc
        $PrinterSvc
        $RemoteDesktopSvc
        $SensorSvc
        $SmartCardSvc
        $VirtualSmartCardSvc
        $TelemetryDiagUsageSvc
        $TroubleshootingDiagUsageSvc
        $VirtualRealitySvc
        #$VpnSvc
        #$WebcamSvc
        #$WindowsBackupAndSystemRestoreSvc
        #$WindowsDefenderPhishingProtectionSvc
        $WindowsSearchSvc
        $WSLSvc
        $XboxSvc
        $MiscFeaturesSvc
        $MiscServices
    )
    ThirdParty = @(
        $AdobeSvc
        $IntelSvc
        $NvidiaSvc
    )
}

function Set-ServicesEntries
{
    Write-Section -Name 'Setting Services'
    Export-DefaultServicesStartupType
    Export-DefaultSystemDriversStartupType
    #$ServicesEntries.SystemDriver | Set-ServiceStartupType
    $ServicesEntries.Windows | Set-ServiceStartupType
    #$ServicesEntries.ThirdParty | Set-ServiceStartupType
}

# Function to easily check for new services (e.g. added by a Windows update).
function Get-ServiceNotInScript
{
    $AllServices = Get-Service -ErrorAction 'SilentlyContinue'
    $HandledServices = @() +
        $AutoplayAndAutorunSvc.ServiceName + $BluetoothSvc.ServiceName + $BluetoothAndCastSvc.ServiceName +
        $BluetoothAudioSvc.ServiceName + $DeprecatedSvc.ServiceName + $HyperVSvc.ServiceName +
        $MicrosoftEdgeSvc.ServiceName + $MicrosoftOfficeSvc.ServiceName + $MicrosoftStoreSvc.ServiceName +
        $NetworkSvc.ServiceName + $NetworkDiscoverySvc.ServiceName + $FileAndPrinterSharingSvc.ServiceName +
        $PrinterSvc.ServiceName + $RemoteDesktopSvc.ServiceName + $SensorSvc.ServiceName +
        $SmartCardSvc.ServiceName + $VirtualSmartCardSvc.ServiceName + $TelemetryDiagUsageSvc.ServiceName +
        $TroubleshootingDiagUsageSvc.ServiceName + $VirtualRealitySvc.ServiceName + $VpnSvc.ServiceName +
        $WebcamSvc.ServiceName + $WindowsBackupAndSystemRestoreSvc.ServiceName +
        $WindowsDefenderPhishingProtectionSvc.ServiceName + $WindowsSearchSvc.ServiceName + $WSLSvc.ServiceName +
        $XboxSvc.ServiceName + $MiscFeaturesSvc.ServiceName + $MiscServices.ServiceName +
        $CastAndProjectSvc.ServiceName + $ProxySvc.ServiceName + $OthersServices.ServiceName +
        $AdobeSvc.ServiceName + $IntelSvc.ServiceName + $NvidiaSvc.ServiceName
    $CurrentLUID = (Get-Service -Name 'WpnUserService_*').Name.Replace('WpnUserService', '')
    $UnhandledServices = $AllServices |
        Where-Object -FilterScript { $HandledServices -notcontains $_.Name.Replace($CurrentLUID, '') }
    $UnhandledServices
}

#endregion services

#=======================================
## scheduled tasks
#=======================================
#region scheduled tasks

$TasksEntries = @(
    #$UcpdTask
    #$AdobeAcrobatTasks
    $FeaturesTasks
    #$MicrosoftEdgeTasks
    #$MicrosoftOfficeTasks
    $MiscTasks
    $TelemetryTasks
    $TelemetryDiagnosticTasks
)

function Set-ScheduledTasksEntries
{
    Write-Section -Name 'Setting Scheduled Tasks'
    Export-DefaultScheduledTasksState
    $TasksEntries | Disable-WinScheduledTask
}

#endregion scheduled tasks

#endregion services & scheduled tasks

#endregion script configuration


#=================================================================================================================
#                                                script execution
#=================================================================================================================
#region script execution

#=======================================
## functions
#=======================================
#region functions

function Set-Tweaks
{
    Set-ActionCenterQuickSettings
    Set-DriversSettings
    #Set-EventLogDriveLocation
    Set-FileExplorerSettings
    Set-MiscellaneousSettings
    Set-NetworkSettingsAndProtocols
    Set-PowerOptionsSettings
    Set-SystemProperties
    Set-TelemetrySettings
}

function Set-Applications
{
    #Install-NewApplications
    Remove-DefaultAppxPackages
}

function Set-ApplicationsSettings
{
    Set-AdobeAcrobatReaderSettings
    Set-MicrosoftEdgeSettings
    Set-MicrosoftOfficeSettings
    Set-MiscellaneousApplicationsSettings
}

function Set-WindowsSettingsApp
{
    Set-SystemSettings
    Set-SystemOptionalFeatures
    Set-BluetoothAndDevicesSettings
    #Set-NetworkAndInternetSettings
    Set-PersonnalizationSettings
    Set-AppsSettings
    Set-AccountsSettings
    Set-TimeAndLanguageSettings
    Set-GamingSettings
    Set-AccessibilitySettings
    Set-WindowsSecuritySettings
    Set-PrivacySettings
    Set-WindowsUpdateSettings
}

function Set-ServicesAndScheduledTasks
{
    Set-ServicesEntries
    Set-ScheduledTasksEntries
}

#endregion functions

#=======================================
## execution
#=======================================
#region execution

$ScriptFileName = (Get-Item -Path $PSCommandPath).Basename
Start-Transcript -Path "$PSScriptRoot\$ScriptFileName.log"

$VerbosePreference = 'Continue'

Set-Tweaks
Set-Applications
Set-ApplicationsSettings
#Set-RamDisk
Set-WindowsSettingsApp
Set-ServicesAndScheduledTasks

Stop-Transcript

#endregion execution

#endregion script execution
