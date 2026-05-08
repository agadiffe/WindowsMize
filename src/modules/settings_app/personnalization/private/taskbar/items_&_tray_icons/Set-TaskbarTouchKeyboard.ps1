#=================================================================================================================
#                         Personnalization > Taskbar > System Tray Icons > Touch Keyboard
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarTouchKeyboard
        [-Visibility] {Never | Always | WhenNoKeyboard}
        [<CommonParameters>]
#>

function Set-TaskbarTouchKeyboard
{
    <#
    .EXAMPLE
        PS> Set-TaskbarTouchKeyboard -Visibility 'Never'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [TouchKeyboardMode] $Visibility
    )

    process
    {
        # never: 0 | always: 1 (default) | when no keyboard attached: 2
        $TaskbarTrayIconsTouchKeyboard = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\TabletTip\1.7'
            Entries = @(
                @{
                    Name  = 'TipbandDesiredVisibility'
                    Value = [int]$Visibility
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Taskbar Tray Icons - Touch Keyboard' to '$Visibility' ..."
        Set-RegistryEntry -InputObject $TaskbarTrayIconsTouchKeyboard
    }
}
