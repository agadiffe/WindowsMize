#=================================================================================================================
#                                              Short 8.3 File Names
#=================================================================================================================

# Short 8.3 file names are a DOS-era legacy, limiting names to 8 characters and extensions to 3.

# Disabling Short 8.3 file names:
#   Windows stops creating short 8.3 file names for new files and folders.
#   It can potentially improve performance, especially in directories with a large number of files.
#   It may enhance security by reducing the risk of certain types of attacks that exploit short file names.

<#
  The command "fsutil.exe 8Dot3Name strip" will display a scary Warning. That's not as bad as stated.

  You should replace any mention of 8.3 Name in the registry (open the generated log file to find them).

  Checking the log file:
  In the first part of the log (between the start and before 'Total affected registry keys:').
  In the column 'Registry Data', if you have a 8.3 Name, open the registry and replace the value with the full path.

  There shouldn't have many, if at all, registry keys affected. On my fresh install testing VM, I had none.
  This script run this command before installing any programs, so in theory, there shouldn't have any 8.3 file names.
  If your UserName is longer than 8 characters, you may need to adjust some affected registry keys.

  The tool report all keys with a tilde(~) character, but that doesn't mean it's a 8.3 Name.
  This was the only one on my system ... despite the tool reported 200+ affected registry keys.
  hive  : HKLM\SOFTWARE\WOW6432Node\Classes\CLSID\{CA8A9780-280D-11CF-A24D-444553540000}\ToolboxBitmap32
  key   : (Default)
  value : C:\PROGRA~1\COMMON~1\Adobe\Acrobat\ActiveX\AcroPDF.dll, 102

  The 8.3 File Names are 'PROGRA~1' and 'COMMON~1'.
  Replace the value with the full path name in the registry.
  i.e. "C:\Program Files\Common Files\Adobe\Acrobat\ActiveX\AcroPDF.dll"
#>

<#
.SYNTAX
    Set-Short8Dot3FileName
        [-State] {Disabled | Enabled}
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
        [state] $State,

        [switch] $RemoveExisting8dot3FileNames
    )

    process
    {
        Write-Verbose -Message "Setting 'Short 8.3 File Names' to '$State' ..."

        # on: 0 (default) | off: 1
        fsutil.exe behavior set Disable8dot3 ($State -eq 'Enabled' ? '0' : '1') | Out-Null

        if ($RemoveExisting8dot3FileNames)
        {
            # It can take a moment on HDD (few minutes). It's really fast on SSD (few seconds).
            Write-Verbose -Message ("   The following Warning is not as bad as stated.`n" +
                "            Open the generated log file and replace any mention of 8dot3 Name in the registry.`n" +
                "            Read the comments in 'src > modules > tweaks > public > system_and_performance > Set-Short8Dot3FileName.ps1'.`n")

            $LogFolderPath = "$PSScriptRoot\..\..\..\..\..\log"
            $LogFileName = '8dot3_removal.log'

            if (Test-Path -Path "$LogFolderPath\$LogFileName")
            {
                # use default log file path: %temp%\8dot3_removal_log@(GMT YYYY-MM-DD HH-MM-SS).log
                fsutil.exe 8Dot3Name strip /f /s $env:SystemDrive
            }
            else
            {
                New-Item -Path $LogFolderPath -ItemType 'Directory' -Force -ErrorAction 'SilentlyContinue' | Out-Null
                $LogFolderPath = Resolve-Path $LogFolderPath
                fsutil.exe 8Dot3Name strip /f /s /l "$LogFolderPath\$LogFileName" $env:SystemDrive
            }

        }
    }
}
