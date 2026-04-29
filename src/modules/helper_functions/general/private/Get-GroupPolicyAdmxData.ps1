#=================================================================================================================
#                                  Helper Function - Get Group Policy Admx Data
#=================================================================================================================

<#
.SYNTAX
    Get-GroupPolicyAdmxData [<CommonParameters>]
#>

function Get-GroupPolicyAdmxData
{
    <#
    .DESCRIPTION
        Build an hashtable of available/valid group policies values.
        Does not handle everything.
        e.g.
        <list valuePrefix="Foo" />
        <list explicitValue="true" />

    .EXAMPLE
        PS> Get-GroupPolicyAdmxData
    #>

    [CmdletBinding()]
    param ()

    process
    {
        $PolicyScope = @{
            Both    = 'HKEY_LOCAL_MACHINE', 'HKEY_CURRENT_USER'
            Machine = 'HKEY_LOCAL_MACHINE'
            User    = 'HKEY_CURRENT_USER'
        }

        $AdmxData = @{}
        $AdmxFiles = Get-ChildItem -Path "$env:SystemRoot\PolicyDefinitions" -Filter '*.admx'

        foreach ($File in $AdmxFiles)
        {
            $XmlReader = [System.Xml.XmlReader]::Create($File.FullName)
            $XmlDocument = [System.Xml.XmlDocument]::new()
            $XmlDocument.Load($XmlReader)

            $AdmxPolicy = $XmlDocument.policyDefinitions.policies.policy
            foreach ($Policy in $AdmxPolicy)
            {
                $Scope = $PolicyScope[$Policy.class]
                foreach ($Hive in $Scope)
                {
                    $BaseKey = "$Hive\$($Policy.key)"

                    if (-not $AdmxData[$BaseKey])
                    {
                        $AdmxData[$BaseKey] = @{}
                    }

                    if ($Policy.valueName)
                    {
                        $AdmxData[$BaseKey][$Policy.valueName] = $true
                    }

                    $PolicyNodes = $Policy.SelectNodes('.//*[@valueName]')
                    foreach ($Node in $PolicyNodes)
                    {
                        $Key = $Node.key ? "$Hive\$($Node.key)" : $BaseKey

                        if (-not $AdmxData[$Key])
                        {
                            $AdmxData[$Key] = @{}
                        }
                        $AdmxData[$Key][$Node.valueName] = $true
                    }
                }
            }
            $XmlReader.Close()
        }
        $AdmxData
    }
}
