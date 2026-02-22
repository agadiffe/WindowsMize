#=================================================================================================================
#                                                 Get Drive Path
#=================================================================================================================

<#
.SYNTAX
    Get-DrivePath
        [-Name] <string>
        [<CommonParameters>]
#>

function Get-DrivePath
{
    <#
    .EXAMPLE
        PS> Get-DrivePath -Name 'RamDisk'
        X:\
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name
    )

    process
    {
        (Get-PSDrive -PSProvider 'FileSystem' | Where-Object -Property 'Description' -EQ -Value $Name).Root
    }
}
