#=================================================================================================================
#                                                New Symbolic Link
#=================================================================================================================

<#
.SYNTAX
    New-SymbolicLink
        [-Path] <string>
        [-Target] <string>
        [-TargetType] {Directory | File}
        [<CommonParameters>]
#>

function New-SymbolicLink
{
    <#
    .DESCRIPTION
        Create a symbolic link of Target to Path (i.e. Path is the symbolic link).
        Delete the Path or Symbolic Link if it exist.
        Create the target if it does not exist.

    .EXAMPLE
        PS> New-SymbolicLink -Path 'X:\Logs\foo\' -Target 'C:\foo\logs\' -TargetType 'Directory'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Path,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Target,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet('Directory', 'File')]
        [string] $TargetType
    )

    process
    {
        if (-not (Test-Path -Path $Target))
        {
            New-Item -ItemType $TargetType -Path $Target -Force | Out-Null
        }
        if (Test-Path -Path $Path)
        {
            Remove-Item -Path $Path -Recurse
        }

        New-ParentPath -Path $Path
        New-Item -ItemType 'SymbolicLink' -Path $Path -Target $Target | Out-Null
    }
}
