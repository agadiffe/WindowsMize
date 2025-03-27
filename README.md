```
__      __  _             _                       __  __   _
\ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
 \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
  \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|

```

## Description
### Purpose
PowerShell script to automate and customize the configuration of Windows.

1. install Windows (semi-unattended) + updates
2. run the script
3. finish some customization

### Characteristics
- designed for Windows 11 (most tweaks/settings also works on Windows 10).  
- fully non-interactive script: make sure to review everything before running it.

### Remarks
Documentation files will be added later (probably).  
For now, you can read some comments directly in the source code files.

Example:
 - src > modules > network > private > NetFirewallRules.ps1
 - src > modules > network > public
 - src > modules > telemetry > public
 - src > modules > tweaks > public

## Features
- customize Windows settings (start > all apps > settings)
- tweaks, telemetry, network, power options, system properties, file explorer
- remove default unwanted apps (bloatware)
- install applications (e.g. 7zip, VLC, Web Browser)
- applications settings (including UWP apps like Photos and Notepad)
- configure a RamDisk (Brave Browser / VSCode)
- disable services & scheduled tasks


## Usage
This script requires 'PowerShell 7 (aka PowerShell Core)' and must be run as Administrator.  
It's recommended to use Notepad++ or VSCode to have the code highlighted.

### Automated
1. Open a PowerShell prompt (Administrator privileges are not required).  
   Right-click on `Start Menu` > `Terminal`.
2. Download and extract WindowsMize archive to the 'Downloads' folder.  
   e.g. `C:\Users\<User>\Downloads\WindowsMize`.  
   If the folder 'WindowsMize' exist, it will be deleted.  
   Save any data you want to keep (e.g. previous log files).
    ```powershell
    irm 'https://github.com/agadiffe/WindowsMize/raw/main/Download_WindowsMize.ps1' | iex
    ```
3. Navigate to the extracted 'WindowsMize' folder in your 'Downloads' folder.
4. **Configure the script (WindowsMize.ps1) according to your preferences**.
5. Double click on the `Run_WindowsMize.bat` file to run the script.  
   Accept the Windows UAC prompt to run it as Administrator (required).  
   If 'PowerShell 7' is not installed, it will be automatically installed.
6. Restart (Mandatory for a lot of tweaks/settings).


### Manually
1. [Download WindowsMize](https://github.com/agadiffe/WindowsMize/archive/main.zip).
2. Navigate to the directory where you downloaded the archive and extract it.
3. **Configure the script (WindowsMize.ps1) according to your preferences**.
3. Open a PowerShell prompt (as Administrator or not).  
   Right-click on `Start Menu` > `Terminal`.
3. Install 'PowerShell 7'.
    ```powershell
    winget install --exact --id 'Microsoft.PowerShell' --accept-source-agreements --accept-package-agreements
    ```
4. Open an elevated PowerShell prompt:  
   Right-click on `Start Menu` > `Terminal (Admin)`.
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


## Support
If you find a bug, please open an issue.
