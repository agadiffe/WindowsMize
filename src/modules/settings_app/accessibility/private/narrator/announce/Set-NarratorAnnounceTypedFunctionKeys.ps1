#=================================================================================================================
#                  Accessibility > Narrator > Have Narrator Announce When I Type > Function Keys
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedFunctionKeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedFunctionKeys
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedFunctionKeys -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $NarratorAnnounceTypedFunctionKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'EchoFunctionKeys'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Function Keys' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedFunctionKeys
    }
}
