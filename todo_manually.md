## Description
Review these todos after the script execution and computer restart.  
(or before, depending of the setting. e.g. you probably want to set the "display scale" right away)

## Settings
- System:
  - display:
    - scale > 100% (or else)
    - advanced display > choose a refresh rate
  - sound:
    - speakers / headphones > output settings > format > 24bits, 96000Hz (Studio Quality)  
      Most games use 96kHz as default ?

- Bluetooth & devices:
  - printers & scanners:
    - Microsoft Print to PDF > printing preferences > advanced > paper size > A4

- Network & internet:
  - wi-fi:
    - random hardware addresses > enable if needed (e.g. public wifi)

- Personalization:
  - taskbar:
    - other system tray icons > hidden icon menu  
      e.g. always show: adobe acrobat reader (new update), bluetooth

- Apps:
  - startup > disable unwanted startup apps

- Privacy & security:
  - windows security (aka Defender) > review the settings and dismiss any warning message
  - device encryption  > turn off device encryption (if desired) (not automated because it can take a long time)  
    The recommended way is to use an "answer file" to prevent the auto device encryption.

## Miscellaneous
- Battery setting (e.g. Laptop)  
  Limit the maximum charge to 90% (or 85%) to preserve the battery longevity.  
  This option is generaly in the BIOS or via a manufacturer application.

- Move the default user folders location outside of the system drive (if possible).  
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
