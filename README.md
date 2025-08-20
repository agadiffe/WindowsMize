<h1 align="center">
  <img src="img/WindowsMizeHeader.png" alt="WindowsMize Header" width="90%">
</h1>
<div align="center">
Automate and customize the configuration of Windows.

Debloat, minimize telemetry, apps installation, general settings, and more.
</div>


## 🎯 Purpose
1. Install Windows (semi-unattended: see [New-WindowsAnswerFile.ps1](tools/New-WindowsAnswerFile.ps1)) + updates.  
   While installing the updates, install Office365 if desired (run [MsOffice365_Install.cmd](tools/MsOffice365_Install.cmd)).
2. Run the script ([WindowsMize.ps1](WindowsMize.ps1) or the no comment version [WindowsMize.mini.ps1](WindowsMize.mini.ps1)).
3. Finish some customization (see [todo_manually.md](todo_manually.md)).


## 📝 Characteristics
- Fully non-interactive script: make sure to review everything before running it.
- Designed for Windows 11 (most tweaks/settings also work on Windows 10).
- Works on both Administrator and Standard account.


## 💫 Features
### 🖥️ Windows settings
Equivalent of the Windows GUI settings app (start > all apps > settings).  
There are almost every settings, organized like the graphical counterpart.

### 📁 File Explorer
Every settings + few extra.  
Extra: Show/Hide Home/Gallery, ShowRemovableDrivesOnlyInThisPC, AutoFolderTypeDetection,  
MaxIconCacheSize, RecycleBin, ConfirmFileDelete.

### ⌛ System Properties
Equivalent of the Windows GUI System Properties.  
Visual Effects, Virtual Memory (paging file), System failure, System Restore, Remote Assistance.

### ⚡ Power options
Settings not present in the Windows GUI settings app.  
Fast startup, Hibernate, Battery settings, Modern standby (S0) Network connectivity.

### 🌐 Network
<details>
  <summary>Improve security by disabling various network protocols (click to expand).</summary>

- Firewall: block some ports/programs shown as listening (locally) in Netstat or TCP View.
- IPv6 transition technologies (6to4, Teredo, IP-HTTPS, ISATAP).
- Network adapter protocol (Equivalent of the GUI properties (more adapter options > edit)).
- Miscellaneous (NetBiosOverTcpIP, IcmpRedirects, IPSourceRouting, LLMNR, Smhnr, Wpad).
</details>

### 📊 Telemetry
<details>
  <summary>Various Group Policies to minimize Windows telemetry (click to expand).</summary>

  DotNetTelemetry, NvidiaTelemetry, PowerShellTelemetry, AppAndDeviceInventory, ApplicationCompatibility, Ceip,  
  CloudContent, ConsumerExperience, DiagnosticLogAndDumpCollectionLimit, DiagnosticsAutoLogger,  
  DiagnosticTracing, ErrorReporting, GroupPolicySettingsLogging, HandwritingPersonalization, InventoryCollector,  
  KmsClientActivationDataSharing, MsrtDiagnosticReport, OneSettingsDownloads, UserInfoSharing.
</details>

The main telemetry configurations are in the Windows settings app.  
See 'Windows Settings App > Privacy & security > Windows permissions'.

For Microsoft Office telemetry, see 'Applications Settings > Microsoft Office'.

### 🛠️ Tweaks
<details>
  <summary>Various tweaks to improve and customize Windows. (click to expand).</summary>

<details>
  <summary>Security, privacy and networking (click to expand).</summary>

  Hotspot2, LockScreenCameraAccess, MessagingCloudSync, NotificationsNetworkUsage,  
  PasswordExpiration, PasswordRevealButton, PrinterDriversDownloadOverHttp, WifiSense, Wpbt.
</details>
<details>
  <summary>System and performance (click to expand).</summary>

  FirstSigninAnimation, LongPaths, NtfsLastAccessTime, NumLockAtStartup, ServiceHostSplitting,  
  Short8Dot3FileName, StartupShutdownVerboseStatusMessages.
</details>
<details>
  <summary>User interface and experience (click to expand).</summary>

  ActionCenterLayout, CopyPasteDialogShowMoreDetails, HelpTips, MenuShowDelay, OnlineTips, ShortcutNameSuffix,  
  StartMenuAllAppsViewMode, StartMenuRecommendedSection, SuggestedContent, WindowsExperimentation,  
  WindowsInputExperience, WindowsPrivacySettingsExperience, WindowsSharedExperience, WindowsSpotlight.
</details>
<details>
  <summary>Windows features and settings (click to expand).</summary>

  MoveCharacterMapShortcutToWindowsTools, EventLogLocation, EaseOfAccessReadScanSection, FileHistory,  
  FontProviders, HomeSettingPageVisibility, OpenWithDialogStoreAccess, TaskbarLastActiveClick,  
  WindowsHelpSupport (F1Key, Feedback), WindowsMediaDrmOnlineAccess, WindowsUpdateSearchDrivers.
