#=================================================================================================================
#                      System Properties - Advanced > Startup and Recovery > System Failure
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

<#
.SYNTAX
    Set-SystemFailureSetting
        [-AutoRestart {Disabled | Enabled}]
        [-WriteDebugInfo {None | Complete | Kernel | Small | Automatic | Active}]
        [<CommonParameters>]
#>

function Set-SystemFailureSetting
{
    <#
    .DESCRIPTION
        Write debugging information - Minimum paging file size:
          Complete:  <YOUR_RAM> MB + 257 MB
          Kernel:    800 MB
          Small:     1 MB
          Automatic: 800 MB

    .EXAMPLE
        PS> Set-SystemFailureSetting -AutoRestart 'Disabled' -WriteDebugInfo 'None'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $AutoRestart,

        [DebugInfoMethod] $WriteDebugInfo
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
            'AutoRestart'    { Set-SystemFailureAutoRestart -State $AutoRestart }
            'WriteDebugInfo' { Set-SystemFailureWriteDebugInfo -Value $WriteDebugInfo }
        }
    }
}
