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

        $SACRegPath = "Registry::$($DefenderSmartAppControl.Hive)\$($DefenderSmartAppControl.Path)"
        $SACCurrentStatus = (Get-ItemProperty -Path $SACRegPath).$($DefenderSmartAppControl.Entries[0].Name)

        Write-Verbose -Message "Setting 'Defender - Smart App Control' to '$State' ..."

        if ($null -eq $SACCurrentStatus)
        {
            Write-Verbose -Message "  Smart App Control not available on this computer (or registry entry is missing)."
        }
        elseif ($SACCurrentStatus -eq 0)
        {
            Write-Verbose -Message "  Smart App Control is off: it can't be turned on without reinstalling or resetting Windows."
        }
        else
        {
            Set-RegistryEntry -InputObject $DefenderSmartAppControl
        }
    }
}
