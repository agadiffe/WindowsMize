#=================================================================================================================
#                                    Bluetooth & Devices > Devices - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-MouseSetting
        [-PrimaryButton {Left | Right}]
        [-PointerSpeed <int>]
        [-EnhancedPointerPrecision {Disabled | Enabled}]
        [-WheelScroll {MultipleLines | OneScreen}]
        [-WheelScrollLinesToScroll <int>]
        [-ScrollInactiveWindowsOnHover {Disabled | Enabled}]
        [-ScrollingDirection {DownMotionScrollsDown | DownMotionScrollsUp}]
        [<CommonParameters>]
#>

function Set-MouseSetting
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            [-WheelScrollLinesToScroll <int>] : available when 'WheelScroll' is defined to 'MultipleLines'.

    .EXAMPLE
        PS> Set-MouseSetting -PrimaryButton 'Left' -PointerSpeed 10 -WheelScroll 'MultipleLines'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [MouseButtonMode] $PrimaryButton,

        [ValidateRange(1, 20)]
        [int] $PointerSpeed,

        [state] $EnhancedPointerPrecision,

        [WheelScrollMode] $WheelScroll,

        [state] $ScrollInactiveWindowsOnHover,

        [ScrollingDirectionMode] $ScrollingDirection
    )

    dynamicparam
    {
        if ($WheelScroll -eq 'MultipleLines')
        {
            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Name       = 'LinesToScroll'
                Type       = [int]
                Attribute  = @{ ValidateRange = 1, 100 }
            }
            Add-DynamicParameter @DynamicParamProperties
            $ParamDictionary
        }
    }

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'PrimaryButton'                { Set-MousePrimaryButton -Value $PrimaryButton }
            'PointerSpeed'                 { Set-MousePointerSpeed -Value $PointerSpeed }
            'EnhancedPointerPrecision'     { Set-MouseEnhancedPointerPrecision -State $EnhancedPointerPrecision }
            'ScrollInactiveWindowsOnHover' { Set-MouseScrollInactiveWindowsOnHover -State $ScrollInactiveWindowsOnHover }
            'ScrollingDirection'           { Set-MouseScrollingDirection -Value $ScrollingDirection }

            'WheelScroll'
            {
                $LinesToScrollValue = $PSBoundParameters.ContainsKey('LinesToScroll') ? $PSBoundParameters.LinesToScroll : 3
                Set-MouseWheelScroll -Value $WheelScroll -LinesToScroll $LinesToScrollValue
            }
        }
    }
}
