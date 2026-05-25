#=================================================================================================================
#                                Accessibility > Keyboard > Underline Access Keys
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardUnderlineAccessKeys
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-KeyboardUnderlineAccessKeys
{
    <#
    .EXAMPLE
        PS> Set-KeyboardUnderlineAccessKeys -State 'Disabled'
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
        $KeyboardUnderlineAccessKeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Accessibility\Keyboard Preference'
            Entries = @(
                @{
                    Name  = 'On'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Underline Access Keys' to '$State' ..."
        Set-RegistryEntry -InputObject $KeyboardUnderlineAccessKeys
    }
}
