#=================================================================================================================
#                                         Helper Function - Write Section
#=================================================================================================================

<#
.SYNTAX
    Write-Section
        [-Name] <string>
        [-SubSection]
        [<CommonParameters>]
#>

function Write-Section
{
    <#
    .EXAMPLE
        PS> Write-Section -Name 'Setting File Explorer'
        # Setting File Explorer
        # ========================================
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [string] $Name,

        [switch] $SubSection
    )

    process
    {
        $ColorOption = @{
            BackgroundColor = $SubSection ? 'Blue' : 'Cyan'
            ForegroundColor = 'Black'
            NoNewline       = $true
        }

        Write-Host
        Write-Host @ColorOption -Object "# $Name"
        Write-Host
        if (-not $SubSection)
        {
            Write-Host @ColorOption -Object '# ========================================'
            Write-Host
        }
    }
}
