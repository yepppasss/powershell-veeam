 <#
.SYNOPSIS
  Nagios script that checks for free Backup instances
.DESCRIPTION
  This script checks the total number of licensed instances and calculates the difference with the number of instances used.
.PARAMETER
  None
.INPUTS
  None
.OUTPUTS
  None
.NOTES
  Version:        0.1
  Author:         Eduard R. Gilete
  Creation Date:  24/12/2021
  Purpose/Change: Check with Nagios the free Backup instances
.EXAMPLE
  None
#>

# Loading Veeam PS Module
Import-Module "C:\Program Files\Veeam\Backup365\Veeam.Archiver.PowerShell\Veeam.Archiver.PowerShell.psd1" 3>$null

$returnStateOK = 0
$returnStateWarning = 1
$returnStateCritical = 2
$returnStateUnknown = 3

$license =  Get-VBOLicense
$Total = $license.Totalnumber
$licenseusers =  Get-VBOLicensedUser | Measure-Object
$Utilizadas = $licenseusers.Count

$Libres = ($Total - $Utilizadas)

if($Libres -lt 5){
    write-host "CRITICAL --> Hay $Utilizadas Instancias en uso y disponibles $Libres."
    exit $returnStateCritical
}
elseif ($Libres -lt 10) {
    write-host "WARNING --> Hay $Utilizadas Instancias en uso y disponibles $Libres."
    exit $returnStateWarning
}
elseif ($Libres -ge 10) {
    write-host "OK --> Hay $Utilizadas Instancias en uso y disponibles $Libres."
    exit $returnStateOK
}
