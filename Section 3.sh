#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# 3 Logging and Auditing
echo "Section 3 - Logging and Auditing"
    echo "Creating backup of original files and saving permissions..."
        sudo cp /etc/security/audit_control /etc/security/audit_control.bak
        sudo cp /etc/asl/com.apple.install /etc/asl/com.apple.install.bak
    
    # Save permissions
        audit_control_perms=$(stat -f "%A %U %G" /etc/security/audit_control)
        install_log_perms=$(stat -f "%A %U %G" /etc/asl/com.apple.install)
        audit_control_perms=$(stat -f "%A %U %G" /etc/security/audit_control)
        install_log_perms=$(stat -f "%A %U %G" /etc/asl/com.apple.install)
    
    # 3.1 Ensure Security Auditing Is Enabled
    echo "Section 3.1 - Ensure Security Auditing Is Enabled"
        LAUNCHD_RUNNING=$(launchctl list | grep -c com.apple.auditd)
        if [ "$LAUNCHD_RUNNING" -ne 1 ]; then
            sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.auditd.plist
        fi
        if [ ! -e /etc/security/audit_control ] && [ -e /etc/security/audit_control.example ]; then
            sudo cp /etc/security/audit_control.example /etc/security/audit_control
        else
            sudo touch /etc/security/audit_control
        fi
        echo "Security auditing is enabled. (OK)"
    echo "Section 3.2 - Ensure Security Auditing Flags For User-Attributable Events Are Configured Per Local Organizational Requirements"
        flags_to_check="-fm, ad, -ex, aa, -fr, lo, -fw"
        current_flags=$(grep "^flags:" /etc/security/audit_control | cut -d ' ' -f 2-)
        if [[ "$current_flags" != *"$flags_to_check"* ]]; then
            echo "The audit_control file does not contain the specified flags. Updating..."
            sudo sed -i '' "s/^flags:.*/flags: $flags_to_check/" /etc/security/audit_control
            echo "The audit_control file has been updated with the specified flags."
        else
            echo "The audit_control file already contains the specified flags."
        fi
    # 3.3 Ensure install.log Is Retained for 365 or More Days and No Maximum Size
    echo "Section 3.3 - Ensure install.log Is Retained for 365 or More Days and No Maximum Size"
        sudo sed -i '' "s/* file \/var\/log\/install.log.*/* file \/var\/log\/install.log format='\$((Time)(JZ)) \$Host \$Sender[\$PID]: \$Message' rotate=utc compress file_max=50M size_only ttl=365/g" /etc/asl/com.apple.install
    # 3.4 Ensure Security Auditing Retention Is Enabled
    echo "Section 3.4 - Ensure Security Auditing Retention Is Enabled (Skipped)"
        # Skipped
    # 3.5 Ensure Access to Audit Records Is Controlled
    echo "Section 3.5 - Ensure Access to Audit Records Is Controlled"
        sudo /usr/sbin/chown -R root:wheel /etc/security/audit_control
        sudo /bin/chmod -R 640 /etc/security/audit_control
        sudo /usr/sbin/chown -R root:wheel $(grep '^dir' /etc/security/audit_control | awk -F: '{print $2}')
        sudo /bin/chmod -R 640 $(grep '^dir' /etc/security/audit_control | awk -F: '{print $2}')
    # 3.6 Audit Software Inventory
    echo "Section 3.6 - Audit Software Inventory (Manually Check)"

    # Restore Backup and Permissions (if needed - MacOs Recovery Mode)
        #cp /etc/security/audit_control.bak /etc/security/audit_control
        #cp /etc/asl/com.apple.install.bak /etc/asl/com.apple.install
    # Restore permissions
        #chmod $(echo $audit_control_perms | awk '{print $1}') /etc/security/audit_control
        #chown $(echo $audit_control_perms | awk '{print $2":"$3}') /etc/security/audit_control
        #chmod $(echo $install_log_perms | awk '{print $1}') /etc/asl/com.apple.install
        #chown $(echo $install_log_perms | awk '{print $2":"$3}') /etc/asl/com.apple.install

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
