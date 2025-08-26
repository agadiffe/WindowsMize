#=================================================================================================================
#                                 Acrobat Reader - Miscellaneous > Tools Shortcut
#=================================================================================================================

# List of App ID: C:\Program Files\Adobe\Acrobat DC\Acrobat\RdrApp\ENU

<#
.SYNTAX
    Set-AcrobatReaderToolsShortcut
        [-GPO] {Disabled | NotConfigured}
        [<CommonParameters>]
#>

function Set-AcrobatReaderToolsShortcut
{
    <#
    .EXAMPLE
        PS> Set-AcrobatReaderToolsShortcut -GPO 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [GpoStateWithoutEnabled] $GPO
    )

    process
    {
        $AcroAppID = @{
            Prepare_for_accessibility = 'AccessibilityRdrApp'
            Use_guided_actions        = 'ActionsRdrApp'
            AI_Assistant              = 'GenAIAssistantApp'
            Design_Pages              = 'CCXRdrApp'
            Use_a_certificate         = 'CertificatesApp'
            Request_e_signatures      = 'CollectSignaturesApp'
            Combine_files             = 'CombinePDFRdrApp', 'CombineDelayedRdrApp'
            Add_comments              = 'CommentApp'
            Compare_files             = 'CompareRdrApp'
            Convert_to_PDF            = 'ConvertPDFAppFull', 'ConvertPDFApp'
            Create_a_PDF              = 'CPDFAppFull', 'CPDFApp'
            Create_custom_tool        = 'CreateCustomUIRdrApp'
            Use_JavaScript            = 'DeveloperRdrApp'
            Edit_a_PDF                = 'EditPDFRdrAppFull', 'EditPDFRdrApp', 'EditPDFRdrMenuApp',
                                        'EditPDFRdrExpApp', 'EditDelayedRdrApp'
            Export_a_PDF              = 'EPDFAppFull', 'EPDFApp'
            Fill_and_Sign             = 'FillSignApp'
            Prepare_a_form            = 'FormsRdrApp'
            Add_search_index          = 'IndexRdrApp'
            Measure_objects           = 'MeasureApp'
            Compress_a_PDF            = 'OptimizePDFRdrCtxApp', 'OptimizePDFRdrApp'
            Organize_pages            = 'PagesRdrApp', 'PagesDelayedRdrApp'
            Use_print_production      = 'PrintProductionRdrApp'
            Protect_a_PDF             = 'ProtectPDFRdrApp'
            Read_aloud                = 'ReadAloudApp'
            Redact_a_PDF              = 'RedactPDFRdrApp'
            Send_for_comments         = 'ReviewPDFRdrApp'
            Add_rich_media            = 'RichMediaRdrApp'
            Scan_and_OCR              = 'ScanPDFRdrApp'
            Add_a_stamp               = 'StampApp'
            Apply_PDF_standards       = 'StandardsRdrApp'
            Generative_summary        = 'GenAISummaryApp'
            Share                     = 'SendAppFull'
            Unified_Share             = 'UnifiedShareApp'
            Create_a_PDF_Space        = 'WorkspacesApp'
        }

        # gpo\ AcroApps (Tools Customization (DC)) > Removing Tools
        #   removes a tool from the Tools tab as well as its associated shortcut in the right-hand pane
        # not configured: delete (default) | on: add index entries (e.g. "a0"="FillSignApp" )
        $AcrobatReaderToolsShortcutGpo = @{
            Hive    = 'HKEY_LOCAL_MACHINE'
            Path    = 'SOFTWARE\Policies\Adobe\Adobe Acrobat\DC\FeatureLockDown\cAcroApp\cDisabled'
            Entries = @(
                @{
                    RemoveEntry = $GPO -eq 'NotConfigured'
                    Name  = ''
                    Value = '1'
                    Type  = 'DWord'
                }
            )
        }

        Write-Verbose -Message "Setting 'Acrobat Reader - Tools Shortcut (GPO)' to '$GPO' ..."
        Set-RegistryEntry -InputObject $AcrobatReaderToolsShortcutGpo
    }
}
