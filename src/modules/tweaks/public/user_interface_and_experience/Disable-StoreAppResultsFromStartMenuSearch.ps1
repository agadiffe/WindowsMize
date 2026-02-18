#=================================================================================================================
#                                Disable Store App Results From Start Menu Search
#=================================================================================================================

<#
.SYNTAX
    Disable-StoreAppResultsFromStartMenuSearch
        [-Reset]
        [<CommonParameters>]
#>

function Disable-StoreAppResultsFromStartMenuSearch
{
    <#
    .EXAMPLE
        PS> Disable-StoreAppResultsFromStartMenuSearch

    .EXAMPLE
        PS> Disable-StoreAppResultsFromStartMenuSearch -Reset
    #>

    [CmdletBinding()]
    param
    (
        [switch] $Reset
    )

    process
    {
        $EnvLocalAppData = (Get-LoggedOnUserEnvVariable).LOCALAPPDATA
        $StoreAppsDatabase = "$EnvLocalAppData\Packages\Microsoft.WindowsStore_8wekyb3d8bbwe\LocalState\store.db"

        # This file doesn't exist in EEA (No Store apps suggestions).
        if (Test-Path -Path $StoreAppsDatabase)
        {
            $AccessRuleParam = @{
                Path = $StoreAppsDatabase
                Sid  = 'S-1-1-0' # 'EVERYONE' group
            }

            $StoreAppsSuggestionsMsg = 'Store Apps Suggestions In Start Menu Search'
            if ($Reset)
            {
                Write-Verbose -Message 'Resetting '$StoreAppsSuggestionsMsg' ...'
                Set-FileSystemAccessRule @AccessRuleParam -RemoveAll
            }
            else
            {
                Write-Verbose -Message 'Disabling '$StoreAppsSuggestionsMsg' ...'
                Set-FileSystemAccessRule @AccessRuleParam -Permission 'Deny' -Access 'FullControl'
            }
        }
    }
}
