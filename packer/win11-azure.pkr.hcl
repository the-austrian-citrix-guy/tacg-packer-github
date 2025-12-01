variable "Azure_ClientID" {
  type        = string
  description = "Azure Service Principal App ID"
  sensitive   = true
}

variable "Azure_ClientSecret" {
  type        = string
  description = "Azure Service Principal Secret"
  sensitive   = true
}

variable "Azure_SubscriptionID" {
  type        = string
  description = "Azure Subscription ID"
  sensitive   = true
}

variable "Azure_TenantID" {
  type        = string
  description = "Azure Tenant ID"
  sensitive   = true
}

variable "Azure_RG" {
  type        = string
  description = "Packer Artifacts Resource Group"
}

variable "Azure_TempRG" {
  type        = string
  description = "Packer Build Resource Group"
}

variable "Azure_ImgPublisher" {
  type        = string
  description = "Windows Image Publisher"
}

variable "Azure_ImgOffer" {
  type        = string
  description = "Windows Image Offer"
}

variable "Azure_ImgSKU" {
  type        = string
  description = "Windows Image SKU"
}

variable "Azure_ImgVersion" {
  type        = string
  description = "Windows Image Version"
}

variable "Azure_ManagedImgName" {
  type        = string
  description = "FInalized Windows Image Name"
}

variable "Azure_SIG-ImgVersion" {
  type        = string
  description = "FInalized Windows Image Name"
}

variable "Azure_SIG-Name" {
  type        = string
  description = "FInalized Windows Image Name"
}


variable "Azure_SIG-ImgName" {
  type        = string
  description = "FInalized Windows Image Name"
}


variable "Azure_VMSize" {
  type        = string
  description = "FInalized Windows Image Name"
}

packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = "~> 2"
    }
  }
}


source "azure-arm" "W11MIWitSWPackagesWithoutVDA" {
  # Tagging
  azure_tags = {
    environment = "TMM",
    environment-entity ="GK-TF",
    usage ="Prod"
  }
  # WinRM Communicator
  communicator   = "winrm"
  winrm_use_ssl  = true
  winrm_insecure = true
  winrm_timeout  = "5m"
  winrm_username = "packer"

  # Service Principal Authentication
  client_id       = var.Azure_ClientID
  client_secret   = var.Azure_ClientSecret
  subscription_id = var.Azure_SubscriptionID
  tenant_id       = var.Azure_TenantID

  # Source Image
  os_type         = "Windows"
  image_publisher = var.Azure_ImgPublisher
  image_offer     = var.Azure_ImgOffer
  image_sku       = var.Azure_ImgSKU
  image_version   = var.Azure_ImgVersion

  # Destination Image
  managed_image_resource_group_name = var.Azure_RG
  managed_image_name                = var.Azure_ManagedImgName

  # Packer Computing Resources
  build_resource_group_name = var.Azure_TempRG
  vm_size                   = var.Azure_VMSize
}

build {
  source "azure-arm.W11MIWitSWPackagesWithoutVDA" {}

  # Install Chocolatey: https://chocolatey.org/install#individual
  provisioner "powershell" {
    inline = ["Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))"]
  }

  # Install Chocolatey packages
  provisioner "file" {
    source      = "./packer/SWPackagesToInstall.config"
    destination = "D:/SWPackagesToInstall.config"
  }

  provisioner "powershell" {
    inline = ["choco install --confirm D:/SWPackagesToInstall.config"]
    # See https://docs.chocolatey.org/en-us/choco/commands/install#exit-codes
    valid_exit_codes = [0, 3010]
  }

  provisioner "windows-restart" {}

  # Generalize image using Sysprep
  # See https://www.packer.io/docs/builders/azure/arm#windows
  # See https://docs.microsoft.com/en-us/azure/virtual-machines/windows/build-image-with-packer#define-packer-template
  provisioner "powershell" {
    inline = [
      "while ((Get-Service RdAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "while ((Get-Service WindowsAzureGuestAgent).Status -ne 'Running') { Start-Sleep -s 5 }",
      "& $env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quiet /quit /mode:vm",
      "while ($true) { $imageState = Get-ItemProperty HKLM:\\SOFTWARE\\Microsoft\\Windows\\CurrentVersion\\Setup\\State | Select ImageState; if($imageState.ImageState -ne 'IMAGE_STATE_GENERALIZE_RESEAL_TO_OOBE') { Write-Output $imageState.ImageState; Start-Sleep -s 10  } else { break } }"
    ]
  }
}