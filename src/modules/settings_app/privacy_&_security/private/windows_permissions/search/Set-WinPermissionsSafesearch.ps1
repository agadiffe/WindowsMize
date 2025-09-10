#=================================================================================================================
#                                    Privacy & Security > Search > SafeSearch
#=================================================================================================================

# old

<#
.SYNTAX
    Set-WinPermissionsSafesearch
        [-State] {Disabled | Moderate | Strict}
        [<CommonParameters>]
#>

function Set-WinPermissionsSafesearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsSafeSearch -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [SafeSearchMode] $State
    )

    process
    {
        # moderate: 1 (default) | strict: 2 | off: 0
        $WinPermissionsSafeSearch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'SafeSearchMode'
                    Value = [int]$State
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search: SafeSearch' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsSafeSearch
    }
}
