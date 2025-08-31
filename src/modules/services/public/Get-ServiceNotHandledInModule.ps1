#=================================================================================================================
#                                        Get Service Not Handled In Module
#=================================================================================================================

<#
.SYNTAX
    Get-ServiceNotHandledInModule [<CommonParameters>]
#>

# Function to easily check for new services (e.g. added by a Windows update).
function Get-ServiceNotHandledInModule
{
    [CmdletBinding()]
    param ()

    process
    {
        $HandledServices = $ServicesList.Values.ServiceName +
                        $ServicesListNotConfigured.Values.ServiceName +
                        $ServicesList.Values.ServiceName.ForEach({ "${_}_*" }) +
                        $ServicesListNotConfigured.Values.ServiceName.ForEach({ "${_}_*" })

        Get-Service -Exclude $HandledServices -ErrorAction 'SilentlyContinue'
    }
}
