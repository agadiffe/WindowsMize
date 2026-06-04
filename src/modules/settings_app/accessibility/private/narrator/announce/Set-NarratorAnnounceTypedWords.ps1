#=================================================================================================================
#                      Accessibility > Narrator > Have Narrator Announce When I Type > Words
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedWords
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedWords
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedWords -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $NarratorAnnounceTypedWords = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'EchoWords'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Words' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedWords
    }
}
