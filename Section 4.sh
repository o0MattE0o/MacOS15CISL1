#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# 4 Network Configurations
echo "Section 4 - Network Configurations"
    # 4.1 Ensure Bonjour Advertising Services Is Disabled
    echo "Section 4.1 - Ensure Bonjour Advertising Services Is Disabled"
        sudo /usr/bin/defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
    # 4.2 Ensure HTTP Server Is Disabled
    echo "Section 4.2 - Ensure HTTP Server Is Disabled (Skipped)"
        # Skipped
        #sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
    # 4.3 Ensure NFS Server Is Disabled
    echo "Section 4.3 - Ensure NFS Server Is Disabled (Skipped)"
        # Skipped
        #sudo launchctl disable system/com.apple.nfsd

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
