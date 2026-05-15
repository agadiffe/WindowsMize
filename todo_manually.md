## Description
Review these todos after the script execution and computer restart.  
(or before, depending of the setting. e.g. you probably want to set the "display scale" right away)

## DNS block lists
Add these domain lists to your hosts file (C:\Windows\System32\drivers\etc\hosts).  
You may need to allow modifications to the hosts file in Microsoft Defender (e.g. by adding the file as an exclusion).

Excluding the hosts file from Defender can reduce security if malware later gains access to your system,  
because malware often abuses the hosts file to block security websites or redirect traffic.  
An alternative is to use AdGuard Home or a similar DNS-based filtering tool.

Not automated, because scripts or tools that modify the hosts file are commonly flagged by antivirus software,  
including Microsoft Defender, as potentially suspicious behavior.

- Microsoft Solitaire Ads  
  See [Microsoft-Solitaire-Ads_DNS-list.txt](tools/Microsoft-Solitaire-Ads_DNS-list.txt).  
  Open Notepad as administrator and copy/paste the list to your hosts file.
- Microsoft trackers (Windows, Office, MSN)  
  GitHub project: https://github.com/hagezi/dns-blocklists  
  Hosts file:  
  - https://github.com/hagezi/dns-blocklists/blob/main/hosts/native.winoffice-compressed.txt
  - https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/native.winoffice-compressed.txt

  <details>
    <summary>Script to add/update the "Windows Tracker DNS Blocklist" (save it as .ps1 file) (Click to expand)</summary>
  
  ```powershell
  #=================================================================================================================
  #                           Hosts file - HaGeZi's Windows/Office Tracker DNS Blocklist
  #=================================================================================================================
  
  # https://github.com/hagezi/dns-blocklists
  
  
  <#
  .SYNTAX
      Set-HostsDnsBlocklistsNativeWinOffice.ps1 [<CommonParameters>]
  #>
  
  [CmdletBinding()]
  param ()
  
  $HostsData = @{
      #Source      = 'https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/native.winoffice-compressed.txt'
      Source      = 'https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/hosts/native.winoffice-compressed.txt'
      Destination = "$env:SystemRoot\System32\drivers\etc\hosts"
  }
  
  try
  {
      Write-Output -InputObject 'Getting HaGeZi''s Windows/Office Tracker DNS Blocklist ...'
      $SourceHostsContent = (Invoke-RestMethod -Uri $HostsData['Source']) -replace '\r?\n', "`r`n"
  }
  catch
  {
      throw
  }
  
  $WinTrackerHeader ="
  
      ###############################################################################
      # HaGeZi's Windows/Office Tracker - DNS list
      ###############################################################################
      " -replace '(?m)^ +' -replace '\r?\n', "`r`n"
  
  $WinTrackerFooter ="
  
      # HaGeZi's Windows/Office Tracker - End #######################################
      " -replace '(?m)^ +' -replace '\r?\n', "`r`n"
  
  $SourceHostsContent = "$WinTrackerHeader$SourceHostsContent$WinTrackerFooter"
  $CurrentHostsContent = (Get-Content -Raw -Path $HostsData['Destination']) -replace '\r?\n', "`r`n"
  
  if ($CurrentHostsContent.Contains($SourceHostsContent))
  {
      Write-Output -InputObject '"HaGeZi''s Windows/Office Tracker DNS list" is already up to date.'
  }
  else
  {
      Write-Output -InputObject 'Updating hosts file with new "HaGeZi''s Windows/Office Tracker DNS list" content ...'
  
      $Pattern = "(?s)$WinTrackerHeader.*?$WinTrackerFooter\r?\n"
  
      if ($CurrentHostsContent -match $Pattern)
      {
          $CurrentHostsContent = $CurrentHostsContent -replace $Pattern, $SourceHostsContent
          $CurrentHostsContent | Out-File -FilePath $HostsData['Destination']
      }
      else
      {
          $SourceHostsContent | Out-File -Append -FilePath $HostsData['Destination']
      }
  
      Clear-DnsClientCache
  }
  ```
  
  </details>

  <details>
    <summary>Script to create a Scheduled Task for auto-updating the "Windows Tracker DNS Blocklist" (Click to expand)</summary>
  
  ```powershell
  # Replace the below "FilePath" with the path where you saved your script.
  $FilePath = 'C:\Users\<User>\Documents\Set-HostsDnsBlocklistsNativeWinOffice.ps1'
  
  $TaskName = 'HaGeZi''s Windows & Office Tracker DNS Blocklist'
  $TaskPath = '\'
  $TaskActionParam = @{
      Execute  = 'powershell.exe'
      Argument = "-NoProfile -ExecutionPolicy Bypass -File ""$FilePath"""
  }
  $TaskAction = New-ScheduledTaskAction @TaskActionParam
  
  $Trigger = New-ScheduledTaskTrigger -Daily -At '1pm' # dummy value
  # disable "synchronize across time zones"
  $Trigger.StartBoundary = (Get-Date -Hour 13 -Minute 0 -Second 0).ToString('yyyy-MM-ddTHH:mm:ss')
  
  $TaskPrincipal = New-ScheduledTaskPrincipal -UserId 'S-1-5-18' # 'NT AUTHORITY\SYSTEM'
  $TaskSettings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -StartWhenAvailable
  
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
  ```
  
  </details>

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
  Limit the maximum charge to 85% (or 90%) to preserve the battery longevity.  
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
