#=================================================================================================================
#                        Windows Update > Get Me Up To Date (Restart As Soon As Possible)
#=================================================================================================================

<#
.SYNTAX
    Set-WinUpdateGetMeUpToDate
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WinUpdateGetMeUpToDate
{
    <#
    .EXAMPLE
        PS> Set-WinUpdateGetMeUpToDate -State 'Disabled'
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
        $WinUpdateRestartAsap = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
            Entries = @(
                @{
                    Name  = 'IsExpedited'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Update - Get Me Up To Date (Restart As Soon As Possible)' to '$State' ..."
        Set-RegistryEntry -InputObject $WinUpdateRestartAsap
    }
}
