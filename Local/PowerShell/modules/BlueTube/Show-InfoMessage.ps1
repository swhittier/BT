﻿<#
    Helper function to show information message.
#>
Function Show-InfoMessage
{
    [cmdletbinding()]
        Param(
            [parameter(Mandatory=$true, ValueFromPipeline)]
            [ValidateNotNullOrEmpty()] #No value
            [string]$msg
            )
    
    Process {
        
        Write-Host $msg -ForegroundColor White
    }
}