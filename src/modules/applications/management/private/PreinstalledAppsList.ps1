#=================================================================================================================
#                                         Preinstalled Applications List
#=================================================================================================================

$PreinstalledAppsList = [ordered]@{
    BingSearch       = 'Microsoft.BingSearch'
    Calculator       = 'Microsoft.WindowsCalculator'
    Camera           = 'Microsoft.WindowsCamera'
    Clipchamp        = 'Clipchamp.Clipchamp'
    Clock            = 'Microsoft.WindowsAlarms'
    Compatibility    = 'Microsoft.ApplicationCompatibilityEnhancements'
    Cortana          = 'Microsoft.549981C3F5F10' # old
    CrossDevice      = 'MicrosoftWindows.CrossDevice'
    DevHome          = 'Microsoft.Windows.DevHome' # old
    EdgeGameAssist   = 'Microsoft.Edge.GameAssist'
    Extensions       = @(
                       'Microsoft.AV1VideoExtension'
                       'Microsoft.AVCEncoderVideoExtension'
                       'Microsoft.HEIFImageExtension'
                       'Microsoft.HEVCVideoExtension'
                       'Microsoft.MPEG2VideoExtension'
                       'Microsoft.RawImageExtension'
                       'Microsoft.VP9VideoExtensions'
                       'Microsoft.WebMediaExtensions'
                       'Microsoft.WebpImageExtension'
                     )
    Family           = 'MicrosoftCorporationII.MicrosoftFamily'
    FeedbackHub      = 'Microsoft.WindowsFeedbackHub'
    GetHelp          = 'Microsoft.GetHelp'
    Journal          = 'Microsoft.MicrosoftJournal'
    MailAndCalendar  = 'microsoft.windowscommunicationsapps' # old
    Maps             = 'Microsoft.WindowsMaps' # old
    MediaPlayer      = 'Microsoft.ZuneMusic'
    Microsoft365     = 'Microsoft.MicrosoftOfficeHub'
    Microsoft365Companions = 'Microsoft.M365Companions'
    MicrosoftCopilot = @(
                       'Microsoft.Copilot'
                       'Microsoft.Windows.Ai.Copilot.Provider'
                       'Microsoft.Windows.Copilot'
                       'MicrosoftWindows.Client.CoPilot'
                     )
    MicrosoftStore   = @(
                       'Microsoft.Services.Store.Engagement'
                       'Microsoft.StorePurchaseApp'
                       'Microsoft.WindowsStore'
                     )
    MicrosoftTeams   = @(
                       'MSTeams'
                       'MicrosoftTeams' # old
                     )
    MoviesAndTV      = 'Microsoft.ZuneVideo' # old
    News             = 'Microsoft.BingNews'
    Notepad          = 'Microsoft.WindowsNotepad'
    Outlook          = 'Microsoft.OutlookForWindows'
    Paint            = @(
                       'Microsoft.Paint'
                       'Microsoft.Windows.MSPaint' # Win10
                     )
    People           = 'Microsoft.People' # old
    PhoneLink        = 'Microsoft.YourPhone'
    Photos           = 'Microsoft.Windows.Photos'
    PowerAutomate    = 'Microsoft.PowerAutomateDesktop'
    QuickAssist      = @(
                       'MicrosoftCorporationII.QuickAssist'
                       'App.Support.QuickAssist' # Win10
                     )
    SnippingTool     = @(
                       'Microsoft.ScreenSketch'
                       'Microsoft.Windows.SnippingTool' # old
                       'Microsoft-SnippingTool' # Win10
                     )
    Solitaire        = 'Microsoft.MicrosoftSolitaireCollection'
    SoundRecorder    = 'Microsoft.WindowsSoundRecorder'
    StickyNotes      = 'Microsoft.MicrosoftStickyNotes'
    Terminal         = 'Microsoft.WindowsTerminal'
    Tips             = 'Microsoft.Getstarted'
    Todo             = 'Microsoft.Todos'
    Weather          = 'Microsoft.BingWeather'
    Whiteboard       = 'Microsoft.Whiteboard'
    Widgets          = @(
                       'MicrosoftWindows.Client.WebExperience'
                       'Microsoft.WidgetsPlatformRuntime'
                       'Microsoft.StartExperiencesApp'
                     )
    Xbox             = @( # might be required for some games
                       'Microsoft.GamingApp'
                       'Microsoft.XboxApp' # old & Win10
                       'Microsoft.Xbox.TCUI'
                       'Microsoft.XboxGameOverlay'
                       'Microsoft.XboxGamingOverlay'
                       'Microsoft.XboxIdentityProvider'
                       'Microsoft.XboxSpeechToTextOverlay'
                     )

    # Windows 10 only
    '3DViewer'       = 'Microsoft.Microsoft3DViewer' # old
    MixedReality     = 'Microsoft.MixedReality.Portal' # old
    OneNote          = 'Microsoft.Office.OneNote'
    Paint3D          = 'Microsoft.MSPaint' # old
    Skype            = 'Microsoft.SkypeApp' # old
    Wallet           = 'Microsoft.Wallet' # old
}
