#=================================================================================================================
#                                         Display Last Signed-In UserName
#=================================================================================================================

<#
.SYNTAX
    Set-DisplayLastSignedinUserName
        [-GPO] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-DisplayLastSignedinUserName
{
    <#
    .EXAMPLE
        PS> Set-DisplayLastSignedinUserName -GPO 'Enabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $GPO
    )

    process
    {
        # gpo\ computer config > windows settings > security settings > local policies > security options
        #   interactive logon: don't display last signed-in
        # on: 1 | off: 0 (Default)
        $DisplayLastUserNameGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System'
            Entries = @(
                @{
                    Name  = 'DontDisplayLastUserName'
                    Value = $GPO -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Display Last Signed-In UserName (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $DisplayLastUserNameGpo
    }
}
