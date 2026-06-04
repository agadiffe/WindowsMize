#=================================================================================================================
#                       Accessibility > Narrator > Narrator > Start Narrator Before Sign-In
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorStartBeforeSignin
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorStartBeforeSignin
{
    <#
    .EXAMPLE
        PS> Set-NarratorStartBeforeSignin -State 'Disabled'
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
        $NarratorStartBeforeSignin = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows NT\CurrentVersion\Accessibility'
            Entries = @(
                @{
                    Name  = 'Configuration'
                    Value = $State -eq 'Enabled' ? 'narrator' : ''
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Start Narrator Before Sign In' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorStartBeforeSignin
    }
}
