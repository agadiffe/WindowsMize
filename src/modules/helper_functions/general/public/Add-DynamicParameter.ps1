#=================================================================================================================
#                                     Helper Function - Add Dynamic Parameter
#=================================================================================================================

class AttributesDynParam
{
    [hashtable] $Parameter
    [string[]] $ValidateSet
    [object[]] $ValidateRange
    [bool] $ValidateNotNullOrWhiteSpace
}

<#
.SYNTAX
    Add-DynamicParameter
        [-Dictionary] <RuntimeDefinedParameterDictionary>
        [-Name] <string>
        [-Type] <type>
        [[-Attribute] <AttributesDynParam>]
        [<CommonParameters>]
#>

function Add-DynamicParameter
{
    <#
    .DESCRIPTION
        ValidateSet: ErrorMessage and IgnoreCase are not handled.

    .EXAMPLE
        PS> $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
        PS> $DynamicParamProperties = @{
                Dictionary = $ParamDictionary
                Name       = "MyDynParam"
                Type       = [string]
                Attribute  = @{
                    Parameter     = @{ Mandatory = $true }
                    ValidateSet   = 'Value1', 'Value2'
                    ValidateRange = 1, 100
                    ValidateNotNullOrWhiteSpace = $true
                }
            }
        PS> Add-DynamicParameter @DynamicParamProperties
        PS> $ParamDictionary
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [System.Management.Automation.RuntimeDefinedParameterDictionary] $Dictionary,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [string] $Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [type] $Type,

        [Parameter(ValueFromPipelineByPropertyName)]
        [AttributesDynParam] $Attribute
    )

    process
    {
        $AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

        # Parameter attribube (e.g. [Parameter(Mandatory, ValueFromPipeline)])
        if (-not $Attribute.Parameter.Count)
        {
            $ParamAttribute = [System.Management.Automation.ParameterAttribute]::new()
            $ParamAttribute.ParameterSetName = "__AllParameterSets"
        }
        else
        {
            $ParamAttribute = [System.Management.Automation.ParameterAttribute]$Attribute.Parameter
        }
        $AttributeCollection.Add($ParamAttribute)

        switch ($true)
        {
            { $Attribute.ValidateSet } # e.g. [ValidateSet("Low", "Average", "High")]
            {
                $ValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($Attribute.ValidateSet)
                $AttributeCollection.Add($ValidateSetAttribute)
            }
            { $Attribute.ValidateRange } # e.g. [ValidateRange(0, 10)]
            {
                $ValidateRangeAttributeProperties = @{
                    TypeName     = 'System.Management.Automation.ValidateRangeAttribute'
                    ArgumentList = $Attribute.ValidateRange
                }
                $ValidateRangeAttribute = New-Object @ValidateRangeAttributeProperties
                $AttributeCollection.Add($ValidateRangeAttribute)
            }
            { $Attribute.ValidateNotNullOrWhiteSpace } # e.g. [ValidateNotNullOrWhiteSpace()]
            {
                $ValidateNotNullOrWhiteSpaceAttribute = [System.Management.Automation.ValidateNotNullOrWhiteSpaceAttribute]::new()
                $AttributeCollection.Add($ValidateNotNullOrWhiteSpaceAttribute)
            }
        }

        $DynamicParam = [System.Management.Automation.RuntimeDefinedParameter]::new($Name, $Type, $AttributeCollection)
        $Dictionary.Add($Name, $DynamicParam)
    }
}
