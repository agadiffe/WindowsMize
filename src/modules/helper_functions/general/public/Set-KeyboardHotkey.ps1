#=================================================================================================================
#                                               Set Keyboard Hotkey
#=================================================================================================================

<#
.SYNTAX
    Set-KeyboardHotkey
        [-Value] <char>
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-KeyboardHotkey
{
    <#
    .DESCRIPTION
        Disable a specific 'Windows + key' shortcut.
        Also disable any combinaison of 'Windows + any + key'.

    .EXAMPLE
        PS> Set-KeyboardHotkey -Value 'X' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [ValidatePattern('^[A-Za-z]$')]
        [char] $Value,

        [Parameter(Mandatory)]
        [ValidateSet('Disabled', 'Enabled')]
        [string] $State
    )

    begin
    {
        $DisabledHotkeys = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
            Entries = @(
                @{
                    Name  = 'DisabledHotkeys'
                    Value = ''
                    Type  = 'String'
                }
            )
        }

        $DisabledHotkeysParam = @{
            Path = $DisabledHotkeys.Path
            Name = $DisabledHotkeys.Entries[0].Name
        }
        $DisabledHotkeysValue = Get-LoggedOnUserItemPropertyValue @DisabledHotkeysParam
        $DisabledHotkeysValue = $null -eq $DisabledHotkeysValue ? '' : $DisabledHotkeysValue.ToUpper()

    }

    process
    {
        $Value = [char]::ToUpper($Value)
        switch ($State)
        {
            'Disabled'
            {
                $DisabledHotkeysValue = $DisabledHotkeysValue.replace("$Value", '')
            }
            'Enabled'
            {
                if (-not $DisabledHotkeysValue.Contains($Value))
                {
                    $DisabledHotkeysValue += $Value
                }
            }
        }
    }

    end
    {
        $DisabledHotkeys.Entries[0].Value = $DisabledHotkeysValue
        Set-RegistryEntry -InputObject $DisabledHotkeys
    }
}
