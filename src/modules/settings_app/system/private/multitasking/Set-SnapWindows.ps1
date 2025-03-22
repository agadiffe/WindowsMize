#=================================================================================================================
#                                      System > Multitasking > Snap Windows
#=================================================================================================================

<#
.SYNTAX
    Set-SnapWindows
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SnapWindows
{
    <#
    .EXAMPLE
        PS> Set-SnapWindows -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $SnapWindows = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'WindowArrangementActive'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Snap Windows' to '$State' ..."
        Set-RegistryEntry -InputObject $SnapWindows
    }
}
