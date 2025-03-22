#=================================================================================================================
#                           Time & Language > Language & Region > Regional Format Date
#=================================================================================================================

# control panel (icons view) > region (intl.cpl) > formats

<#
.SYNTAX
    Set-RegionalFormatDate
        [-FirstDayOfWeek {Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday}]
        [-ShortDate <string>]
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

        [string] $ShortDate
    )

    process
    {
        $RegionalFormatMsg = 'Language & Region - Regional Format'

        switch ($PSBoundParameters.Keys)
        {
            'FirstDayOfWeek'
            {
                # Monday: 0 | ... | Sunday: 6
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
                # e.g. 17-Apr-42: dd-MMM-yy
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
        }
    }
}
