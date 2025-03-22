#=================================================================================================================
#                                    New Script : Backup Brave Persistent Data
#=================================================================================================================

<#
  The purpose is to save the files that doesn't work when symlinked.
  'Favicons' works fine when symlinked, but some others doesn't.
  e.g. 'Bookmarks', 'Preferences', 'Secure Preferences', 'Locate State'

  Copy these files from the RamDisk to the persistent path on user logout.
  Copy them back to the ramdisk on user logon.
#>

<#
  gpo\ User Configuration > Windows Settings > Scripts (logon/logoff)
  As with policies done via regedit, this script will not be displayed in Group Policy Editor.
  If you add a script in the Group Policy Editor, this one (backup Brave data) will be removed.
#>

<#
.SYNTAX
    New-ScriptBackupBravePersistentData
        [-FilePath] <string>
        [<CommonParameters>]
#>

function New-ScriptBackupBravePersistentData
{
    <#
    .EXAMPLE
        PS> New-ScriptBackupBravePersistentData -FilePath 'C:\MyScript.ps1'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $FilePath
    )

    process
    {
        Write-Verbose -Message 'Setting ''Backup Brave Persistent Data'' Script ...'

        New-ParentPath -Path $FilePath
        Write-ScriptBackupBravePersistentData | Out-File -FilePath $FilePath
    }
}
