#=================================================================================================================
#                                   Personnalization > Start > Start Menu Size
#=================================================================================================================

<#
.SYNTAX
    Set-StartMenuSize
        [-Size] {Auto | Small | Large}
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
        # Auto: 0 (default) | Small: 1 | Large: 0
        $StartMenuSize = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Start'
            Entries = @(
                @{
                    Name  = 'StartMenuSize'
                    Value = [int]$Size
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Start - Start Menu Size' to '$Size' ..."
        Set-RegistryEntry -InputObject $StartMenuSize
    }
}
