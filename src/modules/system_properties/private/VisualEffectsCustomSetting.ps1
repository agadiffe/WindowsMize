#=================================================================================================================
#                           System Properties - Advanced > Performance > Visual Effects
#=================================================================================================================

class VisualEffectsCustomSetting : Hashtable
{
    static $VisualEffects = @{
        ByteBitFlag = @(
            'Animate controls and elements inside windows'
            'Fade or slide menus into view'
            'Fade or slide ToolTips into view'
            'Fade out menu items after clicking'
            'Show shadows under mouse pointer'
            'Show shadows under windows'
            'Slide open combo boxes'
            'Smooth-scroll list boxes'
        )
        RegEntry = @(
            'Animate windows when minimizing and maximizing'
            'Animations in the taskbar'
            'Enable Peek'
            'Save taskbar thumbnail previews'
            'Show thumbnails instead of icons'
            'Show translucent selection rectangle'
            'Show window contents while dragging'
            'Smooth edges of screen fonts'
            'Use drop shadows for icon labels on the desktop'
        )
    }

    VisualEffectsCustomSetting([hashtable]$Settings) : base($Settings)
    {
        $this.ValidateSettings($Settings)
    }

    hidden [void] ValidateSettings([hashtable]$Settings)
    {
        $AllVisualEffects = [VisualEffectsCustomSetting]::VisualEffects.Values.ForEach({ $_ })
        $AllowedKeyValue = 'Disabled', 'Enabled'

        foreach ($Key in $Settings.Keys)
        {
            if ($AllVisualEffects -notcontains $Key)
            {
                throw "Invalid key: $Key. Specify one of the following value: $($AllVisualEffects -join ', ')"
            }
            if ($AllowedKeyValue -notcontains $Settings.$Key)
            {
                throw "Invalid value '$($Settings.$Key)' for the key '$Key'." +
                      "Specify one of the following value: $($AllowedKeyValue -join ', ')"
            }
        }
    }
}

class VisualEffectsByteBitFlag : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return [VisualEffectsCustomSetting]::VisualEffects.ByteBitFlag
    }
}

class VisualEffectsRegEntry : System.Management.Automation.IValidateSetValuesGenerator
{
    [string[]] GetValidValues()
    {
        return [VisualEffectsCustomSetting]::VisualEffects.RegEntry
    }
}

<#
.SYNTAX
    Set-VisualEffectsCustomSetting
        [-Setting] <VisualEffectsCustomSetting>
        [<CommonParameters>]
#>

function Set-VisualEffectsCustomSetting
{
    <#
    .EXAMPLE
        PS> $VisualEffectsCustomSettings = @{
                'Animations in the taskbar'       = 'Enabled'
                'Enable Peek'                     = 'Enabled'
                'Save taskbar thumbnail previews' = 'Disabled'
            }
        PS> Set-VisualEffectsCustomSetting -Setting $VisualEffectsCustomSettings
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [VisualEffectsCustomSetting] $Setting
    )

    process
    {
        $VisualEffectsCustomSettingByteBitFlag = [System.Collections.ArrayList]::new()
        $VisualEffectsCustomSettingRegEntry = [System.Collections.ArrayList]::new()

        switch ($Setting.Keys)
        {
            { [VisualEffectsCustomSetting]::VisualEffects.ByteBitFlag -contains $_ }
            {
                $VisualEffectsCustomSettingByteBitFlag.Add([PSCustomObject]@{
                    Name  = $_
                    State = $Setting.$_
                }) | Out-Null
            }
            { [VisualEffectsCustomSetting]::VisualEffects.RegEntry -contains $_ }
            {
                $VisualEffectsCustomSettingRegEntry.Add([PSCustomObject]@{
                    Name  = $_
                    State = $Setting.$_
                }) | Out-Null
            }
        }

        if ($VisualEffectsCustomSettingByteBitFlag.Count)
        {
            $VisualEffectsCustomSettingByteBitFlag | Set-VisualEffectsCustomSettingByteBitFlag
        }
        if ($VisualEffectsCustomSettingRegEntry.Count)
        {
            $VisualEffectsCustomSettingRegEntry | Set-VisualEffectsCustomSettingRegistryEntry
        }
    }
}


