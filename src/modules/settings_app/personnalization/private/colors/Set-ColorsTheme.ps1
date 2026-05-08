#=================================================================================================================
#                                  Personnalization > Colors > Choose Your Mode
#=================================================================================================================

<#
.SYNTAX
    Set-ColorsTheme
        [-Mode] {Dark | Light}
        [<CommonParameters>]

    Set-ColorsTheme
        [-Apps {Dark | Light}]
        [-System {Dark | Light}]
        [<CommonParameters>]
#>

function Set-ColorsTheme
{
    <#
    .EXAMPLE
        PS> Set-ColorsTheme -Mode 'Dark'

    .EXAMPLE
        PS> Set-ColorsTheme -System 'Dark' -Apps 'Dark'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Theme')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Theme')]
        [ColorsTheme] $Mode,

        [Parameter(ParameterSetName = 'Custom')]
        [ColorsTheme] $Apps,

        [Parameter(ParameterSetName = 'Custom')]
        [ColorsTheme] $System
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Theme')
        {
            $PSBoundParameters['Apps'] = $Mode
            $PSBoundParameters['System'] = $Mode
        }

        # light: 1 (default) | dark: 0

        switch ($PSBoundParameters.Keys)
        {
            'Apps'
            {
                $ColorsAppsTheme = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
                    Entries = @(
                        @{
                            Name  = 'AppsUseLightTheme'
                            Value = [int]$PSBoundParameters['Apps']
                            Type  = 'DWord'
                        }
                    )
                }
                Write-Verbose -Message "Setting 'Colors - Choose Your Mode' to 'Apps: $($PSBoundParameters['Apps'])' ..."
                Set-RegistryEntry -InputObject $ColorsAppsTheme
            }
            'System'
            {
                $ColorsSystemTheme = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
                    Entries = @(
                        @{
                            Name  = 'SystemUsesLightTheme'
                            Value = [int]$PSBoundParameters['System']
                            Type  = 'DWord'
                        }
                    )
                }
                Write-Verbose -Message "Setting 'Colors - Choose Your Mode' to 'System: $($PSBoundParameters['System'])' ..."
                Set-RegistryEntry -InputObject $ColorsSystemTheme
            }
        }
    }
}
