#=================================================================================================================
#                        Acrobat Reader - Preferences > General > Show Messages At Launch
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderShowMessagesAtLaunch
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderShowMessagesAtLaunch
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderShowMessagesAtLaunch -State 'Disabled'
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
        $AcrobatReaderShowMessagesAtLaunch = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\IPM'
            Entries = @(
                @{
                    Name  = 'bShowMsgAtLaunch'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Show Me Messages When I Launch Adobe Acrobat' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderShowMessagesAtLaunch
    }
}
