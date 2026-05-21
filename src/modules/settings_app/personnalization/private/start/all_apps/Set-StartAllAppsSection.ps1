#=================================================================================================================
#                                  Personnalization > Start > All (Apps Section)
#=================================================================================================================

# not yet available

<#
.SYNTAX
    Set-StartAllAppsSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartAllAppsSection
{
    <#
    .EXAMPLE
        PS> Set-StartAllAppsSection -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        return

        # on: 1 (default) | off: 0
        $AllAppsSection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = '???'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - All Apps Section' to '$State' ..."
        Set-RegistryEntry -InputObject $AllAppsSection
    }
}
