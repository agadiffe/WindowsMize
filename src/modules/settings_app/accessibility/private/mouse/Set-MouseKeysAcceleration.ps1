#=================================================================================================================
#                                 Accessibility > Mouse > Mouse Keys Acceleration
#=================================================================================================================

<#
.SYNTAX
    Set-MouseKeysAcceleration
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-MouseKeysAcceleration
{
    <#
    .EXAMPLE
        PS> Set-MouseKeysAcceleration -Speed 50
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Speed
    )

    process
    {
        # GUI slider range is 1 to 100, but have 2 times the 51 value ...

        # default: 3000 (range: 1000-5000)
        $MouseKeysAcceleration = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\MouseKeys'
            Entries = @(
                @{
                    Name  = 'TimeToMaximumSpeed'
                    Value = 5000 - $Speed * 40
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse Keys Acceleration' to '$Speed' ..."
        Set-RegistryEntry -InputObject $MouseKeysAcceleration
    }
}
