#=================================================================================================================
#                                   Personnalization > Start > Recent (Section)
#=================================================================================================================

# not yet available

<#
.SYNTAX
    Set-StartRecentSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartRecentSection
{
    <#
    .EXAMPLE
        PS> Set-StartRecentSection -State 'Enabled'
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
        $RecentSection = @{
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

        Write-Verbose -Message "Setting 'Start - Recent Section' to '$State' ..."
        Set-RegistryEntry -InputObject $RecentSection
    }
}
