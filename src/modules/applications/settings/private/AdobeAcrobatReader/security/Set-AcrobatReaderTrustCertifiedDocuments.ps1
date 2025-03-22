#=================================================================================================================
#                       Acrobat Reader - Preferences > Security > Trust Certified Documents
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustCertifiedDocuments
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustCertifiedDocuments
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustCertifiedDocuments -State 'Disabled'
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
        $AcrobatReaderTrustCertifiedDocuments = @{
            Hive    = 'HKEY_CURRENT_USER'
            Path    = 'Software\Adobe\Adobe Acrobat\DC\TrustManager'
            Entries = @(
                @{
                    Name  = 'bTrustCertifiedDocuments'
                    Value = $State -eq 'Enabled' ? '1' : '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Auto Trust Documents With Valid Certification' to '$State' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderTrustCertifiedDocuments
    }
}
