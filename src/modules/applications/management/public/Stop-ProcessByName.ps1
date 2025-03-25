#=================================================================================================================
#                                              Stop Process By Name
#=================================================================================================================

<#
.SYNTAX
    Stop-ProcessByName
        [-Name] <string>
        [<CommonParameters>]
#>

function Stop-ProcessByName
{
    <#
    .EXAMPLE
        PS> Stop-ProcessByName -Name '*OneDrive*'
    #>

    param
    (
        [Parameter(Mandatory)]
        [string] $Name
    )

    while (Get-Process -Name $Name -ErrorAction 'SilentlyContinue')
    {
        Get-Process -Name $Name | Stop-Process -Force -ErrorAction 'SilentlyContinue'
        Start-Sleep -Seconds 0.1
    }
}
