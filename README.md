<h1 align="center">
  <img src="img/WindowsMizeHeader.png" alt="WindowsMize Header" width="90%">
</h1>
<div align="center">
Automate and customize the configuration of Windows.

Debloat, minimize telemetry, apps installation, general settings, and more.
</div>


## 🎯 Purpose
1. Install Windows (semi-unattended: see [New-WindowsAnswerFile.ps1](tools/New-WindowsAnswerFile.ps1)) + Updates.
2. Install MS Office365 if desired (run [MsOffice365_Install.cmd](tools/MsOffice365_Install.cmd)).
3. Run the script ([WindowsMize.ps1](WindowsMize.ps1) or the condensed version [WindowsMize.mini.ps1](WindowsMize.mini.ps1)).
4. Finish some customization (see [todo_manually.md](todo_manually.md)).

Long term: automate step 4.

## 📝 Characteristics
- Fully non-interactive script : make sure to review everything before running it.
- Designed for Windows 11 (most tweaks/settings also work on Windows 10).
- Works on both Administrator and Standard account (including domain account).
- 31 script files based on 26 Powershell modules.


## 💫 Features
### 🖥️ Windows settings
13 modules.  
Equivalent of the Windows GUI settings app : Start > all apps > settings.  
There are almost every settings, organized like the graphical's app.

### 📁 File Explorer
Every settings (general, view, search) + extra.  
Extra: ShowNavigationPane, Show/Hide Home/Gallery, ShowRemovableDrivesOnlyInThisPC, AutoFolderTypeDetection, MaxIconCacheSize, UndoRedo, RecycleBin, ConfirmFileDelete.

### ⌛ System Properties
Equivalent of the Windows GUI System Properties.  
Visual Effects, Virtual Memory (paging file), System failure, System Restore, Remote Assistance.

### ⚡ Power & Battery
Equivalent of the Windows GUI settings app "Power & Battery" + extra from Control Panel.  
Extra: Fast startup, Hibernate, Battery settings, Modern standby (S0) Network connectivity.

### 🌐 Network & Internet
<details>
  <summary>Configure the network settings. Improve security by disabling protocols and firewall rules (click to expand).</summary>

- Network & Internet:
  - equivvalent of the Windows GUI settings app (start > all apps > settings > Network & Internet):  
    Network profile, auto proxy setting, DNS, Network discovery, File and Printer Sharing.
- Firewall:
  - block some ports/programs shown as listening (locally):  
    CDP, DCOM, NetBiosTcpIP, SMB, MiscProgSrv (lsass.exe, wininit.exe, Schedule, EventLog, services.exe)
  - default Defender rules:  
    AllJoynRouter, CastToDevice, ConnectedDevicesPlatform, DeliveryOptimization, DIALProtocol, MicrosoftMediaFoundation, ProximitySharing, WifiDirectDiscovery, WirelessDisplay, WiFiDirectCoordinationProtocol, WiFiDirectKernelModeDriver
- Protocol:
  - IPv6 transition technologies (6to4, Teredo, IP-HTTPS, ISATAP).
  - Network adapter protocol (Equivalent of the GUI properties (more adapter options > edit)).
  - Miscellaneous (NetBiosOverTcpIP, IcmpRedirects, IPSourceRouting, LLMNR, LMHOSTS, mDNS, SMHNR, WPAD).
</details>

### 📊 Telemetry
<details>
<summary>Various Group Policies to minimize Windows telemetry (click to expand).</summary>

  DotNetTelemetry, NvidiaTelemetry, PowerShellTelemetry, AppAndDeviceInventory, ApplicationCompatibility, Ceip, CloudContent, ConsumerExperience, DiagnosticLogAndDumpCollectionLimit, DiagnosticsAutoLogger, DiagnosticTracing, ErrorReporting, GroupPolicySettingsLogging, HandwritingPersonalization, KmsClientActivationDataSharing, MsrtDiagnosticReport, OneSettingsDownloads, UserInfoSharing.
</details>

The main telemetry configurations are in the Windows settings app.  
See "Windows Settings App > Privacy & security > Windows permissions".

For Acrobat Reader & MS Office telemetry, see "Applications Settings".

### 🛠️ Tweaks
<details>
  <summary>Various tweaks to improve and customize Windows. (click to expand).</summary>

- Security, privacy and networking:  
  HomeGroup, Hotspot2, LockScreenCameraAccess, MessagingCloudSync, NotificationsNetworkUsage, PasswordExpiration, PasswordRevealButton, PrinterDriversDownloadOverHttp, WifiSense, Wpbt.

