#=================================================================================================================
#                                                    Copy Data
#=================================================================================================================

<#
.SYNTAX
    Copy-Data
        [-Name] <string[]>
        [-Path] <string>
        [-Destination] <string>
        [<CommonParameters>]
#>

function Copy-Data
{
    <#
    .DESCRIPTION
        Copies an item from one location to another.
        Keep the tree folders of copied item.
        Create the destination directory path if it doesn't exist.

    .EXAMPLE
        PS> Copy-Data -Name 'foo.txt', 'bar\baz.txt' -Path 'X:' -Destination 'Y:\data\'
        PS> Get-ChildItem -Path 'Y:' -Name
        data\foo.txt
        data\bar\baz.txt
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string[]] $Name,

        [Parameter(Mandatory)]
        [string] $Path,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    process
    {
        foreach ($Item in $Name)
        {
            $ItemParameter = @{
                Path        = "$Path\$Item"
                Destination = Split-Path -Path "$Destination\$Item"
                Recurse     = $true
                Force       = $true
            }
            if (Test-Path -Path $ItemParameter.Path)
            {
                if (-not (Test-Path -Path $ItemParameter.Destination))
                {
                    New-Item -ItemType 'Directory' -Path $ItemParameter.Destination -Force | Out-Null
                }
                Copy-Item @ItemParameter
            }
        }
    }
}
