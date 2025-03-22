#=================================================================================================================
#                                            Services - Windows Search
#=================================================================================================================

$ServicesList += @{
    WindowsSearch = @(
        @{
            DisplayName = "Windows Search"
            ServiceName = "WSearch"
            StartupType = "Disabled"
            DefaultType = "AutomaticDelayedStart"
            Comment     = "search indexing & files search in start menu.
                           search still available in file explorer (without index).
                           settings > privacy & security > searching windows."
        }
    )
}
