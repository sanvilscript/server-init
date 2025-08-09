# SANVIL SERVER TOOLS

**Complete Server Management Suite v1.0.0**

Automated tools for SSH server initialization and DNS management with security hardening.

## 🛠️ Tools Included

### 1. **1_ssh_init.sh** - SSH Server Initialization
SSH server setup with password management, port configuration, and security hardening.

### 2. **2_disable_systemd_dns.sh** - DNS Resolver Management  
systemd-resolved replacement with static DNS configuration.

### 3. **3_base_apt_packages.sh** - Essential Packages Installation
Automated installation of 12 essential packages for Debian 12 server administration.

### 4. **4_system_customization.sh** - System Configuration & Personalization
Bash profile customization and Vim configuration with professional settings.

---

## 📋 TOOL 1: SSH Server Initialization

### Features
- ✅ Interactive user password change
- ✅ Root password configuration  
- ✅ SSH port customization (default: 7722)
- ✅ Root login enablement
- ✅ SSH MAC algorithms optimization (removes weak SHA-1/64-bit)
- ✅ Automatic SSH service restart
- ✅ Connection validation

### Usage
```bash
./1_ssh_init.sh <HOST> [user] [current_port] [new_port]
```

#### Parameters
| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `HOST` | Target server hostname or IP | - | ✅ |
| `user` | SSH username | `debian` | ❌ |
| `current_port` | Current SSH port | `22` | ❌ |
| `new_port` | New SSH port | `7722` | ❌ |

#### Examples
```bash
# Basic usage (debian user, port 22→7722)
./1_ssh_init.sh example.org

# Custom user and ports
./1_ssh_init.sh example.org myuser 22 8080

# Full customization
./1_ssh_init.sh example.org root 2222 9999
```

### Process Flow
1. **STEP 1** - User Password Change (interactive)
2. **STEP 2** - Root Configuration & SSH Setup
   - Root password setup
   - SSH port change
   - Security hardening (MAC algorithms)
3. **STEP 3** - Connection Validation

---

## 📋 TOOL 2: DNS Resolver Management

### Features
- ✅ Automatic nameserver extraction from systemd-resolved
- ✅ Complete systemd-resolved disabling (stop, disable, mask)
- ✅ Static `/etc/resolv.conf` creation
- ✅ Multi-method DNS testing (dig, nslookup, host)
- ✅ SSH-based execution
- ✅ Root user support

### Usage
```bash
./2_disable_systemd_dns.sh <HOST> [user] [port]
```

#### Parameters
| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `HOST` | Target server hostname or IP | - | ✅ |
| `user` | SSH username | `debian` | ❌ |
| `port` | SSH port | `22` | ❌ |

#### Examples
```bash
# Basic usage
./2_disable_systemd_dns.sh example.org

# With custom user and port
./2_disable_systemd_dns.sh example.org root 7722

# After 1_ssh_init.sh
./2_disable_systemd_dns.sh example.org root 7722
```

### Process Flow
1. **STEP 1** - Extract real nameserver from systemd-resolved
   - Check if systemd-resolved is active (auto-exit if not needed)
   - Extract nameserver from systemd-resolved configuration
2. **STEP 2** - Disable systemd-resolved & Configure static DNS
   - Install DNS utilities (dnsutils package)
   - Stop/disable/mask systemd-resolved
   - Create static resolv.conf
   - Test DNS resolution

### Before/After DNS Configuration
**Before (systemd-resolved):**
```bash
$ cat /etc/resolv.conf
nameserver 127.0.0.53
options edns0 trust-ad
```

**After (static configuration):**
```bash
$ cat /etc/resolv.conf
# Static DNS configuration - Managed by SANVIL DNS MANAGER
nameserver 213.186.33.99
search .
```

---

## 📋 TOOL 3: Essential Packages Installation

### Features
- ✅ Automated APT cache update
- ✅ Complete system upgrade (security patches and updates)
- ✅ Batch installation of essential packages
- ✅ Post-installation verification for each package
- ✅ Version reporting for installed tools
- ✅ SSH-based execution
- ✅ Error handling and reporting

### Usage
```bash
./3_base_apt_packages.sh <HOST> [user] [port]
```

#### Parameters
| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `HOST` | Target server hostname or IP | - | ✅ |
| `user` | SSH username | `debian` | ❌ |
| `port` | SSH port | `22` | ❌ |

#### Examples
```bash
# Basic usage
./3_base_apt_packages.sh example.org

# With custom user and port
./3_base_apt_packages.sh example.org root 7722

# After server setup
./3_base_apt_packages.sh example.org root 7722
```

### Essential Packages Installed
- **vim** - Advanced text editor
- **net-tools** - Network utilities (ifconfig, netstat, etc.)
- **btop** - Modern system monitor
- **htop** - Interactive process viewer
- **iftop** - Network traffic monitor
- **wget** - File download utility
- **curl** - URL transfer tool
- **git** - Version control system
- **nmap** - Network scanner and security auditing tool
- **tcpdump** - Network packet analyzer
- **screen** - Terminal session manager
- **cron** - Task scheduler and automation daemon

