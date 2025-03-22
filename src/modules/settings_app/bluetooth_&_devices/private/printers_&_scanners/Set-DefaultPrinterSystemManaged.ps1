#=================================================================================================================
#                Bluetooth & Devices > Printers & Scanners > Let Windows Manage My Default Printer
#=================================================================================================================

<#
.SYNTAX
    Set-DefaultPrinterSystemManaged
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DefaultPrinterSystemManaged
{
    <#
    .EXAMPLE
        PS> Set-DefaultPrinterSystemManaged -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $PrintersDefaultPrinter = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows NT\CurrentVersion\Windows'
            Entries = @(
                @{
                    Name  = 'LegacyDefaultPrinterMode'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Printers & Scanners - Let Windows Manage My Default Printer' to '$State' ..."
        Set-RegistryEntry -InputObject $PrintersDefaultPrinter
    }
}
