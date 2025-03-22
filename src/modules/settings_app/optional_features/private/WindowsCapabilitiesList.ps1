#=================================================================================================================
#                             System > Optional Features - Windows Capabilities List
#=================================================================================================================

# Some Windows Capabilities are no longer installed by default.
# e.g. Print.Fax.Scan, WMIC, Microsoft.Windows.WordPad, XPS.Viewer

$WindowsCapabilitiesList = [ordered]@{
    ExtendedThemeContent          = 'Microsoft.Wallpapers.Extended'
    FacialRecognitionWindowsHello = 'Hello.Face.*'
    InternetExplorerMode          = 'Browser.InternetExplorer'
    MathRecognizer                = 'MathRecognizer'
    NotepadSystem                 = @(
                                    'Microsoft.Windows.Notepad.System'
                                    'Microsoft.Windows.Notepad' # Win10
                                  )
    OneSync                       = 'OneCoreUAP.OneSync'
    OpenSSHClient                 = 'OpenSSH.Client'
    PrintManagement               = 'Print.Management.Console'
    StepsRecorder                 = 'App.StepsRecorder'
    WMIC                          = 'WMIC' # deprecated
    VBScript                      = 'VBSCRIPT' # deprecated | might be required by some programs installer
    WindowsFaxAndScan             = 'Print.Fax.Scan'
    WindowsMediaPlayerLegacy      = 'Media.WindowsMediaPlayer' # might be required by some games
    WindowsPowerShellISE          = 'Microsoft.Windows.PowerShell.ISE'
    WordPad                       = 'Microsoft.Windows.WordPad' # deprecated
    XpsViewer                     = 'XPS.Viewer'
}
