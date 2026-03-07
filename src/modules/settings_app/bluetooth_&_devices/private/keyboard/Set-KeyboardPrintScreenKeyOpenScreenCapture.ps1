#=================================================================================================================
#                   Accessibility > Keyboard > Use The Print Screen Key To Open Screen Capture
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardPrintScreenKeyOpenScreenCapture
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-KeyboardPrintScreenKeyOpenScreenCapture
{
    <#
    .EXAMPLE
        PS> Set-KeyboardPrintScreenKeyOpenScreenCapture -State 'Disabled'
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
        $KeyboardPrintScreenKeyOpenScreenCapture = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Keyboard'
            Entries = @(
                @{
                    Name  = 'PrintScreenKeyForSnippingEnabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Keyboard - Use The Print Screen Key To Open Screen Capture' to '$State' ..."
        Set-RegistryEntry -InputObject $KeyboardPrintScreenKeyOpenScreenCapture
    }
}
