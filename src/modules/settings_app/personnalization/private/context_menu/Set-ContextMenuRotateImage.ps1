#=================================================================================================================
#                                 Personnalization > Context Menu > Rotate Image
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuRotateImage
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuRotateImage
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuRotateImage -State 'Disabled'
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
        $ContextMenuRotateImage = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\verbs\rotate90'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Rotate Image' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuRotateImage
    }
}
