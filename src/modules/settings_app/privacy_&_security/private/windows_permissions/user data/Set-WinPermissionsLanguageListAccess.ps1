#=================================================================================================================
#   Privacy & Security > General > Let Websites Show Me Locally Relevant Content By Accessing My Language List
#=================================================================================================================

<#
.SYNTAX
    Set-WinPermissionsLanguageListAccess
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinPermissionsLanguageListAccess
{
    <#
    .EXAMPLE
        PS> Set-WinPermissionsLanguageListAccess -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $WinPermissionsLanguageListAccess = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\International\User Profile'
            Entries = @(
                @{
                    Name  = 'HttpAcceptLanguageOptOut'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        $WinPermissionsLanguageListAccessMsg = 'Let Websites Show Me Locally Relevant Content By Accessing My Language List'

        Write-Verbose -Message "Setting 'Windows Permissions - $WinPermissionsLanguageListAccessMsg' to '$State' ..."
        Set-RegistryEntry -InputObject $WinPermissionsLanguageListAccess
    }
}
