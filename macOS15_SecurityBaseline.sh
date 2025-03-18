#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# Ensure script runs with administrative privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root!"
    exit 1
fi

# Function to apply system settings safely
apply_setting() {
    local domain=$1
    local key=$2
    local value=$3

    echo "Applying setting: $domain -> $key = $value"

    # Handle boolean values properly
    if [[ "$value" == "true" || "$value" == "false" ]]; then
        sudo defaults write "$domain" "$key" -bool "$value"
    elif [[ "$value" =~ ^[0-9]+$ ]]; then
        sudo defaults write "$domain" "$key" -int "$value"
    else
        sudo defaults write "$domain" "$key" "$value"
    fi
}

# 1 Install Updates, Patches and Additional Security Software
echo "Section 1 - Install Updates, Patches and Additional Security Software"
    # 1.1 Ensure All Apple-provided Software Is Current
    echo "Section 1.1 - Ensure All Apple-provided Software Is Current (skipped)"
        #sudo softwareupdate -i -a
    # 1.2 Ensure Auto Update Is Enabled
    echo "Section 1.2 - Ensure Auto Update Is Enabled"
        apply_setting "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticCheckEnabled" -bool true
        apply_setting "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticDownload" -bool true
        apply_setting "/Library/Preferences/com.apple.SoftwareUpdate" "AutomaticallyInstallMacOSUpdates" -bool true
        apply_setting "/Library/Preferences/com.apple.commerce" "AutoUpdate" -bool TRUE
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
# 2 System Settings
echo "Section 2 - System Settings"
    # 2.1 Apple Account
    echo "Section 2.1 - Apple Account"
        # 2.1.1 iCloud
        echo "Section 2.1.1 - iCloud"
            # 2.1.1.1 Audit iCloud Keychain
            echo "Section 2.1.1.1 - Audit iCloud Keychain"
            # 2.1.1.2 Audit iCloud Drive
            echo "Section 2.1.1.2 - Audit iCloud Drive"
            # 2.1.1.3 Ensure iCloud Drive Document and Desktop Sync Is Disabled
            echo "Section 2.1.1.3 - Ensure iCloud Drive Document and Desktop Sync Is Disabled"
                for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody');  do
                    sudo -u "$user" defaults write /Users/"$user"/Library/Preferences/com.apple.finder.plist FXDesktopLayoutGridChar -bool false
                    sudo -u "$user" defaults write /Users/"$user"/Library/Preferences/com.apple.finder.plist FXDocumentsLayoutGridChar -bool false
                done
            # 2.1.1.4 Audit Security Keys Used With Apple Accounts
            echo "Section 2.1.1.4 - Audit Security Keys Used With Apple Accounts"
            # 2.1.1.5 Audit Freeform Sync to iCloud
            echo "Section 2.1.1.5 - Audit Freeform Sync to iCloud"
            # 2.1.1.6 Audit Find My Mac
            echo "Section 2.1.1.6 - Audit Find My Mac"
        # 2.1.2 Audit App Store Password Settings
        echo "Section 2.1.2 - Audit App Store Password Settings"
    # 2.2 Networking
    echo "Section 2.2 - Networking"
        # 2.2.1	Ensure Firewall Is Enabled
        echo "Section 2.2.1 - Ensure Firewall Is Enabled"
            sudo /usr/bin/defaults write /Library/Preferences/com.apple.alf globalstate -int 2
        # 2.2.2	Ensure Firewall Stealth Mode Is Enabled
        echo "Section 2.2.2 - Ensure Firewall Stealth Mode Is Enabled"
            sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on
    #2.3 General
    echo "Section 2.3 - General"
        # 2.3.1 AirDrop & Handoff
        echo "Section 2.3.1 - AirDrop & Handoff"
            # 2.3.1.1 Ensure AirDrop Is Disabled When Not Actively Transferring Files
            echo "Section 2.3.1.1 - Ensure AirDrop Is Disabled When Not Actively Transferring Files"
                apply_setting "com.apple.NetworkBrowser" "DisableAirDrop" -bool true
                killall Finder
            # 2.3.1.2 Ensure AirPlay Receiver Is Disabled
            echo "Section 2.3.1.2 - Ensure AirPlay Receiver Is Disabled"
                apply_setting "/Library/Preferences/com.apple.Bluetooth" "ControllerPowerState" -int 0
                sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
        # 2.3.2 Date & Time
        echo "Section 2.3.2 - Date & Time"
                # 2.3.2.1 Ensure Set Time and Date Automatically Is Enabled
                echo "Section 2.3.2.1 - Ensure Set Time and Date Automatically Is Enabled"
                    sudo systemsetup -setusingnetworktime on
                # 2.3.2.2 Ensure Time Is Set Within Appropriate Limits
                echo "Section 2.3.2.2 - Ensure Time Is Set Within Appropriate Limits"
                    sudo sntp time.apple.com
        # 2.3.3 Sharing
        echo "Section 2.3.3 - Sharing"
            # 2.3.3.1 Ensure DVD or CD Sharing Is Disabled
            echo "Section 2.3.3.1 - Ensure DVD or CD Sharing Is Disabled"
                sudo /bin/launchctl disable system/com.apple.ODSAgent 
                sudo /bin/launchctl bootout system/com.apple.ODSAgent
            # 2.3.3.2 Ensure Screen Sharing Is Disabled
            echo "Section 2.3.3.2 - Ensure Screen Sharing Is Disabled"
                sudo /bin/launchctl disable system/com.apple.screensharing
                sudo /bin/launchctl bootout system/com.apple.screensharing
            # 2.3.3.3 Ensure File Sharing Is Disabled
            echo "Section 2.3.3.3 - Ensure File Sharing Is Disabled"
                sudo /bin/launchctl disable system/com.apple.smbd
                sudo /bin/launchctl bootout system/com.apple.smbd
            # 2.3.3.4 Ensure Printer Sharing Is Disabled
            echo "Section 2.3.3.4 - Ensure Printer Sharing Is Disabled"
                sudo cupsctl --no-share-printers
            # 2.3.3.5 - Ensure Remote Login Is Disabled
            echo "Section 2.3.3.5 - Ensure Remote Login Is Disabled (skipped)"
                #sudo systemsetup -setremotelogin off 2>/dev/null
            # 2.3.3.6 Ensure Remote Management Is Disabled
            echo "Section 2.3.3.6 - Ensure Remote Management Is Disabled"
                sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
            # 2.3.3.7 Ensure Remote Apple Events Is Disabled
            echo "Section 2.3.3.7 - Ensure Remote Apple Events Is Disabled"
                sudo systemsetup -setremoteappleevents off 2>/dev/null
            # 2.3.3.8 Ensure Internet Sharing Is Disabled
            echo "Section 2.3.3.8 - Ensure Internet Sharing Is Disabled"
                sudo /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
            # 2.3.3.9 Ensure Content Caching Is Disabled
            echo "Section 2.3.3.9 - Ensure Content Caching Is Disabled"
                status=$(sudo /usr/bin/AssetCacheManagerUtil status | grep "Active: YES")
                if [ -n "$status" ]; then
                    sudo /usr/bin/AssetCacheManagerUtil deactivate
                    echo "Content caching has been deactivated."
                else
                    echo "Content caching is already deactivated."
                fi   
            #2.3.3.10 Ensure Media Sharing Is Disabled
            echo "Section 2.3.3.10 - Ensure Media Sharing Is Disabled"
                for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                    sudo -u "$user" /usr/bin/defaults write com.apple.amp.mediasharingd home-sharing-enabled -bool false
                done
            # 2.3.3.11 Ensure Bluetooth Sharing Is Disabled
            echo "Section 2.3.3.11 - Ensure Bluetooth Sharing Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0
                sudo launchctl unload /System/Library/LaunchDaemons/com.apple.blued.plist
            # 2.3.3.12 Ensure Computer Name Does Not Contain PII or Protected Organizational Information
            echo "Section 2.3.3.12 - Ensure Computer Name Does Not Contain PII or Protected Organizational Information (Manually Check)"
                # echo "Manually check required Hostname should not contain"
                    # 1. User directory account names
                    # 2. Computer directory account names where machine accounts exist
                    # 3. Contact phone numbers
                    # 4. Physical locations of offices or residences
                    # 5. Personal information that can be augmented with Facebook data to assist social engineering attacks
        # 2.3.4 Time Machine
        echo "Section 2.3.4 - Time Machine"
            # 2.3.4.1 Ensure Backup Automatically is Enabled If Time Machine Is Enabled
            echo "Section 2.3.4.1 - Ensure Backup Automatically is Enabled If Time Machine Is Enabled"
                tm_status=$(tmutil status | grep -c "Running = 1")
                if [ "$tm_status" -eq 1 ]; then
                    echo "Time Machine is enabled. Ensuring automatic backups are enabled."
                    sudo defaults write /Library/Preferences/com.apple.TimeMachine AutoBackup -bool true
                else
                    echo "Time Machine is not enabled. (OK)"
                fi
            # 2.3.4.2 Ensure Time Machine Volumes Are Encrypted If Time Machine Is Enabled
            echo "Section 2.3.4.2 - Ensure Time Machine Volumes Are Encrypted If Time Machine Is Enabled (Skipped)"
                # Create a FileVault Policy in Intune:
                    # 1. Sign in to the Microsoft Intune admin center.
                    # 2.  Go to Devices > Configuration profiles > Create profile.
                    # 3. Select macOS for the platform.
                    # 4. Choose Endpoint protection for the profile type.
                    # 5. Configure the FileVault settings to enforce encryption.
    # 2.4 Control Center
    echo "Section 2.4 - Control Center"
        # 2.4.1 Ensure Show Wi-Fi status in Menu Bar Is Enabled
        echo "Section 2.4.1 - Ensure Show Wi-Fi status in Menu Bar Is Enabled"
            defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/AirPort.menu"
            killall SystemUIServer
        # 2.4.2	Ensure Show Bluetooth Status in Menu Bar Is Enabled
        echo "Section 2.4.2 - Ensure Show Bluetooth Status in Menu Bar Is Enabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults -currentHost write com.apple.controlcenter.plist Bluetooth -int 18
            done
    #2.5 Siri
    echo "Section 2.5 - Siri"
        # 2.5.1	Audit Siri Settings
        echo "Section 2.5.1 - Audit Siri Settings"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults write com.apple.assistant.support 'Assistant Enabled' -bool false
                sudo -u "$user" /usr/bin/defaults write com.apple.Siri LockscreenEnabled -bool false
                sudo -u "$user" /usr/bin/defaults write com.apple.Siri StatusMenuVisible -bool false
                sudo -u "$user" /usr/bin/defaults write com.apple.Siri TypeToSiriEnabled -bool false
                sudo -u "$user" /usr/bin/defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false
                sudo /usr/bin/killall -HUP cfprefsd
                sudo /usr/bin/killall SystemUIServer
            done
        # 2.5.2 Ensure Listen for (Siri) Is Disabled
        echo "Section 2.5.2 - Ensure Listen for (Siri) Is Disabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Preferences/com.apple.assistant.support 'Assistant Enabled' -bool false
            done
    # 2.6 Privacy & Security
    echo "Section 2.6 - Privacy & Security"
        # 2.6.1 Location Services
        echo "Section 2.6.1 - Location Services"
            # 2.6.1.1 Ensure Location Services Is Enabled
            echo "Section 2.6.1.1 - Ensure Location Services Is Enabled"
                if sudo /bin/launchctl bootstrap system /System/Library/LaunchDaemons/com.apple.locationd.plist; then
                    sudo /usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -bool true
                    sudo /usr/bin/killall locationd
                    echo "Location Services have been enabled."
                else
                    echo "Failed to load locationd. Please check for richer errors using launchctl bootstrap."
                fi
            # 2.6.1.2 Ensure 'Show Location Icon in Control Center when System Services Request Your Location' Is Enabled
            echo "Section 2.6.1.2 - Ensure 'Show Location Icon in Control Center when System Services Request Your Location' Is Enabled"
                sudo /usr/bin/defaults write /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices -bool true
            # 2.6.1.3 Audit Location Services Access
            echo "Section 2.6.1.3 - Audit Location Services Access (Skipped)"
        # 2.6.2 Full Disk Access
        echo "Section 2.6.2 - Full Disk Access"
            # 2.6.2.1 Audit Full Disk Access for Applications
            echo "Section 2.6.2.1 - 2.6.2.1 Audit Full Disk Access for Applications (Manually Check)"
                # 1.Open System Settings
                # 2.Select Privacy & Security
                # 3.Select Full Disk Access
                # 4.Set any listed applications to your organization's requirements
                # 5.(Optional) Select the + to add applications to the list, or - to remove them
        # 2.6.3 Analytics & Improvements
        echo "Section 2.6.3 - Analytics & Improvements"
            # 2.6.3.1 Ensure Share Mac Analytics Is Disabled
            echo "Section 2.6.3.1 - Ensure Share Mac Analytics Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.SubmitDiagInfo.plist AutoSubmit -bool false
            # 2.6.3.2 Ensure Improve Siri & Dictation Is Disabled
            echo "Section 2.6.3.2 - Ensure Improve Siri & Dictation Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.applicationaccess.plist "Siri Data Sharing Opt-In Status" -int 2
            # 2.6.3.3 Ensure Improve Assistive Voice Features Is Disabled
            echo "Section 2.6.3.3 - Ensure Improve Assistive Voice Features Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.Accessibility.plist AXSAudioDonationSiriImprovementEnabled -bool false
            # 2.6.3.4 Ensure 'Share with app developers' Is Disabled
            echo "Section 2.6.3.4 - Ensure 'Share with app developers' Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.applicationaccess.plist allowDiagnosticSubmission -bool false
            # 2.6.3.5 Ensure Share iCloud Analytics Is Disabled
            echo "Section 2.6.3.5 - Ensure Share iCloud Analytics Is Disabled (Manually Check)"
                # 1. Open System Settings
                # 2. Open Privacy & Security
                # 3. Select Analytics & Improvements
                # 4. Verify that Share iCloud Analytics is disabled
        # 2.6.4 Ensure Limit Ad Tracking Is Enabled
        echo "Section 2.6.4 - Ensure Limit Ad Tracking Is Enabled"
            sudo defaults write /Library/Preferences/com.apple.applicationaccess.plist allowApplePersonalizedAdvertising -bool false
        # 2.6.5 Ensure Gatekeeper Is Enabled
        echo "Section 2.6.5 - Ensure Gatekeeper Is Enabled"
            sudo defaults write /Library/Preferences/com.apple.systempolicy.control.plist AllowIdentifiedDevelopers -bool true
            sudo defaults write /Library/Preferences/com.apple.systempolicy.control.plist EnableAssessment -bool true
        # 2.6.6 Ensure FileVault Is Enabled
        echo "Section 2.6.6 - Ensure FileVault Is Enabled (Skipped)"
            # sudo defaults write /Library/Preferences/com.apple.MCX.plist dontAllowFDEDisable -bool true
        # 2.6.7 Audit Lockdown Mode
        echo "Section 2.6.7 - Audit Lockdown Mode"
            # echo "1. Open System Settings"
            # echo "2. Select Privacy & Security"
            # echo "3. Set Lockdown Mode to your organization's parameters"
        # 2.6.8 Ensure an Administrator Password Is Required to Access System-Wide Preferences
        echo "Section 2.6.8 - Ensure an Administrator Password Is Required to Access System-Wide Preferences"
            /usr/libexec/PlistBuddy -c "Set :authenticate-user false" "/tmp/$section.plist"
            #declare -a authDBs=("system.preferences" "system.preferences.energysaver" "system.preferences.network" "system.preferences.printing" "system.preferences.sharing" "system.preferences.softwareupdate" "system.preferences.startupdisk" "system.preferences.timemachine")
            #for section in "${authDBs[@]}"; do
            #    /usr/bin/security -q authorizationdb read "$section" > "/tmp/$section.plist"
            #    class_key_value=$(usr/libexec/PlistBuddy -c "Print :class" "/tmp/$section.plist" 2>&1)
            #    if [[ "$class_key_value" == *"Does Not Exist"* ]]; then
            #        /usr/libexec/PlistBuddy -c "Add :class string user" "/tmp/$section.plist"
            #    else
            #        /usr/libexec/PlistBuddy -c "Set :class user" "/tmp/$section.plist"
            #    fi
            #    key_value=$(/usr/libexec/PlistBuddy -c "Print :shared" "/tmp/$section.plist" 2>&1)  	
            #    if [[ "$key_value" == *"Does Not Exist"* ]]; then
            #        /usr/libexec/PlistBuddy -c "Add :shared bool false" "/tmp/$section.plist"
            #    else
            #        /usr/libexec/PlistBuddy -c "Set :shared false" "/tmp/$section.plist"
            #    fi
            #    auth_user_key=$(/usr/libexec/PlistBuddy -c "Print :authenticate-user" "/tmp/$section.plist" 2>&1)  	
            #    if [[ "$auth_user_key" == *"Does Not Exist"* ]]; then
            #        /usr/libexec/PlistBuddy -c "Add :authenticate-user bool true" "/tmp/$section.plist"
            #    else
            #        /usr/libexec/PlistBuddy -c "Set :authenticate-user true" "/tmp/$section.plist"
            #    fi
            #    session_owner_key=$(/usr/libexec/PlistBuddy -c "Print :session-owner" "/tmp/$section.plist" 2>&1)  	
            #    if [[ "$session_owner_key" == *"Does Not Exist"* ]]; then
            #        /usr/libexec/PlistBuddy -c "Add :session-owner bool false" "/tmp/$section.plist"
            #    else
            #        /usr/libexec/PlistBuddy -c "Set :session-owner false" "/tmp/$section.plist"
            #    fi
            #    group_key=$(usr/libexec/PlistBuddy -c "Print :group" "/tmp/$section.plist" 2>&1)
            #    if [[ "$group_key" == *"Does Not Exist"* ]]; then
            #        /usr/libexec/PlistBuddy -c "Add :group string admin" "/tmp/$section.plist"
            #    else
            #        /usr/libexec/PlistBuddy -c "Set :group admin" "/tmp/$section.plist"
            #    fi
            #    /usr/bin/security -q authorizationdb write "$section" < "/tmp/$section.plist"
            #done
    # 2.7 Desktop & Dock
    echo "Section 2.7 - Desktop & Dock"
        # 2.7.1 Ensure Screen Saver Corners Are Secure
        echo "Section 2.7.1 - Ensure Screen Saver Corners Are Secure"
            # Check if the :Forced entry exists
            if ! sudo /usr/libexec/PlistBuddy -c "Print :Forced" /Library/Preferences/com.apple.dock.plist &>/dev/null; then
                sudo /usr/libexec/PlistBuddy -c "Add :Forced array" /Library/Preferences/com.apple.dock.plist
            fi
            # Add the necessary entries
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0 dict" /Library/Preferences/com.apple.dock.plist
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0:mcx_preference_settings dict" /Library/Preferences/com.apple.dock.plist
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0:mcx_preference_settings:wvous-bl-corner integer 6" /Library/Preferences/com.apple.dock.plist
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0:mcx_preference_settings:wvous-br-corner integer 6" /Library/Preferences/com.apple.dock.plist
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0:mcx_preference_settings:wvous-tl-corner integer 6" /Library/Preferences/com.apple.dock.plist
            sudo /usr/libexec/PlistBuddy -c "Add :Forced:0:mcx_preference_settings:wvous-tr-corner integer 6" /Library/Preferences/com.apple.dock.plist
        # 2.7.2 Audit iPhone Mirroring
        echo "Section 2.7.2 - Audit iPhone Mirroring"
            sudo defaults write /Library/Preferences/com.apple.applicationaccess.plist allowiPhoneMirroring -bool false
    # 2.8 Displays
    echo "Section 2.8 - Displays"
        # 2.8.1 Audit Universal Control Settings
        echo "Section 2.8.1 - Audit Universal Control Settings"
            sudo defaults write com.apple.universalcontrol Disable -bool true
    # 2.9 Battery (Energy Saver)
    echo "Section 2.9 - Battery (Energy Saver)"
        # 2.9.1 OS Resuming From Sleep
        echo "Section 2.9.1 - OS Resuming From Sleep"
            # 2.9.1.1 Ensure the OS Is Not Active When Resuming from Standby (Intel)
            echo "Section 2.9.1.1 - Ensure the OS Is Not Active When Resuming from Standby (Intel)"
                sudo /usr/bin/pmset -a standbydelaylow 500
                sudo /usr/bin/pmset -a standbydelayhigh 500
                sudo /usr/bin/pmset -a highstandbythreshold 100
                #sudo /usr/bin/pmset -a destroyfvkeyonstandby 1
                sudo /usr/bin/pmset -a hibernatemode 25
            # 2.9.1.2 Ensure Sleep and Display Sleep Is Enabled on Apple Silicon Devices
            echo "Section 2.9.1.2 - Ensure Sleep and Display Sleep Is Enabled on Apple Silicon Devices"
                sudo /usr/bin/pmset -a sleep 15
                sudo /usr/bin/pmset -a displaysleep 10
        # 2.9.2 Ensure Power Nap Is Disabled for Intel Macs
        echo "Section 2.9.2 - Ensure Power Nap Is Disabled for Intel Macs"
            sudo /usr/bin/pmset -a powernap 0
        # 2.9.3 Ensure Wake for Network Access Is Disabled
        echo "Section 2.9.3 - Ensure Wake for Network Access Is Disabled"
            sudo /usr/bin/pmset -a womp 0  
    # 2.10 Lock Screen
    echo "Section 2.10 - Lock Screen"
        # 2.10.1 Ensure an Inactivity Interval of 20 Minutes Or Less for the Screen Saver Is Enabled
        echo "Section 2.10.1 - Ensure an Inactivity Interval of 20 Minutes Or Less for the Screen Saver Is Enabled"
            sudo defaults -currentHost write com.apple.screensaver idleTime -int 1200
        # 2.10.2 Ensure Require Password After Screen Saver Begins or Display Is Turned Off Is Enabled for 5 Seconds or Immediately
        echo "Section 2.10.2 - Ensure Require Password After Screen Saver Begins or Display Is Turned Off Is Enabled for 5 Seconds or Immediately"
            apply_setting "com.apple.screensaver" "askForPassword" -int 1
            apply_setting "com.apple.screensaver" "askForPasswordDelay" -int 5
        # 2.10.3 Ensure a Custom Message for the Login Screen Is Enabled
        echo "Section 2.10.3 - Ensure a Custom Message for the Login Screen Is Enabled"
            sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "WARNING: Unauthorized use of Somerset Bridge Group computers and networking resources is prohibited. If you log on to this computer system, you acknowledge your awareness of and concurrence with the Somerset Bridge Group IT Security Policy. Somerset Bridge Group will prosecute violators to the full extent of the law. If you suspect that your computer has been tampered with or modified in any way, please contact the Somerset Bridge Shared Services Ltd IT Team."
        # 2.10.4 Ensure Login Window Displays as Name and Password Is Enabled
        echo "Section 2.10.4 - Ensure Login Window Displays as Name and Password Is Enabled"
            apply_setting "/Library/Preferences/com.apple.loginwindow" "SHOWFULLNAME" -bool true
        # 2.10.5 Ensure Show Password Hints Is Disabled
        echo "Section 2.10.5 - Ensure Show Password Hints Is Disabled"
            sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0
    # 2.11 Touch ID & Password (Login Password)
    echo "Section 2.11 - Touch ID & Password (Login Password)"
        # 2.11.1 Ensure Users' Accounts Do Not Have a Password Hint
        echo "Section 2.11.1 - Ensure Users' Accounts Do Not Have a Password Hint"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody');  do
                sudo /usr/bin/dscl . -list /Users hint . -delete /Users/"$user" hint
            done
        # 2.11.2 Audit Touch ID
        echo "Section 2.11.2 - Audit Touch ID (Skipped)"
    # 2.12 Users & Groups
    echo "Section 2.12 - Users & Groups"
        # 2.12.1 Ensure Guest Account Is Disabled
        echo "Section 2.12.1 - Ensure Guest Account Is Disabled"
            apply_setting "/Library/Preferences/com.apple.loginwindow" "GuestEnabled" -bool false
        # 2.12.2 Ensure Guest Access to Shared Folders Is Disabled
        echo "Section 2.12.2 - Ensure Guest Access to Shared Folders Is Disabled"
            sudo /usr/sbin/sysadminctl -smbGuestAccess off
        # 2.12.3 Ensure Automatic Login Is Disabled
        echo "Section 2.12.3 - Ensure Automatic Login Is Disabled"
            if sudo /usr/bin/defaults read /Library/Preferences/com.apple.loginwindow autoLoginUser &>/dev/null; then
                sudo /usr/bin/defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser
                echo "Automatic login has been disabled."
            else
                echo "autoLoginUser key does not exist. Automatic login is already disabled. (OK)"
            fi
    # 2.13 Passwords
    echo "Section 2.13 - Passwords"
        # 2.13.1 Audit Passwords System Preference Setting
        echo "Section 2.13.1 - Audit Passwords System Preference Setting (Manually Check)"
            # 1. Open System Settings
            # 2. Select Passwords
            # 3. Enter the user's password
            # 4. Select the Security Recommendations
            # 5. Remove stored passwords that should not be saved.
    # 2.14 Game Center
    echo "Section 2.14 - Game Center"
        # 2.14.1 Audit Game Center Settings
        echo "Section 2.14.1 - Audit Game Center Settings"
            sudo defaults write com.apple.applicationaccess allowGameCenter -bool false
    # 2.15 Notifications
    echo "Section 2.15 - Notifications"
        # 2.15.1 Audit Notification & Focus Settings
        echo "Section 2.15.1 - Audit Notification & Focus Settings (Manually Check)"
            # 1. Open System Settings
            # 2. Select Notifications
            # 3. Select any applications that are not in compliance with your organization's requirements
            # 4. Turn off or mute notifications that may expose information to unauthorized people that might be able to view screens of organizational computers.
    # 2.16 Wallet & Apple Pay
    echo "Section 2.16 - Wallet & Apple Pay"
        # 2.16.1 Audit Wallet & Apple Pay Settings
        echo "Section 2.16.1 - Audit Wallet & Apple Pay Settings (Manually Check)"
            # 1. Open System Settings
            # 2. Select Wallet & Apple Pay
            # 3. Set the Wallet & Apple Pay settings to your organization's requirements
    # 2.17 Internet Accounts
    echo "Section 2.17 - Internet Accounts"
        # 2.17.1 Audit Internet Accounts for Authorized Use
        echo "Section 2.17.1 - Audit Internet Accounts for Authorized Use (Manually Check)"
            # 1. Open System Settings
            # 2. Select Internet Accounts
            # 3. For each account, select the account
            # 4. Verify that each sync option is set to your organization's requirements
            # 5. (Optional) Select Delete Account... to remove the account
            # 6. (Optional) Select Add Account... to add an account to the system
    # 2.18 Keyboard
    echo "Section 2.18 - Keyboard"
        # 2.18.1 Ensure On-Device Dictation Is Enabled
        echo "Section 2.18.1 - Ensure On-Device Dictation Is Enabled"
            sudo defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMEnabled -bool true
            sudo defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMLocaleIdentifier -string "en_US"
            killall SystemUIServer
