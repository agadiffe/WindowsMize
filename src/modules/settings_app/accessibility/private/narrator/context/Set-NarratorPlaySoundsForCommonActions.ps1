#=================================================================================================================
#       Accessibility > Narrator > Context Level > Play Sounds Instead Of Announcements For Common Actions
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorPlaySoundsForCommonActions
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorPlaySoundsForCommonActions
{
    <#
    .EXAMPLE
        PS> Set-NarratorPlaySoundsForCommonActions -State 'Disabled'
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
        $NarratorPlaySoundsForCommonActions = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'HearOnlySoundsForCommonActions'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Context Level: Play Sounds For Common Actions' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorPlaySoundsForCommonActions
    }
}
