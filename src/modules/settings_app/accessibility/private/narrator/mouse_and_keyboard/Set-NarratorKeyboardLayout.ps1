#=================================================================================================================
#                                   Accessibility > Narrator > Keyboard Layout
#=================================================================================================================

<#
.SYNTAX
    Set-NarratorKeyboardLayout
        [-Layout] {Legacy | Standard}
        [<CommonParameters>]
#>

function Set-NarratorKeyboardLayout
{
    <#
    .EXAMPLE
        PS> Set-NarratorKeyboardLayout -Layout 'Standard'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [NarratorKeyboardLayout] $Layout
    )

    process
    {
        # standard: 1 (default) | legacy: 0
        $NarratorKeyboardLayout = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Narrator'
            Entries = @(
                @{
                    Name  = 'KeyboardLayout'
                    Value = [int]$Layout
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Narrator - Keyboard Layout' to '$Layout' ..."
        Set-RegistryEntry -InputObject $NarratorKeyboardLayout
    }
}
