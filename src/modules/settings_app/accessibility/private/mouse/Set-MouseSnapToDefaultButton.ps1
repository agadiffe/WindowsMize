#=================================================================================================================
#                                 Accessibility > Mouse > Snap To Default Button
#=================================================================================================================

<#
.SYNTAX
    Set-MouseSnapToDefaultButton
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-MouseSnapToDefaultButton
{
    <#
    .EXAMPLE
        PS> Set-MouseSnapToDefaultButton -State 'Disabled'
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
        $SnapToDefaultButton = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'SnapToDefaultButton'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Snap To Default Button' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapToDefaultButton
    }
}
