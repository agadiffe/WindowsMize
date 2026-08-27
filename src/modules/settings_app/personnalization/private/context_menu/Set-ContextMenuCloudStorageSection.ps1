#=================================================================================================================
#                Personnalization > Context Menu > Keep Cloud Storage Actions In Their Own Section
#=================================================================================================================

<#
.SYNTAX
    Set-ContextMenuCloudStorageSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-ContextMenuCloudStorageSection
{
    <#
    .EXAMPLE
        PS> Set-ContextMenuCloudStorageSection -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 (default) | off: 0
        $ContextMenuCloudStorageSection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\ContextMenu\Preferences\CloudStorageActions'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Context Menu - Keep Cloud Storage Actions In Their Own Section' to '$State' ..."
        Set-RegistryEntry -InputObject $ContextMenuCloudStorageSection
    }
}
