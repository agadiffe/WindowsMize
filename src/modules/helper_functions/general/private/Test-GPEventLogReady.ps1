#=================================================================================================================
#                               Helper Function - Test Group Policy Event Log Ready
#=================================================================================================================

<#
.SYNTAX
    Test-GPEventLogReady
        [[-LogName] <string>]
        [<CommonParameters>]
#>

function Test-GPEventLogReady
{
    <#
    .EXAMPLE
        PS> Test-GPEventLogReady

    .EXAMPLE
        PS> Test-GPEventLogReady -LogName 'Microsoft-Windows-GroupPolicy/Operational'
    #>

    [CmdletBinding()]
    param
    (
        [string] $LogName = 'Microsoft-Windows-GroupPolicy/Operational'
    )

    $GPLog = Get-WinEvent -ListLog $LogName -ErrorAction 'SilentlyContinue'
    if (-not $GPLog -or -not $GPLog.IsEnabled)
    {
        return $false
    }

    $EventLogSvc = Get-Service -Name 'EventLog' -ErrorAction 'SilentlyContinue'
    if (-not $EventLogSvc -or $EventLogSvc.StartType -eq 'Disabled')
    {
        return $false
    }

    return $true
}
