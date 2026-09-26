#=================================================================================================================
#                    Personnalization > Taskbar > Taskbar Behaviors > Show Taskbar Previews As
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarPreviewMode
        [-Mode] {Thumbnail | List}
        [<CommonParameters>]
#>

function Set-TaskbarPreviewMode
{
    <#
    .EXAMPLE
        PS> Set-TaskbarPreviewMode -Mode 'Thumbnail'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarPreviewMode] $Mode
    )

    process
    {
        # thumbnail: 1 (default) | list: 0
        $TaskbarPreviewMode = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarPreviewMode'
                    Value = [int]$Mode
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Taskbar Previews As' to '$Mode' ..."
        Set-RegistryEntry -InputObject $TaskbarPreviewMode
    }
}
