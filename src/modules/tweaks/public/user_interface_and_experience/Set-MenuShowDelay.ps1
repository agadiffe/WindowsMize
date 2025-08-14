#=================================================================================================================
#                                                 Menu Show Delay
#=================================================================================================================

# Change the delay to display a submenu item.

<#
.SYNTAX
    Set-MenuShowDelay
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-MenuShowDelay
{
    <#
    .EXAMPLE
        PS> Set-MenuShowDelay -Value '200'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(50, 1000)]
        [int] $Value
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
                    Value = $Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Menu Show Delay' to '$Value milliseconds' ..."
        Set-RegistryEntry -InputObject $MenuShowDelay
    }
}
