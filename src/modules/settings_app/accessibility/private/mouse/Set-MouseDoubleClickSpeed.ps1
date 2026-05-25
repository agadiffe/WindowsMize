#=================================================================================================================
#                                   Accessibility > Mouse > Double Click Speed
#=================================================================================================================

<#
.SYNTAX
    Set-MouseDoubleClickSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-MouseDoubleClickSpeed
{
    <#
    .EXAMPLE
        PS> Set-MouseDoubleClickSpeed -Speed 5
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 11)]
        [int] $Speed
    )

    process
    {
        # default: 480 (range: 200-900)
        $MouseDoubleClickSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'DoubleClickSpeed'
                    Value = 130 + $Speed * 70
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Double Click Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $MouseDoubleClickSpeed
    }
}
