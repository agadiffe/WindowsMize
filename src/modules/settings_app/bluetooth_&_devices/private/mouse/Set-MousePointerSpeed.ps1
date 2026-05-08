#=================================================================================================================
#                                Bluetooth & Devices > Mouse > Mouse Pointer Speed
#=================================================================================================================

<#
.SYNTAX
    Set-MousePointerSpeed
        [-Speed] <int>
        [<CommonParameters>]
#>

function Set-MousePointerSpeed
{
    <#
    .EXAMPLE
        PS> Set-MousePointerSpeed -Speed 10
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(1, 20)]
        [int] $Speed
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
                    Value = $Speed
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Mouse Pointer Speed' to '$Speed' ..."
        Set-RegistryEntry -InputObject $MousePointerSpeed
    }
}
