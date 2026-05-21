#=================================================================================================================
#                                   Personnalization > Start > Start Menu Size
#=================================================================================================================

# not yet available

<#
.SYNTAX
    Set-StartMenuSize
        [-Size] {Small | Large}
        [<CommonParameters>]
#>

function Set-StartMenuSize
{
    <#
    .EXAMPLE
        PS> Set-StartMenuSize -Size 'Small'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [StartMenuSize] $Size
    )

    process
    {
        return

        # Small: 0 | Large: 1 | default: depends on resolution and screen size
        $StartMenuSize = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = '???'
                    Value = [int]$Size
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Start Menu Size' to '$Size' ..."
        Set-RegistryEntry -InputObject $StartMenuSize
    }
}
