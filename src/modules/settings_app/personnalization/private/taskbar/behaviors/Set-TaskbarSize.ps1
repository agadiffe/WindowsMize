#=================================================================================================================
#                          Personnalization > Taskbar > Taskbar Behaviors > Taskbar Size
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarSize
        [-Mode] {Default | Small}
        [<CommonParameters>]
#>

function Set-TaskbarSize
{
    <#
    .EXAMPLE
        PS> Set-TaskbarSize -Mode 'Center'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarSize] $Mode
    )

    process
    {
        # default: 1 (default) | small: 0
        $TaskbarSize = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarSize'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Size' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TaskbarSize
    }
}
