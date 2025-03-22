#=================================================================================================================
#                               Bluetooth & Devices > Mouse > Primary Mouse Button
#=================================================================================================================

<#
.SYNTAX
    Set-MousePrimaryButton
        [-Value] {Left | Right}
        [<CommonParameters>]
#>

function Set-MousePrimaryButton
{
    <#
    .EXAMPLE
        PS> Set-MousePrimaryButton -Value 'Left'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MouseButtonMode] $Value
    )

    process
    {
        # left: 0 (default) | right: 1
        $MousePrimaryButton = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Control Panel\Mouse'
            Entries = @(
                @{
                    Name  = 'SwapMouseButtons'
                    Value = [int]$Value
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Primary Mouse Button' to '$Value' ..."
        Set-RegistryEntry -InputObject $MousePrimaryButton
    }
}
