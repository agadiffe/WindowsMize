#=================================================================================================================
#      Accessibility > Narrator > Have Narrator Announce When I Type > Arrow, Tab, And Other Navigation Keys
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorAnnounceTypedNavigationKeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorAnnounceTypedNavigationKeys
{
    <#
    .EXAMPLE
        PS> Set-NarratorAnnounceTypedNavigationKeys -State 'Disabled'
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
        $NarratorAnnounceTypedNavigationKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'EchoNavigationKeys'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Announce When I Type: Arrow, Tab, And Other Navigation Keys' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorAnnounceTypedNavigationKeys
    }
}
