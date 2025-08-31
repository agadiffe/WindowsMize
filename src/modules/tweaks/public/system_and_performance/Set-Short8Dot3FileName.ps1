#=================================================================================================================
#                                              Short 8.3 File Names
#=================================================================================================================

# Short 8.3 file names are a DOS-era legacy, limiting names to 8 characters and extensions to 3.

# Disabling Short 8.3 file names:
#   Windows stops creating short 8.3 file names for new files and folders.
#   It can potentially improve performance, especially in directories with a large number of files.
#   It may enhance security by reducing the risk of certain types of attacks that exploit short file names.

<#
  The command "fsutil.exe 8Dot3Name strip/ f /s C:" will display a scary Warning. That's not as bad as stated.

  This command lists, but does not modify the registry keys that point to the files that had 8dot3 file names.

  You might need to edit some affected registry entries.
  On a fresh installation (or even on an existing one), you shouldn't have any.
  Short 8.3 file names are used by very old/legacy programs.

  Open the generated log file to find them:
    At the top, you have a table of affected registry keys.
    The tool reports all keys with a tilde (~) character, but that doesn't mean they are 8.3 file names.

  8.3 file names format: 6 first characters, then a tilde (~), then a single digit (1-9).
  Example: 'PROGRA~1' and 'COMMON~1'.

  Example of an affected registry key:
  hive  : HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{CA8A9780-280D-11CF-A24D-444553540000}\ToolboxBitmap32
  key   : (Default)
  value : C:\PROGRA~1\COMMON~1\Adobe\Acrobat\ActiveX\AcroPDF.dll, 102

  Open the regedit and replace the value data with the full path name:
  i.e. "C:\Program Files\Common Files\Adobe\Acrobat\ActiveX\AcroPDF.dll"

  'PROGRA~1', 'COMMON~1', and others, will not be stripped because they are in used (access denied).
  To remove them:
    - Settings > System > Recovery > Advanced Startup: click on "Restart now".
    - On the recovery Menu, choose: Troubleshoot > Commmand Prompt.
    - On the Commmand Prompt, run: fsutil.exe 8Dot3Name strip /f /s /l C:\8dot3.log C:
      /l C:\8dot3.log: save the log file into your C: drive instead of the recovery partition.

  If your are not sure about your system drive letter (C:), you can confirm it with Diskpart:
    - Run: Diskpart.exe
    - DISKPART> list volume # confirm your system drive letter.
    - DISKPART> exit # exit Diskpart and return to Commmand Prompt.
#>

<#
.SYNTAX
    Set-Short8Dot3FileName
        [-State] {Disabled | Enabled | PerVolumeBasis | DisabledExceptSystemVolume}
        [-RemoveExisting8dot3FileNames]
        [<CommonParameters>]
#>

function Set-Short8Dot3FileName
{
    <#
    .EXAMPLE
        PS> Set-Short8Dot3FileName -State 'Disabled' -RemoveExisting8dot3FileNames
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Disabled', 'Enabled', 'PerVolumeBasis', 'DisabledExceptSystemVolume')]
        [string] $State,

        [switch] $RemoveExisting8dot3FileNames
    )

    process
    {
        Write-Verbose -Message "Setting 'Short 8.3 File Names' to '$State' ..."

        # 0 - Enable 8dot3 name creation on all volumes on the system
        # 1 - Disable 8dot3 name creation on all volumes on the system
        # 2 - Set 8dot3 name creation on a per volume basis (default)
        # 3 - Disable 8dot3 name creation on all volumes except the system volume
        $8Dot3NameBehavior = switch ($State)
        {
            'Enabled'                    { '0' }
            'Disabled'                   { '1' }
            'PerVolumeBasis'             { '2' }
            'DisabledExceptSystemVolume' { '3' }
        }
        fsutil.exe 8Dot3Name set $8Dot3NameBehavior | Out-Null

        if ($RemoveExisting8dot3FileNames)
        {
            # It can take a moment on HDD (few minutes). It's really fast on SSD (few seconds).
            Write-Verbose -Message ("   The following Warning is not as bad as stated.`n" +
                "            Open the generated log file and replace any mention of 8dot3 names in the registry.`n" +
                "            Read the comments in 'src > modules > tweaks > public > system_and_performance > Set-Short8Dot3FileName.ps1'.`n")

            $LogFolderPath = "$PSScriptRoot\..\..\..\..\..\log"
            $LogFileName = "8dot3_removal_@($(Get-Date -Format 'yyyy-MM-ddTHH:mm:ssK')).log"

            $LogFolderPath = Resolve-Path -Path $LogFolderPath
            $LogFilePath = "$LogFolderPath\$LogFileName"
            New-ParentPath -Path $LogFilePath

            fsutil.exe 8Dot3Name strip /f /s /l $LogFilePath $env:SystemDrive
        }
    }
}
