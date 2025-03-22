#=================================================================================================================
#                                       File Explorer - Misc > Show Gallery
#=================================================================================================================

<#
.SYNTAX
    Set-FileExplorerShowGallery
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-FileExplorerShowGallery
{
    <#
    .EXAMPLE
        PS> Set-FileExplorerShowGallery -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: key present (default) | off: delete key
        $ShowGallery = @{
            RemoveKey = $State -eq 'Disabled'
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
            Entries = @(
                @{
                    Name  = '(Default)'
                    Value = 'Gallery Folder'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'File Explorer - Show Gallery' to '$State' ..."
        Set-RegistryEntry -InputObject $ShowGallery
    }
}
