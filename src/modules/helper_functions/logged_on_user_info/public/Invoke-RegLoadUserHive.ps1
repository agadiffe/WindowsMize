#=================================================================================================================
#                                                 Load User Hive
#=================================================================================================================

<#
.SYNTAX
    Invoke-RegLoadUserHive
        -Sid <string>
        [<CommonParameters>]
#>

function Invoke-RegLoadUserHive
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Sid
    )

    process
    {
        $UserRegPath = "HKEY_USERS\$Sid"
        if (-not (Test-Path -Path "Registry::$UserRegPath"))
        {
            $ProfileRegPath = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\$Sid"
            $ProfilePath = Get-ItemPropertyValue -Path "Registry::$ProfileRegPath" -Name 'ProfileImagePath'
            $ProfileFilePath = "$ProfilePath\NTUSER.DAT" 

            if (-not (Test-Path -Path $ProfileFilePath))
            {
                Write-Error -Message "Error: User registry Hive not found. Cannot be loaded. File path: $ProfileFilePath"
                exit
            }
            reg.exe LOAD $UserRegPath $ProfileFilePath | Out-Null
        }
    }
}
