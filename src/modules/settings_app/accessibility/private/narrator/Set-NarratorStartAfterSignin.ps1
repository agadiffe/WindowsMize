#=================================================================================================================
#                       Accessibility > Narrator > Narrator > Start Narrator After Sign-In
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorStartAfterSignin
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorStartAfterSignin
{
    <#
    .EXAMPLE
        PS> Set-NarratorStartAfterSignin -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: narrator | off: empty value (default)
        $NarratorStartAfterSignin = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Accessibility'
            Entries = @(
                @{
                    Name  = 'Configuration'
                    Value = $State -eq 'Enabled' ? 'narrator' : ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Start Narrator After Sign In' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorStartAfterSignin
    }
}
