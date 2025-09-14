@{
    RootModule        = 'network.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '37ba9c0b-d6d3-4098-b984-c9c1fe15d8d8'
    PowerShellVersion = '7.5'

    RequiredModules = @(
        "$PSScriptRoot\..\helper_functions\general"
    )

    NestedModules = @(
        "$PSScriptRoot\..\helper_functions\classes\State_enums.ps1"
    )

    FunctionsToExport = @(
        'Block-NetFirewallInboundRule'
        'Export-DefaultNetAdapterProtocolsState'
        'Set-AllJoynRouterNetFirewallRule'
        'Set-DiagTrackNetFirewallRule'
        'Set-NetAdapterProtocol'
        'Set-NetBiosOverTcpIP'
        'Set-NetIcmpRedirects'
        'Set-NetIPSourceRouting'
        'Set-NetIPv6Transition'
        'Set-NetLlmnr'
        'Set-NetLmhosts'
        'Set-NetMulicastDns'
        'Set-NetProxyAutoDetectprotocol'
        'Set-NetSmhnr'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
