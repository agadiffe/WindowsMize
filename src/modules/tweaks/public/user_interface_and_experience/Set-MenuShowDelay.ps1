#=================================================================================================================
#                                                 Menu Show Delay
#=================================================================================================================

# Change the delay to display a submenu item.

<#
.SYNTAX
    Set-MenuShowDelay
        [-Milliseconds] <int>
        [<CommonParameters>]
#>

function Set-MenuShowDelay
{
    <#
    .EXAMPLE
        PS> Set-MenuShowDelay -Milliseconds '200'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(50, 1000)]
        [int] $Milliseconds
    )

    process
    {
        # default: 400 milliseconds
        $MenuShowDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'MenuShowDelay'
                    Value = $Milliseconds
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Menu Show Delay' to '$Milliseconds milliseconds' ..."
        Set-RegistryEntry -InputObject $MenuShowDelay
    }
}
