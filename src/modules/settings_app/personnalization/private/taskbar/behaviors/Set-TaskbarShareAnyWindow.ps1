#=================================================================================================================
#                     Personnalization > Taskbar Behaviors > Share Any Window From My Taskbar
#=================================================================================================================

# Quickly share the content from open app windows directly from your taskbar.

<#
.SYNTAX
    Set-TaskbarShareAnyWindow
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarShareAnyWindow
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShareAnyWindow -Value 'None'
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
        $TaskbarShareWindow = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarSn'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Share Any Window From My Taskbar' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarShareWindow
    }
}
