#=================================================================================================================
#                                             Brave Browser Path Info
#=================================================================================================================

function Get-BraveBrowserPathInfo
{
    $LoggedOnUserLocalAppData = (Get-LoggedOnUserEnvVariable).LOCALAPPDATA
    $BraveAppDataPath = "$LoggedOnUserLocalAppData\BraveSoftware\Brave-Browser"
    $BravePathInfo = @{
        LocalAppData   = $BraveAppDataPath
        UserData       = "$BraveAppDataPath\User Data"
        PersistentData = "$BraveAppDataPath\User Data Persistent"
        Profile        = "$BraveAppDataPath\User Data\Default"
    }
    $BravePathInfo
}
