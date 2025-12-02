# Terraform Deployment to install Software Packages on Target machines using Ansible and Chocolatey
## Reference https://docs.ansible.com/projects/ansible/latest/collections/chocolatey/chocolatey/win_chocolatey_module.html
### Reference https://community.chocolatey.org/packages
#### Ansible-related Variables

variable "XS-CL-IP" {
  type        = string
  sensitive   = false
  description = "REQUIRED: FQDN of the XenServer-Master"
}
variable "XS-CL-UN" {
  type        = string
  sensitive   = true
  description = "REQUIRED: XenServer Username"
}
variable "XS-CL-PW" {
  type        = string
  sensitive   = true
  description = "REQUIRED: XenServer Password"
}

## Definition of Citrix ADC Provider variables - not all available variables are defined, only these we use
variable "NSVPX-NSIP1" {
  type        = string
  description = "REQUIRED: IP of the NSVPX1 to connect to"
}
variable "NSVPX-UN" {
  type        = string
  sensitive   = true
  description = "REQUIRED: nsroot"
}
variable "NSVPX-PW" {
  type        = string
  sensitive   = true
  description = "REQUIRED: nsroot-PW"
}