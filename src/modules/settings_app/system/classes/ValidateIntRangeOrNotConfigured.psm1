#=================================================================================================================
#                                Validate Range Or NotConfigured Attribute - Class
#=================================================================================================================

class ValidateIntRangeOrNotConfiguredAttribute : System.Management.Automation.ValidateArgumentsAttribute
{
    [int] $Min
    [int] $Max

    ValidateIntRangeOrNotConfiguredAttribute([int]$Min, [int]$Max)
    {
        if ($Min -gt $Max)
        {
            throw [ArgumentException]::new("Min must be less than or equal to Max.")
        }

        $this.Min = $Min
        $this.Max = $Max
    }

    [void] Validate([object]$Arg, [System.Management.Automation.EngineIntrinsics]$EngineIntrinsics)
    {
        if ($Arg -eq 'NotConfigured')
        {
            return
        }

        $ErrorMsg = "Invalid value. Specify an integer from $($this.Min) to $($this.Max), or 'NotConfigured'."

        try
        {
            $Value = [int]$Arg
        }
        catch
        {
            throw [System.Management.Automation.ValidationMetadataException]::new($ErrorMsg)
        }

        if ($Value -lt $this.Min -or $Value -gt $this.Max)
        {
            throw [System.Management.Automation.ValidationMetadataException]::new($ErrorMsg)
        }
    }
}
