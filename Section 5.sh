#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# 5 System Access, Authentication and Authorization
echo "Section 5 - System Access, Authentication and Authorization"
    # 5.1 File System Permissions and Access Controls
    echo "Section 5.1 - File System Permissions and Access Controls"
        # 5.1.1 Ensure Home Folders Are Secure
        echo "Section 5.1.1 - Ensure Home Folders Are Secure (Skipped)"
            # Skipped
        # 5.1.2 Ensure System Integrity Protection Status (SIP) Is Enabled
        echo "Section 5.1.2 - Ensure System Integrity Protection Status (SIP) Is Enabled (Manually Check)"
            csrutil status | grep -q "enabled" || echo "WARNING: System Integrity Protection (SIP) is disabled!"
        # 5.1.3 Ensure Apple Mobile File Integrity (AMFI) Is Enabled
        echo "Section 5.1.3 - Ensure Apple Mobile File Integrity (AMFI) Is Enabled (Manually Check)"
        # 5.1.4 Ensure Signed System Volume (SSV) Is Enabled
        echo "Section 5.1.4 - Ensure Signed System Volume (SSV) Is Enabled (Manually Check)"
            csrutil authenticated-root status | grep -q "enabled" || echo "WARNING: Signed System Volume (SSV) is disabled!"
        # 5.1.5 Ensure Appropriate Permissions Are Enabled for System Wide Applications
        echo "Section 5.1.5 - Ensure Appropriate Permissions Are Enabled for System Wide Applications"
            IFS=$'\n'
            for apps in $(/usr/bin/find /System/Volumes/Data/Applications -iname "*.app" -type d -perm -2 | grep -v Xcode.app); do
                sudo /bin/chmod -R o-w "$apps"
            done
        # 5.1.6 Ensure No World Writable Folders Exist in the System Folder
        echo "Section 5.1.6 - Ensure No World Writable Folders Exist in the System Folder (Skipped)"
            # Skipped
        # 5.1.7 Ensure No World Writable Folders Exist in the Library Folder
        echo "Section 5.1.7 - Ensure No World Writable Folders Exist in the Library Folder (Skipped)"  
            # Skipped
    # 5.2 Password Management
    echo "Section 5.2 - Password Management"
        # 5.2.1 Ensure Password Account Lockout Threshold Is Configured
        echo "Section 5.2.1 - Ensure Password Account Lockout Threshold Is Configured"
            # Skipped
        # 5.2.2 Ensure Password Minimum Length Is Configured
        echo "Section 5.2.2 - Ensure Password Minimum Length Is Configured"
            # Skipped
        # 5.2.3 Ensure Complex Password Must Contain Alphabetic Characters Is Configured
        echo "Section 5.2.3 - Ensure Complex Password Must Contain Alphabetic Characters Is Configured (Skipped)"
            # Skipped
        # 5.2.4 Ensure Complex Password Must Contain Numeric Character Is Configured
        echo "Section 5.2.4 - Ensure Complex Password Must Contain Numeric Character Is Configured (Skipped)"
            # Skipped
        # 5.2.5 Ensure Complex Password Must Contain Special Character Is Configured
        echo "Section 5.2.5 - Ensure Complex Password Must Contain Special Character Is Configured (Skipped)"
            # Skipped
        # 5.2.6 Ensure Complex Password Must Contain Uppercase and Lowercase Characters Is Configured
        echo "Section 5.2.6 - Ensure Complex Password Must Contain Uppercase and Lowercase Characters Is Configured (Skipped)"
            # Skipped
        # 5.2.7 Ensure Password Age Is Configured
        echo "Section 5.2.7 - Ensure Password Age Is Configured (Skipped)"
            # Skipped
        # 5.2.8 Ensure Password History Is Configured
        echo "Section 5.2.8 - Ensure Password History Is Configured (Skipped)"
            # Skipped
    # 5.3 Encryption
    echo "Section 5.3 - Encryption"
        # 5.3.1 Ensure all user storage APFS volumes are encrypted
        echo "Section 5.3.1 - Ensure all user storage APFS volumes are encrypted (Manually Check)"
        # 5.3.2 Ensure all user storage CoreStorage volumes are encrypted
        echo "Section 5.3.2 - Ensure all user storage CoreStorage volumes are encrypted  (Manually Check)"
    # 5.4 Ensure the Sudo Timeout Period Is Set to Zero
    echo "Section 5.4 - Ensure the Sudo Timeout Period Is Set to Zero (Manually Check)"
    # 5.5 Ensure a Separate Timestamp Is Enabled for Each User/tty Combo
    echo "Section 5.5 - Ensure a Separate Timestamp Is Enabled for Each User/tty Combo (Manually Check)"
    # 5.6 Ensure the 'root' Account Is Disabled
    echo "Section 5.6 - Ensure the 'root' Account Is Disabled (Skipped)"
        # Skipped
    # 5.7 Ensure an Administrator Account Cannot Login to Another User's Active and Locked Session
    echo "Section 5.7 - Ensure an Administrator Account Cannot Login to Another User's Active and Locked Session"
        # sudo /usr/bin/security authorizationdb write system.login.screensaver allow
        # Running this command will disable Touch ID to unlock the screen saver. To re-enable Touch ID for users, run the following command:
        # sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow screenUnlockMode -int 1
    # 5.8 Ensure a Login Window Banner Exists
    echo "Section 5.8 - Ensure a Login Window Banner Exists (Skipped)"
        # Skipped
    # 5.9 Ensure the Guest Home Folder Does Not Exist
    echo "Section 5.9 - Ensure the Guest Home Folder Does Not Exist"
        if [ -d /Users/Guest ]; then
            sudo /bin/rm -R /Users/Guest
            echo "Guest home folder has been removed."
        else
            echo "Guest home folder does not exist."
        fi
    # 5.10 Ensure XProtect Is Running and Updated
    echo "Section 5.10 - Ensure XProtect Is Running and Updated (Skipped)"
        # Skipped
    # 5.11 Ensure Logging Is Enabled for Sudo
    echo "Section 5.11 - Ensure Logging Is Enabled for Sudo (Skipped)"
        #Skipped 

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
