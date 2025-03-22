#=================================================================================================================
#                                               Password Expiration
#=================================================================================================================

# all apps > windows tools > computer management (compmgmt.msc) > local users and groups (lusrmgr.msc)

<#
.SYNTAX
    Set-PasswordExpiration
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-PasswordExpiration
{
    <#
    .EXAMPLE
        PS> Set-PasswordExpiration -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Password Expiration' to '$State' ..."

        $IsEnabled = $State -eq 'Enabled'

        # Disable for all local users and make default to never expires.
        $Value = $IsEnabled ? '42' : 'UNLIMITED'
        net.exe accounts /maxpwage:$Value | Out-Null

        # Disable for all local users and ensures the setting is visible in the GUI.
        # net.exe doesn't update the GUI checkbox in 'Local Users and Groups'.
        Get-LocalUser | Set-LocalUser -PasswordNeverExpires (-not $IsEnabled)
    }
}
