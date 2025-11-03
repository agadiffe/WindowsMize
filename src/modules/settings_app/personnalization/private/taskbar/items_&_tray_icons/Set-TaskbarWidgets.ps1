#=================================================================================================================
#                              Personnalization > Taskbar > Taskbar Items > Widgets
#=================================================================================================================

# Function not used.

# To disable Widgets, see: applications > management > Set-Widgets

# UCPD filter driver prevent the modification of this registry key.
# Requested registry access is not allowed.

<#
.SYNTAX
    Set-TaskbarWidgets
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-TaskbarWidgets
{
    <#
    .EXAMPLE
        PS> Set-TaskbarWidgets -State 'Disabled'
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
        $TaskbarWidgetsButton = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'TaskbarDa'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Items - Widgets' to '$State' ..."
        Set-RegistryEntry -InputObject $TaskbarWidgetsButton
    }
}
