#=================================================================================================================
#                                               Set UWP App Setting
#=================================================================================================================

# Functions to customize UWP app settings.
# e.g. microsoft store, notepad, photos, snipping tool

class UwpRegistryKeyEntry
{
    [string] $Path
    [string] $Name
    [string] $Value
    [string] $Type
}

<#
.SYNTAX
    Set-UwpAppSetting
        [-Name] {MicrosoftStore | WindowsNotepad | WindowsPhotos | WindowsSnippingTool | AppActions | TaskbarCalendar}
        [-Setting] <UwpRegistryKeyEntry[]>
        [<CommonParameters>]
#>

function Set-UwpAppSetting
{
    <#
    .EXAMPLE
        PS> Set-UwpAppSetting -Name 'MicrosoftStore' -Setting $MicrosoftStoreSettings
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('MicrosoftStore', 'WindowsNotepad', 'WindowsPhotos', 'WindowsSnippingTool', 'AppActions', 'TaskbarCalendar')]
        [string] $Name,

        [Parameter(Mandatory)]
        [UwpRegistryKeyEntry[]] $Setting
    )

    process
    {
        $AppxPathName, $ProcessName = switch ($Name)
        {
            'MicrosoftStore'      { 'Microsoft.WindowsStore_8wekyb3d8bbwe',   'WinStore.App' }
            'WindowsNotepad'      { 'Microsoft.WindowsNotepad_8wekyb3d8bbwe', 'Notepad' }
            'WindowsPhotos'       { 'Microsoft.Windows.Photos_8wekyb3d8bbwe', 'Photos' }
            'WindowsSnippingTool' { 'Microsoft.ScreenSketch_8wekyb3d8bbwe',   'SnippingTool' }

            'TaskbarCalendar' { 'Microsoft.Windows.ShellExperienceHost_cw5n1h2txyewy', 'ShellExperienceHost' }
            'AppActions'
            {
                'MicrosoftWindows.Client.CBS_cw5n1h2txyewy',
                @('AppActions', 'SearchHost', 'FESearchHost', 'msedgewebview2', 'TextInputHost', 'VisualAssistExe', 'WebExperienceHostApp')
            }
        }

        $AppxPath = "$((Get-LoggedOnUserEnvVariable).LOCALAPPDATA)\Packages\$AppxPathName"
        $AppxSettingsFilePath = "$AppxPath\Settings\settings.dat"

        if (Test-Path -Path $AppxSettingsFilePath)
        {
            # The app could be open or running in background.
            Stop-Process -Name $ProcessName -Force -ErrorAction 'SilentlyContinue'

            # Settings.dat file is not instantly unlocked after process termination.
            $MaxRetries = 20
            $RetryCount = 0
            while ((Test-FileLock -FilePath $AppxSettingsFilePath) -and $RetryCount -lt $MaxRetries)
            {
                Start-Sleep -Seconds 0.1
                $RetryCount++
            }

            if ($RetryCount -eq $MaxRetries)
            {
                Write-Error -Message "$Name settings.dat file is still locked after the maximum retries."
            }
            else
            {
                Write-Verbose -Message "Setting $Name settings ..."
                $Setting | Set-UwpAppRegistryEntry -FilePath $AppxSettingsFilePath

                if ($Name -eq 'AppActions')
                {
                    # Ensure SearchHost will respawn properly once the settings.dat file has been unlocked.
                    # It seems that sometimes the process is stuck in an unstable state.
                    Stop-Process -Name $ProcessName -Force -ErrorAction 'SilentlyContinue'
                }
            }
        }
        else
        {
            Write-Verbose -Message "$Name is not installed (settings.dat not found)"
        }
    }
}


<#
.SYNTAX
    Set-UwpAppRegistryEntry
        [-InputObject] <RegistryKeyEntry>
        [-FilePath] <string>
        [<CommonParameters>]
#>

