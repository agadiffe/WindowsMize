#=================================================================================================================
#     Personnalization > Taskbar > Taskbar Behaviors > When Using Multiple Displays, Show My Taskbar Apps On
#=================================================================================================================

# Requires Set-TaskbarShowOnAllDisplays to 'Enabled'.

<#
.SYNTAX
    Set-TaskbarShowAppsOnMultipleDisplays
        [-Value] {AllTaskbars | MainAndTaskbarWhereAppIsOpen | TaskbarWhereAppIsOpen}
        [<CommonParameters>]
#>

function Set-TaskbarShowAppsOnMultipleDisplays
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowAppsOnMultipleDisplays -Value 'AllTaskbars'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarAppsVisibility] $Value
    )

    process
    {
        # all taskbars: 0 (default) | main taskbar and taskbar where window is open: 1 | taskbar where window is open: 2
        $TaskbarAppsVisibility = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'MMTaskbarMode'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - When Using Multiple Displays, Show My Taskbar Apps On' to '$Value' ..."
        Set-RegistryEntry -InputObject $TaskbarAppsVisibility
    }
}