- System and performance:  
  FirstSigninAnimation, LongPaths, NtfsLastAccessTime, NumLockAtStartup, ServiceHostSplitting, Short8Dot3FileName, StartupAppsDelay, StartupShutdownVerboseStatusMessages.

- User interface and experience:  
  DisableGameBarLinks, ActionCenterLayout, CopyPasteDialogShowMoreDetails, HelpTips, MenuShowDelay, OnlineTips, ShortcutNameSuffix, StartMenuAllAppsViewMode, StartMenuRecommendedSection, SuggestedContent, WindowsExperimentation, WindowsInputExperience, WindowsPrivacySettingsExperience, WindowsSharedExperience, WindowsSpotlight.

- Windows features and settings:  
  MoveCharacterMapShortcutToWindowsTools, DisplayModeChangeAnimation, EventLogLocation, EaseOfAccessReadScanSection, FileHistory, FontProviders, HomeSettingPageVisibility, LocationPermission, LocationScriptingPermission, OpenWithDialogStoreAccess, SensorsPermission, ShareShowDragTrayOnTopScreen, TaskbarLastActiveClick, WindowsHelpSupport, WindowsMediaDrmOnlineAccess, WindowsUpdateSearchDrivers.

</details>

### 💿 Applications
2 modules.
<details>
  <summary>Management (Removal | Installation ) & Configuration (click to expand)</summary>

- Uninstall unwanted default apps (bloatware).  
  e.g. Edge, OneDrive, Start Menu sponsored apps, Widgets, BingSearch, ClipChamp, etc...

- Install applications via Winget.

  Predefined apps with short names (aliases for Winget package names):  
  Git, VSCode, VLC, Bitwarden, KeePassXC, ProtonPass, AcrobatReader, SumatraPDF, 7zip, Notepad++, qBittorrent, ProtonVPN, MullVadVPN, Brave, Firefox, MullvadBrowser, VCRedist, DirectXEndUserRuntime, DotNetDesktopRuntime.

  You can also install any apps with their Winget app name (e.g. "Valve.Steam").

- Configure application settings.

  Apps: Acrobat Reader, Brave Browser, Git, KeePassXC, MS Office, qBittorrent, VLC, VSCode.  
  UWP apps: MS Store, Notepad, Photos, Snipping Tool, Terminal.

</details>

### 💾 RamDisk
<details>
  <summary>Configure a RamDisk for "Brave Browser" and "VSCode" (click to expand).</summary>

For Brave, only few elements are either restored to or excluded from the RamDisk:
- Extensions and their settings (excluded. i.e. symlinked).
- Bookmarks and their favicons (saved and restored upon logoff/logon).
- Settings preferences (saved and restored upon logoff/logon).

i.e. By default, history and cookies are not restored across logoff/logon.
</details>

### ⚙️ Services & Scheduled Tasks
2 modules.  
Configure (e.g. disable) Windows Services & Scheduled Tasks (grouped by categories).

There are a lot of comments about the services in "src > modules > services > private".  
Make sure to review them to know which one to disable according to your usages.


## 📚 Usage
It's recommended to use Notepad++, VSCode or else to have the code highlighted.

### Main script
"WindowsMize.ps1" is the main script that will execute the other scripts.  
Settings are divided into 6 main categories with 31 script files.  
These script files are located in the "scripts" folder.

You can provide an optional "User" parameter to the script to apply the settings to a specific user.  
This user must have logged-in at least once.

```powershell
.\WindowsMize.ps1 # logged-on User
.\WindowsMize.ps1 -User 'Groot'
.\WindowsMize.ps1 -User 'Domain\Groot'
```

You can uncomment or comment the script names to execute or not the corresponding script.  
Example:  
To execute only "Telemetry & Annoyances", "file_explorer" and some others:  
comment everything except the script files you want to run.

```powershell
$ScriptsToExecute = @(
    # --- Apps Management
    'apps_management\debloat'
    #'apps_management\install'

    # --- Apps Settings
    [...]
    # --- Network & Internet
    [...]
    # --- System & Tweaks
    'system_&_tweaks\file_explorer'
    [...]
    'system_&_tweaks\tweaks'

    # --- Telemetry & Annoyances
    'telemetry_&_annoyances\telemetry'
    'telemetry_&_annoyances\defender_security_center'
    'telemetry_&_annoyances\privacy_&_security'
    'telemetry_&_annoyances\notifications'
    'telemetry_&_annoyances\start_&_taskbar'

    # --- Win Settings App
    [...]
    #'win_settings_app\windows_update'
)
```

### Setting parameters
Mostly every functions have a "-State" and/or "-GPO" parameters.  
The accepted values for these parameters are below the setting title.

