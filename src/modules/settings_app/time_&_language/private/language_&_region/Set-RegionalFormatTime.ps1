#=================================================================================================================
#                           Time & Language > Language & Region > Regional Format Time
#=================================================================================================================

# control panel (icons view) > region (intl.cpl) > formats

<#
.SYNTAX
    Set-RegionalFormatTime
        [-ShortTime <string>]
        [-LongTime <string>]
        [<CommonParameters>]
#>

function Set-RegionalFormatTime
{
    <#
    .EXAMPLE
        PS> Set-RegionalFormatTime -ShortTime 'HH:mm tt' -LongTime 'HH:mm:ss tt'
    #>

    [CmdletBinding(PositionalBinding = $false)]
    param
    (
        [string] $ShortTime,

        [string] $LongTime
    )

    process
    {
        $RegionalFormatMsg = 'Language & Region - Regional Format'

        switch ($PSBoundParameters.Keys)
        {
            'ShortTime'
            {
                # e.g. 13:42: HH:mm tt
                $RegionalFormatShortTime = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sShortTime'
                            Value = $ShortTime
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Short Time' to '$ShortTime' ..."
                Set-RegistryEntry -InputObject $RegionalFormatShortTime
            }
            'LongTime'
            {
                # e.g. 13:42:07: HH:mm:ss tt
                $RegionalFormatLongTime = @{
                    Hive    = 'HKEY_CURRENT_USER'
                    Path    = 'Control Panel\International'
                    Entries = @(
                        @{
                            Name  = 'sTimeFormat'
                            Value = $LongTime
                            Type  = 'String'
                        }
                    )
                }

                Write-Verbose -Message "Setting '$RegionalFormatMsg : Long Time' to '$LongTime' ..."
                Set-RegistryEntry -InputObject $RegionalFormatLongTime
            }
        }
    }
}
