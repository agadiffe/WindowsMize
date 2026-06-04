#=================================================================================================================
#    Accessibility > Narrator > Have Narrator Announce When I Type > Toggle Keys, Like Caps Lock And Num Lock
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedToggleKeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedToggleKeys
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedToggleKeys -State 'Enabled'
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
        $NarratorAnnounceTypedToggleKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'EchoToggleKeys'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Toggle Keys, Like Caps Lock And Num Lock' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedToggleKeys
    }
}
