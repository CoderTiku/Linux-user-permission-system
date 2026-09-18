#!/bin/bash

# ==========================================================
# LUPMS
# Linux User & Permission Management System
# Version: 1.0
# ==========================================================


# ==========================================================
# COLORS
# ==========================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BLUE='\033[0;34m'
NC='\033[0m'


# ==========================================================
# LOG SYSTEM
# ==========================================================

LOG_DIR="./logs"
LOG_FILE="$LOG_DIR/activity.log"

mkdir -p "$LOG_DIR"
touch "$LOG_FILE"


log_action() {

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"

}


# ==========================================================
# BANNER
# ==========================================================

show_banner() {

    clear

    echo -e "${CYAN}"

    echo "██╗     ██╗   ██╗██████╗ ███╗   ███╗███████╗"
    echo "██║     ██║   ██║██╔══██╗████╗ ████║██╔════╝"
    echo "██║     ██║   ██║██████╔╝██╔████╔██║███████╗"
    echo "██║     ██║   ██║██╔═══╝ ██║╚██╔╝██║╚════██║"
    echo "███████╗╚██████╔╝██║     ██║ ╚═╝ ██║███████║"
    echo "╚══════╝ ╚═════╝ ╚═╝     ╚═╝     ╚═╝╚══════╝"

    echo
    echo "       LINUX USER & PERMISSION"
    echo "            MANAGEMENT SYSTEM"

    echo -e "${NC}"

    echo "--------------------------------------------------"
    echo -e "${GREEN}Version : 1.0${NC}"
    echo "Author  : CoderTiku"
    echo "Platform: Linux"
    echo "--------------------------------------------------"
}


# ==========================================================
# ROOT CHECK
# ==========================================================

check_root() {

    if [ "$EUID" -ne 0 ]; then

        echo -e "${RED}"
        echo "ERROR: Root permission required!"
        echo -e "${NC}"

        echo "Run the program using:"
        echo
        echo "sudo ./linux_manager.sh"

        exit 1

    fi

}


# ==========================================================
# PAUSE SCREEN
# ==========================================================

pause_screen() {

    echo
    read -p "Press Enter to continue..."

}


# ==========================================================
# USER MANAGEMENT
# ==========================================================


create_user() {

    echo
    echo "========== CREATE USER =========="

    read -p "Enter username: " username

    if [ -z "$username" ]; then

        echo -e "${RED}Username cannot be empty.${NC}"
        pause_screen
        return

    fi


    if id "$username" &>/dev/null; then

        echo -e "${YELLOW}User '$username' already exists.${NC}"
        pause_screen
        return

    fi


    useradd -m -s /bin/bash "$username"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User '$username' created successfully.${NC}"

        echo
        passwd "$username"

        log_action "User '$username' created."

    else

        echo -e "${RED}Failed to create user.${NC}"

        log_action "Failed to create user '$username'."

    fi


    pause_screen
}


# ----------------------------------------------------------


delete_user() {

    echo
    echo "========== DELETE USER =========="

    read -p "Enter username: " username


    if [ -z "$username" ]; then

        echo -e "${RED}Username cannot be empty.${NC}"
        pause_screen
        return

    fi


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User '$username' does not exist.${NC}"
        pause_screen
        return

    fi


    if [ "$username" = "root" ]; then

        echo -e "${RED}Root user cannot be deleted.${NC}"
        pause_screen
        return

    fi


    echo
    read -p "Delete home directory also? (y/n): " choice


    if [[ "$choice" =~ ^[Yy]$ ]]; then

        userdel -r "$username"

    else

        userdel "$username"

    fi


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User '$username' deleted successfully.${NC}"

        log_action "User '$username' deleted."

    else

        echo -e "${RED}Failed to delete user.${NC}"

    fi


    pause_screen
}


# ----------------------------------------------------------


list_users() {

    echo
    echo "========== SYSTEM USERS =========="
    echo

    printf "%-20s %-10s %-10s %-30s\n" \
    "USERNAME" "UID" "GID" "HOME"

    echo "-----------------------------------------------------------------------"


    awk -F: '$3 >= 1000 && $1 != "nobody" {

        printf "%-20s %-10s %-10s %-30s\n",
        $1, $3, $4, $6

    }' /etc/passwd


    echo
    pause_screen

}


