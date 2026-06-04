#=================================================================================================================
#            Accessibility > Narrator > Verbosity Level > Read Phonetically When Reading By Character
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorReadCharactersPhonetically
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorReadCharactersPhonetically
{
    <#
    .EXAMPLE
        PS> Set-NarratorReadCharactersPhonetically -Mode 'AllControlDetails'
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
        $NarratorReadCharactersPhonetically = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'ReadCharactersPhonetically'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Verbosity Level: Read Phonetically When Reading By Character' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorReadCharactersPhonetically
    }
}
