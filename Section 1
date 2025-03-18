#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# 1 Install Updates, Patches and Additional Security Software
echo "Section 1 - Install Updates, Patches and Additional Security Software"
    # 1.1 Ensure All Apple-provided Software Is Current
    echo "Section 1.1 - Ensure All Apple-provided Software Is Current"
        sudo softwareupdate -i -a
    # 1.2 Ensure Auto Update Is Enabled
    echo "Section 1.2 - Ensure Auto Update Is Enabled"
        sudo defaults write "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticCheckEnabled" -bool true
        sudo defaults write "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticDownload" -bool true
        sudo defaults write "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticallyInstallMacOSUpdates" -bool true
        sudo defaults write "/Library/Preferences/com.apple.commerce" "AutoUpdate" -bool TRUE
    # 1.3 Ensure Download New Updates When Available Is Enabled
    echo "Section 1.3 - Ensure Download New Updates When Available Is Enabled"
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true 
    # 1.4 Ensure Install of macOS Updates Is Enabled
    echo "Section 1.4 - Ensure Install of macOS Updates Is Enabled"
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticallyInstallMacOSUpdates -bool true
    # 1.5 Ensure Install Application Updates from the App Store Is Enabled
    echo "Section 1.5 - Ensure Install Application Updates from the App Store Is Enabled"
        sudo defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
    # 1.6 Ensure Install Security Responses and System Files Is Enabled
    echo "Section 1.6 - Ensure Install Security Responses and System Files Is Enabled"
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate ConfigDataInstall -bool true
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true
    # 1.7 Ensure Software Update Deferment Is Less Than or Equal to 30 Days
    echo "Section 1.7 - Ensure Software Update Deferment Is Less Than or Equal to 30 Days"
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate enforcedSoftwareUpdateDelay -int 5 #No.Days Deferred
    # 1.8 Ensure the System is Managed by a Mobile Device Management (MDM) Software
    echo "Section 1.8 - Ensure the System is Managed by a Mobile Device Management (MDM) Software (Manually Check)"
        #echo "Ensure Device is enrolled in Intune."

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
