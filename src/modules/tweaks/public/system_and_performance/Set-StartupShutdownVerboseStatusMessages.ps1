#=================================================================================================================
#                                    Startup/Shutdown Verbose Status Messages
#=================================================================================================================

<#
.SYNTAX
    Set-StartupShutdownVerboseStatusMessages
        [-GPO] {Enabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-StartupShutdownVerboseStatusMessages
{
    <#
    .EXAMPLE
        PS> Set-StartupShutdownVerboseStatusMessages -GPO 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutDisabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > system
        #   display highly detailed status messages
        # not configured: delete (default) | on: 1
        $VerboseStatusMessagesGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'VerboseStatus'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Startup/Shutdown Verbose Status Messages (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $VerboseStatusMessagesGpo
    }
}
