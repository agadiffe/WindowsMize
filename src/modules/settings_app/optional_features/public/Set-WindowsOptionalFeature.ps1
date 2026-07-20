#=================================================================================================================
#                System > Optional Features > More Windows Features - Set Windows Optional Feature
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsOptionalFeature
        [-Name] <string>
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WindowsOptionalFeature
{
    <#
    .EXAMPLE
        PS> Set-WindowsOptionalFeature -Name 'WorkFolders-Client' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # "Get-WindowsOptionalFeature -Online" fails on PowerShell from MSIX installation: Class not registered.
        # https://github.com/PowerShell/PowerShell/issues/13866
        # "Import-Module -Name 'xxx' -UseWindowsPowerShell" import the 1.0 version ...

        $WinOptionalFeature = powershell.exe -args $Name -NoProfile -Command {
            Get-WindowsOptionalFeature -Online -FeatureName $args[0] -Verbose:$false
        }

        if (-not $WinOptionalFeature)
        {
            Write-Verbose -Message "Windows Optional Feature '$Name' not found"
            return
        }

        if ($WinOptionalFeature.State.Value -eq $State)
        {
            Write-Verbose -Message "$Name is already '$State'"
        }
        else
        {
            $OptionalFeatureOptions = @{
                NoRestart     = $true
                Verbose       = $false
                WarningAction = 'SilentlyContinue'
            }

            $StateMsg = $State -eq 'Enabled' ? 'Enabling' : 'Disabling'
            Write-Verbose -Message "$StateMsg $Name ..."

            powershell.exe -NoProfile -Command {
                param
                (
                    [ValidateSet('Disabled', 'Enabled')]
                    [string] $State,
                    [string[]] $FeatureName,
                    [hashtable] $Options
                )

                process
                {
                    switch ($State)
                    {
                        'Enabled'  { Enable-WindowsOptionalFeature -FeatureName $FeatureName -Online -All @Options | Out-Null }
                        'Disabled' { Disable-WindowsOptionalFeature -FeatureName $FeatureName -Online @Options | Out-Null }
                    }
                }
            } -Args $State, $WinOptionalFeature.FeatureName, $OptionalFeatureOptions
        }
    }
}
