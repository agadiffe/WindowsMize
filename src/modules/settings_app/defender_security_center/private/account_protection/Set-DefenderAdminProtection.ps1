#=================================================================================================================
#                              Defender > Account Protection > Administrator Protection
#=================================================================================================================

# Windows 11 24H2+ only.

# Replace the 'User Account Control (UAC)' with a more secure elevation approval.
# You will be prompted to enter your password if you need admin privileges (e.g. regedit, task manager, ...).

<#
.SYNTAX
    Set-DefenderAdminProtection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefenderAdminProtection
{
    <#
    .EXAMPLE
        PS> Set-DefenderAdminProtection -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # gpo\ computer config > windows settings > security settings > local policies > security options
        #   user account control: configure type of admin approval mode
        # legacy admin approval mode: 1 (Default) | admin approval mode with administrator protection: 2
        $AdminProtection = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Entries = @(
                @{
                    Name  = 'TypeOfAdminApprovalMode'
                    Value = $State -eq 'Enabled' ? '2' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Defender - Administrator Protection' to '$State' ..."
        Set-RegistryEntry -InputObject $AdminProtection
    }
}
