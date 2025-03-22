#=================================================================================================================
#                                    Acrobat Reader - Miscellaneous > Webmail
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderWebmail
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderWebmail
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderWebmail -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        # on: 0 (default) | off: 1
        $AcrobatReaderWebmail = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cWebmailProfiles'
            Entries = @(
                @{
                    Name  = 'bDisableWebmail'
                    Value = $State -eq 'Enabled' ? '0' : '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Webmail' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderWebmail
    }
}
