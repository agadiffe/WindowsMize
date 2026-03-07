#=================================================================================================================
#                                    Bluetooth & Devices > Keyboard - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardSetting
        [-PrintScreenKeyOpenScreenCapture {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-KeyboardSetting
{
    <#
    .EXAMPLE
        PS> Set-KeyboardSetting -PrintScreenKeyOpenScreenCapture 'Enabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $PrintScreenKeyOpenScreenCapture
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'PrintScreenKeyOpenScreenCapture' { Set-KeyboardPrintScreenKeyOpenScreenCapture -State $PrintScreenKeyOpenScreenCapture }
        }
    }
}
