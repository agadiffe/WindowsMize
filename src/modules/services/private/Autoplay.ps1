#=================================================================================================================
#                                               Services - Autoplay
#=================================================================================================================

$ServicesList += @{
    Autoplay = @(
        @{
            DisplayName = 'Shell Hardware Detection'
            ServiceName = 'ShellHWDetection'
            StartupType = 'Disabled'
            DefaultType = 'Automatic'
            Comment     = 'autoplay.
                           settings > bluetooth & devices > autoplay.
                           seems to be needed by bitlocker ?'
        }
    )
}
