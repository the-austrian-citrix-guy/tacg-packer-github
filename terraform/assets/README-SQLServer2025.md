# SQL Server 2025 Developer Edition - Ansible Playbook

This directory contains a ready-to-use Ansible playbook for installing Microsoft SQL Server 2025 Developer Edition on Windows servers.

## Prerequisites

### On the Ansible Control Node
- Ansible 2.9 or later
- Python 3.6 or later
- Required Ansible collections:
  ```bash
  ansible-galaxy collection install ansible.windows
  ansible-galaxy collection install community.windows
  ```

### On the Target Windows Server
- Windows Server 2019, 2022, or Windows 10/11 (for Developer Edition)
- PowerShell 5.1 or later
- WinRM configured and enabled
- .NET Framework 4.8 or later
- At least 6GB of free disk space
- At least 4GB of RAM (8GB recommended)

## Playbook Files

### Main Playbook
- **InstallSQLServer2025DeveloperEdition.ansible.yml**: Complete playbook with all features

## Quick Start

### 1. Update Inventory File

Edit the inventory file (e.g., `inventory.ini`) with your target Windows server(s):

```ini
[sqlservers]
192.168.1.100

[sqlservers:vars]
ansible_user=Administrator
ansible_password=YourWindowsPassword
ansible_connection=winrm
ansible_winrm_transport=basic
ansible_winrm_port=5985
ansible_winrm_server_cert_validation=ignore
```

### 2. Customize Variables (Optional)

The playbook includes several variables you can customize. Edit the playbook and modify the `vars` section:

```yaml
vars:
  sql_instance_name: "MSSQLSERVER"              # Default instance name
  sql_sa_password: "YourStrongPassword123!"      # SA password (change this!)
  sql_features: "SQLENGINE,REPLICATION,FULLTEXT" # Features to install
  sql_collation: "SQL_Latin1_General_CP1_CI_AS"  # Collation setting
```

**Important Security Note**: Always change the default `sql_sa_password` to a strong, unique password!

### 3. Run the Playbook

Execute the playbook with the following command:

```bash
ansible-playbook -i inventory.ini InstallSQLServer2025DeveloperEdition.ansible.yml
```

For verbose output:
```bash
ansible-playbook -i inventory.ini InstallSQLServer2025DeveloperEdition.ansible.yml -vvv
```

## What the Playbook Does

1. **Pre-Installation Checks**
   - Verifies if SQL Server is already installed
   - Creates necessary temporary directories

2. **Download and Prepare**
   - Downloads the SQL Server 2025 Developer Edition ISO from Microsoft
   - Mounts the ISO file
   - Generates a configuration file for unattended installation

3. **Installation**
   - Installs SQL Server with the following features:
     - Database Engine
     - Replication
     - Full-Text Search
     - Integration Services
     - Client Tools Connectivity
     - SQL Client Connectivity SDK

4. **Post-Installation Configuration**
   - Enables TCP/IP protocol on port 1433
   - Enables Named Pipes protocol
   - Configures Windows Firewall rules
   - Restarts SQL Server service
   - Verifies the installation

## Installed Components

The playbook installs the following SQL Server features by default:
- **SQLENGINE**: Database Engine Services
- **REPLICATION**: SQL Server Replication
- **FULLTEXT**: Full-Text and Semantic Extractions for Search
- **IS**: Integration Services
- **CONN**: Client Tools Connectivity
- **BC**: Client Tools Backwards Compatibility
- **SDK**: Client Tools SDK
- **SNAC_SDK**: SQL Client Connectivity SDK

## Configuration Details

### Default Installation Paths
- **Program Files**: `C:\Program Files\Microsoft SQL Server`
- **Instance Directory**: `C:\Program Files\Microsoft SQL Server`
- **Data Directory**: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data`
- **Backup Directory**: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup`

### Network Configuration
- **TCP/IP Port**: 1433 (SQL Server)
- **UDP Port**: 1434 (SQL Server Browser)
- **Protocols Enabled**: TCP/IP, Named Pipes

### Service Accounts
The playbook uses built-in system accounts suitable for Developer Edition:
- **SQL Server Service**: NT AUTHORITY\SYSTEM
- **SQL Server Agent**: NT AUTHORITY\SYSTEM

