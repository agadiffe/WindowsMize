#=================================================================================================================
#                             Acrobat Reader - Miscellaneous > Adobe Online Services
#=================================================================================================================

# This setting disables:
#   Home page:
#     Files (Your documents, Scans, Shared by you, Shared by others)
#     All agreements (documents sent or received for signature)
#   Top bar:
#     create button (create PDF, combine files, open files)
#     help icon
#     notifications icon
#     free mobile and web apps icon
#     sign in button
#   Menu bar:
#     save changes to Adobe's cloud storage icon
#     share icon (replaced with Email icon)
#   Tools that requires Acrobat:
#     Export a PDF
#     Edit a PDF
#     Create a PDF
#     Combine files
#     Request e-signatures
#     Convert to PDF

<#
.SYNTAX
    Set-AcrobatReaderOnlineServices
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderOnlineServices
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderOnlineServices -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        # This setting is not the same as bUpdater which resides directly under FeatureLockDown and disables product updates.

        # gpo\ FeatureLockDown (Lockable Settings) > Services-Master Switches (DC)
        #   disables both updates to the product's web-plugin components as well as all services
        # not configured: delete (default) | off: 0
        $AcrobatReaderOnlineServices = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cServices'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = 'bUpdater'
                    Value = '0'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Adobe Online Services (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderOnlineServices
    }
}
