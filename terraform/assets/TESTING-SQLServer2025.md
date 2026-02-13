# SQL Server 2025 Installation - Testing and Validation Guide

This guide helps you verify that SQL Server 2025 Developer Edition has been successfully installed using the Ansible playbooks.

## Pre-Installation Checklist

Before running the playbook, verify:

- [ ] Windows target server is accessible via WinRM
- [ ] You have administrator credentials for the Windows server
- [ ] At least 6GB free disk space on C: drive
- [ ] At least 4GB RAM available (8GB recommended)
- [ ] .NET Framework 4.8 is installed
- [ ] PowerShell 5.1 or later is installed
- [ ] Ansible collections are installed on control node:
  ```bash
  ansible-galaxy collection install ansible.windows
  ansible-galaxy collection install community.windows
  ```

## Installation Validation Steps

### 1. Verify SQL Server Service

After playbook execution, check if the SQL Server service is running:

**Via Ansible:**
```bash
ansible -i inventory-sqlserver.ini sqlservers -m ansible.windows.win_service -a "name=MSSQLSERVER"
```

**Expected Output:**
- Service state: `running`
- Service start mode: `auto`

**On Windows Server (PowerShell):**
```powershell
Get-Service -Name MSSQLSERVER | Select-Object Name, Status, StartType
```

### 2. Verify SQL Server Agent Service

**Via Ansible:**
```bash
ansible -i inventory-sqlserver.ini sqlservers -m ansible.windows.win_service -a "name=SQLSERVERAGENT"
```

**On Windows Server (PowerShell):**
```powershell
Get-Service -Name SQLSERVERAGENT | Select-Object Name, Status, StartType
```

### 3. Test SQL Server Connectivity

**Using sqlcmd (on Windows server):**
```cmd
sqlcmd -S localhost -U sa -P YourStrongPassword123!
```

If successful, you should see the `1>` prompt. Type `exit` to quit.

**Test Query:**
```cmd
sqlcmd -S localhost -U sa -P YourStrongPassword123! -Q "SELECT @@VERSION"
```

### 4. Verify TCP/IP Connectivity

**From a remote machine:**
```bash
# Using sqlcmd
sqlcmd -S <server-ip> -U sa -P YourStrongPassword123!

# Using telnet to test port
telnet <server-ip> 1433
```

### 5. Check Firewall Rules

**Via Ansible:**
```bash
ansible -i inventory-sqlserver.ini sqlservers -m ansible.windows.win_shell -a "Get-NetFirewallRule -DisplayName 'SQL Server*' | Select-Object DisplayName, Enabled, Direction"
```

**On Windows Server (PowerShell):**
```powershell
Get-NetFirewallRule -DisplayName "SQL Server*" | Select-Object DisplayName, Enabled, Direction, Action
```

**Expected Rules:**
- SQL Server Database Engine (Port 1433, TCP, Inbound, Enabled)
- SQL Server Browser (Port 1434, UDP, Inbound, Enabled)

### 6. Verify Installed Features

**Using PowerShell:**
```powershell
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\*\MSSQLServer\CurrentVersion' | Select-Object PSChildName
```

**Check installed components:**
```powershell
$sqlInstance = "MSSQLSERVER"
$sqlPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL"
$instanceName = (Get-ItemProperty -Path $sqlPath).$sqlInstance
$setupPath = "HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\$instanceName\Setup"
Get-ItemProperty -Path $setupPath | Select-Object Edition, Version
```

### 7. Test Database Operations

**Create a test database:**
```sql
sqlcmd -S localhost -U sa -P YourStrongPassword123!
> CREATE DATABASE TestDB;
> GO
> USE TestDB;
> GO
> CREATE TABLE TestTable (ID INT, Name NVARCHAR(50));
> GO
> INSERT INTO TestTable VALUES (1, 'Test');
> GO
> SELECT * FROM TestTable;
> GO
> DROP DATABASE TestDB;
> GO
> exit
```

### 8. Verify SQL Server Configuration

**Check TCP/IP Protocol:**
```powershell
# Via Registry
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp' | Select-Object Enabled

# Check TCP Port
Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQLServer\SuperSocketNetLib\Tcp\IPAll' | Select-Object TcpPort
```

**Expected:**
- TCP/IP Enabled: 1
- TCP Port: 1433

### 9. Review SQL Server Error Logs

**Location:**
```
C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\ERRORLOG
```

