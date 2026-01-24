#=================================================================================================================
#                                          System > Display > Brightness
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayBrightness
        [-Value] <int>
        [<CommonParameters>]
#>

function Set-DisplayBrightness
{
    <#
    .DESCRIPTION
        Available with a built-in display (e.g. Laptop).

    .EXAMPLE
        PS> Set-DisplayBrightness -Value 70
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Value
    )

    process
    {
        # range: 0-100
        Write-Verbose -Message "Setting 'Display Brightness' to '$Value%' ..."

        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Value 2>&1 | Out-Null
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Value 2>&1 | Out-Null
        if ($Global:LASTEXITCODE -ne 0) {
            Write-Verbose -Message "  cannot set the Display Brightness (probably no built-in display available)"
        }
        powercfg.exe -SetActive SCHEME_CURRENT
    }
}
