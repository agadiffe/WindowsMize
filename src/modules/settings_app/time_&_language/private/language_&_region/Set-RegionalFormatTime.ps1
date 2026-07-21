#=================================================================================================================
#                           Time & Language > Language & Region > Regional Format Time
#=================================================================================================================

# control panel (icons view) > region (intl.cpl) > formats

<#
.SYNTAX
    Set-RegionalFormatTime
        [-ShortTime <string>]
        [-LongTime <string>]
        [<CommonParameters>]
#>

function Set-RegionalFormatTime
{
    <#
    .EXAMPLE
        PS> Set-RegionalFormatTime -ShortTime 'HH:mm tt' -LongTime 'HH:mm:ss tt'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [string] $ShortTime,

        [string] $LongTime
    )

    process
    {
        $RegionalFormatMsg = 'Language & Region - Regional Format'

        switch ($PSBoundParameters.Keys)
        {
            'ShortTime'
            {
                # GUI values (en-US):
                #   h:mm tt  (9:40 AM / 2:40 AM) (default)
                #   hh:mm tt (09:40 AM / 02:40 AM)
                #   H:mm     (9:40 / 14:30)
                #   HH:mm    (09:40 / 14:30)
                $RegionalFormatShortTime = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sShortTime'
                            Value = $ShortTime
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Short Time' to '$ShortTime' ..."
                Set-RegistryEntry -InputObject $RegionalFormatShortTime
            }
            'LongTime'
            {
                # GUI values (en-US):
                #   h:mm:ss tt  (9:40:07 AM / 2:40:07 AM) (default)
                #   hh:mm:ss tt (09:40:07 AM / 02:40:07 AM)
                #   H:mm:ss     (9:40:07 / 14:30:07)
                #   HH:mm:ss    (09:40:07 / 14:30:07)
                $RegionalFormatLongTime = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sTimeFormat'
                            Value = $LongTime
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Long Time' to '$LongTime' ..."
                Set-RegistryEntry -InputObject $RegionalFormatLongTime
            }
        }
    }
}
