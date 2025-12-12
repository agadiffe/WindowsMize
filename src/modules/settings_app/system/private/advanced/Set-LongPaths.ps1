#=================================================================================================================
#                                      System > Advanced > Enable Long Paths
#=================================================================================================================

# default MAX_PATH = 260 characters

<#
.SYNTAX
    Set-LongPaths
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-LongPaths
{
    <#
    .EXAMPLE
        PS> Set-LongPaths -State 'Enabled'
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
        $LongPaths = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Control\FileSystem'
            Entries = @(
                @{
                    Name  = 'LongPathsEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'System Advanced - Long Paths' to '$State' ..."
        Set-RegistryEntry -InputObject $LongPaths
    }
}
