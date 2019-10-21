<#
 .Synopsis
  Get the IP of a VM.

 .Description
  Returns the first IP address of a running VM. Fails if the VM is not running.

 .Parameter Name
  Name of the VM.

 .Example
   # Get first IP address of the VM "Ubuntu".
   Get-VM-IP Ubuntu
#>
function Get-VMIP {
param (
    [Parameter(Mandatory=$true)][string]$Name
)

$vm = Get-VM $Name -ErrorAction stop

if (!$vm.State.Equals([Microsoft.HyperV.PowerShell.VMState]::Running)) {
    throw "VM $($vm.Name) is not Running"
}

$addrs = $vm.NetworkAdapters[0].IPAddresses

if (!$addrs) {
    throw "VM $($vm.Name) has no IP address"
}

return $addrs[0]
}
Set-Alias gvmip Get-VMIP
Export-ModuleMember -Function Get-VMIP -Alias gvmip