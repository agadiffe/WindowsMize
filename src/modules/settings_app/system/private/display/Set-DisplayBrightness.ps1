#=================================================================================================================
#                                          System > Display > Brightness
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayBrightness
        [-Percent] <int>
        [<CommonParameters>]
#>

function Set-DisplayBrightness
{
    <#
    .DESCRIPTION
        Available with a built-in display (e.g. Laptop).

    .EXAMPLE
        PS> Set-DisplayBrightness -Percent 70
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange(0, 100)]
        [int] $Percent
    )

    process
    {
        Write-Verbose -Message "Setting 'Display Brightness' to '$Percent%' ..."

        # SUB_VIDEO: '7516b95f-f776-4464-8c53-06167f40cc99'
        # VIDEONORMALLEVEL: 'aded5e82-b909-4619-9949-f5d71dac0bcb'

        # range: 0-100
        powercfg.exe -SetACValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Percent 2>&1 | Out-Null
        powercfg.exe -SetDCValueIndex SCHEME_CURRENT SUB_VIDEO VIDEONORMALLEVEL $Percent 2>&1 | Out-Null

        if ($Global:LASTEXITCODE -ne 0) {
            Write-Error -Message "  cannot set the Display Brightness (probably no built-in display available)"
        }

        powercfg.exe -SetActive SCHEME_CURRENT
    }
}
