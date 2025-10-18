#=================================================================================================================
#                                             Brave Browser Path Info
#=================================================================================================================

<#
.SYNTAX
    Get-BraveBrowserPathInfo [<CommonParameters>]
#>

function Get-BraveBrowserPathInfo
{
    [CmdletBinding()]
    param ()

    process
    {
        $LoggedOnUserLocalAppData = (Get-LoggedOnUserEnvVariable).LOCALAPPDATA
        $BraveAppDataPath = "$LoggedOnUserLocalAppData\BraveSoftware\Brave-Browser"

        $BraveLocalStateFilePath = "$BraveAppDataPath\User Data\Local State"
        $BraveLocalState = Get-Content -Raw -Path $BraveLocalStateFilePath -ErrorAction 'SilentlyContinue' | ConvertFrom-Json
        $ProfileNames = if ($BraveLocalState.Profile.profiles_order) { $BraveLocalState.Profile.profiles_order } else { @('Default') }

        $BravePathInfo = @{
            LocalAppData   = $BraveAppDataPath
            UserData       = "$BraveAppDataPath\User Data"
            PersistentData = "$BraveAppDataPath\User Data Persistent"
            ProfileNames  = $ProfileNames
        }
        $BravePathInfo
    }
}