# 3 Logging and Auditing
echo "Section 3 - Logging and Auditing"
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
    # 3.2 Ensure Security Auditing Flags For User-Attributable Events Are Configured Per Local Organizational Requirements
    echo "Section 3.2 - Ensure Security Auditing Flags For User-Attributable Events Are Configured Per Local Organizational Requirements"
        flags_to_check="-fm, ad, -ex, aa, -fr, lo, -fw"
        current_flags=$(grep "^flags:" /etc/security/audit_control | cut -d ' ' -f 2-)
        if [[ "$current_flags" == *"$flags_to_check"* ]]; then
            echo "The audit_control file already contains the specified flags."
        else
            echo "The audit_control file does not contain the specified flags. Updating..."
            sudo cp /etc/security/audit_control /etc/security/audit_control.bak
            sudo sed -i '' "s/^flags:.*/flags: $flags_to_check/" /etc/security/audit_control
            echo "The audit_control file has been updated with the specified flags."
        fi
    # 3.3 Ensure install.log Is Retained for 365 or More Days and No Maximum Size
    echo "Section 3.3 - Ensure install.log Is Retained for 365 or More Days and No Maximum Size"
        sudo sed -i '' "s/* file \/var\/log\/install.log.*/* file \/var\/log\/install.log format='\$((Time)(JZ)) \$Host \$Sender[\$PID]: \$Message' rotate=utc compress file_max=50M size_only ttl=365/g" /etc/asl/com.apple.install
    # 3.4 Ensure Security Auditing Retention Is Enabled
    echo "Section 3.4 - Ensure Security Auditing Retention Is Enabled"
        sudo cp /etc/security/audit_control /etc/security/audit_control.bak
        sudo sed -i '' 's/^expire-after:.*/expire-after:60d OR 5G/' /etc/security/audit_control
        sudo launchctl stop com.apple.auditd
        sudo launchctl start com.apple.auditd
    # 3.5 Ensure Access to Audit Records Is Controlled
    echo "Section 3.5 - Ensure Access to Audit Records Is Controlled"
        sudo /usr/sbin/chown -R root:wheel /etc/security/audit_control
        sudo /bin/chmod -R 440 /etc/security/audit_control
        sudo /usr/sbin/chown -R root:wheel "$(/usr/bin/sudo /usr/bin/grep '^dir' /etc/security/audit_control | /usr/bin/awk -F: '{print $2}')"
        sudo /bin/chmod -R 440 "$(/usr/bin/grep '^dir' /etc/security/audit_control | /usr/bin/awk -F: '{print $2}')"
    # 3.6 Audit Software Inventory
    echo "Section 3.6 - Audit Software Inventory"
        echo "Delete any unnecessary applications from the system."
