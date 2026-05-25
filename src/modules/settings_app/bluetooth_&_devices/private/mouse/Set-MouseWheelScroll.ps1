#=================================================================================================================
#                          Bluetooth & Devices > Mouse > Roll The Mouse Wheel To Scroll
#=================================================================================================================

# Roll the mouse wheel to scroll
# Lines to scroll at a time

<#
.SYNTAX
    Set-MouseWheelScroll
        [-Mode] {MultipleLines | OneScreen}
        [-LinesToScroll <int>]
        [<CommonParameters>]
#>

function Set-MouseWheelScroll
{
    <#
    .EXAMPLE
        PS> Set-MouseWheelScroll -Mode 'OneScreen'

    .EXAMPLE
        PS> Set-MouseWheelScroll -Mode 'MultipleLines' -LinesToScroll 42
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [WheelScrollMode] $Mode,

        [ValidateRange(1, 100)]
        [int] $LinesToScroll = 3
    )

    process
    {
        $SettingValue = switch ($Mode)
        {
            'MultipleLines' { $LinesToScroll }
            'OneScreen'     { '-1' }
        }

        # multiple lines at times: 3 (default) (range: 1-100) | one screen at a time: -1
        $MouseWheelScroll = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Desktop'
            Entries = @(
                @{
                    Name  = 'WheelScrollLines'
                    Value = $SettingValue
                    Type  = 'String'
                }
            )
        }

        $MouseWheelScrollMsg = "$Mode$(if($Mode -eq 'MultipleLines') { " (Lines to scroll at a time: $SettingValue)" })"
        Write-Verbose -Message "Setting 'Mouse - Roll The Mouse Wheel To Scroll' to '$MouseWheelScrollMsg' ..."
        Set-RegistryEntry -InputObject $MouseWheelScroll
    }
}
