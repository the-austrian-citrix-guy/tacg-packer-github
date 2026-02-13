# Quick Start Guide: SQL Server 2025 Developer Edition Installation

This guide will help you quickly install SQL Server 2025 Developer Edition using the provided Ansible playbooks.

## Choose Your Installation Method

Two playbooks are available:

1. **InstallSQLServer2025DeveloperEdition.ansible.yml** - Full installation with complete control
2. **InstallSQLServerUsingChocolatey.ansible.yml** - Simplified installation using Chocolatey (recommended for quick setup)

## Prerequisites

Install required Ansible collections:
```bash
ansible-galaxy collection install ansible.windows
ansible-galaxy collection install community.windows
```

## Quick Installation (3 Steps)

### Step 1: Update Inventory

Edit `inventory-sqlserver.ini`:
```ini
[sqlservers]
192.168.1.100    # Replace with your server IP

[sqlservers:vars]
ansible_user=Administrator
ansible_password=YourPassword
ansible_connection=winrm
ansible_winrm_transport=basic
ansible_winrm_port=5985
ansible_winrm_server_cert_validation=ignore
```

### Step 2: Customize SA Password

Edit the playbook and change the default SA password:
```yaml
sql_sa_password: "YourStrongPassword123!"  # Change this!
```

### Step 3: Run the Playbook

```bash
# Using the full installation playbook
ansible-playbook -i inventory-sqlserver.ini InstallSQLServer2025DeveloperEdition.ansible.yml

# OR using the Chocolatey simplified version
ansible-playbook -i inventory-sqlserver.ini InstallSQLServerUsingChocolatey.ansible.yml
```

## What Happens During Installation

1. Downloads SQL Server 2025 Developer Edition
2. Installs SQL Server with default features
3. Configures TCP/IP on port 1433
4. Sets up Windows Firewall rules
5. Starts SQL Server services
6. Verifies the installation

## After Installation

Connect to SQL Server:
```bash
sqlcmd -S <server-ip> -U sa -P YourStrongPassword123!
```

Or use SQL Server Management Studio (SSMS) to connect.

## Need Help?

See the full documentation: **README-SQLServer2025.md**

## Important Security Note

⚠️ **Always change the SA password immediately after installation!**

The default password in the playbook is for demonstration purposes only. Use a strong, unique password for production or even development environments.
