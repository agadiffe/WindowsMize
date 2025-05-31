#=================================================================================================================
#                                                  Apps > Resume
#=================================================================================================================

<#
.SYNTAX
    Set-AppsResume
        [[-State] {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-AppsResume
{
    <#
    .EXAMPLE
        PS> Set-AppsResume -State 'Disabled'
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
        $AppsResume = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\CrossDeviceResume\Configuration'
            Entries = @(
                @{
                    Name  = 'IsResumeAllowed'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Apps Resume' to '$State' ..."
        Set-RegistryEntry -InputObject $AppsResume
    }
}
