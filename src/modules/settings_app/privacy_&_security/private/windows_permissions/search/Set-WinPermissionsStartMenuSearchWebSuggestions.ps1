#=================================================================================================================
#                   Privacy & Security > Search > Show Suggested Search Results > Web Searches
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuSearchWebSuggestions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuSearchWebSuggestions
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuSearchWebSuggestions -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $StartMenuWebSuggestions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsWebSuggestionsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $StartMenuWebSuggestionsMsg = 'Suggested Search Results: Web Searches'

        Write-Verbose -Message "Setting 'Windows Permissions - $StartMenuWebSuggestionsMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $StartMenuWebSuggestions
    }
}
