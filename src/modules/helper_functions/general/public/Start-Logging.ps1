#=================================================================================================================
#                                         Helper Function - Start Logging
#=================================================================================================================

<#
.SYNTAX
    Start-Logging [<CommonParameters>]
#>

function Start-Logging
{
    <#
    .EXAMPLE
        PS> Start-Logging
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FileName
    )

    process
    {
        $LogFilePath = "$(Get-LogPath -User)\$FileName-$(Get-Date -Format 'yyyy-MM-ddTHH-mm-ss').log"
        Start-Transcript -Path $LogFilePath
    }
}
