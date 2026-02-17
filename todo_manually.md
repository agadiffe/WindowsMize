## Description
Review these todos after the script execution and computer restart.  
(or before, depending of the setting. e.g. you probably want to set the "display scale" right away)

## DNS block lists
Add these lists to your Hosts file: `C:\System32\drivers\etc\hosts`.  
You might need to add this file as exception in Microsoft Defender.

Not automated because such functions/scripts would certainly be flagged by Antivirus ...

- Microsoft Solitaire Ads  
  see [Microsoft-Solitaire-Ads_DNS-list.txt](tools/Microsoft-Solitaire-Ads_DNS-list.txt)
- Microsoft trackers (Windows, Office, MSN)  
  GitHub project: https://github.com/hagezi/dns-blocklists  
  Hosts file:  
  - https://github.com/hagezi/dns-blocklists/blob/main/hosts/native.winoffice-compressed.txt  
  - https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/native.winoffice-compressed.txt

## Settings
- System:
  - Display:
    - Scale > 100% (or else)
    - Advanced display > choose a refresh rate
  - Sound:
    - Speakers / Headphones > output settings > format > 24bits, 96000Hz (Studio Quality)  
      Most games use 96kHz as default ?

- Bluetooth & devices:
  - Printers & scanners:
    - Microsoft Print to PDF > printing preferences > advanced > paper size > A4

- Network & internet:
  - Wi-Fi:
    - Random hardware addresses > enable if needed (e.g. public wifi)

- Personalization:
  - Taskbar:
    - Other system tray icons > hidden icon menu  
      e.g. always show: Acrobat Reader (new update), Bluetooth, Windows Update Status

- Apps:
  - Startup > disable unwanted startup apps

- Privacy & security:
  - Windows Security (aka Defender) > review the settings and dismiss any warning message
  - Device encryption  > turn off device encryption (if desired) (not automated because it can take a long time)  
    The recommended way is to install Windows with an "answer file" to prevent auto device encryption.

## Miscellaneous
- Personalize the Start Menu and taskbar items.  
  e.g. unpin Microsoft Store

- Move the default user folders location outside of the system drive (if possible).  
  i.e. desktop, downloads, documents, music, pictures, videos

- Battery setting (e.g. Laptop)  
  Limit the maximum charge to 85%% (or 90%) to preserve the battery longevity.  
  This option is generaly in the BIOS or via a manufacturer application.

- Monitor: Download icc profile (if needed).  
  settings > system > display > color profile  
  control panel (icons view) > color management (colorcpl.exe)

## Hardware
- Update needed driver/firmware.  
  e.g. audio, bios, bluetooth, ethernet, gpu, monitor, wifi

  If Windows Update rollback to an older version, open Device manager:  
  update driver > browse my computer for drivers > let me pick from a list of available drivers on my computer:  
    Choose the newest driver and apply. This should prevent Window Update to override the driver.  
  When installing Intel Graphics Drivers (iGPU), do not choose clean installation.  
  If the old driver (the one installed by Windows) is removed, Windows Update will reinstall it.

- Device Manager: Disable unused hardware.  
  e.g. biometric, bluetooth, cameras

- Undervolt cpu/gpu (if desired).  
  cpu: Intel XTU / AMD Ryzen Master / Throttlestop  
  gpu: MSI afterburner  
  tools: heaven benchmark / cinebench

- Nvidia GPU  
  Uninstall the old driver with Display Driver Uninstaller (DDU).  
  Install the new driver with NVCleanstall.
