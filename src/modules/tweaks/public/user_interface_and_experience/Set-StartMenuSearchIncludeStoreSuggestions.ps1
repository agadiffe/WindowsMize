#=================================================================================================================
#                            Start Menu - Include Store Suggestions In Search Results
#=================================================================================================================

<#
.SYNTAX
    Set-StartMenuSearchIncludeStoreSuggestions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartMenuSearchIncludeStoreSuggestions
{
    <#
    .EXAMPLE
        PS> Set-StartMenuSearchIncludeStoreSuggestions -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
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

            Write-Verbose -Message "Setting 'Store Apps Suggestions In Start Menu Search' to '$State' ..."

            if ($State -eq 'Enabled')
            {
                Set-FileSystemAccessRule @AccessRuleParam -RemoveAll
            }
            else
            {
                Set-FileSystemAccessRule @AccessRuleParam -Permission 'Deny' -Access 'FullControl'
            }
        }
    }
}