<#
.SYNTAX
    Set-VisualEffectsCustomSettingByteBitFlag
        [-Name] {Animate controls and elements inside windows | Fade or slide menus into view |
                 Fade or slide ToolTips into view | Fade out menu items after clicking |
                 Show shadows under mouse pointer | Show shadows under windows | Slide open combo boxes |
                 Smooth-scroll list boxes}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsCustomSettingByteBitFlag
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsCustomSettingByteBitFlag -Name 'Smooth-scroll list boxes' -State 'Enabled'

    .NOTES
        UserPreferencesMask Binary value
        1001???0 00?1??10 00000?11 10000100 000100?0 00000000 00000000 00000000
            |||    | ||        |                  |
            ABC    D EF        G                  H

        A: Smooth-scroll list boxes
        B: Slide open combo boxes
        C: Fade or slide menus into view
        D: Show shadows under mouse pointer
        E: Fade or slide ToolTips into view
        F: Fade out menu items after clicking
        G: Show shadows under windows
        H: Animate controls and elements inside windows
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet([VisualEffectsByteBitFlag])]
        [string] $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [state] $State
    )

    begin
    {
        $VisualEffectsRegPath = 'Control Panel\Desktop'
        $VisualEffectsBytes = Get-LoggedOnUserItemPropertyValue -Path $VisualEffectsRegPath -Name 'UserPreferencesMask'
    }

    process
    {
        Write-Verbose -Message "Setting Visual Effect '$Name' to '$State' ..."

        $ByteNum, $BitPos = switch ($Name)
        {
            'Smooth-scroll list boxes'                     { 0, 4 }
            'Slide open combo boxes'                       { 0, 3 }
            'Fade or slide menus into view'                { 0, 2 }
            'Show shadows under mouse pointer'             { 1, 6 }
            'Fade or slide ToolTips into view'             { 1, 4 }
            'Fade out menu items after clicking'           { 1, 3 }
            'Show shadows under windows'                   { 2, 3 }
            'Animate controls and elements inside windows' { 4, 2 }
        }

        Set-ByteBitFlag -Bytes $VisualEffectsBytes -ByteNum $ByteNum -BitPos $BitPos -State ($State -eq 'Enabled')
    }

    end
    {
        $VisualEffectsCustomSettings = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'UserPreferencesMask'
                    Value = $VisualEffectsBytes
                    Type  = 'Binary'
                }
            )
        }
        Write-Verbose -Message "Visual Effects 'Byte Bit Flag':"
        Set-RegistryEntry -InputObject $VisualEffectsCustomSettings
    }
}


<#
.SYNTAX
    Set-VisualEffectsCustomSettingRegistryEntry
        [-Name] {Animate windows when minimizing and maximizing | Animations in the taskbar | Enable Peek |
                 Save taskbar thumbnail previews | Show thumbnails instead of icons |
                 Show translucent selection rectangle | Show window contents while dragging |
                 Smooth edges of screen fonts | Use drop shadows for icon labels on the desktop}
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-VisualEffectsCustomSettingRegistryEntry
{
    <#
    .EXAMPLE
        PS> Set-VisualEffectsCustomSettingRegistryEntry -Name 'Show thumbnails instead of icons' -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [ValidateSet([VisualEffectsRegEntry])]
        [string] $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [state] $State
    )

    begin
    {
        $VisualEffectsCustomSettings = [System.Collections.ArrayList]::new()
    }

    process
    {
        Write-Verbose -Message "Setting Visual Effect '$Name' to '$State' ..."

        $Value = $State -eq 'Enabled' ? '1' : '0'
        switch ($Name)
        {
            'Animate windows when minimizing and maximizing'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\Desktop\WindowMetrics'
                    Entries = @(
                        @{
                            Name  = 'MinAnimate'
                            Value = $Value
                            Type  = 'String'
                        }
                    )
                }) | Out-Null
            }
            'Animations in the taskbar'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'TaskbarAnimations'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
            'Enable Peek'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\DWM'
                    Entries = @(
                        @{
                            Name  = 'EnableAeroPeek'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
            'Save taskbar thumbnail previews'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\DWM'
                    Entries = @(
                        @{
                            Name  = 'AlwaysHibernateThumbnails'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
            'Show thumbnails instead of icons'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'IconsOnly'
                            Value = $State -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
            'Show translucent selection rectangle'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'ListviewAlphaSelect'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
            'Show window contents while dragging'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\Desktop'
                    Entries = @(
                        @{
                            Name  = 'DragFullWindows'
                            Value = $Value
                            Type  = 'String'
                        }
                    )
                }) | Out-Null
            }
            'Smooth edges of screen fonts'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\Desktop'
                    Entries = @(
                        @{
                            Name  = 'FontSmoothing'
                            Value = $State -eq 'Enabled' ? '2' : '0'
                            Type  = 'String'
                        }
                    )
                }) | Out-Null
            }
            'Use drop shadows for icon labels on the desktop'
            {
                $VisualEffectsCustomSettings.Add([PSCustomObject]@{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
                    Entries = @(
                        @{
                            Name  = 'ListviewShadow'
                            Value = $Value
                            Type  = 'DWord'
                        }
                    )
                }) | Out-Null
            }
        }
    }

    end
    {
        Write-Verbose -Message "Visual Effects 'Registry Entries':"
        $VisualEffectsCustomSettings | Set-RegistryEntry
        Write-Verbose -Message "End of Visual Effects 'Registry Entries'"
    }
}
