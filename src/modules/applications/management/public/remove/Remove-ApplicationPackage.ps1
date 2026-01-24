#=================================================================================================================
#                                           Remove Application Package
#=================================================================================================================

<#
.SYNTAX
    Remove-ApplicationPackage
        [-Name] <string>
        [<CommonParameters>]
#>

function Remove-ApplicationPackage
{
    <#
    .EXAMPLE
        PS> Remove-ApplicationPackage -Name 'Microsoft.WindowsAlarms'
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipeline)]
        [string] $Name
    )

    begin
    {
        try
        {
            # "-PackageTypeFilter 'All'" also retrieves Provisionned packages
            $AllAppxPackages = Get-AppxPackage -AllUsers -PackageTypeFilter 'All' -Verbose:$false
        }
        catch
        {
            # PowerShell on Windows 10: Get-AppxPackage not found
            # https://github.com/PowerShell/PowerShell/issues/19031
            Import-Module -Name 'Appx' -UseWindowsPowerShell -Verbose:$false
            $AllAppxPackages = Get-AppxPackage -AllUsers -PackageTypeFilter 'All' -Verbose:$false
        }
    }

    process
    {
        $AppxPackageNames = ($AllAppxPackages | Where-Object -Property 'Name' -EQ -Value $Name).PackageFullName

        if ($AppxPackageNames)
        {
            Write-Verbose -Message "Removing $Name ..."

            # The progress bar of Remove-AppxPackage mess up the terminal rendering.
            # Use a PowerShell child process as workaround.
            powershell.exe -args $AppxPackageNames -NoProfile -Command {
                $args | Remove-AppxPackage -ErrorAction 'SilentlyContinue'
                $args | Remove-AppxPackage -AllUsers -ErrorAction 'SilentlyContinue'
            }
        }
        else
        {
            Write-Verbose -Message "$Name is not installed"
        }
    }
}
