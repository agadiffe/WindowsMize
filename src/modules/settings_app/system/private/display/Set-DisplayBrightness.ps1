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

        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Value
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Value
        powercfg.exe -SetActive SCHEME_CURRENT
    }
}
