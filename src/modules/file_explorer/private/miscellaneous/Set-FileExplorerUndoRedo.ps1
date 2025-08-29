#=================================================================================================================
#                                    File Explorer - Misc > Undo/Redo Feature
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerUndoRedo
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerUndoRedo
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerUndoRedo -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: delete (default) | off: 0
        $UndoRedoFeature = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    RemoveEntry = $State -eq 'Enabled'
                    Name  = 'MaxUndoItems'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Undo/Redo Feature' to '$State' ..."
        Set-RegistryEntry -InputObject $UndoRedoFeature
    }
}