# ----------------------------------------------------------


user_information() {

    echo
    echo "========== USER INFORMATION =========="

    read -p "Enter username: " username


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User '$username' does not exist.${NC}"
        pause_screen
        return

    fi


    echo
    echo "Username : $username"
    echo "UID      : $(id -u "$username")"
    echo "GID      : $(id -g "$username")"
    echo "Groups   : $(id -nG "$username")"
    echo "Home     : $(getent passwd "$username" | cut -d: -f6)"
    echo "Shell    : $(getent passwd "$username" | cut -d: -f7)"

    echo

    pause_screen

}


# ----------------------------------------------------------


change_password() {

    echo
    echo "========== CHANGE PASSWORD =========="

    read -p "Enter username: " username


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    passwd "$username"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Password changed successfully.${NC}"

        log_action "Password changed for '$username'."

    else

        echo -e "${RED}Failed to change password.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


lock_user() {

    echo
    echo "========== LOCK USER =========="

    read -p "Enter username: " username


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    if [ "$username" = "root" ]; then

        echo -e "${RED}Root user cannot be locked.${NC}"
        pause_screen
        return

    fi


    usermod -L "$username"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User '$username' locked successfully.${NC}"

        log_action "User '$username' locked."

    else

        echo -e "${RED}Failed to lock user.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


unlock_user() {

    echo
    echo "========== UNLOCK USER =========="

    read -p "Enter username: " username


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    usermod -U "$username"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User '$username' unlocked successfully.${NC}"

        log_action "User '$username' unlocked."

    else

        echo -e "${RED}Failed to unlock user.${NC}"

    fi


    pause_screen

}


# ==========================================================
# USER MANAGEMENT MENU
# ==========================================================


user_menu() {

    while true
    do

        clear

        echo "=========================================="
        echo "          USER MANAGEMENT"
        echo "=========================================="

        echo
        echo "1. Create User"
        echo "2. Delete User"
        echo "3. List Users"
        echo "4. User Information"
        echo "5. Change Password"
        echo "6. Lock User"
        echo "7. Unlock User"
        echo "0. Back"

        echo

        read -p "Enter your choice: " choice


        case $choice in

            1) create_user ;;
            2) delete_user ;;
            3) list_users ;;
            4) user_information ;;
            5) change_password ;;
            6) lock_user ;;
            7) unlock_user ;;

            0)
                return
                ;;

            *)
                echo -e "${RED}Invalid choice.${NC}"
                sleep 2
                ;;

        esac

    done

}


# ==========================================================
# GROUP MANAGEMENT
# ==========================================================


create_group() {

    echo
    echo "========== CREATE GROUP =========="

    read -p "Enter group name: " groupname


    if [ -z "$groupname" ]; then

        echo -e "${RED}Group name cannot be empty.${NC}"
        pause_screen
        return

    fi


    if getent group "$groupname" &>/dev/null; then

        echo -e "${YELLOW}Group already exists.${NC}"
        pause_screen
        return

    fi


    groupadd "$groupname"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Group '$groupname' created successfully.${NC}"

        log_action "Group '$groupname' created."

    else

        echo -e "${RED}Failed to create group.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


delete_group() {

    echo
    echo "========== DELETE GROUP =========="

    read -p "Enter group name: " groupname


    if ! getent group "$groupname" &>/dev/null; then

        echo -e "${RED}Group does not exist.${NC}"
        pause_screen
        return

    fi


    groupdel "$groupname"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Group '$groupname' deleted successfully.${NC}"

        log_action "Group '$groupname' deleted."

    else

        echo -e "${RED}Failed to delete group.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


add_user_group() {

    echo
    echo "========== ADD USER TO GROUP =========="

    read -p "Enter username: " username
    read -p "Enter group name: " groupname


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    if ! getent group "$groupname" &>/dev/null; then

        echo -e "${RED}Group does not exist.${NC}"
        pause_screen
        return

    fi


    usermod -aG "$groupname" "$username"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User added to group successfully.${NC}"

        log_action "User '$username' added to group '$groupname'."

    else

        echo -e "${RED}Failed to add user to group.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


remove_user_group() {

    echo
    echo "========== REMOVE USER FROM GROUP =========="

    read -p "Enter username: " username
    read -p "Enter group name: " groupname


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    if ! getent group "$groupname" &>/dev/null; then

        echo -e "${RED}Group does not exist.${NC}"
        pause_screen
        return

    fi


    gpasswd -d "$username" "$groupname"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}User removed from group successfully.${NC}"

        log_action "User '$username' removed from group '$groupname'."

    else

        echo -e "${RED}Failed to remove user from group.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


list_groups() {

    echo
    echo "========== GROUP LIST =========="
    echo

    getent group | cut -d: -f1 | sort

    echo

    pause_screen

}


# ==========================================================
# GROUP MENU
# ==========================================================


group_menu() {

    while true
    do

        clear

        echo "=========================================="
        echo "          GROUP MANAGEMENT"
        echo "=========================================="

        echo
        echo "1. Create Group"
        echo "2. Delete Group"
        echo "3. Add User to Group"
        echo "4. Remove User from Group"
        echo "5. List Groups"
        echo "0. Back"

        echo

        read -p "Enter your choice: " choice


        case $choice in

            1) create_group ;;
            2) delete_group ;;
            3) add_user_group ;;
            4) remove_user_group ;;
            5) list_groups ;;

            0)
                return
                ;;

            *)
                echo -e "${RED}Invalid choice.${NC}"
                sleep 2
                ;;

        esac

    done

}


