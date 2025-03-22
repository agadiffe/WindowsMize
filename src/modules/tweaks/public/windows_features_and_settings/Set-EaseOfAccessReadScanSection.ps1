#=================================================================================================================
#                                 Ease Of Access - Always Read/Scan This Section
#=================================================================================================================

# control panel (icons view) > ease of access center (control.exe access.cpl)

<#
.SYNTAX
    Set-EaseOfAccessReadScanSection
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-EaseOfAccessReadScanSection
{
    <#
    .EXAMPLE
        PS> Set-EaseOfAccessReadScanSection -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $Value = $State -eq 'Enabled' ? '1' : '0'

        # on: 1 (default) | off: 0
        $EaseOfAccessReadScanSection = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Ease of Access'
            Entries = @(
                @{
                    Name  = 'selfvoice'
                    Value = $Value
                    Type  = 'DWord'
                }
                @{
                    Name  = 'selfscan'
                    Value = $Value
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Ease Of Access - Always Read/Scan This Section' to '$State' ..."
        Set-RegistryEntry -InputObject $EaseOfAccessReadScanSection
    }
}
