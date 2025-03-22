#=================================================================================================================
#               Accounts > Sign-In Options > Sign In With An External Camera Or Fingerprint Reader
#=================================================================================================================

# Enhanced Sign-in Security (ESS).
# Requires compatible hardware and software components.

<#
.SYNTAX
    Set-SigninWithExternalDevice
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-SigninWithExternalDevice
{
    <#
    .DESCRIPTION
        Enabled: disable Enhanced Sign-in Security (ESS)
        Disabled: enable Enhanced Sign-in Security (ESS)

    .EXAMPLE
        PS> Set-SigninWithExternalDevice -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 | off: 1 (default)
        $EnhancedSigninSecurity = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\WinBio'
            Entries = @(
                @{
                    Name  = 'SupportPeripheralsWithEnhancedSignInSecurity'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Sign-In Options - Sign In With An External Camera Or Fingerprint Reader' to '$State' ..."
        Set-RegistryEntry -InputObject $EnhancedSigninSecurity
    }
}
