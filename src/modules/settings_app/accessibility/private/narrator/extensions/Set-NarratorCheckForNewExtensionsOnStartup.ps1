#=================================================================================================================
#      Accessibility > Narrator > Narrator Extensions > Find And Download New Extensions On Narrator Startup
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorCheckForNewExtensionsOnStartup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorCheckForNewExtensionsOnStartup
{
    <#
    .EXAMPLE
        PS> Set-NarratorCheckForNewExtensionsOnStartup -State 'Enabled'
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
        $NarratorCheckForNewExtensionsOnStartup = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NoRoam'
            Entries = @(
                @{
                    Name  = 'CheckForScriptsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Find And Download New Extensions On Narrator Startup' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorCheckForNewExtensionsOnStartup
    }
}
