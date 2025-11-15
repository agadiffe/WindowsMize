#=================================================================================================================
#                                          System > Advanced > End Task
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarEndTask
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarEndTask
{
    <#
    .EXAMPLE
        PS> Set-TaskbarEndTask -State 'Disabled'
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
        $EndTask = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings'
            Entries = @(
                @{
                    Name  = 'TaskbarEndTask'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Advanced - End Task' to '$State' ..."
        Set-RegistryEntry -InputObject $EndTask
    }
}
