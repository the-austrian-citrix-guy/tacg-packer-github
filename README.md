
# The Austrian Citrix Guy

![TACG-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/the-austrian-citrix-guy.at_.512sq.noblue.png)

## Welcome to my GitHub repository.

I want to use this repository as a way to show my enthusiasm for all kinds of Automation like Terraform, Ansible, Packer, Docker, etc.

I am working as a Principal Product Marketing Manager@Citrix/Cloud Software Group Austria GmbH in Vienna, Austria.

I have almost 30 years of experience in End-User Computing and working with Microsoft and Citrix Technologies.
As PPMM, my focus is on all kinds of Automation and HyperScalers (especially Microsoft Azure) as well as Microsoft AzureStack HCI.
I am also responsible for the Citrix TechZone in the Citrix Community together with 2 other colleagues.

I hold numerous certifications in the Microsoft and Citrix area and the Automation and Network field.

![AzureArch-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/azure-architect-225.png) ![AzureCyber-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/azure-cybersec-225.png) ![MCT-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/mct2024-225.png) ![MCSE-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/mcse-225.png) ![CCEV-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/cce-v-225.png) ![CCI-Logo](https://www.the-austrian-citrix-guy.at/wp-content/uploads/2024/11/CCI-225.png)

## Featured Content

### SQL Server 2025 Developer Edition - Ansible Playbooks

Ready-to-use Ansible playbooks for automated installation of Microsoft SQL Server 2025 Developer Edition on Windows servers.

📁 **Location**: `terraform/assets/`

**Available Playbooks:**
- **InstallSQLServer2025DeveloperEdition.ansible.yml** - Complete installation with full control over all parameters
- **InstallSQLServerUsingChocolatey.ansible.yml** - Simplified installation using Chocolatey package manager

**Quick Start:**
```bash
# Install required Ansible collections
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install community.windows

# Run the playbook
ansible-playbook -i inventory-sqlserver.ini InstallSQLServer2025DeveloperEdition.ansible.yml
```

📖 **Documentation:**
- [Quick Start Guide](terraform/assets/QUICKSTART-SQLServer2025.md)
- [Complete Documentation](terraform/assets/README-SQLServer2025.md)
- [Example Inventory](terraform/assets/inventory-sqlserver.ini)

**Features:**
- Unattended installation
- Automatic firewall configuration
- TCP/IP protocol enablement
- Comprehensive error handling
- Post-installation verification
