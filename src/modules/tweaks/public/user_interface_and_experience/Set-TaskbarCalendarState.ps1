#=================================================================================================================
#                                             Taskbar Calendar State
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarCalendarState
        [-Value] {Collapsed | Expanded}
        [<CommonParameters>]
#>

function Set-TaskbarCalendarState
{
    <#
    .EXAMPLE
        PS> Set-TaskbarCalendarState -Value 'Expanded'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Collapsed', 'Expanded')]
        [string] $Value
    )

    process
    {
        # Collapsed: 0 (default) | Expanded: 1
        $TaskbarCalendarState = @{
            Name  = 'CalendarState'
            Value = $Value -eq 'Expanded' ? '1' : '0'
            Type  = '5f5e10b'
        }

        Write-Verbose -Message "Setting 'TaskbarCalendarState' to '$Value' ..."
        Set-UwpAppSetting -Name 'TaskbarCalendar' -Setting $TaskbarCalendarState
    }
}
