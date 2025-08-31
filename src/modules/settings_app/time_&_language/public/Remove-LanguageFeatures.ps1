#=================================================================================================================
#        Time & Language > Language & Region > Preferred Languages > 3 Dots On Language > Language Options
#=================================================================================================================

# Doesn't work for Windows 10 (features will be automatically reinstalled).

# Basic typing, Handwriting, OCR, Text-To-Speech, Speech recognition

<#
.SYNTAX
    Remove-LanguageFeatures [<CommonParameters>]
#>

function Remove-LanguageFeatures
{
    [CmdletBinding()]
    param ()

    process
    {
        $AllWinPackages = Get-WindowsPackage -Online -Verbose:$false

        # Basic Typing must be removed in last.
        $LanguageFeatures = 'Handwriting', 'OCR', 'Speech', 'TextToSpeech', 'Basic'

        foreach ($Feature in $LanguageFeatures)
        {
            # e.g. Microsoft-Windows-LanguageFeatures-Basic-en-us-Package~31bf3856ad364e35~amd64~~10.0.22621.3007
            $WinPackage = $AllWinPackages |
                Where-Object -FilterScript {
                    $_.PackageName -like "*LanguageFeatures-$Feature*" -and
                    $_.PackageState -eq 'Installed'
                }

            if ($WinPackage)
            {
                $WindowsPackageOptions = @{
                    NoRestart     = $true
                    Verbose       = $false
                    WarningAction = 'SilentlyContinue'
                }

                Write-Verbose -Message "Removing LanguageFeatures-$Feature ..."
                $WinPackage | Remove-WindowsPackage -Online @WindowsPackageOptions | Out-Null
            }
            else
            {
                Write-Verbose -Message "LanguageFeatures-$Feature is not installed"
            }
        }
    }
}
