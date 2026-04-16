#=================================================================================================================
#                           Gaming > Game Bar > Allow Your Controller To Open Game Bar
#=================================================================================================================

<#
.SYNTAX
    Set-GameBarOpenWithController
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-GameBarOpenWithController
{
    <#
    .EXAMPLE
        PS> Set-GameBarOpenWithController -State 'Disabled'
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
        $GameBarOpenWithController = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\GameBar'
            Entries = @(
                @{
                    Name  = 'UseNexusForGameBarEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Game Bar - Allow Your Controller To Open Game Bar' to '$State' ..."
        Set-RegistryEntry -InputObject $GameBarOpenWithController
    }
}
