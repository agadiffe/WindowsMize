#=================================================================================================================
#                                  Acrobat Reader - Preferences > Email Accounts
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderWebmail
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderWebmail
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderWebmail -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # gpo\ WebMail > Webmail Basics
        #   specifies whether to disable WebMail
        # not configured: delete (default) | off: 1
        $AcrobatReaderWebmail = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cWebmailProfiles'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bDisableWebmail'
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Email Accounts (Webmail) (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderWebmail
    }
}