## Customization Options

### Installing Specific Features

To install only specific features, modify the `sql_features` variable:

```yaml
# Minimal installation (Database Engine only)
sql_features: "SQLENGINE"

# Full installation
sql_features: "SQLENGINE,REPLICATION,FULLTEXT,IS,AS,RS,CONN,BC,SDK,SNAC_SDK"
```

Available features:
- **SQLENGINE**: Database Engine
- **REPLICATION**: Replication
- **FULLTEXT**: Full-Text Search
- **IS**: Integration Services
- **AS**: Analysis Services
- **RS**: Reporting Services
- **CONN**: Client Tools Connectivity
- **BC**: Backwards Compatibility
- **SDK**: Software Development Kit

### Custom Instance Name

To use a named instance instead of the default:

```yaml
sql_instance_name: "MYINSTANCE"
```

### Authentication Mode

The playbook is configured for mixed mode authentication (Windows + SQL Server). To use Windows Authentication only, modify the configuration file section in the playbook.

## Troubleshooting

### Playbook Fails to Download ISO
- Check internet connectivity on the target server
- Verify the ISO URL is current and accessible
- Increase the timeout value in the download task

### Installation Hangs
- Check available disk space (minimum 6GB required)
- Verify .NET Framework 4.8 is installed
- Check the Windows Event Viewer for SQL Server installation logs

### Service Won't Start
- Check Windows Event Viewer > Application logs
- Review SQL Server Error logs at: `C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\ERRORLOG`
- Verify service account permissions

### Cannot Connect to SQL Server
- Verify SQL Server service is running
- Check firewall rules are properly configured
- Test connectivity: `sqlcmd -S localhost -U sa -P YourPassword`
- Verify TCP/IP protocol is enabled in SQL Server Configuration Manager

## Post-Installation Steps

After successful installation:

1. **Change the SA Password**
   ```sql
   ALTER LOGIN sa WITH PASSWORD = 'NewStrongPassword123!';
   ```

2. **Create Additional Logins/Users**
   ```sql
   CREATE LOGIN MyUser WITH PASSWORD = 'Password123!';
   CREATE USER MyUser FOR LOGIN MyUser;
   ```

3. **Configure Databases**
   ```sql
   CREATE DATABASE MyDatabase;
   ```

4. **Enable SQL Server Agent** (if needed)
   ```sql
   EXEC sp_configure 'show advanced options', 1;
   RECONFIGURE;
   EXEC sp_configure 'Agent XPs', 1;
   RECONFIGURE;
   ```

5. **Review and adjust SQL Server configuration settings** based on your workload

## Security Recommendations

1. **Change Default Passwords**: Always change the SA password immediately after installation
2. **Use Windows Authentication**: Where possible, use Windows Authentication instead of SQL Authentication
3. **Disable SA Account**: Consider disabling the SA account and using individual Windows accounts
4. **Configure Firewall**: Only allow SQL Server access from trusted networks
5. **Enable Encryption**: Configure SSL/TLS for SQL Server connections
6. **Regular Updates**: Keep SQL Server updated with the latest patches
7. **Audit Configuration**: Enable SQL Server auditing for security monitoring

## Additional Resources

- [SQL Server 2025 Documentation](https://docs.microsoft.com/en-us/sql/)
- [SQL Server Installation Guide](https://docs.microsoft.com/en-us/sql/database-engine/install-windows/install-sql-server)
- [Ansible Windows Modules](https://docs.ansible.com/ansible/latest/collections/ansible/windows/)
- [SQL Server Configuration Best Practices](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/)

## License

This playbook is provided as-is for use with Microsoft SQL Server 2025 Developer Edition. 
SQL Server Developer Edition is free but licensed only for development and testing, not production use.
Please review Microsoft's licensing terms for SQL Server.

## Support

For issues or questions:
- Check the troubleshooting section above
- Review Ansible and SQL Server documentation
- Open an issue in this repository

## Version History

- **v1.0** (2026-02-13): Initial release
  - SQL Server 2025 Developer Edition support
  - Unattended installation
  - Automatic firewall configuration
  - TCP/IP protocol enablement
