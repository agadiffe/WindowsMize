#=================================================================================================================
#                              Defender > App & Browser Control > Smart App Control
#=================================================================================================================

# If Smart App Control is off it can't be turned on without reinstalling or resetting Windows.

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

        $SACRegPath = "Registry::$($DefenderSmartAppControl.Hive)\$($DefenderSmartAppControl.Path)"
        $SACCurrentStatus = Get-ItemPropertyValue -Path $SACRegPath -Name $DefenderSmartAppControl.Entries[0].Name

        Write-Verbose -Message "Setting 'Defender - Smart App Control' to '$State' ..."

        if ($SACCurrentStatus -eq 0)
        {
            Write-Verbose -Message "  Smart App Control is off: it can't be turned on without reinstalling or resetting Windows."
        }
        else
        {
            Set-RegistryEntry -InputObject $DefenderSmartAppControl
        }
    }
}
