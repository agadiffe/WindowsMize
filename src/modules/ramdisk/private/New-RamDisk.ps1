#=================================================================================================================
#                                                   New RamDisk
#=================================================================================================================

<#
.SYNTAX
    New-RamDisk
        [-Name] <string>
        [[-DriveLetter] <string>]
        [[-Size] <string>]
        [<CommonParameters>]
#>

function New-RamDisk
{
    <#
    .DESCRIPTION
        DriveLetter: use the first unused drive letter if not specified.
        Size: 512MB if not specified.

    .EXAMPLE
        PS> New-RamDisk -Name 'My RamDisk' -Size '4G'

    .NOTES
        See OSFMount documentation for more info.
        e.g.
        -s size
            Size of the virtual disk. Size is number of bytes unless suffixed with
                [...]
                'M'    megabytes
                'G'    gigabytes
                [...]
        -m mountpoint
            Specifies a drive letter (eg. "-m F:" for F:)
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name,

        [ValidatePattern(
            '^[A-Za-z]:\\?$',
            ErrorMessage = 'DriveLetter format must be a letter followed by a colon, ' +
                           'optionally with a backslash (e.g. ''C:'' or ''C:\'').')]
        [string] $DriveLetter = '#:',

        [ValidatePattern(
            '^\d[MG]$',
            ErrorMessage = 'Size format must be a number followed by M or G. (e.g. ''512M'' or ''2G'').')]
        [string] $Size = '512M'
    )

    process
    {
        $OSFMountProcess = @{
            FilePath     = "$((Get-ApplicationInfo -Name 'OSFMount').InstallLocation)\OSFMount.com"
            ArgumentList = "-a -t vm -m $DriveLetter -o rw,format:ntfs:""$Name"" -s $Size"
        }
        Start-Process -Wait -NoNewWindow @OSFMountProcess
    }
}
