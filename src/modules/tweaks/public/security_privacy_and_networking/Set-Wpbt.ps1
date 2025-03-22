#=================================================================================================================
#                                      Windows Platform Binary Table (WPBT)
#=================================================================================================================

# The Windows Platform Binary Table (WPBT) allows manufacturers to embed executable code in UEFI firmware,
# enabling software to run at startup and persist across installations.
# This feature raises security concerns due to potential misuse.

<#
.SYNTAX
    Set-Wpbt
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-Wpbt
{
    <#
    .EXAMPLE
        PS> Set-Wpbt -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete (default) | off: 1
        $Wpbt = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\Session Manager'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'DisableWpbtExecution'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Platform Binary Table (WPBT)' to '$State' ..."
        Set-RegistryEntry -InputObject $Wpbt
    }
}
