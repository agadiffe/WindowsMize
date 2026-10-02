#=================================================================================================================
#                                              Services - Overrides
#=================================================================================================================

<#
  Use this file to override services StartupType defined by WindowsMize in "src\modules\services\private".

  The overrides works only if the service StartupType is actually used as part of the script.
  For example, "IP Helper (iphlpsvc)" is in the "Network" section (network.ps1), if you comment
  that section in services_and_scheduled_tasks.ps1 (#'Network'), the override will do nothing.

  Comment the StartupType line to keep a list of services without editing their settings.
  Rename this file if you don't want any StartupType overrides.
#>

$ServiceOverrides = @(
    # Miscellaneous
    @{
        DisplayName = 'Human Interface Device Service'
        ServiceName = 'hidserv'
        #StartupType = 'Disabled'
    }

    # Network
    @{
        DisplayName = 'IP Helper'
        ServiceName = 'iphlpsvc'
        #StartupType = 'Disabled'
    }
)
