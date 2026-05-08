#=================================================================================================================
#                                             Taskbar Calendar State
#=================================================================================================================

<#
.SYNTAX
    Set-TaskbarCalendarState
        [-State] {Collapsed | Expanded}
        [<CommonParameters>]
#>

function Set-TaskbarCalendarState
{
    <#
    .EXAMPLE
        PS> Set-TaskbarCalendarState -State 'Expanded'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateSet('Collapsed', 'Expanded')]
        [string] $State
    )

    process
    {
        # Collapsed: 0 (default) | Expanded: 1
        $TaskbarCalendarState = @{
            Name  = 'CalendarState'
            Value = $State -eq 'Expanded' ? '1' : '0'
            Type  = '5f5e10b'
        }

        Write-Verbose -Message "Setting 'TaskbarCalendarState' to '$State' ..."
        Set-UwpAppSetting -Name 'TaskbarCalendar' -Setting $TaskbarCalendarState
    }
}
