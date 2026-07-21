#=================================================================================================================
#                           Time & Language > Language & Region > Regional Format Date
#=================================================================================================================

# control panel (icons view) > region (intl.cpl) > formats

<#
.SYNTAX
    Set-RegionalFormatDate
        [-FirstDayOfWeek {Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday}]
        [-ShortDate <string>]
        [-LongDate <string>]
        [<CommonParameters>]
#>

function Set-RegionalFormatDate
{
    <#
    .EXAMPLE
        PS> Set-RegionalFormatDate -FirstDayOfWeek 'Monday' -ShortDate 'dd-MMM-yy'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [DayOfWeek] $FirstDayOfWeek,

        [string] $ShortDate,

        [string] $LongDate
    )

    process
    {
        $RegionalFormatMsg = 'Language & Region - Regional Format'

        switch ($PSBoundParameters.Keys)
        {
            'FirstDayOfWeek'
            {
                # Monday: 0 | Tuesday: 1 | Wednesday: 2 | Thursday: 3 | Friday: 4 | Saturday: 5 | Sunday: 6
                $RegionalFormatFirstDayOfWeek = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'iFirstDayOfWeek'
                            Value = [int]$FirstDayOfWeek
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : First Day Of Week' to '$FirstDayOfWeek' ..."
                Set-RegistryEntry -InputObject $RegionalFormatFirstDayOfWeek
            }
            'ShortDate'
            {
                # GUI values (en-US):
                #   M/d/yyyy   (4/5/2042)
                #   M/d/yy     (4/5/42) (default)
                #   MM/dd/yy   (04/05/2042)
                #   MM/dd/yyyy (04/05/2042)
                #   yy/MM/dd   (42/04/05)
                #   yyyy-MM-dd (2042-04-05)
                #   dd-MMM-yy  (05-Apr-42)
                $RegionalFormatShortDate = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sShortDate'
                            Value = $ShortDate
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Short Date' to '$ShortDate' ..."
                Set-RegistryEntry -InputObject $RegionalFormatShortDate
            }
            'LongDate'
            {
                # GUI values (en-US):
                #   dddd, MMMM d, yyyy (Wednesday, April 5, 2042) (default)
                #   MMMM d, yyyy       (April 5, 2042)
                #   dddd, d MMMM, yyyy (Wednesday, 5 April, 2042)
                #   d MMMM, yyyy       (5 April, 2042)
                $RegionalFormatLongDate = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sLongDate'
                            Value = $LongDate
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Long Date' to '$LongDate' ..."
                Set-RegistryEntry -InputObject $RegionalFormatLongDate
            }
        }
    }
}
