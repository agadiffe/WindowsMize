#=================================================================================================================
#                                               Set Data To RamDisk
#=================================================================================================================

<#
.SYNTAX
    Set-DataToRamDisk
        -RamDiskName <string>
        -AppToRamDisk {Brave | BraveCache | VSCode}
        [<CommonParameters>]

    Set-DataToRamDisk
        -AppToRamDisk {Brave | BraveCache | VSCode}
        -Remove
        [<CommonParameters>]
#>

function Set-DataToRamDisk
{
    <#
    .EXAMPLE
        PS> Set-DataToRamDisk -RamDiskName 'RamDisk' -AppToRamDisk 'Brave', 'VSCode'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Set')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Set')]
        [string] $RamDiskName,

        [Parameter(Mandatory)]
        [AppName[]] $AppToRamDisk,

        [Parameter(Mandatory, ParameterSetName = 'Remove')]
        [switch] $Remove
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Remove' -and -not $Remove)
        {
            return
        }

        $RamDiskPath = $Remove ? $null : (Get-DrivePath -Name $RamDiskName | Select-Object -First 1)
        $RamDiskUserProfilePath = "$RamDiskPath\$((Get-LoggedOnUserInfo)['UserName'])"
        $DataToSymlink = Get-DataToSymlink -RamDiskPath $RamDiskUserProfilePath -Data $AppToRamDisk
        $SymbolicLinksPair = New-SymbolicLinksPair -Data $DataToSymlink

        if ($IsBraveAppToRamDisk = $AppToRamDisk.Contains([AppName]::Brave))
        {
            $BraveExceptionFolders = $DataToSymlink['BraveException']['Data']['Directory']
        }

        if ($RamDiskPath)
        {
            if (-not (Test-Path -Path $RamDiskUserProfilePath))
            {
                if ($IsBraveAppToRamDisk)
                {
                    # Copy the items if not a symlink and not in persistent folder.
                    # i.e. Save installed extensions if used on existing installation.
                    Copy-BraveDataForSymlink -Name $BraveExceptionFolders -Action 'Backup'
                }

                New-RamDiskUserProfile -Path $RamDiskUserProfilePath
                $SymbolicLinksPair | New-SymbolicLink
            }
        }
        else
        {
            # Brave/VSCode will fail to launch if the RamDisk creation failed.
            Remove-SymbolicLink -Path $SymbolicLinksPair.Path
            if ($IsBraveAppToRamDisk)
            {
                Copy-BraveDataForSymlink -Name $BraveExceptionFolders -Action 'Restore'
            }

        }

        if ($IsBraveAppToRamDisk)
        {
            Copy-BravePersistentData -Action 'Restore'
        }
    }
}
