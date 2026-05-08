#=================================================================================================================
#                       Personnalization > Taskbar Behaviors > Show Smaller Taskbar Buttons
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarShowSmallerButtons
        [-Preference] {Always | Never | WhenFull}
        [<CommonParameters>]
#>

function Set-TaskbarShowSmallerButtons
{
    <#
    .EXAMPLE
        PS> Set-TaskbarShowSmallerButtons -Preference 'WhenFull'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TaskbarSmallerButtonsMode] $Preference
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
                    Value = [int]$Preference
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar - Show Smaller Taskbar Buttons' to '$Preference' ..."
        Set-RegistryEntry -InputObject $TaskbarSmallerButtons
    }
}
