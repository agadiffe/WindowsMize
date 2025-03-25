#=================================================================================================================
#                     System Properties - Advanced > Performance > Advanced > Virtual Memory
#=================================================================================================================

# settings > system > about > device specifications > related links (sysdm.cpl)

# A paging file is an area on the hard disk that Windows uses as if it were RAM.

# automatically manage paging file size for all drives
#-------------------
# default: Enabled

# custom paging file size
#-------------------
# Depends on how much RAM you have:
#   20GB+: 512/512 for safeguard and (very) old programs that needs pagefile.
#   8-16GB: 2048/2048 should be enought, safeguard in case you eat up all ram.
#   4GB: 4096/4096 should be enought (if not enought, consider to upgrade your physical RAM if possible).


<#
.SYNTAX
    Set-PagingFileSize
        [-Drive] <string[]>
        [-State] {CustomSize | SystemManaged | NoPagingFile}
        -InitialSize <int>
        -MaximumSize <int>
        [<CommonParameters>]

    Set-PagingFileSize
        -AllDrivesAutoManaged {Disabled | Enabled}
        [<CommonParameters>]
#>

function Set-PagingFileSize
{
    <#
    .DESCRIPTION
        Dynamic parameters:
            -InitialSize <int> & -MaximumSize <int> : available when 'State' is defined to 'CustomSize'.

    .EXAMPLE
        PS> Set-PagingFileSize -Drive $env:SystemDrive -State 'CustomSize' -InitialSize 512 -MaximumSize 2048

    .EXAMPLE
        PS> Set-PagingFileSize -Drive 'X:', 'Y:' -State 'NoPagingFile'
    #>

    [CmdletBinding(DefaultParameterSetName = 'State')]
    param
    (
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'State')]
        [ValidatePattern(
            '^[A-Za-z]:\\?$',
            ErrorMessage = 'Drive format must be a letter followed by a colon, ' +
                           'optionally with a backslash (e.g. ''C:'' or ''C:\'').')]
        [ValidateScript(
            { Test-Path -Path $_ },
            ErrorMessage = 'The specified drive does not exist or is not accessible.')]
        [string[]] $Drive,

        [Parameter(Mandatory, Position = 1, ParameterSetName = 'State')]
        [ValidateSet('CustomSize', 'SystemManaged', 'NoPagingFile')]
        [string] $State,

        [Parameter(Mandatory, ParameterSetName = 'AllDrivesAutoManaged')]
        [state] $AllDrivesAutoManaged
    )

    dynamicparam
    {
        if ($State -eq 'CustomSize')
        {
            $DynParameter = 'InitialSize', 'MaximumSize'

            $ParamDictionary = [System.Management.Automation.RuntimeDefinedParameterDictionary]::new()
            $DynParameter | ForEach-Object -Process {
                $DynamicParamProperties = @{
                    Dictionary = $ParamDictionary
                    Name       = $_
                    Type       = [int]
                    Attribute  = @{
                        Parameter     = @{ Mandatory = $true; ParameterSetName = 'State' }
                        ValidateRange = 'NonNegative'
                    }
                }
                Add-DynamicParameter @DynamicParamProperties
            }
            $ParamDictionary
        }
    }

    process
    {
        if ($State -eq 'CustomSize')
        {
            $InitialSize = $PSBoundParameters.InitialSize
            $MaximumSize = $PSBoundParameters.MaximumSize

            # [ValidateScript({ $_ -ge $InitialSize })] does not work if $InitialSize is defined after $MaximumSize
            if ($MaximumSize -lt $InitialSize)
            {
                Write-Error -Message 'MaximumSize must be greater than or equal to InitialSize.'
                return
            }
        }

        Write-Verbose -Message "Setting 'All Drives AutoManaged Paging File Size' to '$AllDrivesSystemManaged'"

        $ComputerSystem = Get-CimInstance -ClassName 'Win32_ComputerSystem' -Verbose:$false
        $ComputerSystem.AutomaticManagedPagefile = $AllDrivesSystemManaged -eq 'Enabled'
        Set-CimInstance -InputObject $ComputerSystem -Verbose:$false

        if ($PSCmdlet.ParameterSetName -eq 'State')
        {
            $StateMsg = $State -eq 'CustomSize' ? "$InitialSize MB / $MaximumSize MB" : $State

            foreach ($DriveLetter in $Drive)
            {
                Write-Verbose -Message "Setting 'Paging File Size' for drive '$DriveLetter' to '$StateMsg' ..."

                $DriveLetter = $DriveLetter.Replace('\', '')

                $PagingFileProperties = @{
                    ClassName = 'Win32_PageFileSetting'
                    Filter    = "Name like '$DriveLetter%'"
                }
                $PagingFileSetting = Get-CimInstance @PagingFileProperties -Verbose:$false

                if ($State -eq 'NoPagingFile')
                {
                    if ($PagingFileSetting)
                    {
                        Remove-CimInstance -InputObject $PagingFileSetting -Verbose:$false
                    }
                }
                else
                {
                    if (-not $PagingFileSetting)
                    {
                        $NewPagingFileProperties = @{
                            ClassName = 'Win32_PageFileSetting'
                            Property  = @{ Name = "$DriveLetter\pagefile.sys" }
                        }
                        $PagingFileSetting = New-CimInstance @NewPagingFileProperties -Verbose:$false
                    }

                    if ($State -eq 'SystemManaged')
                    {
                        $InitialSize = $MaximumSize = 0
                    }

                    $PagingFileSetting.InitialSize = $InitialSize
                    $PagingFileSetting.MaximumSize = $MaximumSize
                    Set-CimInstance -InputObject $PagingFileSetting -Verbose:$false
                }
            }
        }
    }
}
