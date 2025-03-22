#=================================================================================================================
#                                         System > Projecting To This PC
#=================================================================================================================

# When disabled, the PC isn't discoverable unless Wireless Display app is manually launched.

<#
.SYNTAX
    Set-ProjectingToThisPC
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-ProjectingToThisPC
{
    <#
    .EXAMPLE
        PS> Set-ProjectingToThisPC -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > connect
        #   don't allow this PC to be projected to
        # not configured: delete (default) | on: 1
        $ProjectingToThisPC = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\Connect'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'AllowProjectionToPC'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Projecting To This PC' to '$GPO' ..."
        Set-RegistryEntry -InputObject $ProjectingToThisPC
    }
}
