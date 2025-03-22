#=================================================================================================================
#                                Bluetooth & Devices > Mouse > Mouse Pointer Speed
#=================================================================================================================

<#
.SYNTAX
    Set-MousePointerSpeed
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-MousePointerSpeed
{
    <#
    .EXAMPLE
        PS> Set-MousePointerSpeed -Value 10
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 20)]
        [int] $Value
    )

    process
    {
        # default: 10 (range 1-20)
        $MousePointerSpeed = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'MouseSensitivity'
                    Value = $Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Mouse Pointer Speed' to '$Value' ..."
        Set-RegistryEntry -InputObject $MousePointerSpeed
    }
}
