#=================================================================================================================
#               System > Optional Features > More Windows Features - Windows Optional Feature List
#=================================================================================================================

$WindowsOptionalFeaturesList = [ordered]@{
    InternetPrintingClient          = @( # printer in local network (or usb) do not need this feature
                                      'Printing-Foundation-InternetPrinting-Client'
                                      'Printing-Foundation-Features'
                                    )
    MediaFeatures                   = @(
                                      'WindowsMediaPlayer'
                                      'MediaPlayback'
                                    )
    MicrosoftXpsDocumentWriter      = 'Printing-XPSServices-Features'
    NetFramework48TcpPortSharing   = @(
                                      'WCF-TCP-PortSharing45'
                                      'WCF-Services45'
                                    )
    RemoteDesktopConnection         = 'Microsoft-RemoteDesktopConnection' # same as: mstsc.exe /uninstall
    RemoteDiffCompressionApiSupport = 'MSRDC-Infrastructure'
    SmbDirect                       = 'SmbDirect'
    WindowsPowerShell2              = @(
                                      'MicrosoftWindowsPowerShellV2Root'
                                      'MicrosoftWindowsPowerShellV2'
                                    )
    WindowsRecall                   = 'Recall'
    WorkFoldersClient               = 'WorkFolders-Client'
}
