#=================================================================================================================
#                                     Helper Function - Add Dynamic Parameter
#=================================================================================================================

class AttributesDynParam
{
    [hashtable] $Parameter
    [string[]] $ValidateSet
    [object[]] $ValidateRange
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
                }
            }
        PS> Add-DynamicParameter @DynamicParamProperties
        PS> $ParamDictionary
    #>

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory)]
        [System.Management.Automation.RuntimeDefinedParameterDictionary] $Dictionary,

        [Parameter(Mandatory)]
        [string] $Name,

        [Parameter(Mandatory)]
        [type] $Type,

        [AttributesDynParam] $Attribute

    )

    $AttributeCollection = [System.Collections.ObjectModel.Collection[System.Attribute]]::new()

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

    if ($Attribute.ValidateSet)
    {
        $ValidateSetAttribute = [System.Management.Automation.ValidateSetAttribute]::new($Attribute.ValidateSet)
        $AttributeCollection.Add($ValidateSetAttribute)
    }

    if ($Attribute.ValidateRange)
    {
        $ValidateRangeAttributeProperties = @{
            TypeName     = 'System.Management.Automation.ValidateRangeAttribute'
            ArgumentList = $Attribute.ValidateRange
        }
        $ValidateRangeAttribute = New-Object @ValidateRangeAttributeProperties
        $AttributeCollection.Add($ValidateRangeAttribute)
    }

    $DynamicParam = [System.Management.Automation.RuntimeDefinedParameter]::new($Name, $Type, $AttributeCollection)
    $Dictionary.Add($Name, $DynamicParam)
}
