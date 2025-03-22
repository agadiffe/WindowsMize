#=================================================================================================================
#                                         Accounts > Your Info - Settings
#=================================================================================================================

<#
.SYNTAX
    Set-YourInfoSetting
        [-BlockMicrosoftAccountsGPO {CannotAddMicrosoftAccount | CannotAddOrLogonWithMicrosoftAccount | NotConfigured}]
        [<CommonParameters>]
#>

function Set-YourInfoSetting
{
    <#
    .EXAMPLE
        PS> Set-YourInfoSetting -BlockMicrosoftAccountsGPO 'NotConfigured'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [BlockMSAccountsMode] $BlockMicrosoftAccountsGPO
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
            'BlockMicrosoftAccountsGPO' { Set-YourInfoBlockMicrosoftAccounts -GPO $BlockMicrosoftAccountsGPO }
        }
    }
}
