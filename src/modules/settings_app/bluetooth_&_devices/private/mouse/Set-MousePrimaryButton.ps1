#=================================================================================================================
#                               Bluetooth & Devices > Mouse > Primary Mouse Button
#=================================================================================================================

<#
.SYNTAX
    Set-MousePrimaryButton
        [-Button] {Left | Right}
        [<CommonParameters>]
#>

function Set-MousePrimaryButton
{
    <#
    .EXAMPLE
        PS> Set-MousePrimaryButton -Button 'Left'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [MouseButtonMode] $Button
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
                    Value = [int]$Button
                    Type  = 'String'
                }
            )
        }

        Write-Verbose -Message "Setting 'Mouse - Primary Mouse Button' to '$Button' ..."
        Set-RegistryEntry -InputObject $MousePrimaryButton
    }
}
