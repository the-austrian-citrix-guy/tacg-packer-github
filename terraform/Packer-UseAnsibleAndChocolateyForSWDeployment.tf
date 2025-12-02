# Terraform Deployment to install Software Packages on Target machines using Ansible and Chocolatey
## Reference https://docs.ansible.com/projects/ansible/latest/collections/chocolatey/chocolatey/win_chocolatey_module.html
### Reference https://community.chocolatey.org/packages
#### Ansible-related Variables
###### ***** IMPORTANT: You must set the permissions to the destination directory accordingly (sudo) chmod 777 otherwise the provisioning will fail *****
resource "null_resource" "CopyPlaybooksForTargetToAnsibleServer" {
  connection {
    type     = var.TACG-TMM-Ansible-Connection-Type
    user     = var.TACG-TMM-Ansible-Connection-User
    password = var.TACG-TMM-Ansible-Connection-Password
    host     = var.TACG-TMM-Ansible-Connection-HostIP
  }

  provisioner "file" {
    source      = var.TACG-TMM-Ansible-GetSWPackagesInstalledByChocolatey-Playbook-Source
    destination = var.TACG-TMM-Ansible-GetSWPackagesInstalledByChocolatey-Playbook-Destination
  }

  provisioner "file" {
    source      = var.TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-Playbook-Source
    destination = var.TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-Playbook-Destination
  }

  provisioner "file" {
    source      = var.TACG-TMM-Ansible-RemoveSWPackagesUsingChocolatey-Playbook-Source
    destination = var.TACG-TMM-Ansible-RemoveSWPackagesUsingChocolatey-Playbook-Destination
  }

    provisioner "file" {
    source      = var.TACG-TMM-Ansible-CheckAnsibleReturnCodeShellScript-Source
    destination = var.TACG-TMM-Ansible-CheckAnsibleReturnCodeShellScript-Destination
  }

  provisioner "file" {
    source      = var.TACG-TMM-Ansible-Inventory-Source
    destination = var.TACG-TMM-Ansible-Inventory-Destination
  }
}
 
#### Wait 10s Minute for Backgroud Processes to settle
resource "time_sleep" "wait_10_seconds" {
  depends_on = [null_resource.CopyPlaybooksForTargetToAnsibleServer]
  create_duration = "10s"
}

#### Use Ansible to install Software Packages using Chocolatey on Target Machine 
resource "null_resource" "DeploySW" {
  depends_on = [time_sleep.wait_10_seconds]
  provisioner "local-exec" {
    working_dir = "/etc/ansible"
    command     = var.TACG-TMM-Ansible-InstallSWPackagesUsingChocolatey-CMD
  }
}

##### Check Ansible Return Code
data "external" "CheckAnsibleReturnCode" {
  depends_on = [null_resource.DeploySW]
  program    = ["bash", "/etc/ansible/packer/assets/CheckAnsibleReturnCode.sh", "/etc/ansible/packer/assets/ansible_exit_code.txt", "0|3010"]
}

##### Terminate if Return Code is not 0
resource "null_resource" "IfExitCodeIsNotZeroThenHalt" {
  depends_on = [data.external.CheckAnsibleReturnCode]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "[ \"${data.external.CheckAnsibleReturnCode.result.found}\" = \"1\" ] && echo \"Software Packages were successfully deployed - Everything OK\" || { echo \"Deploying Software Packages failed. Please review the settings. Halting Terraform.\"; exit 1; }"
  }
}

resource "time_sleep" "wait_10_seconds_1" {
  depends_on      = [null_resource.IfExitCodeIsNotZeroThenHalt]
  create_duration = "10s"
}

#### Use Ansible to list all Software Packages using Chocolatey on Target Machine 
resource "null_resource" "GetSWPackages" {
  depends_on = [time_sleep.wait_10_seconds_1]
  provisioner "local-exec" {
    working_dir = "/etc/ansible"
    command     = var.TACG-TMM-Ansible-GetSWPackagesInstalledByChocolate-CMD
  }
}

##### Check Ansible Return Code
data "external" "CheckAnsibleReturnCode_1" {
  depends_on = [null_resource.GetSWPackages]
  program    = ["bash", "/etc/ansible/packer/assets/CheckAnsibleReturnCode.sh", "/etc/ansible/packer/assets/ansible_exit_code.txt", "0"]
}

##### Terminate if Return Code is not 0
resource "null_resource" "IfExitCodeIsNotZeroThenHalt_1" {
  depends_on = [data.external.CheckAnsibleReturnCode_1]
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = "[ \"${data.external.CheckAnsibleReturnCode_1.result.found}\" = \"1\" ] && echo \"Software Packages were successfully listed - Everything OK\" || { echo \"Listing Software Packages failed. Please review the settings. Halting Terraform.\"; exit 1; }"
  }
}

##### All necessary playbooks on the VMs are complete
