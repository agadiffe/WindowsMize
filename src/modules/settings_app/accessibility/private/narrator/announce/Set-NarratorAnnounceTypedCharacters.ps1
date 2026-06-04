#=================================================================================================================
#        Accessibility > Narrator > Have Narrator Announce When I Type > Letters, Numbers, And Punctuation
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedCharacters
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedCharacters
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedCharacters -State 'Enabled'
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
        $NarratorAnnounceTypedCharacters = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'EchoChars'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Letters, Numbers, And Punctuation' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedCharacters
    }
}
