﻿Function Invoke-MohawkDependencyCopy {
    [cmdletbinding()]
    Param(        
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$siteName,
        [parameter(Mandatory=$true, ValueFromPipeline)]
        [ValidateNotNullOrEmpty()] #No value
        [string]$buildConfig          
    )
    Begin {
        
        <#
            Helper function to show usage of cmdlet.
        #>
        Function Show-Usage {
        
            Show-InfoMessage "Usage: Invoke-MohawkDependencyCopy -siteName [siteName] -buildConfig [buildConfig]"  
            Show-InfoMessage "siteName: flooring for Mohawk Flooring Website (Conversion)"
            Show-InfoMessage "siteName: flooringlegacy for Mohawk Flooring Website (Legacy)"
            Show-InfoMessage "siteName: tmg Mohawk Commercial Website (Redesign)"
            Show-InfoMessage "siteName: tmglegacy for Mohawk Commercial Website (Legacy)"
            Show-InfoMessage "siteName: rrts for Residential Ready To Ship Website"
            Show-InfoMessage "siteName: rts for Commerical Ready To Ship Website"
            Show-InfoMessage "siteName: bmf for BMF/Portico Website"
            Show-InfoMessage "siteName: aladdin for BMF/Portico Website"
            
            Show-InfoMessage "buildConfig: debug or release"
        }
    }
    Process {                    
            
        #$currentDir = (Get-Item -Path ".\" -Verbose).FullName
        $workingDirRoot = if(![string]::IsNullOrEmpty($env:BTPROJPATH)) { $env:BTPROJPATH } else { "C:\src\" }
        $sitecoreWorkingDirRoot = if(![string]::IsNullOrEmpty($env:BTPROJPATH)) { $env:BTPROJPATH } else { "C:\src\" }
        $soaDir = "mohawk-soa\"
        $projectDirRoot = ""
        $solutionDir = ""
        $dependencySourceDirs = @()
        $dependencyDestDir = ""

        switch($siteName) {

            "flooring" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Flooring Website"

                $projectDirRoot = $sitecoreWorkingDirRoot + "mohawk-sitecore-shell\inetpub\Mohawk.SitecoreShell.Website\Areas\MohawkFlooring"
                $solutionDir = $projectDirRoot
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.MohawkGroup\bin\" + $buildConfig)
                $dependencyDestDir = $solutionDir + "\dotNet\dependencies\Mohawk-SOA"
                                
                break
            }

            "flooringlegacy" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Flooring (Legacy)..."

                $projectDirRoot = $workingDirRoot + "mohawk"
                $solutionDir = $projectDirRoot + "\MohawkFlooring"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net45\bin\" + $buildConfig)
                $dependencyDestDir = $solutionDir + "\Dependencies"

                break
            }
            
            "tmg" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Commercial Website (Redesign)..."

                $projectDirRoot = $sitecoreWorkingDirRoot + "mohawk-sitecore-shell\inetpub\Mohawk.SitecoreShell.Website\Areas\MohawkGroup"
                $solutionDir = $projectDirRoot
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.MohawkGroup\bin\" + $buildConfig)
                $dependencyDestDir = $solutionDir + "\dotNet\dependencies\Mohawk SOA"
                                
                break
            }            

            "tmglegacy" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Commercial Website (Legacy)..."

                $projectDirRoot = $workingDirRoot + "mohawk-group"
                $solutionDir = $projectDirRoot + "\projects\TMG\trunk"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net35\bin\" + $buildConfig)
                $dependencyDestDir = $solutionDir + "\Dependencies"
                
                break
            }

            "rrts" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Residential Ready To Ship..."

                $projectDirRoot = $workingDirRoot + "mohawk-residential-ready-to-ship"
                $solutionDir = $projectDirRoot + "\dotnet"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net45\bin\" + $buildConfig)
                $dependencyDestDir = $solutionDir + "\Dependencies"
                
                break
            }

            "rts" {
                    
                Show-InfoMessage "Getting Dependencies for Mohawk Commerical Ready To Ship..."

                $projectDirRoot = $workingDirRoot + "mohawk-ready-to-ship"
                $solutionDir = $projectDirRoot + "\dotnet"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net45\bin\"  + $buildConfig)
                $dependencyDestDir = $solutionDir + "\Dependencies"
                
                break
            }

            "bmf" {
                    
                Show-InfoMessage "Getting Dependencies for BMF/Portico Website"

                $projectDirRoot = $workingDirRoot + "mohawk-bmf"
                $solutionDir = $projectDirRoot + "\dotnet"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net45\bin\"  + $buildConfig)
                $dependencyDestDir = $solutionDir + "\dependencies\Mohawk-SOA"
                                
                break
            }

            "aladdin" {
                    
                Show-InfoMessage "Getting Dependencies for Aladdin Commercial Website"

                $projectDirRoot = $workingDirRoot + "mohawk-aladdin-commercial"
                $solutionDir = $projectDirRoot + "\dotnet"
                $dependencySourceDirs = @($workingDirRoot + $soaDir + "dotNet\Mohawk.Services.Client.Net45\bin\"  + $buildConfig)
                $dependencyDestDir = $solutionDir + "\dependencies\Mohawk-SOA"
                                
                break
            }
                        
            default {

                Show-InfoMessage "Invalid Site Name!"
                Show-Usage
                return
            }
        }

        # Step 1: Build SOA
        Start-SiteBuild -siteName soa -buildConfig $buildConfig

        # Step 2, copy dependencies
        if($dependencySourceDirs.length -ne 0) {

            Show-InfoMessage "Copying dependencies..."

            foreach ($dependencyPath in $dependencySourceDirs) {
                Show-InfoMessage "Copying path contents from $dependencyPath to $dependencyDestDir"
                Invoke-Expression ("robocopy " + $dependencyPath + " " + '$dependencyDestDir' + " /XF *.config *.xml")
            }

            Show-InfoMessage "Dependency copy step complete."
        }
    }
}