# ==========================================================
# PERMISSION MANAGEMENT
# ==========================================================


change_permission() {

    echo
    echo "========== CHANGE FILE PERMISSION =========="

    read -p "Enter file/directory path: " filepath


    if [ ! -e "$filepath" ]; then

        echo -e "${RED}File or directory does not exist.${NC}"
        pause_screen
        return

    fi


    echo
    echo "Examples:"
    echo "755 = rwxr-xr-x"
    echo "700 = rwx------"
    echo "644 = rw-r--r--"

    echo

    read -p "Enter permission: " permission


    if [[ ! "$permission" =~ ^[0-7]{3,4}$ ]]; then

        echo -e "${RED}Invalid permission format.${NC}"
        pause_screen
        return

    fi


    chmod "$permission" "$filepath"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Permission changed successfully.${NC}"

        log_action "Permission '$permission' applied to '$filepath'."

    else

        echo -e "${RED}Failed to change permission.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


change_owner() {

    echo
    echo "========== CHANGE FILE OWNER =========="

    read -p "Enter file/directory path: " filepath


    if [ ! -e "$filepath" ]; then

        echo -e "${RED}File or directory does not exist.${NC}"
        pause_screen
        return

    fi


    read -p "Enter new owner username: " username


    if ! id "$username" &>/dev/null; then

        echo -e "${RED}User does not exist.${NC}"
        pause_screen
        return

    fi


    chown "$username" "$filepath"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Owner changed successfully.${NC}"

        log_action "Owner of '$filepath' changed to '$username'."

    else

        echo -e "${RED}Failed to change owner.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


change_group_owner() {

    echo
    echo "========== CHANGE GROUP OWNER =========="

    read -p "Enter file/directory path: " filepath


    if [ ! -e "$filepath" ]; then

        echo -e "${RED}File or directory does not exist.${NC}"
        pause_screen
        return

    fi


    read -p "Enter group name: " groupname


    if ! getent group "$groupname" &>/dev/null; then

        echo -e "${RED}Group does not exist.${NC}"
        pause_screen
        return

    fi


    chgrp "$groupname" "$filepath"


    if [ $? -eq 0 ]; then

        echo -e "${GREEN}Group ownership changed successfully.${NC}"

        log_action "Group owner of '$filepath' changed to '$groupname'."

    else

        echo -e "${RED}Failed to change group ownership.${NC}"

    fi


    pause_screen

}


# ----------------------------------------------------------


show_permission() {

    echo
    echo "========== FILE PERMISSION =========="

    read -p "Enter file/directory path: " filepath


    if [ ! -e "$filepath" ]; then

        echo -e "${RED}File or directory does not exist.${NC}"
        pause_screen
        return

    fi


    echo

    ls -ld "$filepath"

    echo

    stat -c "Owner       : %U" "$filepath"
    stat -c "Group       : %G" "$filepath"
    stat -c "Permissions : %A" "$filepath"
    stat -c "Numeric     : %a" "$filepath"

    echo

    pause_screen

}


# ==========================================================
# PERMISSION MENU
# ==========================================================


permission_menu() {

    while true
    do

        clear

        echo "=========================================="
        echo "       PERMISSION MANAGEMENT"
        echo "=========================================="

        echo
        echo "1. Change File Permission"
        echo "2. Change File Owner"
        echo "3. Change Group Owner"
        echo "4. Show File Permission"
        echo "0. Back"

        echo

        read -p "Enter your choice: " choice


        case $choice in

            1) change_permission ;;
            2) change_owner ;;
            3) change_group_owner ;;
            4) show_permission ;;

            0)
                return
                ;;

            *)
                echo -e "${RED}Invalid choice.${NC}"
                sleep 2
                ;;

        esac

    done

}