```powershell
# --- Bing Search in Start Menu (default: Enabled)
# State: Disabled | Enabled
# GPO: Disabled | NotConfigured
Set-StartMenuBingSearch -State 'Disabled' -GPO 'Disabled'
#Set-StartMenuBingSearch -State 'Enabled' -GPO 'NotConfigured'
```

### Function execution
To don't run a function, comment it (i.e. add the "#" character before the function name).
```powershell
#Disable-PowerShellTelemetry
```

To run a function, uncomment it (i.e. remove the "#" character before the function name).
```powershell
Disable-PowerShellTelemetry
```

To comment an entire section : begin with "<#" and end with "#>".  
Example:  
In "Win Settings app > Bluetooth & Devices.ps1 : "Touchpad" is commented by default.
```powershell
<#
# --- Touchpad
...
settings
...
#>
```


## 📥 Download & Execution
This script requires "PowerShell 7 (aka PowerShell (Core))" and must be run as Administrator.  

### Automated
1. Open a PowerShell prompt (Administrator privileges are not required).  
   Right-click on `Start Menu` > `Terminal`.
2. Download and extract WindowsMize archive to the "Downloads" folder.  
   e.g. `C:\Users\<User>\Downloads\WindowsMize`.  
   If the folder "WindowsMize" exist, it will be deleted.  
   Save any data you want to keep (e.g. previous configuration and/or log files).
    ```powershell
    irm 'https://github.com/agadiffe/WindowsMize/raw/main/tools/Download_WindowsMize.ps1' | iex
    ```
3. Navigate to the extracted "WindowsMize" folder in your "Downloads" folder.
4. **Configure the script (WindowsMize.ps1) according to your preferences**.
5. Double click on the `Run_WindowsMize.cmd` file to run the script.  
   Accept the Windows UAC prompt to run it as Administrator (required).  
   If "PowerShell 7" is not installed, it will be automatically installed.
6. Restart (Mandatory for a lot of tweaks/settings).

### Manually
<details>
  <summary>Details (Click to expand)</summary>

1. [Download WindowsMize](https://github.com/agadiffe/WindowsMize/archive/main.zip).
2. Navigate to the directory where you downloaded the archive and extract it.
3. **Configure the script (WindowsMize.ps1) according to your preferences**.
3. Open a PowerShell prompt (as Administrator or not).  
   Right-click on `Start Menu` > `Terminal`.
3. Install "PowerShell 7".
    ```powershell
    winget install --exact --id 'Microsoft.PowerShell' --accept-source-agreements --accept-package-agreements
    ```
4. Open an elevated (i.e. Administrator) PowerShell prompt:  
   Right-click on `Start Menu` > `Terminal (Admin)`.  
   At the top of the Terminal window:  
   Click on the down arrow and choose "PowerShell".
5. Navigate to the directory where you extracted "WindowsMize" (replace <User\> with your username).  
   Example:
    ```powershell
    cd 'C:\Users\<User>\Downloads\WindowsMize-main\WindowsMize-main'
    ```
6. Unblock the script files (might not be necessary).
    ```powershell
    Get-ChildItem -File -Recurse | Unblock-File
    ```
7. Sets the PowerShell execution policies for the current session (enable PowerShell script execution).  
   (This is not required for "Powershell 7", but it might change in future Windows release)
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process' -Force
    ```
8. Run the script.
    ```powershell
    .\WindowsMize.ps1
    ```
9. Restart (Mandatory for a lot of tweaks/settings).

</details>


## 📌 Remarks
- The Powershell modules source code is designed to also serve as documention.  
  PS1 file often includes header comments.  
  The structure allows quick navigation to identify the registry values associated with any specific setting.  
  All GPO settings include references to their corresponding paths, names, and registry values.
  ```powershell
  # gpo\ computer config > administrative tpl > windows components > data collection and preview builds
  #   do not show feedback notifications
  # not configured: delete (default) | on: 1
  ```

- Read some comments about why you should disable some features.  
  src\modules : network, telemetry, tweaks, ...

- Make sure to backup all of your data.  
  e.g. browser bookmarks, apps settings, personal files, passwords database

- Make sure your Windows is fully updated.  
  Settings > Windows Update > Check for updates  
  Microsoft Store > Library (or Downloads) > Check for updates (run it at least twice)


## ♾️ Links
Special thanks to [ElevenForum](https://elevenforum.com/) (make sure to add it as exception in Brave).  
If you have suggestions or comments, I made a post there : [WindowsMize on ElevenForum](https://www.elevenforum.com/t/windowsmize-powershell-script-to-automate-and-customize-the-configuration-of-windows.32302/).


## 💙 Support
If you find a bug, open an issue.  
If you like the project, leave a ⭐.  
Thanks.
