#=================================================================================================================
#                  Privacy & Security > Search > Show Suggested Search Results > Microsoft Store
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuSearchMSStoreSuggestions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuSearchMSStoreSuggestions
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuSearchMSStoreSuggestions -State 'Disabled'
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
        $StartMenuMSStoreSuggestions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsStoreSuggestionsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        $StartMenuMSStoreSuggestionsMsg = 'Suggested Search Results: Microsoft Store'

        Write-Verbose -Message "Setting 'Windows Permissions - $StartMenuMSStoreSuggestionsMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $StartMenuMSStoreSuggestions
    }
}
