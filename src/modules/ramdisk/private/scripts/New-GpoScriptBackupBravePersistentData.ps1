#=================================================================================================================
#                                  New GPO Script : Backup Brave Persistent Data
#=================================================================================================================

<#
.SYNTAX
    New-GpoScriptBackupBravePersistentData
        [-FilePath] <string>
        [<CommonParameters>]
#>

function New-GpoScriptBackupBravePersistentData
{
    <#
    .EXAMPLE
        PS> New-GpoScriptBackupBravePersistentData -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath
    )

    process
    {
        Write-Verbose -Message 'Setting ''Backup Brave Persistent Data'' GPO Script ...'
        if (-not (Test-GpoScript -Name $FilePath -Type 'Logoff'))
        {
            New-GpoScript -FilePath $FilePath -Type 'Logoff'
        }
    }
}
