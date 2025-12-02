# Terraform Deployment to install Software Packages on Target machines using Ansible and Chocolatey
## Reference https://docs.ansible.com/projects/ansible/latest/collections/chocolatey/chocolatey/win_chocolatey_module.html
### Reference https://community.chocolatey.org/packages
#### Ansible-related Variables
variable "TACG-TMM-Ansible-Connection-Type" {
  type        = string
  description = "REQUIRED: Type of Connection to Ansible Server"
}

variable "TACG-TMM-Ansible-Connection-User" {
  type        = string
  description = "REQUIRED: Username for Connection to Ansible Server"
}

variable "TACG-TMM-Ansible-Connection-Password" {
  type        = string
  description = "REQUIRED: Password for Connection to Ansible Server"
}

variable "TACG-TMM-Ansible-Connection-HostIP" {
  type        = string
  description = "REQUIRED: IP of Ansible Server"
}

variable "TACG-TMM-Ansible-GetSWPackagesInstalledByChocolate-CMD" {
  type        = string
  description = "REQUIRED: Command for running GetSWPackagesInstalledByChocolate-Playbook to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-CMD" {
  type        = string
  description = "REQUIRED: Command for running InstallSWPackagesUsingChocolatey-Playbook to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-RemoveSWPackagesUsingChocolatey-CMD" {
  type        = string
  description = "REQUIRED: Command for running RemoveSWPackagesUsingChocolatey-Playbook to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-GetSWPackagesInstalledByChocolatey-Playbook-Source" {
  type        = string
  description = "REQUIRED: Source path to GetSWPackagesInstalledByChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-Playbook-Source" {
  type        = string
  description = "REQUIRED: Source path to InstallSWPackagesUsingChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-RemoveSWPackagesUsingChocolatey-Playbook-Source" {
  type        = string
  description = "REQUIRED: Source path to RemoveSWPackagesUsingChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-CheckAnsibleReturnCodeShellScript-Source" {
  type        = string
  description = "REQUIRED: Source path to CheckAnsibleReturnCodeShellScript-shell script for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-Inventory-Source" {
  type        = string
  description = "REQUIRED: Source path to Inventory for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-GetSWPackagesInstalledByChocolatey-Playbook-Destination" {
  type        = string
  description = "REQUIRED: Destination path to GetSWPackagesInstalledByChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-Playbook-Destination" {
  type        = string
  description = "REQUIRED: Destination path to InstallSWPackagesUsingChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-RemoveSWPackagesUsingChocolatey-Playbook-Destination" {
  type        = string
  description = "REQUIRED: Destination path to RemoveSWPackagesUsingChocolatey-Playbook for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-CheckAnsibleReturnCodeShellScript-Destination" {
  type        = string
  description = "REQUIRED: Destination path to CheckAnsibleReturnCodeShellScript-shell script for target machine to be sent to Ansible Server"
}

variable "TACG-TMM-Ansible-Inventory-Destination" {
  type        = string
  description = "REQUIRED: Destination path to Inventory for target machine to be sent to Ansible Server"
}
