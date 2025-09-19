#=================================================================================================================
#        Time & Language > Language & Region > Preferred Languages > 3 Dots On Language > Language Options
#=================================================================================================================

# Doesn't work for Windows 10 (features will be automatically reinstalled).

<#
.SYNTAX
    Set-LanguageFeatures
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-LanguageFeatures
{
    <#
    .DESCRIPTION
        Install or remove: Basic typing, Handwriting, OCR, Speech recognition, Text-To-Speech.

    .EXAMPLE
        PS> Set-LanguageFeatures -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $InstalledLanguageId = (Get-InstalledLanguage).LanguageId
        $BaseFeatures = [System.Collections.ArrayList]@(
            'Language.Basic'
            'Language.Handwriting'
            'Language.OCR'
            'Language.Speech'
            'Language.TextToSpeech'
        )

        $LanguageFeatures = [System.Collections.ArrayList]::new()
        foreach ($Lang in $InstalledLanguageId)
        {
            foreach ($Feature in $BaseFeatures)
            {
                $LanguageFeatures.Add("$Feature~~~$Lang*") | Out-Null
            }
        }

        # Basic Typing must be removed in last.
        if ($State -eq 'Disabled')
        {
            $LanguageFeatures.Reverse()
        }

        $LanguageFeatures | Set-WindowsCapability -State $State
    }
}
