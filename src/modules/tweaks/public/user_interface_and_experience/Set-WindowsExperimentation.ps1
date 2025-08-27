#=================================================================================================================
#                                             Windows Experimentation
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsExperimentation
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-WindowsExperimentation
{
    <#
    .EXAMPLE
        PS> Set-WindowsExperimentation -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ not configured: 1 (default) | off: 0
        $WindowsExperimentation = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\PolicyManager\default\System\AllowExperimentation'
            Entries = @(
                @{
                    Name  = 'value'
                    Value = $GPO -eq 'Disabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Windows Experimentation' to '$GPO' ..."
        Set-RegistryEntry -InputObject $WindowsExperimentation
    }
}