</details>

</details>

### 💿 Applications
<details>
  <summary>Removal | Installation | Configuration (click to expand)</summary>

- Uninstall unwanted default apps (bloatware).  
  e.g. Microsoft Edge, OneDrive, Start Menu sponsored apps, Widgets, BingSearch, ClipChamp, etc...

- Install applications via Winget.

  <details>
    <summary>Predefined apps with short names (aliases for Winget package names) (click to expand).</summary>

  Git, VSCode, VLC, Bitwarden, KeePassXC, ProtonPass, AcrobatReader, SumatraPDF, 7zip, Notepad++, qBittorrent,  
  Brave, Firefox, MullvadBrowser, VCRedist, DirectXEndUserRuntime, DotNetDesktopRuntime.
  </details>

  You can also install any apps with their Winget app name (e.g. 'Valve.Steam').

- Configure application settings.

  Apps: Acrobat Reader, Brave Browser, Git, KeePassXC, MS Office, qBittorrent, VLC, VSCode.  
  UWP apps: Microsoft Store, Notepad, Photos, Snipping Tool, Terminal.

</details>

### 💾 RamDisk
<details>
  <summary>Configure a RamDisk for 'Brave Browser' and 'VSCode' (click to expand).</summary>

For Brave, only few elements are either restored to or excluded from the RamDisk:
- Extensions and their settings (excluded. i.e. symlinked).
- Bookmarks and their favicons (saved and restored upon logoff/logon).
- Settings preferences (saved and restored upon logoff/logon).

i.e. By default, history and cookies are not restored across logoff/logon.
</details>

### ⚙️ Services & Scheduled Tasks
Configure (e.g. disable) Windows Services & Scheduled Tasks (grouped by categories).

There are a lot of comments about the services in 'src > modules > services > private'.  
Make sure to review them to know which one to disable according to your usages.


## 📚 Usage
This script requires 'PowerShell 7 (aka PowerShell Core)' and must be run as Administrator.  
It's recommended to use Notepad++ or VSCode to have the code highlighted.

### Automated
1. Open a PowerShell prompt (Administrator privileges are not required).  
   Right-click on `Start Menu` > `Terminal`.
2. Download and extract WindowsMize archive to the 'Downloads' folder.  
   e.g. `C:\Users\<User>\Downloads\WindowsMize`.  
   If the folder 'WindowsMize' exist, it will be deleted.  
   Save any data you want to keep (e.g. previous configuration and/or log files).
    ```powershell
    irm 'https://github.com/agadiffe/WindowsMize/raw/main/tools/Download_WindowsMize.ps1' | iex
    ```
3. Navigate to the extracted 'WindowsMize' folder in your 'Downloads' folder.
4. **Configure the script (WindowsMize.ps1) according to your preferences**.
5. Double click on the `Run_WindowsMize.cmd` file to run the script.  
   Accept the Windows UAC prompt to run it as Administrator (required).  
   If 'PowerShell 7' is not installed, it will be automatically installed.
6. Restart (Mandatory for a lot of tweaks/settings).

### Manually
<details>
  <summary>Details (Click to expand)</summary>

1. [Download WindowsMize](https://github.com/agadiffe/WindowsMize/archive/main.zip).
2. Navigate to the directory where you downloaded the archive and extract it.
3. **Configure the script (WindowsMize.ps1) according to your preferences**.
3. Open a PowerShell prompt (as Administrator or not).  
   Right-click on `Start Menu` > `Terminal`.
3. Install 'PowerShell 7'.
    ```powershell
    winget install --exact --id 'Microsoft.PowerShell' --accept-source-agreements --accept-package-agreements
    ```
4. Open an elevated (i.e. Administrator) PowerShell prompt:  
   Right-click on `Start Menu` > `Terminal (Admin)`.  
   At the top of the Terminal window:  
   Click on the down arrow and choose 'PowerShell'.
5. Navigate to the directory where you extracted 'WindowsMize' (replace '\<User\>' with your username).  
   Example:
    ```powershell
    cd 'C:\Users\<User>\Downloads\WindowsMize-main\WindowsMize-main'
    ```
6. Unblock the script files (might not be necessary).
    ```powershell
    Get-ChildItem -File -Recurse | Unblock-File
    ```
7. Sets the PowerShell execution policies for the current session (enable PowerShell script execution).
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process'
    ```
8. Run the script.
    ```powershell
    .\WindowsMize.ps1
    ```
9. Restart (Mandatory for a lot of tweaks/settings).

</details>


## 📍 Remarks
Read some comments in the source code files about why you should disable some features.

  - src > modules > 
    - network > private > NetFirewallRules.ps1
    - network > public
    - telemetry > public
    - tweaks > public


## 💙 Support
If you find a bug, please open an issue.  
If you like the project, leave a ⭐.
