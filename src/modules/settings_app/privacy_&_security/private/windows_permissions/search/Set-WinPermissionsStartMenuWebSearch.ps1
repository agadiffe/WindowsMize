#=================================================================================================================
#                           Privacy & Security > Search > Let Search Apps Show Results
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsStartMenuWebSearch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsStartMenuWebSearch
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsStartMenuWebSearch -State 'Disabled'
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
        $WinPermissionsStartMenuWebSearch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\SearchSettings'
            Entries = @(
                @{
                    Name  = 'IsGlobalWebSearchProviderToggleEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Permissions - Search: Let Search Apps Show Results' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsStartMenuWebSearch
    }
}
