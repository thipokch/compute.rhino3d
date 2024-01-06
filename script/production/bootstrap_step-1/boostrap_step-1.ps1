# This script installs IIS and the features required to
# run rhino.compute.
#
# * Make sure you run this script from a Powershel Admin Prompt!
# * Make sure Powershell Execution Policy is bypassed to run these scripts:
Set-ExecutionPolicy Bypass -Scope Process -Force

#Region funcs
function Write-Step { 
  Write-Host
  Write-Host "===> "$args[0] -ForegroundColor Green
  Write-Host
}
#EndRegion funcs

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path C:\bootstrap_step-1_log.txt -append

#In case $PSScriptRoot is empty (version of powershell V.2).  
if(!$PSScriptRoot){ $PSScriptRoot = Split-Path $MyInvocation.MyCommand.Path -Parent } 

Write-Host @"
  # # # # # # # # # # # # # # # # # # # # #
  #                                       #
  #       R H I N O   C O M P U T E       #
  #                                       #
  #    B O O T S T R A P   S C R I P T    #
  #                                       #
  #                STEP 1                 #
  #                                       #
  # # # # # # # # # # # # # # # # # # # # #
"@

# check os is server
# $os = (Get-CimInstance -ClassName 'Win32_OperatingSystem').Caption
# if ($os -notlike '*server*') {
#     Write-Host "The script is intended for use on Windows Server. Detected '$os'" -ForegroundColor Red
#     exit 1
# }

Write-Host "Root Script Path:" $PSScriptRoot

# These scripts should be run in this order
& "$PSScriptRoot\module_rhino.ps1"
& "$PSScriptRoot\module_firewall.ps1"
& "$PSScriptRoot\module_iis_install.ps1"

Write-Step 'Restart Windows to complete setup!'
Write-Host 'Rebooting in 5 seconds...'
Stop-Transcript
shutdown /r /t 5

