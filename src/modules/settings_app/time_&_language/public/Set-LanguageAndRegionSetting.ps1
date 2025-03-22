#=================================================================================================================
#                                 Time & Language > Language & Region - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-LanguageAndRegionSetting
        [-FirstDayOfWeek {Monday | Tuesday | Wednesday | Thursday | Friday | Saturday | Sunday}]
        [-ShortDateFormat <string>]
        [-Utf8ForNonUnicodePrograms {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-LanguageAndRegionSetting
{
    <#
    .EXAMPLE
        PS> Set-LanguageAndRegionSetting -ShortDate 'dd-MMM-yy' -Utf8ForNonUnicodePrograms 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [DayOfWeek] $FirstDayOfWeek,

        [string] $ShortDateFormat,

        [state] $Utf8ForNonUnicodePrograms
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'FirstDayOfWeek'            { Set-RegionalFormatDate -FirstDayOfWeek $FirstDayOfWeek }
            'ShortDateFormat'           { Set-RegionalFormatDate -ShortDate $ShortDateFormat }
            'Utf8ForNonUnicodePrograms' { Set-SystemLocaleUtf8ForNonUnicodePrograms -State $Utf8ForNonUnicodePrograms }
        }
    }
}
