#=================================================================================================================
#                                           Start Menu Webview2 Version
#=================================================================================================================

# Task Manager:
#   Webview2 version: idle ~ 175MB (SearchHost.exe + msedgewebview2.exe processes) (does not "suspend", can be in efficiency mode)
#   Previous version: idle ~ 100MB (SearchHost.exe) (can be "suspended" (i.e. will use 0MB when not in use))

<#
.SYNTAX
    Set-StartMenuWebview2Version
        [-State] {Enabled | Disabled}
        [<CommonParameters>]
#>

function Set-StartMenuWebview2Version
{
    <#
    .EXAMPLE
        PS> Set-StartMenuWebview2Version -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        Write-Verbose -Message "Setting 'Start Menu Webview2 Version' to '$State' ..."

        $FeatureOverrideId = '1694661260'

        Remove-FeatureManagementOverride -FeatureId $FeatureOverrideId

        if ($State -eq 'Disabled')
        {
            # on: delete (default) | off: 1 0
            $StartMenuWebview2Version = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = "SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\8\$FeatureOverrideFlag"
                Entries = @(
                    @{
                        Name  = 'EnabledState'
                        Value = '1'
                        Type  = 'DWord'
                    }
                    @{
                        Name  = 'EnabledStateOptions'
                        Value = '0'
                        Type  = 'DWord'
                    }
                )
            }

            Set-RegistryEntry -InputObject $StartMenuWebview2Version
        }
    }
}


<#
.SYNTAX
    Remove-FeatureManagementOverride
        [-FeatureID] <int>
        [<CommonParameters>]
#>

function Remove-FeatureManagementOverride
{
    <#
    .EXAMPLE
        PS> Remove-FeatureManagementOverride -FeatureId '1694661260'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [ValidateRange('NonNegative')]
        [int] $FeatureId
    )

    process
    {
        # https://github.com/thebookisclosed/ViVe/blob/master/ViVe/NativeEnums.cs

        $OverridesRegPath = 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\FeatureManagement\Overrides\*'
        $CurrentOverrides = (Get-ChildItem -Path "Registry::$OverridesRegPath" -Recurse | Where-Object -FilterScript {
            @(2, 4, 6, 8, 10, 12) -contains (Split-Path -Path $_.PSParentPath -Leaf) -and
            $_.PSChildName -eq $FeatureId
        }).Name

        if ($CurrentOverrides)
        {
            Write-Verbose -Message "  remove: $OverridesRegPath\$FeatureId"
            Remove-Item -Path $CurrentOverrides.ForEach({ "Registry::$_" })
        }
    }
}
