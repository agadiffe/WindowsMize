#=================================================================================================================
#                         Time & Language > Date & Time > Show Abbreviated Time And Date
#=================================================================================================================

# old

<#
.SYNTAX
    Set-DateAndTimeShowAbbreviatedValue
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DateAndTimeShowAbbreviatedValue
{
    <#
    .EXAMPLE
        PS> Set-DateAndTimeShowAbbreviatedValue -State 'Disabled'
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
        $DateAndTimeShowAbbreviatedValue = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'ShowShortenedDateTime'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Date & Time - Show Abbreviated Time And Date' to '$State' ..."
        Set-RegistryEntry -InputObject $DateAndTimeShowAbbreviatedValue
    }
}
