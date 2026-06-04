#=================================================================================================================
#               Accessibility > Narrator > Narrator Home > Show Narrator Home When Narrator Starts
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorShowHomeOnStartup
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-NarratorShowHomeOnStartup
{
    <#
    .EXAMPLE
        PS> Set-NarratorShowHomeOnStartup -State 'Enabled'
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
        $NarratorShowHomeOnStartup = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator\NarratorHome'
            Entries = @(
                @{
                    Name  = 'AutoStart'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Show Narrator Home When Narrator Starts' to '$State' ..."
        Set-RegistryEntry -InputObject $NarratorShowHomeOnStartup
    }
}
