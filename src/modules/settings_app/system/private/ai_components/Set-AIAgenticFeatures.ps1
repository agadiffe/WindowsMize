#=================================================================================================================
#                             System > AI Components > Experimental Agentic Features
#=================================================================================================================

<#
.SYNTAX
    Set-AIAgenticFeatures
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AIAgenticFeatures
{
    <#
    .EXAMPLE
        PS> Set-AIAgenticFeatures -State 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 1 | off: 0 (default)
        $AgenticFeatures = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SYSTEM\CurrentControlSet\Services\IsoEnvBroker'
            Entries = @(
                @{
                    Name  = 'Enabled'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'AI Components - Experimental Agentic Features' to '$State' ..."
        Set-RegistryEntry -InputObject $AgenticFeatures
    }
}
