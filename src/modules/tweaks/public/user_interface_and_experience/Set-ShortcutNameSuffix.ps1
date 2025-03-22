#=================================================================================================================
#                                              Shortcut Name Suffix
#=================================================================================================================

<#
.SYNTAX
    Set-ShortcutNameSuffix
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ShortcutNameSuffix
{
    <#
    .EXAMPLE
        PS> Set-ShortcutNameSuffix -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # default: e.g. "MyFile - Shortcut"
        # on: delete (default) | off: 00 00 00 00
        $ShortcutNameSuffix = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'link'
                    Value = '00 00 00 00'
                    Type  = 'Binary'
                }
            )
        }

        Write-Verbose -Message "Setting 'Shortcut Name Suffix' to '$State' ..."
        Set-RegistryEntry -InputObject $ShortcutNameSuffix
    }
}
