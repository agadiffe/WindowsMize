#=================================================================================================================
#                     Personnalization > Taskbar > Taskbar Behaviors > Taskbar Icon Alignment
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarIconAlignment
        [-Mode] {Left | Center}
        [<CommonParameters>]
#>

function Set-TaskbarIconAlignment
{
    <#
    .EXAMPLE
        PS> Set-TaskbarIconAlignment -Mode 'Center'
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
        $TaskbarIconAlignment = @{
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

        Write-Verbose -Message "Setting 'Taskbar Icon Alignment' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TaskbarIconAlignment
    }
}
