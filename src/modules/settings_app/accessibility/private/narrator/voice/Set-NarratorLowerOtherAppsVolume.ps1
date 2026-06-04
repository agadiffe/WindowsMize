#=================================================================================================================
#               Accessibility > Narrator > Lower The Volume Of Other Apps When Narrator Is Speaking
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorLowerOtherAppsVolume
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorLowerOtherAppsVolume
{
    <#
    .EXAMPLE
        PS> Set-NarratorLowerOtherAppsVolume -State 'Enabled'
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
        $NarratorLowerOtherAppsVolume = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'DuckAudio'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Lower The Volume Of Other Apps When Narrator Is Speaking' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorLowerOtherAppsVolume
    }
}