# ==========================================================
# SECURITY MANAGEMENT
# ==========================================================


security_status() {

    echo
    echo "========== SECURITY STATUS =========="

    echo

    echo "Current User:"
    whoami

    echo

    echo "Current UID:"
    id -u

    echo

    echo "Current Groups:"
    id -nG

    echo

    echo "Password Policy Information:"
    grep -E "PASS_MAX_DAYS|PASS_MIN_DAYS|PASS_WARN_AGE" /etc/login.defs 2>/dev/null

    echo

    pause_screen

}


# ==========================================================
# SECURITY MENU
# ==========================================================


security_menu() {

    while true
    do

        clear

        echo "=========================================="
        echo "          SECURITY MANAGEMENT"
        echo "=========================================="

        echo
        echo "1. Lock User"
        echo "2. Unlock User"
        echo "3. Security Status"
        echo "0. Back"

        echo

        read -p "Enter your choice: " choice


        case $choice in

            1) lock_user ;;
            2) unlock_user ;;
            3) security_status ;;

            0)
                return
                ;;

            *)
                echo -e "${RED}Invalid choice.${NC}"
                sleep 2
                ;;

        esac

    done

}


# ==========================================================
# SYSTEM INFORMATION
# ==========================================================


system_information() {

    echo
    echo "========== SYSTEM INFORMATION =========="

    echo

    echo "Hostname : $(hostname)"

    echo "Kernel   : $(uname -r)"

    echo "OS       : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2- | tr -d '"')"

    echo "Date     : $(date)"

    echo "Uptime   : $(uptime -p)"

    echo

    echo "Memory:"
    free -h

    echo

    echo "Disk:"
    df -h /

    echo

    pause_screen

}


# ==========================================================
# ACTIVITY LOG
# ==========================================================


view_logs() {

    echo
    echo "========== ACTIVITY LOG =========="

    echo

    if [ ! -s "$LOG_FILE" ]; then

        echo "No activity recorded yet."

    else

        tail -50 "$LOG_FILE"

    fi

    echo

    pause_screen

}


# ==========================================================
# MAIN MENU
# ==========================================================


main_menu() {

    while true
    do

        show_banner

        echo
        echo -e "${YELLOW}MAIN MENU${NC}"

        echo "--------------------------------------------------"

        echo " [1] User Management"
        echo " [2] Group Management"
        echo " [3] Permission Management"
        echo " [4] Security Management"
        echo " [5] System Information"
        echo " [6] Activity Logs"
        echo " [0] Exit"

        echo "--------------------------------------------------"

        read -p "Enter your choice: " choice


        case $choice in

            1)
                user_menu
                ;;

            2)
                group_menu
                ;;

            3)
                permission_menu
                ;;

            4)
                security_menu
                ;;

            5)
                system_information
                ;;

            6)
                view_logs
                ;;

            0)

                log_action "LUPMS stopped."

                echo
                echo -e "${GREEN}Thank you for using LUPMS.${NC}"
                echo

                exit 0
                ;;

            *)

                echo
                echo -e "${RED}Invalid choice! Please try again.${NC}"

                sleep 2
                ;;

        esac

    done

}


# ==========================================================
# START PROGRAM
# ==========================================================

check_root

log_action "LUPMS started."

main_menu
