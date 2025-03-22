#=================================================================================================================
#                                                 New Parent Path
#=================================================================================================================

<#
.SYNTAX
    New-ParentPath
        [-Path] <string>
        [<CommonParameters>]
#>

function New-ParentPath
{
    <#
    .DESCRIPTION
        Create the parent directory of Path if it does not exist.

    .EXAMPLE
        PS> $FilePath = X:\foo\bar\baz.txt
        PS> New-ParentPath -Path $FilePath
        PS> Get-ChildItem -Path 'X:' -Name -Recurse
        foo\bar
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Path
    )

    process
    {
        $ParentPath = Split-Path -Path $Path -ErrorAction 'SilentlyContinue'
        if ($ParentPath -and -not (Test-Path -Path $ParentPath))
        {
            New-Item -ItemType 'Directory' -Path $ParentPath | Out-Null
        }
    }
}