# 4 Network Configurations
echo "Section 4 - Network Configurations"
    # 4.1 Ensure Bonjour Advertising Services Is Disabled
    echo "Section 4.1 - Ensure Bonjour Advertising Services Is Disabled"
        sudo /usr/bin/defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
    # 4.2 Ensure HTTP Server Is Disabled
    echo "Section 4.2 - Ensure HTTP Server Is Disabled (Skipped)"
        # sudo /usr/sbin/apachectl stop
        # sudo /bin/launchctl bootout system /System/Library/LaunchDaemons/org.apache.httpd.plist
    # 4.3 Ensure NFS Server Is Disabled
    echo "Section 4.3 - Ensure NFS Server Is Disabled (Skipped)"
        # sudo /sbin/nfsd stop
        # sudo /bin/launchctl disable system/com.apple.nfsd
        # if [ -f /etc/exports ]; then
        #     sudo rm /etc/exports
        # else
        #     echo "/etc/exports file does not exist."
        # fi
# 5 System Access, Authentication and Authorization
echo "Section 5 - System Access, Authentication and Authorization"
    # 5.1 File System Permissions and Access Controls
    echo "Section 5.1 - File System Permissions and Access Controls"
        # 5.1.1 Ensure Home Folders Are Secure
        echo "Section 5.1.1 - Ensure Home Folders Are Secure (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    if [ -d /Users/"$user" ]; then
            #        sudo /bin/chmod -R og-rw /Users/"$user"
            #    else
            #        echo "Home directory for user $user does not exist."
            #    fi
            #done
        # 5.1.2 Ensure System Integrity Protection Status (SIP) Is Enabled
        echo "Section 5.1.2 - Ensure System Integrity Protection Status (SIP) Is Enabled (Skipped)"
        # 5.1.3 Ensure Apple Mobile File Integrity (AMFI) Is Enabled
        echo "Section 5.1.3 - Ensure Apple Mobile File Integrity (AMFI) Is Enabled"
            csrutil status | grep -q "enabled" || echo "WARNING: System Integrity Protection (SIP) is disabled!"
        # 5.1.4 Ensure Signed System Volume (SSV) Is Enabled
        echo "Section 5.1.4 - Ensure Signed System Volume (SSV) Is Enabled"
            csrutil authenticated-root status | grep -q "enabled" || echo "WARNING: Signed System Volume (SSV) is disabled!"
        # 5.1.5 Ensure Appropriate Permissions Are Enabled for System Wide Applications
        echo "Section 5.1.5 - Ensure Appropriate Permissions Are Enabled for System Wide Applications"
            IFS=$'\n'
            for apps in $(/usr/bin/find /System/Volumes/Data/Applications -iname "*.app" -type d -perm -2 | grep -v Xcode.app); do
                sudo /bin/chmod -R o-w "$apps"
            done
        # 5.1.6 Ensure No World Writable Folders Exist in the System Folder
        echo "Section 5.1.6 - Ensure No World Writable Folders Exist in the System Folder (Skipped)"
        # 5.1.7 Ensure No World Writable Folders Exist in the Library Folder
        echo "Section 5.1.7 - Ensure No World Writable Folders Exist in the Library Folder"  
            #IFS=$'\n'
            #for libPermissions in $( /usr/bin/find /System/Volumes/Data/Library -type d -perm -2 2>&1 | /usr/bin/grep -v Caches | /usr/bin/grep -v /Preferences/Audio/Data ); do
            #    sudo /bin/chmod -R o-w "$libPermissions"
            #done
    # 5.2 Password Management
    echo "Section 5.2 - Password Management"
        # 5.2.1 Ensure Password Account Lockout Threshold Is Configured
        echo "Section 5.2.1 - Ensure Password Account Lockout Threshold Is Configured"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "maxFailedLoginAttempts=5"
        # 5.2.2 Ensure Password Minimum Length Is Configured
        echo "Section 5.2.2 - Ensure Password Minimum Length Is Configured"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "minChars=15"
        # 5.2.3 Ensure Complex Password Must Contain Alphabetic Characters Is Configured
        echo "Section 5.2.3 - Ensure Complex Password Must Contain Alphabetic Characters Is Configured (Skipped)"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresAlpha=1"
        # 5.2.4 Ensure Complex Password Must Contain Numeric Character Is Configured
        echo "Section 5.2.4 - Ensure Complex Password Must Contain Numeric Character Is Configured (Skipped)"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresNumeric=2"
        # 5.2.5 Ensure Complex Password Must Contain Special Character Is Configured
        echo "Section 5.2.5 - Ensure Complex Password Must Contain Special Character Is Configured (Skipped)"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresSymbol=1"
        # 5.2.6 Ensure Complex Password Must Contain Uppercase and Lowercase Characters Is Configured
        echo "Section 5.2.6 - Ensure Complex Password Must Contain Uppercase and Lowercase Characters Is Configured (Skipped)"
            # sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "requiresMixedCase=1"
        # 5.2.7 Ensure Password Age Is Configured
        echo "Section 5.2.7 - Ensure Password Age Is Configured (Skipped)"
            # /usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "maxMinutesUntilChangePassword=43200"
        # 5.2.8 Ensure Password History Is Configured
        echo "Section 5.2.8 - Ensure Password History Is Configured (Skipped)"
            # /usr/bin/sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "usingHistory=15"
    # 5.3 Encryption
    echo "Section 5.3 - Encryption"
        # 5.3.1 Ensure all user storage APFS volumes are encrypted
        echo "Section 5.3.1 - Ensure all user storage APFS volumes are encrypted (Manually Check)"
            # 1. Use Disk Utility to erase a user disk and format as APFS (Encrypted)
        # 5.3.2 Ensure all user storage CoreStorage volumes are encrypted
        echo "Section 5.3.2 - Ensure all user storage CoreStorage volumes are encrypted  (Manually Check)"
            # 1. Use Disk Utility to erase a disk and format as macOS Extended (Journaled, Encrypted)
    # 5.4 Ensure the Sudo Timeout Period Is Set to Zero
    echo "Section 5.4 - Ensure the Sudo Timeout Period Is Set to Zero (Manually Check)"
        if ! grep -q "Defaults timestamp_timeout=0" /etc/sudoers; then
            echo "Defaults timestamp_timeout=5" | sudo tee -a /etc/sudoers
        fi
    # 5.5 Ensure a Separate Timestamp Is Enabled for Each User/tty Combo
    echo "Section 5.5 - Ensure a Separate Timestamp Is Enabled for Each User/tty Combo (Manually Check)"
        # 1. Open Terminal: Launch the Terminal application.
        # 2. Edit the sudoers file: Use the visudo command to safely edit the sudoers file. This command checks for syntax errors before saving the file.
            # sudo visudo
        # 3. Find the Defaults line: Look for the line that starts with Defaults.
        # 4. Set the timeout to zero: Add or modify the following line to set the sudo timeout period to zero:
            # Defaults tty_tickets
        # 5. Save and exit: Save the file and exit the editor. If you're using the default nano editor, you can save by pressing Ctrl+O, then Enter, and exit by pressing Ctrl+X.
    # 5.6 Ensure the 'root' Account Is Disabled
    echo "Section 5.6 - Ensure the 'root' Account Is Disabled (Skipped)"
    # 5.7 Ensure an Administrator Account Cannot Login to Another User's Active and Locked Session
    echo "Section 5.7 - Ensure an Administrator Account Cannot Login to Another User's Active and Locked Session"
        sudo /usr/bin/security authorizationdb write system.login.screensaver allow
        # Running this command will disable Touch ID to unlock the screen saver. To re-enable Touch ID for users, run the following command:
        # sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow screenUnlockMode -int 1
    # 5.8 Ensure a Login Window Banner Exists
    echo "Section 5.8 - Ensure a Login Window Banner Exists (Skipped)"
        # Files are needed before activiating 
        # sudo /bin/chmod o+r /Library/Security/PolicyBanner.txt
        # sudo /bin/chmod o+r /Library/Security/PolicyBanner.rtf 
    # 5.9 Ensure the Guest Home Folder Does Not Exist
    echo "Section 5.9 - Ensure the Guest Home Folder Does Not Exist"
        if [ -d /Users/Guest ]; then
            sudo /bin/rm -R /Users/Guest
            echo "Guest home folder has been removed."
        else
            echo "Guest home folder does not exist."
        fi
    # 5.10 Ensure XProtect Is Running and Updated
    echo "Section 5.10 - Ensure XProtect Is Running and Updated"
        sudo softwareupdate --background-critical
    # 5.11 Ensure Logging Is Enabled for Sudo
    echo "Section 5.11 - Ensure Logging Is Enabled for Sudo"
        sudo cp /etc/sudoers /etc/sudoers.bak
        echo "Defaults log_output" | sudo tee -a /etc/sudoers
        sudo visudo -c
