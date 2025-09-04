#=================================================================================================================
#                            Acrobat - Miscellaneous > Removes Tool From The Tools Tab
#=================================================================================================================

# List of App ID:
#   [HKEY_CURRENT_USER\Software\Adobe\Adobe Acrobat\DC\AcroApp\cRegistered]
#   C:\Program Files\Adobe\Acrobat DC\Acrobat\RdrApp\ENU
#   C:\Program Files\Adobe\Acrobat DC\Acrobat\AcroApp\ENU

# Acrobat Reader and Acrobat applications ID
$AdobeAcrobatAppID = [ordered]@{
    AddComments             = 'CommentApp'
    AddRichMedia            = 'RichMediaRdrApp', 'RichMediaApp'
    AddSearchIndex          = 'IndexRdrApp', 'IndexApp'
    AddStamp                = 'StampApp'
    ApplyPdfStandards       = 'StandardsRdrApp', 'StandardsApp'
    CombineFiles            = 'CombinePDFRdrApp', 'CombineDelayedRdrApp', 'CombineApp'
    CompareFiles            = 'CompareRdrApp', 'CompareApp'
    CompressPdf             = 'OptimizePDFRdrApp', 'OptimizePDFRdrCtxApp', 'OptimizePDFApp'
    ConvertPdf              = 'ConvertPDFAppFull', 'ConvertPDFApp'
    CreatePdf               = 'CPDFAppFull', 'CPDFApp', 'CreatePDFApp'
    EditPdf                 = 'EditPDFRdrAppFull', 'EditPDFRdrApp', 'EditPDFRdrMenuApp', 'EditPDFRdrExpApp', 'EditDelayedRdrApp', 'EditPDFApp'
    ExportPdf               = 'EPDFAppFull', 'EPDFApp', 'ExportPDFApp'
    FillAndSign             = 'FillSignApp'
    MeasureObjects          = 'MeasureApp'
    OrganizePages           = 'PagesRdrApp', 'PagesDelayedRdrApp', 'PagesApp'
    PrepareForAccessibility = 'AccessibilityRdrApp', 'AccessibilityApp'
    PrepareForm             = 'FormsRdrApp', 'FormsApp'
    ProtectPdf              = 'ProtectPDFRdrApp', 'ProtectApp'
    RedactPdf               = 'RedactPDFRdrApp', 'RedactApp'
    RequestSignatures       = 'CollectSignaturesApp'
    ScanAndOcr              = 'ScanPDFRdrApp', 'PaperToPDFApp'
    UseCertificate          = 'CertificatesApp'
    UseGuidedActions        = 'ActionsRdrApp', 'ActionsApp'
    UsePrintProduction      = 'PrintProductionRdrApp', 'PrintProductionApp'
}


<#
.SYNTAX
    Remove-AcrobatToolFromToolsTab
        [-Name] {AddComments | AddRichMedia | AddSearchIndex | AddStamp | ApplyPdfStandards | CombineFiles |
                 CompareFiles | CompressPdf | ConvertPdf | CreatePdf | EditPdf | ExportPdf | FillAndSign |
                 MeasureObjects | OrganizePages | PrepareForAccessibility | PrepareForm | ProtectPdf | RedactPdf |
                 RequestSignatures | ScanAndOCR | UseCertificate | UseGuidedActions | UsePrintProduction}
        [<CommonParameters>]

    Remove-AcrobatToolFromToolsTab
        -Reset
        [<CommonParameters>]
#>

function Remove-AcrobatToolFromToolsTab
{
    <#
    .DESCRIPTION
        Override any existing removed tools.
        i.e. Only the listed tools will be removed from the Tools tab.

    .EXAMPLE
        PS> Remove-AcrobatToolFromToolsTab -Name 'CreatePdf', 'EditPdf', 'ConvertPdf'

    .EXAMPLE
        PS> Remove-AcrobatToolFromToolsTab -Reset
    #>

    [CmdletBinding(DefaultParameterSetName = 'RemoveTools')]
    param
    (
        [Parameter(Mandatory, ParameterSetName = 'RemoveTools')]
        [ValidateSet([AdobeAcrobatAppNames])]
        [string[]] $Name,

        [Parameter(Mandatory, ParameterSetName = 'Reset')]
        [switch] $Reset
    )

    process
    {
        $AcrobatRemovedToolsMsg = 'Acrobat - Removed Tools From The Tools Tab (GPO)'

        if ($Reset -or $PSCmdlet.ParameterSetName -eq 'RemoveTools')
        {
            $AcrobatResetRemovedToolsGpo = @{
                RemoveKey = $true
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cAcroApp\cDisabled'
                Entries = $null
            }

            Write-Verbose -Message "Setting '$AcrobatRemovedToolsMsg' to 'Reset' ..."
            Set-RegistryEntry -InputObject $AcrobatResetRemovedToolsGpo
        }

        if ($PSCmdlet.ParameterSetName -eq 'RemoveTools')
        {
            $Index = 0
            $RemovedTools = foreach ($Tool in $Name)
            {
                foreach ($Id in $AdobeAcrobatAppID.$Tool)
                {
                    @{
                        Name  = "a$Index"
                        Value = $Id
                        Type  = 'String'
                    }
                    $Index++
                }
            }

            # gpo\ AcroApps (Tools Customization (DC)) > Removing Tools
            #   removes a tool from the Tools tab as well as its associated shortcut in the right-hand pane
            # not configured: delete (default) | on: add index entries (e.g. "a0"="CreatePDFApp" )
            $AcrobatRemovedToolsGpo = @{
                Hive    = 'HKEY_LOCAL_MACHINE'
                Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cAcroApp\cDisabled'
                Entries = $RemovedTools
            }

            Write-Verbose -Message "Setting '$AcrobatRemovedToolsMsg' to '$($Name -join ', ')' ..."
            Set-RegistryEntry -InputObject $AcrobatRemovedToolsGpo
        }
    }
}
