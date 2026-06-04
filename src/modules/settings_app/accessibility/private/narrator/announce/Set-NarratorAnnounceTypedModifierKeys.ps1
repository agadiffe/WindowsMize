#=================================================================================================================
#       Accessibility > Narrator > Have Narrator Announce When I Type > Shift, Alt, And Other Modifier Keys
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedModifierKeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedModifierKeys
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedModifierKeys -State 'Disabled'
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
        $NarratorAnnounceTypedModifierKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'EchoModifierKeys'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Shift, Alt, And Other Modifier Keys' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedModifierKeys
    }
}
