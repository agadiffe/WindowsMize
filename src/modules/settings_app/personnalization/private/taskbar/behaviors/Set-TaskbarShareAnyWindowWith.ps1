#=================================================================================================================
#                  Personnalization > Taskbar Behaviors > Share Any Window From My Taskbar With
#=================================================================================================================

# Quickly share the content from open app windows directly from your taskbar to your meeting calls.

<#
.SYNTAX
    Set-TaskbarShareAnyWindowWith
        [-Value] {None | AllApps | CommunicationApps | ChatAgentApps}
        [<CommonParameters>]
#>

function Set-TaskbarShareAnyWindowWith
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShareAnyWindowWith -Value 'None'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarShareAnyWindowMode] $Value
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
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Share Any Window From My Taskbar With' to '$Value' ..."
        Set-RegistryEntry -InputObject $TaskbarShareWindow
    }
}
