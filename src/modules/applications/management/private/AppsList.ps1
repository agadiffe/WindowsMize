#=================================================================================================================
#                                                Applications List
#=================================================================================================================

$AppsList = [ordered]@{
    # Development
    Git            = 'Git.Git'
    VSCode         = 'Microsoft.VisualStudioCode'

    # Multimedia
    VLC            = 'VideoLAN.VLC'

    # Password Manager
    Bitwarden      = 'Bitwarden.Bitwarden'
    KeePassXC      = 'KeePassXCTeam.KeePassXC'
    ProtonPass     = 'Proton.ProtonPass'

    # PDF Viewer
    AcrobatReader  = 'Adobe.Acrobat.Reader.64-bit'
    SumatraPDF     = 'SumatraPDF.SumatraPDF'

    # Utilities
    '7zip'         = '7zip.7zip'
    'Notepad++'    = 'Notepad++.Notepad++'
    qBittorrent    = 'qBittorrent.qBittorrent'

    # Web Browser
    Brave          = @(
                     'Brave.Brave'
                     'Brave.BraveUpdater'
                   )
    Firefox        = 'Mozilla.Firefox'
    MullvadBrowser = 'MullvadVPN.MullvadBrowser'


    # Microsoft DirectX (might be needed for older games)
    DirectXEndUserRuntime  = 'Microsoft.DirectX'

    # Microsoft Visual C++ Redistributable
    'VCRedist2015+.ARM' =
        'Microsoft.VCRedist.2015+.arm64'

    'VCRedist2015+' = @(
        'Microsoft.VCRedist.2015+.x64'
        'Microsoft.VCRedist.2015+.x86'
    )
    VCRedist2013 = @(
        'Microsoft.VCRedist.2013.x64'
        'Microsoft.VCRedist.2013.x86'
    )
    VCRedist2012 = @(
        'Microsoft.VCRedist.2012.x64'
        'Microsoft.VCRedist.2012.x86'
    )
    VCRedist2010 = @(
        'Microsoft.VCRedist.2010.x64'
        'Microsoft.VCRedist.2010.x86'
    )
    VCRedist2008 = @(
        'Microsoft.VCRedist.2008.x64'
        'Microsoft.VCRedist.2008.x86'
    )
    VCRedist2005 = @(
        'Microsoft.VCRedist.2005.x64'
        'Microsoft.VCRedist.2005.x86'
    )
}
