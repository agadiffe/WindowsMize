#=================================================================================================================
#                                               Startup Apps Delay
#=================================================================================================================

<#
.SYNTAX
    Set-StartupAppsDelay
        -Value <second>
        [<CommonParameters>]

    Set-StartupAppsDelay
        -Default
        [<CommonParameters>]
#>

function Set-StartupAppsDelay
{
    <#
    .EXAMPLE
        PS> Set-StartupAppsDelay -Value 2

    .EXAMPLE
        PS> Set-StartupAppsDelay -Default
    #>

    [CmdletBinding(DefaultParameterSetName = 'Custom')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [ValidateRange(0, 45)]
        [int] $Value,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [switch] $Default
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Default' -and $Default -eq $false)
        {
            return
        }

        # default (delete): about 10s / some idle state threehold
        $StartupAppsDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize'
            Entries = @(
                @{
                    RemoveEntry = $Default
                    Name  = 'Startupdelayinmsec'
                    Value = $Value * 1000 + 100
                    Type  = 'DWord'
                }
                @{
                    RemoveEntry = $Default
                    Name  = 'WaitForIdleState'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        $StateMsg = $Default ? 'Default' : "$Value ms"
        Write-Verbose -Message "Setting 'Startup Apps Delay' to '$StateMsg' ..."
        Set-RegistryEntry -InputObject $StartupAppsDelay 
    }
}
