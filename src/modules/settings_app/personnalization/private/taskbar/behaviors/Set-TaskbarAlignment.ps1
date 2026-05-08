#=================================================================================================================
#                       Personnalization > Taskbar > Taskbar Behaviors > Taskbar Alignment
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarAlignment
        [-Mode] {Left | Center}
        [<CommonParameters>]
#>

function Set-TaskbarAlignment
{
    <#
    .EXAMPLE
        PS> Set-TaskbarAlignment -Mode 'Center'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarAlignment] $Mode
    )

    process
    {
        # center: 1 (default) | left: 0
        $TaskbarAlignment = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarAl'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Alignment' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TaskbarAlignment
    }
}