### Process Flow
1. **STEP 1** - System update and package installation (single SSH session)
   - Update package repository information
   - Upgrade system with latest security patches and updates
   - Install all essential packages
   - Verify successful installation
   - Test functionality and report versions

---

## 📋 TOOL 4: System Configuration & Personalization

### Features
- ✅ Bash profile customization with colorized prompt
- ✅ Professional Vim configuration with syntax highlighting
- ✅ Useful aliases for server administration
- ✅ Automatic backup of existing configurations
- ✅ SSH-based execution
- ✅ Configuration verification and testing

### Usage
```bash
./4_system_customization.sh <HOST> [user] [port]
```

#### Parameters
| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `HOST` | Target server hostname or IP | - | ✅ |
| `user` | SSH username | `debian` | ❌ |
| `port` | SSH port | `22` | ❌ |

#### Examples
```bash
# Basic usage
./4_system_customization.sh example.org

# With custom user and port
./4_system_customization.sh example.org root 7722

# After complete server setup
./4_system_customization.sh example.org root 7722
```

### Bash Profile Features
- **Colorized Prompt**: Cyan user, green host, yellow path
- **Useful Aliases**: 
  - `nmaps` - Advanced nmap scanning
  - `lsa` - Detailed file listing
  - `psg` - Process search with grep
  - `search` - System-wide file search
  - Navigation shortcuts (`ll`, `la`, `..`, `...`)
- **History Optimization**: Extended history with duplicate removal
- **Color Support**: Enhanced ls and grep with colors

### Vim Configuration Features
- **Display**: Line numbers, syntax highlighting, status line
- **Editing**: Auto-indentation, smart indentation, mouse support
- **Search**: Incremental search, case-smart searching, highlight results
- **Performance**: Fast terminal updates, optimized settings
- **Backup**: Disabled swap/backup files for cleaner workspace
- **Auto-commands**: Automatic trailing space removal

### Process Flow
1. **STEP 1** - System configuration
   - Backup existing bash_profile and vimrc (if present)
   - Create new bash profile with colorized prompt and aliases
   - Generate professional Vim configuration
   - Apply configurations and verify installation

---

## 🚀 Complete Workflow

For a complete server setup, use all four tools in sequence:

```bash
# Step 1: Initialize SSH server
./1_ssh_init.sh example.org debian 22 7722

# Step 2: Configure static DNS (use new port)
./2_disable_systemd_dns.sh example.org root 7722

# Step 3: Install essential packages
./3_base_apt_packages.sh example.org root 7722

# Step 4: Configure system personalization
./4_system_customization.sh example.org root 7722
```

## 📦 Installation

### Quick Setup
```bash
# Download all scripts
wget https://raw.githubusercontent.com/sanvilscript/server-init/main/1_ssh_init.sh
wget https://raw.githubusercontent.com/sanvilscript/server-init/main/2_disable_systemd_dns.sh
wget https://raw.githubusercontent.com/sanvilscript/server-init/main/3_base_apt_packages.sh
wget https://raw.githubusercontent.com/sanvilscript/server-init/main/4_system_customization.sh

# Make executable
chmod +x *.sh

# Run complete setup
./1_ssh_init.sh your-server.com
./2_disable_systemd_dns.sh your-server.com root 7722
./3_base_apt_packages.sh your-server.com root 7722
./4_system_customization.sh your-server.com root 7722
```

### Git Clone
```bash
git clone https://github.com/sanvilscript/server-init.git
cd server-init
chmod +x *.sh
```

## 🔧 Requirements

- **Debian 12** server with SSH access
- User with sudo privileges (or root access)
- SSH client on local machine
- systemd-resolved active (for DNS tool)

## 🔒 Security Features

### SSH Hardening
- **MAC Algorithm Optimization**: Removes weak SHA-1 and 64-bit algorithms
- **Port Security**: Custom SSH ports to reduce attack surface
- **Root Access Control**: Configurable root login

### DNS Security
- **Static Configuration**: Eliminates systemd-resolved complexity
- **Direct Nameserver**: Uses real DNS servers (no local stub)
- **Immutable Config**: Prevents accidental overwrites

## 🛠️ Troubleshooting

### SSH Issues
```bash
# Check SSH service
sudo systemctl status sshd

# Verify configuration
sudo cat /etc/ssh/sshd_config | grep -E "(Port|PermitRootLogin|MACs)"

# Test connection
ssh -v -p NEW_PORT user@server
```

### DNS Issues
```bash
# Check systemd-resolved status
systemctl status systemd-resolved

# Test DNS resolution
nslookup google.com
dig google.com

# Verify resolv.conf
cat /etc/resolv.conf
```

### Restore systemd-resolved (if needed)
```bash
sudo systemctl unmask systemd-resolved
sudo systemctl enable systemd-resolved
sudo systemctl start systemd-resolved
sudo rm /etc/resolv.conf
sudo ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
```

---

**© 2025 Sanvil - Enterprise Server Management Tools**