function Set-UwpAppRegistryEntry
{
    <#
    .EXAMPLE
        PS> $FilePath = "C:\Users\<User>\AppData\Local\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\Settings\settings.dat"
        PS> $PhotosTheme = '[
              {
                "Name"  : "AppBackgroundRequestedTheme",
                "Value" : "2",
                "Type"  : "5f5e104"
              }
            ]' | ConvertFrom-Json
        PS> $PhotosTheme | Set-UwpAppRegistryEntry -FilePath $FilePath
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [UwpRegistryKeyEntry] $InputObject,

        [Parameter(Mandatory)]
        [string] $FilePath
    )

    begin
    {
        $AppSettingsRegPath = 'HKEY_USERS\UWP_APP_SETTINGS_4242'
        $RegContent = "Windows Registry Editor Version 5.00`n"

        # load Settings.dat asap to prevent file lock by other processes.
        reg.exe UNLOAD $AppSettingsRegPath 2>&1 | Out-Null
        reg.exe LOAD $AppSettingsRegPath $FilePath | Out-Null
    }

    process
    {
        $Value = $InputObject.Value
        $Value = switch ($InputObject.Type)
        {
            '5f5e10b' { ([int]$Value | Format-Hex -Count 1).HexBytes }
            '5f5e10c' { [string]($Value | Format-Hex -Encoding 'unicode').HexBytes + ' 00 00' }
            '5f5e104' { ([int]$Value | Format-Hex).HexBytes }
            '5f5e105' { ([uint]$Value | Format-Hex).HexBytes }
            '5f5e106' { ([int64]$Value | Format-Hex).HexBytes }
        }

        $Value = $Value -replace '\s+', ','
        $Timestamp = ((Get-Date).ToFileTime() | Format-Hex).HexBytes.Replace(' ', ',')
        $RegKey = $InputObject.Path ? $InputObject.Path : 'LocalState'

        $RegContent += "`n[$AppSettingsRegPath\$RegKey]
            ""$($InputObject.Name)""=hex($($InputObject.Type)):$Value,$Timestamp`n" -replace '(?m)^ *'
    }

    end
    {
        $SettingRegFilePath = "$([System.IO.Path]::GetTempPath())\uwp_app_settings.reg"

        Write-Verbose -Message $RegContent
        $RegContent | Out-File -FilePath $SettingRegFilePath

        # 'reg.exe import' writes its output on success to stderr ...
        reg.exe IMPORT $SettingRegFilePath 2>&1 | Out-Null
        reg.exe UNLOAD $AppSettingsRegPath | Out-Null

        Remove-Item -Path $SettingRegFilePath
    }
}


<#
  Pattern to match the key=value in registry file (.reg): '(?m)^(.*)=((?:.*)(?:(?<=\\)\s*.*)*)$'.
  Will not be used because the registry entry doesn't exist if the setting hasn't been toggled at least once.

  Settings are stored in a file encoded as binary data.
  e.g. "C:\Users\<User>\AppData\Local\Packages\Microsoft.Windows.Photos_8wekyb3d8bbwe\Settings\settings.dat"

  This file is a registry Hive and can be loaded in regedit. The settings have non-standard type.
  The first bytes are the setting (the number of bytes depends of the type and data).
  The last 8 bytes are a timestamp (they can all be zeroed, the setting will still be applied).

  Most of the types use little-endian (left-aligned) for the value.

  Common types:
  0x5f5e10b: bool (1 byte) | e.g. "WordWrap"=hex(5f5e10b):01,4b,da,0a,0a,a8,23,db,01

  0x5f5e10c: string (N bytes) | e.g. "GeolocationConsent"=hex(5f5e10c):66,00,61,00,6c,00,73,00,65,00,00,00,ef,b8,44,70,aa,23,db,01
  The string is encoded as unicode and must be null terminated.
  'false' : 66,00,61,00,6c,00,73,00,65,00,00,00
  'true'  : 74,00,72,00,75,00,65,00,00,00

  0x5f5e104: int32 (4 bytes) | e.g. "FontSize"=hex(5f5e104):0b,00,00,00,a3,1a,40,6f,84,36,da,01
  0x5f5e104, 0x5f5e105: int32, uint32 (4 bytes)
  0x5f5e106, 0x5f5e107: int64, uint64 (8 bytes)


  More types: (non-exhaustive list)
  0x5f5e10d: specific format (N bytes)
      e.g. "Settings_ShapeOutlineColor"=hex(5f5e10d):
              19,00,00,00, | struct size (number of bytes: including these ones, without padding) | decimal: 25
              01,00,00,00, | value type (e.g. 01 == byte, 04 == int32, 0C == string)
              05,00,00,00, | string lenght (number of characters) | 'alpha' == 5
              61,00,6c,00,70,00,68,00,61,00,00,00, | the null terminated string in unicode
              ff,00,00,00,00,00,00,00, | value (here: 1 byte) + padding (7 bytes) (25 + 7 == 32)

              15,00,00,00, | decimal: 21
              01,00,00,00,
              03,00,00,00, | 'red' == 3
              72,00,65,00,64,00,00,00,
              e6,00,00,00, | value + padding (21 + 3 == 24)

              19,00,00,00, | decimal: 25
              01,00,00,00,
              05,00,00,00, | 'green' == 5
              67,00,72,00,65,00,65,00,6e,00,00,00,
              1b,00,00,00,00,00,00,00, | value + padding (25 + 7 == 32)

              17,00,00,00, | decimal: 23
              01,00,00,00,
              04,00,00,00, | 'blue' == 4
              62,00,6c,00,75,00,65,00,00,00,
              1b,00, | value + padding (23 + 1 == 24)

              ba,f7,3b,fd,89,24,db,01 | timestamp

      The padding aligns the structure to an 8-byte boundary.

      For this entry, modifying the first byte of RGB works and change the color of the border in Snipping Tool settings.
      This registry type (0x5f5e10d) can be used to store any data, not only color (following the same above pattern).
        e.g. "LaunchScreenPosition"=hex(5f5e10d):left..top..right..bottom..monitorLeft..monitorTop..monitorRight..monitorBottom

  0x5f5e109: double-precision floating-point (8 bytes) | big-endian (right-aligned)
      e.g. "Width"=hex(5f5e109):00,00,00,00,00,94,93,40,1a,1f,ad,ab,3e,26,db,01
      $Number = 2.0553e-320
      $Bytes = [System.BitConverter]::GetBytes($Number)
      [array]::Reverse($Bytes)
      $Bytes | Format-Hex

  0x5f5e110: specific format (16 bytes)
      e.g. "LastSentSessionId"=hex(5f5e110):xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,xx,3c,b3,8d,a7,cd,26,db,01
      Used to store GUID or UUID

  0x5f5e113: specific format (16 bytes)
      e.g. "Settings_Last_Window_Size_Position"=hex(5f5e113):00,00,ef,43,00,00,1a,43,00,c0,70,44,00,80,34,44,fe,26,ab,c6,79,d8,da,01
      Series of smaller values : 4 double (4 * 4 bytes) (i.e. 4 single-precision floating-point numbers)
      Each series use big-endian (right-aligned)
#>
