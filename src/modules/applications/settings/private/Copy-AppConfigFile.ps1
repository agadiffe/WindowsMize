#=================================================================================================================
#                                              Copy App Config File
#=================================================================================================================

<#
.SYNTAX
    Copy-AppConfigFile
        [-ConfigFileName] <string>
        [-Destination] <string>
        [<CommonParameters>]
#>

function Copy-AppConfigFile
{
    <#
    .EXAMPLE
        PS> $VlcSettingsFilePath = 'C:\Users\<User>\AppData\Roaming\vlc\vlcrc'
        PS> Copy-AppConfigFile -ConfigFileName 'VLC.ini' -Destination $VlcSettingsFilePath
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $ConfigFileName,

        [Parameter(Mandatory)]
        [string] $Destination
    )

    process
    {
        if (Test-Path -Path $Destination)
        {
            Rename-Item -Path $Destination -NewName "$Destination.old" -ErrorAction 'SilentlyContinue'
        }

        $ConfigFilePath = "$PSScriptRoot\..\config_files\$ConfigFileName"
        New-ParentPath -Path $Destination
        Copy-Item -Path $ConfigFilePath -Destination $Destination
    }
}
