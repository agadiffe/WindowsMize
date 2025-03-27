#=================================================================================================================
#                                             Brave Browser Path Info
#=================================================================================================================

function Get-BraveBrowserPathInfo
{
    $LoggedOnUserLocalAppData = (Get-LoggedOnUserEnvVariable).LOCALAPPDATA
    $BraveAppDataPath = "$LoggedOnUserLocalAppData\BraveSoftware\Brave-Browser"

    $BraveLocalStateFilePath = "$BraveAppDataPath\User Data\Local State"
    $BraveLocalState = Get-Content -Raw -Path $BraveLocalStateFilePath -ErrorAction 'SilentlyContinue' | ConvertFrom-Json
    $ProfilesNames = $BraveLocalState.Profile.profiles_order ? $BraveLocalState.Profile.profiles_order : @('Default')

    $BravePathInfo = @{
        LocalAppData   = $BraveAppDataPath
        UserData       = "$BraveAppDataPath\User Data"
        PersistentData = "$BraveAppDataPath\User Data Persistent"
        ProfilesNames  = $ProfilesNames
    }
    $BravePathInfo
}
