#=================================================================================================================
#                                         Get Brave Browser Filter Lists
#=================================================================================================================

# helper function used to populate New-BraveBrowserConfigData.ps1
# "$(Get-BraveBrowserFilterLists | ConvertTo-Json -Depth 100)" -replace '(".+": \{\s+)"title": "(.+)",\s+("enabled": false)', '$1$3 // $2'

function Get-BraveBrowserFilterLists
{
    <#
    .DESCRIPTION
        Default list are not included.

    .EXAMPLE
        PS> Get-BraveBrowserFilterLists | ConvertTo-Json -Depth 100
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $BraveFilterListsUrl = 'https://github.com/brave/adblock-resources/raw/master/filter_lists/list_catalog.json'
        $BraveFilterLists = [ordered]@{}
        Invoke-RestMethod -Uri $BraveFilterListsUrl |
            ForEach-Object -Process { $_ | Where-Object -Property 'hidden' -EQ $null } |
            ForEach-Object -Process {
                $BraveFilterLists += @{
                    $_.uuid.ToUpper() = [ordered]@{
                        title = $_.title
                        enabled = $false
                    }
                }
            }
        $BraveFilterLists
    }
}
