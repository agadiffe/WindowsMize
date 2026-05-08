#=================================================================================================================
#                                               Startup Apps Delay
#=================================================================================================================

<#
.SYNTAX
    Set-StartupAppsDelay
        -Seconds <int>
        [<CommonParameters>]

    Set-StartupAppsDelay
        -Default
        [<CommonParameters>]
#>

function Set-StartupAppsDelay
{
    <#
    .EXAMPLE
        PS> Set-StartupAppsDelay -Seconds 2

    .EXAMPLE
        PS> Set-StartupAppsDelay -Default
    #>

    [CmdletBinding(DefaultParameterSetName = 'Custom')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'Custom')]
        [ValidateRange(0, 45)]
        [int] $Seconds,

        [Parameter(Mandatory, ParameterSetName = 'Default')]
        [switch] $Default
    )

    process
    {
        if ($PSCmdlet.ParameterSetName -eq 'Default' -and -not $Default)
        {
            return
        }

        # default (delete): about 10s / some idle state threshold
        $StartupAppsDelay = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize'
            Entries = @(
                @{
                    RemoveEntry = $Default
                    Name  = 'Startupdelayinmsec'
                    Value = $Seconds * 1000 + 100
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

        $ValueMsg = $Default ? 'Default' : "$Seconds seconds"
        Write-Verbose -Message "Setting 'Startup Apps Delay' to '$ValueMsg' ..."
        Set-RegistryEntry -InputObject $StartupAppsDelay 
    }
}
