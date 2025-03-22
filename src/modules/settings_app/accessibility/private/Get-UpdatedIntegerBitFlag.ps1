#=================================================================================================================
#                                           Get Updated Integer BitFlag
#=================================================================================================================

<#
.SYNTAX
    Get-UpdatedIntegerBitFlag
        [-Flags] <int>
        [-BitFlag] <int>
        [-State] <bool>
        [<CommonParameters>]
#>

function Get-UpdatedIntegerBitFlag
{
    <#
    .EXAMPLE
        PS> $CurrentFlags = 0 (0000)
        PS> $NewFlags = Get-UpdatedIntegerBitFlag -Flags $CurrentFlags -BitFlag 0x00000004 -State $true
        PS> $NewFlags
        4 (0100)
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [int] $Flags,

        [Parameter(Mandatory)]
        [int] $BitFlag,

        [Parameter(Mandatory)]
        [bool] $State
    )

    process
    {
        $State ? $Flags -bor $BitFlag : $Flags -band -bnot $BitFlag
    }
}
