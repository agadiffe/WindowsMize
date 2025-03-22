#=================================================================================================================
#                   System > Power & Battery > Power Mode > Screen, Sleep, & Hibernate Timeouts
#=================================================================================================================

# When plugged in | On battery power
#   turn my screen off after
#   make my device sleep after
#   make my device hibernate after

<#
.SYNTAX
    Set-PowerStateTimeout
        [-Name] {Screen | Sleep | Hibernate}
        [-Timeout] <int>
        [-PowerSource] {PluggedIn | OnBattery}
        [<CommonParameters>]
#>

function Set-PowerStateTimeout
{
    <#
    .EXAMPLE
        PS> Set-PowerStateTimeout -Name 'Sleep' -Timeout 10 -PowerSource 'PluggedIn'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [PowerState] $Name,

        [Parameter(Mandatory)]
        [ValidateRange('NonNegative')]
        [int] $Timeout,

        [Parameter(Mandatory)]
        [PowerSource] $PowerSource
    )

    process
    {
        # value are in minutes
        # never: 0 | default (depends): PluggedIn\ 5 15 180, OnBattery\ 3 10 180

        $PowerStateValue = switch ($Name)
        {
            'Screen'    { 'Monitor' }
            'Sleep'     { 'Standby' }
            'Hibernate' { 'Hibernate' }
        }

        $PowerSourceValue = switch ($PowerSource)
        {
            'PluggedIn' { 'AC' }
            'OnBattery' { 'DC' }
        }

        Write-Verbose -Message "Setting 'Power - $Name Timeout ($PowerSource)' to '$Timeout min' ..."
        powercfg.exe -Change $PowerStateValue-Timeout-$PowerSourceValue $Timeout
    }
}