**Check for errors:**
```powershell
Get-Content "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Log\ERRORLOG" -Tail 50
```

Look for:
- "SQL Server is now ready for client connections"
- No critical errors or warnings

### 10. Verify Installation Directories

**Check installation paths:**
```powershell
# SQL Server binaries
Test-Path "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER"

# Data directory
Test-Path "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Data"

# Backup directory
Test-Path "C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\Backup"
```

## Automated Validation Playbook

You can create a simple validation playbook:

```yaml
---
- name: Validate SQL Server Installation
  hosts: sqlservers
  gather_facts: no

  tasks:
  - name: Check SQL Server service status
    ansible.windows.win_service:
      name: MSSQLSERVER
    register: sql_service

  - name: Display SQL Server service status
    debug:
      msg: "SQL Server is {{ sql_service.state }}"

  - name: Test SQL Server connectivity
    ansible.windows.win_command: >
      sqlcmd -S localhost -U sa -P "YourStrongPassword123!" -Q "SELECT @@VERSION"
    register: sql_test
    failed_when: false

  - name: Show SQL Server version
    debug:
      msg: "{{ sql_test.stdout_lines }}"
    when: sql_test.rc == 0

  - name: Check firewall rules
    ansible.windows.win_shell: |
      Get-NetFirewallRule -DisplayName "SQL Server*" | Select-Object DisplayName, Enabled
    register: firewall_rules

  - name: Display firewall rules
    debug:
      msg: "{{ firewall_rules.stdout_lines }}"
```

## Troubleshooting Common Issues

### Service Won't Start

1. Check Windows Event Viewer logs
2. Verify service account permissions
3. Check for port conflicts
4. Review SQL Server error logs

### Cannot Connect Remotely

1. Verify firewall rules are enabled
2. Check TCP/IP protocol is enabled
3. Confirm port 1433 is listening:
   ```powershell
   netstat -an | findstr 1433
   ```
4. Test basic network connectivity

### Installation Failed

1. Check available disk space
2. Verify .NET Framework version
3. Review Ansible playbook output for errors
4. Check setup logs at:
   ```
   C:\Program Files\Microsoft SQL Server\160\Setup Bootstrap\Log\
   ```

## Performance Tests (Optional)

### Basic Performance Test

```sql
-- Create test database
CREATE DATABASE PerfTest;
GO
USE PerfTest;
GO

-- Create test table
CREATE TABLE PerfTable (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Data NVARCHAR(100),
    DateCreated DATETIME DEFAULT GETDATE()
);
GO

-- Insert test data
DECLARE @i INT = 0;
WHILE @i < 10000
BEGIN
    INSERT INTO PerfTable (Data) VALUES ('Test data ' + CAST(@i AS NVARCHAR(10)));
    SET @i = @i + 1;
END;
GO

-- Test query performance
SET STATISTICS TIME ON;
SELECT COUNT(*) FROM PerfTable;
SET STATISTICS TIME OFF;
GO

-- Cleanup
DROP DATABASE PerfTest;
GO
```

## Success Criteria

Installation is successful if:

- [x] SQL Server service (MSSQLSERVER) is running
- [x] SQL Server Agent service is running
- [x] Can connect locally using sqlcmd
- [x] Can connect remotely (if required)
- [x] TCP/IP protocol is enabled on port 1433
- [x] Firewall rules are configured
- [x] Can create and query databases
- [x] No critical errors in SQL Server error logs
- [x] SQL Server version displays correctly

## Next Steps After Validation

1. **Security Hardening**
   - Change SA password
   - Disable SA account (if using Windows Authentication only)
   - Create individual user accounts
   - Configure auditing

2. **Configuration Optimization**
   - Adjust max memory settings
   - Configure backup strategy
   - Set up maintenance plans
   - Configure database mail (if needed)

3. **Monitoring Setup**
   - Configure SQL Server Agent alerts
   - Set up performance monitoring
   - Configure extended events

4. **Backup Configuration**
   - Create backup jobs
   - Test restore procedures
   - Document backup strategy

## Additional Resources

- [SQL Server Troubleshooting Guide](https://docs.microsoft.com/en-us/sql/database-engine/configure-windows/troubleshoot-connecting-to-the-sql-server-database-engine)
- [SQL Server Best Practices](https://docs.microsoft.com/en-us/sql/relational-databases/best-practices/)
- [SQL Server Security Best Practices](https://docs.microsoft.com/en-us/sql/relational-databases/security/)
