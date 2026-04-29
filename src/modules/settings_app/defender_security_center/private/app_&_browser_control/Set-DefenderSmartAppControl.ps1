#=================================================================================================================
#                              Defender > App & Browser Control > Smart App Control
#=================================================================================================================

<#
.SYNTAX
    Set-DefenderSmartAppControl
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderSmartAppControl
{
    <#
    .EXAMPLE
        PS> Set-DefenderSmartAppControl -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 | evaluation: 2 (default)
        $DefenderSmartAppControl = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\CI\Policy'
            Entries = @(
                @{
                    Name  = 'VerifiedAndReputablePolicyState'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender - Smart App Control' to '$State' ..."
        Set-RegistryEntry -InputObject $DefenderSmartAppControl
    }
}
