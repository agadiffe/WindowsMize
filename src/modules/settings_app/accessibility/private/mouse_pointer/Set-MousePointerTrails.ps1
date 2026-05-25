#=================================================================================================================
#                             Accessibility > Mouse Pointer > Mouse Pointer Trails
#=================================================================================================================

<#
.SYNTAX
    Set-MousePointerTrails
        [-Length] <int>
        [<CommonParameters>]
#>

function Set-MousePointerTrails
{
    <#
    .EXAMPLE
        PS> Set-MousePointerTrails -Length 0
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet(0, 2, 3, 4, 5, 6, 7)]
        [int] $Length
    )

    process
    {
        # on: 2, 3, 4, 5, 6, 7 | off: 0 (default)
        $MousePointerTrails = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'MouseTrails'
                    Value = $Length
                    Type  = 'String'
                }
            )
        }

        $SettingMsg = $Length -eq 0 ? 'Disabled' : "Length level: $Length"
        Write-Verbose -Message "Setting 'Mouse Pointer Trails' to '$SettingMsg' ..."
        Set-RegistryEntry -InputObject $MousePointerTrails
    }
}
