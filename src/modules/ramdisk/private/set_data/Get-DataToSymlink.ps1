#=================================================================================================================
#                                               Get Data To Symlink
#=================================================================================================================

<#
.SYNTAX
    Get-DataToSymlink
        [-RamDiskPath] <string>
        [-Data] {Brave | VSCode}
        [<CommonParameters>]
#>

function Get-DataToSymlink
{
    <#
    .EXAMPLE
        PS> Get-DataToSymlink -RamDiskPath 'X:' -Data 'Brave', 'VSCode'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskPath,

        [Parameter(Mandatory)]
        [AppName[]] $Data
    )

    process
    {
        $DataToSymlink = @{}
        switch ($Data)
        {
            'Brave'  { $DataToSymlink += Get-BraveDataToSymlink -RamDiskPath $RamDiskPath }
            'VSCode' { $DataToSymlink += Get-VSCodeDataToSymlink -RamDiskPath $RamDiskPath }
        }
        $DataToSymlink
    }
}
