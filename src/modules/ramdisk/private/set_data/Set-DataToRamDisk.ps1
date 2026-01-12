#=================================================================================================================
#                                               Set Data To RamDisk
#=================================================================================================================

<#
.SYNTAX
    Set-DataToRamDisk
        [-RamDiskName] <string>
        [-AppToRamDisk] {Brave | VSCode}
        [<CommonParameters>]
#>

function Set-DataToRamDisk
{
    <#
    .EXAMPLE
        PS> Set-DataToRamDisk -RamDiskName 'RamDisk' -AppToRamDisk 'Brave', 'VSCode'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $RamDiskName,

        [Parameter(Mandatory)]
        [AppName[]] $AppToRamDisk
    )

    process
    {
        $RamDiskPath = Get-DrivePath -Name $RamDiskName | Select-Object -First 1
        $RamDiskUserProfilePath = "$RamDiskPath\$((Get-LoggedOnUserInfo).UserName)"
        $DataToSymlink = Get-DataToSymlink -RamDiskPath $RamDiskUserProfilePath -Data $AppToRamDisk
        $SymbolicLinksPair = New-SymbolicLinksPair -Data $DataToSymlink

        if (Test-Path -Path $RamDiskPath)
        {
            if (-not (Test-Path -Path $RamDiskUserProfilePath))
            {
                # Copy the items if not a symlink and not in persistent folder.
                # i.e. Save installed extensions if used on current installation.
                Copy-BraveDataForSymlink -Name $DataToSymlink.BraveException.Data.Directory -Action 'Backup'

                New-RamDiskUserProfile -Path $RamDiskUserProfilePath
                $SymbolicLinksPair | New-SymbolicLink
            }
        }
        else
        {
            # Brave/VSCode will fail to launch if the RamDisk creation failed.
            Remove-SymbolicLink -Path $SymbolicLinksPair.Path
            Copy-BraveDataForSymlink -Name $DataToSymlink.BraveException.Data.Directory -Action 'Restore'

        }

        if ($AppToRamDisk.Contains([AppName]::Brave))
        {
            Copy-BravePersistentData -Action 'Restore'
        }
    }
}
