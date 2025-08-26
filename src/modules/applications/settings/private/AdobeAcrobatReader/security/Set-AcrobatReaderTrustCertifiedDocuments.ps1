#=================================================================================================================
#       Acrobat Reader - Preferences > Security (Enhanced) > Auto Trust Documents With Valid Certification
#=================================================================================================================

<#
.SYNTAX
    Set-AcrobatReaderTrustCertifiedDocuments
        [[-State] {Disabled | Enabled}]
        [-GPO {Disabled | Enabled | NotConfigured}]
        [<CommonParameters>]
#>

function Set-AcrobatReaderTrustCertifiedDocuments
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderTrustCertifiedDocuments -State 'Disabled' -GPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [Parameter(Position = 0)]
        [state] $State,

        [GpoState] $GPO
    )

    process
    {
        $TrustCertifiedDocumentsMsg = 'Acrobat Reader - Auto Trust Documents With Valid Certification'

        switch ($PSBoundParameters.Keys)
        {
            'State'
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

                Write-Verbose -Message "Setting '$TrustCertifiedDocumentsMsg' to '$State' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderTrustCertifiedDocuments
            }
            'GPO'
            {
                # gpo\ TrustManager > Certified Document Trust
                #   elevates (trusts) certified documents as a privileged location
                # not configured: delete (default) | on: 0 | off: 1
                $AcrobatReaderTrustCertifiedDocumentsGpo = @{
                    Hive    = 'HKEY_LOCAL_MACHINE'
                    Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown'
                    Entries = @(
                        @{
                            RemoveEntry = $GPO -eq 'NotConfigured'
                            Name  = 'bEnableCertificateBasedTrust'
                            Value = $GPO -eq 'Enabled' ? '0' : '1'
                            Type  = 'DWord'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$TrustCertifiedDocumentsMsg (GPO)' to '$GPO' ..."
                Set-RegistryEntry -InputObject $AcrobatReaderTrustCertifiedDocumentsGpo
            }
        }
    }
}
