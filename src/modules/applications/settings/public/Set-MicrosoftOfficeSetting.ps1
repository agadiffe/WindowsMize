#=================================================================================================================
#                                            Microsoft Office Setting
#=================================================================================================================

<#
  You can use the 'Office Deployment Tool (ODT)' to automate the installation of Microsoft Office.
  With that tool, you can choose which program to install. e.g. Only Word, Excel and PowerPoint.
  Use your favorite search engine for more information.

  Configuration file example (configuration.xml):
  <Configuration>
    <Add OfficeClientEdition="64" Channel="PerpetualVL2024">
      <Product ID="ProPlus2024Volume" PIDKEY="XJ2XN-FW8RK-P4HMP-DKDBV-GCVGB">
        <Language ID="MatchOS" />
        <ExcludeApp ID="Access" />
        <ExcludeApp ID="Lync" />
        <ExcludeApp ID="OneDrive" />
        <ExcludeApp ID="OneNote" />
        <ExcludeApp ID="Outlook" />
        <ExcludeApp ID="Publisher" />
      </Product>
    </Add>
    <Display AcceptEULA="TRUE" />
  </Configuration>
#>

<#
.SYNTAX
    Set-MicrosoftOfficeSetting
        [-ConnectedExperiences {Disabled | Enabled}]
        [-LinkedinFeatures {Disabled | Enabled}]
        [-ShowStartScreen {Disabled | Enabled}]
        [-Ceip {Disabled | Enabled}]
        [-Feedback {Disabled | Enabled}]
        [-Logging {Disabled | Enabled}]
        [-Telemetry {Disabled | Enabled}]
        [<CommonParameters>]
#>

function Set-MicrosoftOfficeSetting
{
    <#
    .EXAMPLE
        PS> Set-MicrosoftOfficeSetting -Ceip 'Disabled' -Feedback 'Disabled' -Telemetry 'Disabled'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [state] $ConnectedExperiences,
        [state] $LinkedinFeatures,
        [state] $ShowStartScreen,
        [state] $Ceip,
        [state] $Feedback,
        [state] $Logging,
        [state] $Telemetry
    )

    process
    {
        if (-not $PSBoundParameters.Keys.Count)
        {
            Write-Error -Message (Write-InsufficientParameterCount)
            return
        }

        switch ($PSBoundParameters.Keys)
        {
            'ConnectedExperiences' { Set-MSOfficeConnectedExperiences -State $ConnectedExperiences }
            'LinkedinFeatures'     { Set-MSOfficeLinkedinFeatures -State $LinkedinFeatures }
            'ShowStartScreen'      { Set-MSOfficeShowStartScreen -State $ShowStartScreen }
            'Ceip'                 { Set-MSOfficeCeip -State $Ceip }
            'Feedback'             { Set-MSOfficeFeedback -State $Feedback }
            'Logging'              { Set-MSOfficeLogging -State $Logging }
            'Telemetry'            { Set-MSOfficeTelemetry -State $Telemetry }
        }
    }
}
