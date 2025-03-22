#=================================================================================================================
#                                  Personnalization > Colors > Choose Your Mode
#=================================================================================================================

<#
.SYNTAX
    Set-ColorsTheme
        [-Value] {Dark | Light}
        [<CommonParameters>]

    Set-ColorsTheme
        -Apps {Dark | Light}
        -System {Dark | Light}
        [<CommonParameters>]
#>

function Set-ColorsTheme
{
    <#
    .EXAMPLE
        PS> Set-ColorsTheme -Value 'Dark'

    .EXAMPLE
        PS> Set-ColorsTheme -System 'Dark' -Apps 'Dark'
    #>

    [CmdletBinding(DefaultParameterSetName = 'Theme')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'Theme')]
        [ColorsTheme] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [ColorsTheme] $Apps,

        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [ColorsTheme] $System
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Theme')
        {
            $Apps = $System = $Value
        }

        # light: 1 (default) | dark: 0
        $ColorsTheme = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
            Entries = @(
                @{
                    Name  = 'AppsUseLightTheme'
                    Value = [int]$Apps
                    Type  = 'DWord'
                }
                @{
                    Name  = 'SystemUsesLightTheme'
                    Value = [int]$System
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Colors - Choose Your Mode' to 'Apps: $Apps, System: $System' ..."
        Set-RegistryEntry -InputObject $ColorsTheme
    }
}