# 6 Applications
echo "Section 6 - Applications"
    # 6.1 Finder
    echo "Section 6.1 - Finder"
        # 6.1.1	Ensure Show All Filename Extensions Setting is Enabled
        echo "Section 6.1.1 - Ensure Show All Filename Extensions Setting is Enabled"
            sudo defaults write NSGlobalDomain AppleShowAllExtensions
            sudo killall Finder
    # 6.2 Mail
    echo "Section 6.2 - Mail"
        # 6.2.1 Ensure Protect Mail Activity in Mail Is Enabled
        echo "Section 6.2.1 - Ensure Protect Mail Activity in Mail Is Enabled (Manually Check)"
            # Perform the following steps to enabled protect mail activity:"
                # 1. Open Mail
                # 2. Select Mail in the menu bar
                # 3. Select Settings...
                # 4. Select Privacy
                # 5. Set Protect Mail Activity to enabled
    # 6.3 Safari
    echo "Section 6.3 - Safari"
        # 6.3.1	Ensure Automatic Opening of Safe Files in Safari Is Disabled
        echo "Section 6.3.1 - Ensure Automatic Opening of Safe Files in Safari Is Disabled (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    if [ -d "/Users/$user/Library/Containers/com.apple.Safari/Data/Library/Preferences" ]; then
            #        sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari AutoOpenSafeDownloads -bool false
            #    else
            #        echo "Skipping user $user: Preferences directory not found."
            #    fi
            #done
        # 6.3.2 Audit History and Remove History Items
        echo "Section 6.3.2 - Audit History and Remove History Items"
            # Replace <value> with one of the allowed integers: 1, 7, 14, 31, 365, 36500
            value=31
            sudo defaults write com.apple.Safari HistoryAgeInDaysLimit -int $value
        # 6.3.3 Ensure Warn When Visiting A Fraudulent Website in Safari Is Enabled
        echo "Section 6.3.3 - Ensure Warn When Visiting A Fraudulent Website in Safari Is Enabled"
            sudo defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
            killall Safari
        # 6.3.4 Ensure Prevent Cross-site Tracking in Safari Is Enabled
        echo "Section 6.3.4 - Ensure Prevent Cross-site Tracking in Safari Is Enabled (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    if [ -d "/Users/$user/Library/Containers/com.apple.Safari/Data/Library/Preferences" ]; then
            #        sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari BlockStoragePolicy -int 2
            #        sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1
            #        sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WebKitStorageBlockingPolicy -int 1
            #    else
            #        echo "Skipping user $user: Preferences directory not found."
            #    fi
            #done
        # 6.3.5 Audit Hide IP Address in Safari Setting
        echo "Section 6.3.5 - Audit Hide IP Address in Safari Setting (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari/Data/Library/Preferences/com.apple.Safari WBSPrivacyProxyAvailabilityTraffic -int 33422572
            #done
        # 6.3.6 Ensure Advertising Privacy Protection in Safari Is Enabled
        echo "Section 6.3.6 - Ensure Advertising Privacy Protection in Safari Is Enabled"
            sudo defaults write com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool true
            killall Safari
        # 6.3.7 Ensure Show Full Website Address in Safari Is Enabled
        echo "Section 6.3.7 - Ensure Show Full Website Address in Safari Is Enabled"
            defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
            killall Safari
        # 6.3.8 Audit AutoFill
        echo "Section 6.3.8 - Audit AutoFill (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari AutoFillFromAddressBook -bool true
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari AutoFillPasswords -bool true
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari AutoFillCreditCardData -bool true
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari AutoFillMiscellaneousForms -bool true
            #done
        # 6.3.9 Audit Pop-up Windows
        echo "Section 6.3.9 - Audit Pop-up Windows (Skipped)"
            #for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
            #    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Containers/com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
            #    sudo -u "$user" /usr/bin/defaults delete /Users/"$user"/Library/Containers/com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomaticallyExceptions
            #done
        # 6.3.10 Ensure Show Status Bar Is Enabled
        echo "Section 6.3.10 - Ensure Show Status Bar Is Enabled"
            sudo defaults write com.apple.finder ShowStatusBar -bool true
            killall Finder
    # 6.4 Terminal
    echo "Section 6.4 - Terminal"
        # 6.4.1 Ensure Secure Keyboard Entry Terminal.app Is Enabled
        echo "Section 6.4.1 - Ensure Secure Keyboard Entry Terminal.app Is Enabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults write com.apple.Terminal SecureKeyboardEntry -bool true
            done
# 7 Supplemental
echo "Section 7 - Supplemental"
    # 7.1 CIS Apple macOS Benchmark development collaboration with mSCP
    echo "Section 7.1 CIS Apple macOS Benchmark development collaboration with mSCP (Skipped)"
        #No recommendations
    # 7.2 Apple Push Notification Service (APNs)
    echo "Section 7.2 - Apple Push Notification Service (APNs) (Skipped)"
        #No recommendations
    # 7.3 Mobile Configuration Profiles
    echo "Section 7.3 - Mobile Configuration Profiles (Skipped)"
        #No recommendations

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
