```
__      __  _             _                       __  __   _
\ \    / / (_)  _ _    __| |  ___  __ __ __  ___ |  \/  | (_)  ___  ___
 \ \/\/ /  | | | ' \  / _` | / _ \ \ V  V / (_-< | |\/| | | | |_ / / -_)
  \_/\_/   |_| |_||_| \__,_| \___/  \_/\_/  /__/ |_|  |_| |_| /__| \___|

```

## Purpose
Automate and customize everything we can.

1. install Windows (semi-unattended) + updates
2. run the script
3. finish some customization


## Description
### Main features
- customize Windows settings (start > all apps > settings)
- tweaks (file explorer, network, system properties, telemetry, ...)
- remove unwanted apps (bloatware)
- install applications + settings
- disable services & scheduled tasks

### Characteristics
- fully non-interactive script: make sure to review everything before running it.  
- active tweaks/settings are selectable at the bottom of the script.
- easily customizable, maintainable and scalable.
- most tweaks/settings works on Windows 10.
- designed for Windows 11.


## Usage
This script requires 'PowerShell Core' and must be run as Administrator.

1. Download the script and **configure it according to your preferences**.  
   You may need `Notepad++` or `VSCode` to easily edit the script.

2. Install 'PowerShell Core':  
  In a `Terminal`, enter:
    ```powershell
    PS> winget install --exact --id 'Microsoft.PowerShell'
    ```
3. Open an elevated PowerShell prompt:  
   Right-click on `Start Menu` > `Terminal (Admin)`.
   
4. Sets the PowerShell execution policies for the current session (enable PowerShell script execution).
    ```powershell
    PS> Set-ExecutionPolicy -ExecutionPolicy 'Bypass' -Scope 'Process' -Force
    ```
5. Navigate to the directory where you downloaded the script.  
   You should download the script in its own directory (several log files will be created in the script location).  
    ```powershell
    PS> cd "C:\Users\<User>\Downloads\WindowsMize\"
    ```
6. Unblock the PowerShell script (might not be necessary).
    ```powershell
    PS> Unblock-File -Path '.\WindowsMize.ps1'
    ```
7. Run the script.
    ```powershell
    PS> .\WindowsMize.ps1
    ```
8. Restart (Mandatory for a lot of tweaks/settings).


## Features
The script is divided into 9 sections in the following order:

### WindowsMize
Requirements, answer files for Windows installation and a todo list to maually do atfter the script.  
Some helper functions (user info / set registry entries).

### Tweaks
Various tweaks to customize Windows (e.g. file explorer, network, power options, system properties, telemetry).  
There is also a miscellaneous sub-section that contains a lot of tweaks.

### Applications
Installation of new applications (e.g. 7zip, VLC, Web Browser).  
Removal of default (bloatware) applications (e.g. Camera, Clock, Clipchamp).

### Applications settings
Configuration of several applications (including default UWP apps like Photos and Notepad).  
e.g. adobe acrobat reader, brave browser, microsoft office, windows terminal.

### RamDisk
Could almost be a project by its own.  
Configure 'Brave browser' and 'Visual Studio Code' to use a Ram disk.

### Windows Settings app
Equivalent of the Microsoft Windows Settings app (Start > All apps > Settings).    
There are a lot of the settings present in the GUI, but not everything.

### Services & Scheduled tasks
Disable unwanted services and scheduled tasks (grouped by category).  
Be sure to review every services to know which one to disable according to your usage.

### Script configuration / execution
In these two sections, comment or uncomment the tweaks/settings you want to execute or not.


## Configuration
### Customization
It can take a moment to configure everything, but it's a one time job.

Most of the tweaks/settings are done with a JSON format. Change the preset values according to your preferences.  
Once you've configured the default tweaks/settings values, you can choose which one to execute in the sections "Script configuration" and "Script execution".

If you want to change a value for a specific tweak/setting, the fastest way is to highlight the variable in these two sections and use "Ctrl + F" to find the related JSON/function.  
You can also use the 'region folder' to easily naviguate to the corresponding tweak/setting (involves to use a code editor that support 'region folder' like VSCode or Notepad++).

### Group Policy
There are several settings with both Group Policy and User values (Mainly in the "Windows Settings app" section).  
By default, there is a '"SkipKey" : true' for these Group Policy rules (delete this key or set it to false to enable them).  
They are default enabled only in the section "settings > privacy & security > windows permissions > diagnostics & feedback".


## Support
If you find a bug, please open an issue.  
If you like this project, let me know with a star. ⭐️ :)


## Similar tools (in no particular order)
https://schneegans.de/windows/unattend-generator/

https://github.com/Atlas-OS/Atlas  
https://github.com/builtbybel/xd-AntiSpy  
https://github.com/ChrisTitusTech/winutil  
https://github.com/farag2/Sophia-Script-for-Windows  
https://github.com/hellzerg/optimizer  
https://github.com/Raphire/Win11Debloat  
https://github.com/simeononsecurity/Windows-Optimize-Harden-Debloat  
https://github.com/undergroundwires/privacy.sexy  
