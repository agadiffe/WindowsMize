#=================================================================================================================
#                       Personnalization > Taskbar > Taskbar Behaviors > Taskbar Alignment
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarAlignment
        [-Value] {Left | Center}
        [<CommonParameters>]
#>

function Set-TaskbarAlignment
{
    <#
    .EXAMPLE
        PS> Set-TaskbarAlignment -Value 'Center'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarAlignment] $Value
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
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Alignment' to '$Value' ..."
        Set-RegistryEntry -InputObject $TaskbarAlignment
    }
}
