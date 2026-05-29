#=================================================================================================================
#                                   Personnalization > Start > Pinned (Section)
#=================================================================================================================

<#
.SYNTAX
    Set-StartPinnedSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartPinnedSection
{
    <#
    .EXAMPLE
        PS> Set-StartPinnedSection -State 'Enabled'
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
        $PinnedSection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'ShowPinnedSection'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Pinned Section' to '$State' ..."
        Set-RegistryEntry -InputObject $PinnedSection
    }
}
