#=================================================================================================================
#                               Personnalization > Start > Show All Pins By Default
#=================================================================================================================

<#
.SYNTAX
    Set-StartShowAllPins
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-StartShowAllPins
{
    <#
    .EXAMPLE
        PS> Set-StartShowAllPins -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $ShowAllPins = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'ShowAllPinsList'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Show All Pins By Default' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowAllPins
    }
}
