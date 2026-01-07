@{
    RootModule        = 'logged_on_user_info.psm1'
    ModuleVersion     = '0.0.1'
    GUID              = '80cced54-f708-42d0-8b9a-8dfb9dcdcbc6'
    PowerShellVersion = '7.5'

    RequiredModules = @()

    NestedModules = @()

    FunctionsToExport = @(
        'Get-LoggedOnUserEnvVariable'
        'Get-LoggedOnUserInfo'
        'Get-LoggedOnUserItemPropertyValue'
        'Get-LoggedOnUserShellFolder'
        'Get-UserInfo'
        'Get-UserSid'
        'Invoke-RegLoadUserHive'
    )
    CmdletsToExport   = @()
    VariablesToExport = @()
    AliasesToExport   = @()
}
