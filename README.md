# LUPMS — Linux User & Permission Management System

LUPMS (Linux User & Permission Management System) is a Bash-based Linux administration tool designed to simplify user, group, security, and file permission management through an interactive terminal interface.

## 📌 Project Overview

Managing Linux users, groups, and file permissions normally requires multiple commands such as `useradd`, `usermod`, `groupadd`, `chmod`, `chown`, and `passwd`.

LUPMS combines these operations into a single menu-driven Bash script, making basic Linux administration easier to perform and demonstrate.

## ✨ Features

### 👤 User Management

* Create Linux users
* Delete Linux users
* List system users
* View user information
* Change user passwords
* Lock users
* Unlock users

### 👥 Group Management

* Create groups
* Delete groups
* Add users to groups
* Remove users from groups
* List available groups

### 🔐 Permission Management

* Change file/directory permissions using `chmod`
* Change file ownership using `chown`
* Change group ownership using `chgrp`
* View file permissions and ownership

### 🛡️ Security Management

* Lock and unlock user accounts
* Display current user and group information
* Display basic password policy information

### 🖥️ System Information

* Hostname
* Operating system
* Kernel version
* System uptime
* Memory usage
* Disk usage

### 📝 Activity Logging

LUPMS automatically records important operations in:

```text
logs/activity.log
```

Example:

```text
[2026-09-18 14:20:10] LUPMS started.
[2026-09-18 14:21:05] User 'student1' created.
[2026-09-18 14:22:15] Group 'developers' created.
```

## 🛠️ Technologies Used

* Bash Shell Scripting
* Linux
* Kali Linux / Ubuntu
* Linux User & Group Management Commands
* File Permission Management

## 📂 Project Structure

```text
LUPMS/
│
├── linux_manager.sh
│
└── logs/
    └── activity.log
```

The `logs/` directory and `activity.log` file are created automatically when the script runs.

## ⚙️ Installation

Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Go to the project directory:

```bash
cd LUPMS
```

Give execute permission:

```bash
chmod +x linux_manager.sh
```

Run the program with root privileges:

```bash
sudo ./linux_manager.sh
```

## 🖥️ Main Menu

```text
==================================================
       LINUX USER & PERMISSION
            MANAGEMENT SYSTEM
==================================================

[1] User Management
[2] Group Management
[3] Permission Management
[4] Security Management
[5] System Information
[6] Activity Logs
[0] Exit
```

## 🧪 Example Workflow

A typical demonstration can be performed as follows:

```text
Create User
     ↓
Create Group
     ↓
Add User to Group
     ↓
Create/Test File
     ↓
Change File Permission
     ↓
Change File Owner
     ↓
View Permission
     ↓
View Activity Log
```

## 🎯 Project Objectives

* Understand Linux user management.
* Understand Linux group management.
* Learn Linux file permissions and ownership.
* Automate common Linux administration tasks using Bash.
* Build a practical Linux Administration project.
* Maintain an activity log of administrative operations.

## 🔮 Future Improvements

Possible future versions may include:

* Graphical User Interface (GUI)
* Web-based dashboard
* User search and filtering
* Advanced permission management
* Backup and restore functionality
* More detailed security auditing
* Export activity logs
* Configuration file support

## ⚠️ Disclaimer

This project performs real system administration operations. Run it only on a Linux system or virtual machine where you have permission to modify users, groups, and file permissions.

For learning and testing, using a Kali Linux or Ubuntu virtual machine is recommended.

## 👨‍💻 Author

**CoderTiku**

B.Tech in Cyber Security

## 📄 License

This project is intended for educational and learning purposes.


## ▶️ How to Run

Clone the repository:

```bash
git clone YOUR_GITHUB_REPOSITORY_URL
```

Go to the project directory:

```bash
cd LUPMS
```

Give execute permission:

```bash
chmod +x linux_manager.sh
```

Run LUPMS with root privileges:

```bash
sudo ./linux_manager.sh
```

### Example

```text
========================================
        LUPMS
 Linux User & Permission Management
========================================

[1] User Management
[2] Group Management
[3] Permission Management
[4] Security Management
[5] System Information
[6] Activity Logs
[0] Exit

Enter your choice:
```

> ⚠️ **Note:** Run LUPMS inside a Linux virtual machine or test environment when possible. Avoid testing destructive operations on important system users.
