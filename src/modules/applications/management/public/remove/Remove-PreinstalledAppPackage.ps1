#=================================================================================================================
#                                         Remove Preinstalled AppPackage
#=================================================================================================================

# Some apps are no longer installed by default.
# e.g. Cortana, Mail & Calendar, Maps, People, Movies & TV

class PreinstalledAppsList : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return $Script:PreinstalledAppsList.Keys
    }
}

<#
.SYNTAX
    Remove-PreinstalledAppPackage
        [-Name] {BingSearch | Calculator | Camera | Clipchamp | Clock | Compatibility | Cortana | CrossDevice |
                 DevHome | EdgeGameAssist | Extensions | Family | FeedbackHub | GetHelp | Journal | MailAndCalendar |
                 Maps | MediaPlayer | Microsoft365 | Microsoft365Companions | MicrosoftCopilot | MicrosoftStore |
                 MicrosoftTeams | MoviesAndTV | News | Notepad | Outlook | Paint | People | PhoneLink | Photos |
                 PowerAutomate | QuickAssist | SnippingTool | Solitaire | SoundRecorder | StickyNotes | Terminal |
                 Tips | Todo | Weather | Whiteboard | Widgets | Xbox | 3DViewer | MixedReality | OneNote | Paint3D |
                 Skype | Wallet}
        [<CommonParameters>]
#>

function Remove-PreinstalledAppPackage
{
    <#
    .EXAMPLE
        PS> $AppsToRemove = @(
                'BingSearch'
                'Camera'
                'Clipchamp'
                'Clock'
            )
        PS> $AppsToRemove | Remove-PreinstalledAppPackage
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidateSet([PreinstalledAppsList])]
        [string] $Name
    )

    process
    {
        $PreinstalledAppsList.$Name | Remove-ApplicationPackage
    }
}
