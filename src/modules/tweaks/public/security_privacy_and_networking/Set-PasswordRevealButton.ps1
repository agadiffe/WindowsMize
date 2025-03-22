#=================================================================================================================
#                                             Password Reveal Button
#=================================================================================================================

<#
.SYNTAX
    Set-PasswordRevealButton
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-PasswordRevealButton
{
    <#
    .EXAMPLE
        PS> Set-PasswordRevealButton -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ user config > administrative tpl > windows components > credential user interface
        #   do not display the password reveal button
        # not configured: delete (default) | on: 1
        $PasswordRevealButtonGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\CredUI'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'DisablePasswordReveal'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Password Reveal Button (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $PasswordRevealButtonGpo
    }
}
