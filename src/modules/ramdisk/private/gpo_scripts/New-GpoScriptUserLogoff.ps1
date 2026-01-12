#=================================================================================================================
#                                           New GPO Script User Logoff
#=================================================================================================================

<#
.SYNTAX
    New-GpoScriptUserLogoff
        [-FilePath] <string>
        [[-VerboseMsg] <string>]
        [<CommonParameters>]
#>

function New-GpoScriptUserLogoff
{
    <#
    .EXAMPLE
        PS> New-GpoScriptUserLogoff -FilePath 'C:\MyScript.ps1' -VerboseMsg 'Backup Brave Persistent Data'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath,

        [string] $VerboseMsg
    )

    process
    {
        Write-Verbose -Message "Setting '$VerboseMsg' User Logoff GPO Script ..."
        if (-not (Test-GpoScript -Name $FilePath -Type 'Logoff'))
        {
            New-GpoScript -FilePath $FilePath -Type 'Logoff'
        }
    }
}
