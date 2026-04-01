#=================================================================================================================
#                       Bluetooth & Devices > Keyboard > Customize Copilot Key On Keyboard
#=================================================================================================================

# Get the list of AppID: PowerShell CmdLet: Get-StartApps

<#
.SYNTAX
    Set-KeyboardCopilotAndWinCKeys
        [-Name] <string>
        [<CommonParameters>]
#>

function Set-KeyboardCopilotAndWinCKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardCopilotAndWinCKeys -Name 'Calculator'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name
    )

    process
    {
        $AppId = switch ($Name)
        {
            'Search'       { 'current_AppId_value' }
            'Calculator'   { 'Microsoft.WindowsCalculator_8wekyb3d8bbwe!App' }
            'Copilot'      { 'Microsoft.Copilot_8wekyb3d8bbwe!App' }
            'M365Copilot'  { 'Microsoft.MicrosoftOfficeHub_8wekyb3d8bbwe!Microsoft.MicrosoftOfficeHub' }
            'Notepad'      { 'Microsoft.WindowsNotepad_8wekyb3d8bbwe!App' }
            'Photos'       { 'Microsoft.Windows.Photos_8wekyb3d8bbwe!App' }
            'SnippingTool' { 'Microsoft.ScreenSketch_8wekyb3d8bbwe!App' }
            'Terminal'     { 'Microsoft.WindowsTerminal_8wekyb3d8bbwe!App' }
            Default        { $Name }
        }

        $IsSearchKey = $Name -eq 'Search'

        # default/ AppAumid: M365Copilot AppId | BrandedKeyChoiceType: App (choices: Search | App)
        # if AppId is uninstalled or invalid, GUI default is: None Selected
        $KeyboardCopilotKey = @(
            @{
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\Shell\BrandedKey'
                Entries = @(
                    @{
                        Name  = 'BrandedKeyChoiceType'
                        Value = $IsSearchKey ? 'Search' : 'App'
                        Type  = 'String'
                    }
                )
            }
            @{
                SkipKey = $IsSearchKey
                Hive    = 'HKEY_CURRENT_USER'
                Path    = 'Software\Microsoft\Windows\Shell\BrandedKey'
                Entries = @(
                    @{
                        Name  = 'AppAumid'
                        Value = $AppId
                        Type  = 'String'
                    }
                )
            }
        )

        Write-Verbose -Message "Setting 'Keyboard - Customize Copilot Key On Keyboard (and Win + C)' to '$Name' ..."
        $KeyboardCopilotKey | Set-RegistryEntry
    }
}
