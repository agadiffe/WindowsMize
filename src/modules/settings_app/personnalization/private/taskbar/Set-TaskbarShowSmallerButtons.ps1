#=================================================================================================================
#                       Personnalization > Taskbar Behaviors > Show Smaller Taskbar Buttons
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowSmallerButtons
        [-Value] {Always | Never | WhenFull}
        [<CommonParameters>]
#>

function Set-TaskbarShowSmallerButtons
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowSmallerButtons -Value 'WhenFull'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarSmallerButtonsMode] $Value
    )

    process
    {
        # Always: 0 | Never: 1 | WhenFull: 2 (default)
        $TaskbarSmallerButtons = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'IconSizePreference'
                    Value = [int]$Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Smaller Taskbar Buttons' to '$Value' ..."
        Set-RegistryEntry -InputObject $TaskbarSmallerButtons
    }
}
