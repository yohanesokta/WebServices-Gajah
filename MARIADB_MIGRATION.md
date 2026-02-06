# MariaDB Migration Guide

## Overview

This document describes the migration from MySQL to MariaDB for the Gajah WebServer project to ensure cross-platform consistency and better compatibility.

## Background

### Previous State
- **Windows**: MariaDB 12.0.2 ✅ (already compliant)
- **Linux**: MySQL 9.6.0 ⚠️ (inconsistent)

### Current State (After Migration)
- **Windows**: MariaDB 12.0.2 ✅
- **Linux**: MariaDB 10.11.10 LTS ✅

## Benefits of This Migration

1. **Cross-Platform Consistency**: Both Windows and Linux now use MariaDB
2. **Better Compatibility**: MariaDB is a drop-in replacement for MySQL with better Linux server support
3. **Long-Term Support**: Using MariaDB 10.11 LTS ensures stability and long-term updates
4. **Licensing**: MariaDB has more permissive licensing compared to Oracle MySQL
5. **Performance**: MariaDB offers performance improvements and better query optimization

## Changes Made

### 1. Linux Installation Script (`pages/linux.sh`)
- Updated download URL to MariaDB 10.11.10 LTS
- Changed all references from "MySQL" to "MariaDB" in user messages
- Updated initialization command to use MariaDB's `mysql_install_db` script
- Maintained backward compatibility with symlink to `/opt/runtime/mysql`

### 2. Application Code (`lib/components/mariadb_control.dart`)
- Unified display name to "MariaDB" on both platforms
- Updated asset image reference to use MariaDB logo consistently

### 3. Documentation
- This migration guide documents the changes and rationale

## Technical Details

### MariaDB Version Selection
- **Windows**: MariaDB 12.0.2 (latest stable)
- **Linux**: MariaDB 10.11.10 (LTS - Long Term Support)

The different versions are acceptable because:
- Both are MariaDB (same codebase)
- Both support utf8mb4 charset
- Both use InnoDB as default storage engine
- SQL compatibility is maintained across versions

### Character Set & Collation
Both installations use:
- **Charset**: `utf8mb4` (recommended for full Unicode support)
- **Storage Engine**: InnoDB (ACID-compliant, supports transactions)

### Installation Paths
- **Windows**: `C:\gajahweb\mariadb`
- **Linux**: `/opt/runtime/mysql` (symlink to MariaDB installation)

The Linux path maintains "mysql" for compatibility with existing scripts and configurations.

## Migration Steps for Existing Users

### For New Installations
No special steps required. Just run the setup scripts:
- **Windows**: `setup.bat`
- **Linux**: `sudo bash pages/linux.sh`

### For Existing Linux Users

If you already have MySQL 9.6.0 installed and want to migrate to MariaDB:

1. **Backup your databases**:
   ```bash
   /opt/runtime/mysql/bin/mysqldump -u root -p --all-databases > ~/mysql_backup.sql
   ```

2. **Stop MySQL**:
   ```bash
   # Use the Gajah WebServer UI or:
   sudo /opt/runtime/mysql/bin/mysqladmin shutdown
   ```

3. **Backup data directory**:
   ```bash
   sudo mv /opt/runtime/mysql/data /opt/runtime/mysql/data.backup
   ```

4. **Remove old MySQL installation**:
   ```bash
   sudo rm -rf /opt/runtime/mysql-9.6.0-linux-glibc2.28-x86_64-minimal
   sudo rm /opt/runtime/mysql
   ```

5. **Re-run the installer**:
   ```bash
   sudo bash pages/linux.sh
   ```

6. **Restore your databases**:
   ```bash
   /opt/runtime/mysql/bin/mysql -u root < ~/mysql_backup.sql
   ```

## Verification

After installation, verify MariaDB is working:

### Check Version
```bash
# Linux
/opt/runtime/mysql/bin/mysqld --version

# Windows
C:\gajahweb\mariadb\bin\mysqld.exe --version
```

Expected output should contain "MariaDB".

### Check Service Status
Use the Gajah WebServer UI to start MariaDB and verify:
- Green "Running" status
- Port 3306 is in use
- phpMyAdmin is accessible at `http://localhost/phpmyadmin`

## Compatibility Notes

### SQL Mode
MariaDB uses a slightly different default SQL mode. If you encounter compatibility issues:

```sql
-- Check current SQL mode
SELECT @@sql_mode;

-- Set MySQL-compatible mode if needed
SET GLOBAL sql_mode = 'MYSQL';
```

### Character Set
Ensure utf8mb4 is used for new databases:

```sql
CREATE DATABASE mydb 
CHARACTER SET utf8mb4 
COLLATE utf8mb4_unicode_ci;
```

### Engine
InnoDB is the default and recommended engine:

```sql
CREATE TABLE mytable (
  id INT PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(255)
) ENGINE=InnoDB;
```

## Troubleshooting

### Port Already in Use
If port 3306 is already in use:
1. Check for other MySQL/MariaDB instances
2. Stop conflicting services
3. Or change the port in Settings

### Permission Issues (Linux)
Ensure proper ownership:
```bash
sudo chown -R mysql:mysql /opt/runtime/mysql/data
```

### Data Directory Not Initialized
If MariaDB won't start, reinitialize:
```bash
sudo rm -rf /opt/runtime/mysql/data
sudo /opt/runtime/mysql/scripts/mysql_install_db \
  --user=mysql \
  --basedir=/opt/runtime/mysql \
  --datadir=/opt/runtime/mysql/data
```

## References

- [MariaDB Official Documentation](https://mariadb.org/documentation/)
- [MariaDB vs MySQL Compatibility](https://mariadb.com/kb/en/mariadb-vs-mysql-compatibility/)
- [MariaDB InnoDB Documentation](https://mariadb.com/kb/en/innodb/)

## Acceptance Criteria (Met)

- ✅ Aplikasi berjalan normal di MariaDB
- ✅ Character set menggunakan utf8mb4
- ✅ Storage engine menggunakan InnoDB
- ✅ Cross-platform consistency (Windows & Linux)
- ✅ Menggunakan MariaDB LTS untuk stabilitas
- ✅ Dokumentasi lengkap tersedia

## Conclusion

The migration to MariaDB provides better cross-platform consistency and long-term stability for the Gajah WebServer project. Windows users already had MariaDB, and Linux users now benefit from the same reliable database engine.
