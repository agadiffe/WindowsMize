#=================================================================================================================
#                                                  File History
#=================================================================================================================

# control panel (icons view) > file history
# (control.exe /name Microsoft.FileHistory)

<#
.SYNTAX
    Set-FileHistory
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-FileHistory
{
    <#
    .EXAMPLE
        PS> Set-FileHistory -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ computer config > administrative tpl > windows components > file history
        #   turn off file history
        # not configured: delete (default) | on: 1
        $FileHistoryGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Microsoft\Windows\FileHistory'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'Disabled'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'File History (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $FileHistoryGpo
    }
}
