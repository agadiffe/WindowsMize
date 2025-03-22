#=================================================================================================================
#                                       Helper Function - Set Byte Bit Flag
#=================================================================================================================

<#
.SYNTAX
    Set-ByteBitFlag
        [-Bytes] <byte[]>
        [-ByteNum] <int>
        [-BitPos] <int>
        [-State] <bool>
        [<CommonParameters>]
#>

function Set-ByteBitFlag
{
    <#
    .DESCRIPTION
        ByteNum start at 0.
        BitPos start at 1.

    .EXAMPLE
        PS> $Bytes = [byte[]]::new(1)
        PS> $Bytes
        0 (0000 0000)
        PS> Set-ByteBitFlag -Bytes $Bytes -ByteNum 0 -BitPos 7 -State $true
        PS> $Bytes
        64 (0100 0000)
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [byte[]] $Bytes,

        [Parameter(Mandatory)]
        [ValidateRange('NonNegative')]
        [int] $ByteNum,

        [Parameter(Mandatory)]
        [ValidateRange(1, 8)]
        [int] $BitPos,

        [Parameter(Mandatory)]
        [bool] $State
    )

    process
    {
        $Bitmask = 1 -shl ($BitPos - 1)
        $Bytes[$ByteNum] = $State ? $Bytes[$ByteNum] -bor $Bitmask : $Bytes[$ByteNum] -band -bnot $Bitmask
    }
}
