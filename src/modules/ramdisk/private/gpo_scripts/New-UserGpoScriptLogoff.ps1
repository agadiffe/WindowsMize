#=================================================================================================================
#                                         New User GPO Script User Logoff
#=================================================================================================================

<#
.SYNTAX
    New-UserGpoScriptLogoff
        [-FilePath] <string>
        [[-VerboseMsg] <string>]
        [<CommonParameters>]
#>

function New-UserGpoScriptLogoff
{
    <#
    .EXAMPLE
        PS> New-UserGpoScriptLogoff -FilePath 'C:\MyScript.ps1' -VerboseMsg 'Backup Brave Persistent Data'
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

        $LogoffScriptParam = @{
            FilePath = $FilePath
            Type     = 'Logoff'
        }
        Remove-UserGpoScript @LogoffScriptParam
        New-UserGpoScript @LogoffScriptParam
    }
}
