#=================================================================================================================
#                System > Optional Features > More Windows Features - Set Windows Optional Feature
#=================================================================================================================

<#
.SYNTAX
    Set-WindowsOptionalFeature
        [-Name] <string>
        [-State] {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-WindowsOptionalFeature
{
    <#
    .EXAMPLE
        PS> Set-WindowsOptionalFeature -Name 'WorkFolders-Client' -State 'Disabled'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name,

        [Parameter(Mandatory)]
        [state] $State
    )

    process
    {
        $WinOptionalFeature = Get-WindowsOptionalFeature -Online -FeatureName $Name -Verbose:$false
        if (-not $WinOptionalFeature)
        {
            Write-Verbose -Message "Windows Optional Feature '$Name' not found"
            return
        }

        if ($WinOptionalFeature.State -eq $State)
        {
            Write-Verbose -Message "$Name is already '$State'"
        }
        else
        {
            $OptionalFeatureOptions = @{
                NoRestart     = $true
                Verbose       = $false
                WarningAction = 'SilentlyContinue'
            }

            switch ($State)
            {
                'Enabled'
                {
                    Write-Verbose -Message "Enabling $Name ..."
                    $WinOptionalFeature | Enable-WindowsOptionalFeature -Online -All @OptionalFeatureOptions | Out-Null
                }
                'Disabled'
                {
                    Write-Verbose -Message "Disabling $Name ..."
                    $WinOptionalFeature | Disable-WindowsOptionalFeature -Online @OptionalFeatureOptions | Out-Null
                }
            }
        }
    }
}
