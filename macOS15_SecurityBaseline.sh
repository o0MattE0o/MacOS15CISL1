#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

############################
# 1 Install Updates, Patches and Additional Security Software
############################
echo "Section 1 - Install Updates, Patches and Additional Security Software"
    # 1.1 Ensure All Apple-provided Software Is Current
    echo "Section 1.1 - Ensure All Apple-provided Software Is Current"
        sudo softwareupdate -i -a
    # 1.2 Ensure Auto Update Is Enabled
    echo "Section 1.2 - Ensure Auto Update Is Enabled"
        sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
        defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
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
       SOFTWARE_UPDATE_DELAY=5  # Set to a value between 1 and 30
       sudo defaults write com.apple.applicationaccess enforcedSoftwareUpdateDelay -int "$SOFTWARE_UPDATE_DELAY"
    # 1.8 Ensure the System is Managed by a Mobile Device Management (MDM) Software
    echo "Section 1.8 - Ensure the System is Managed by a Mobile Device Management (MDM) Software (Manually Check)"
        #echo "Ensure Device is enrolled in Intune."
        
############################
# 2 System Settings
############################
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
            sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -int 1
    #2.3 General
    echo "Section 2.3 - General"
        # 2.3.1 AirDrop & Handoff
        echo "Section 2.3.1 - AirDrop & Handoff"
            # 2.3.1.1 Ensure AirDrop Is Disabled When Not Actively Transferring Files
            echo "Section 2.3.1.1 - Ensure AirDrop Is Disabled When Not Actively Transferring Files"
                sudo defaults write com.apple.applicationaccess allowAirDrop -bool false
                defaults write com.apple.applicationaccess allowAirDrop -bool false
            # 2.3.1.2 Ensure AirPlay Receiver Is Disabled
            echo "Section 2.3.1.2 - Ensure AirPlay Receiver Is Disabled"
                sudo defaults write com.apple.applicationaccess allowAirPlayIncomingRequests -bool false
                defaults write com.apple.applicationaccess allowAirPlayIncomingRequests -bool false
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
            echo "Section 2.3.3.5 - Ensure Remote Login Is Disabled"
                yes "yes" | sudo systemsetup -setremotelogin off
            # 2.3.3.6 Ensure Remote Management Is Disabled
            echo "Section 2.3.3.6 - Ensure Remote Management Is Disabled"
                sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -stop
            # 2.3.3.7 Ensure Remote Apple Events Is Disabled
            echo "Section 2.3.3.7 - Ensure Remote Apple Events Is Disabled"
                sudo systemsetup -setremoteappleevents off > /dev/null 2>&1
            # 2.3.3.8 Ensure Internet Sharing Is Disabled
            echo "Section 2.3.3.8 - Ensure Internet Sharing Is Disabled"
                sudo /usr/bin/defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict Enabled -int 0
            # 2.3.3.9 Ensure Content Caching Is Disabled
            echo "Section 2.3.3.9 - Ensure Content Caching Is Disabled"
                status=$(sudo /usr/bin/AssetCacheManagerUtil status | grep "Active: YES")
                if [ -n "$status" ]; then
                    sudo /usr/bin/AssetCacheManagerUtil deactivate
                    echo "     Content caching has been deactivated."
                else
                    echo "     Content caching is already deactivated."
                fi   
            #2.3.3.10 Ensure Media Sharing Is Disabled
            echo "Section 2.3.3.10 - Ensure Media Sharing Is Disabled"
                for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                    sudo -u "$user" /usr/bin/defaults write com.apple.amp.mediasharingd home-sharing-enabled -bool false
                done
            # 2.3.3.11 Ensure Bluetooth Sharing Is Disabled
            echo "Section 2.3.3.11 - Ensure Bluetooth Sharing Is Disabled"
                for user in $(ls /Users); do
                    # Skip system users that shouldn't have settings changed
                    if [[ "$user" != "Shared" && "$user" != "Guest" && -d "/Users/$user" ]]; then
                        # Disable Bluetooth Sharing for each user
                        echo "Disabling Bluetooth Sharing for user: $user"
                        sudo -u "$user" /usr/bin/defaults -currentHost write com.apple.Bluetooth PrefKeyServicesEnabled -bool false
                    fi
                done
            # 2.3.3.12 Ensure Computer Name Does Not Contain PII or Protected Organizational Information
            echo "Section 2.3.3.12 - Ensure Computer Name Does Not Contain PII or Protected Organizational Information (Manually Check)"
        # 2.3.4 Time Machine
        echo "Section 2.3.4 - Time Machine"
            # 2.3.4.1 Ensure Backup Automatically is Enabled If Time Machine Is Enabled
            echo "Section 2.3.4.1 - Ensure Backup Automatically is Enabled If Time Machine Is Enabled"
                status=$(tmutil status | grep -i "Running = 1")
                if [ -n "$status" ]; then
                    echo "Time Machine is enabled. Disabling it now..."
                    sudo tmutil disable
                    echo "     Time Machine has been disabled."
                else
                    echo "     Time Machine is already disabled."
                fi
            # 2.3.4.2 Ensure Time Machine Volumes Are Encrypted If Time Machine Is Enabled
            echo "Section 2.3.4.2 - Ensure Time Machine Volumes Are Encrypted If Time Machine Is Enabled (Skipped)"
                # Skipped - Time Machine is disabled
    # 2.4 Control Center
    echo "Section 2.4 - Control Center"
        # 2.4.1 Ensure Show Wi-Fi status in Menu Bar Is Enabled
        echo "Section 2.4.1 - Ensure Show Wi-Fi status in Menu Bar Is Enabled"
            sudo defaults write com.apple.controlcenter WiFi -int 18
        # 2.4.2	Ensure Show Bluetooth Status in Menu Bar Is Enabled
        echo "Section 2.4.2 - Ensure Show Bluetooth Status in Menu Bar Is Enabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults -currentHost write com.apple.controlcenter.plist Bluetooth -int 18
            done
    #2.5 Siri
    echo "Section 2.5 - Siri"
        # 2.5.1	Audit Siri Settings
        echo "Section 2.5.1 - Audit Siri Settings"
            PLIST_FILE="$HOME/Library/Preferences/com.apple.ironwood.support.plist"
            IRONWOOD_KEY="Ironwood Allowed"
            IRONWOOD_VALUE=true  # Change to false if needed
            if [ ! -f "$PLIST_FILE" ]; then
                echo "Creating new plist file: $PLIST_FILE"
                defaults write "$PLIST_FILE" "$IRONWOOD_KEY" -bool "$IRONWOOD_VALUE"
            else
                echo "Updating existing plist file: $PLIST_FILE"
                defaults write "$PLIST_FILE" "$IRONWOOD_KEY" -bool "$IRONWOOD_VALUE"
            fi
        # 2.5.2 Ensure Listen for (Siri) Is Disabled
        echo "Section 2.5.2 - Ensure Listen for (Siri) Is Disabled"
            sudo defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false
    # 2.6 Privacy & Security
    echo "Section 2.6 - Privacy & Security"
        # 2.6.1 Location Services
        echo "Section 2.6.1 - Location Services"
            # 2.6.1.1 Ensure Location Services Is Enabled
            echo "Section 2.6.1.1 - Ensure Location Services Is Enabled(Manually Check)"
                echo "Enabling Location Services via Terminal on macOS cannot be done directly due to System Integrity Protection (SIP) restrictions."
            # 2.6.1.2 Ensure 'Show Location Icon in Control Center when System Services Request Your Location' Is Enabled
            echo "Section 2.6.1.2 - Ensure 'Show Location Icon in Control Center when System Services Request Your Location' Is Enabled"
                sudo /usr/bin/defaults write /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices -bool true
            # 2.6.1.3 Audit Location Services Access
            echo "Section 2.6.1.3 - Audit Location Services Access (Manually Check)"
                echo "To audit Location Services access on macOS 15, you need to check which applications have access to location data. Use the following Terminal commands:"
                echo "sudo /usr/bin/defaults read /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled"
        # 2.6.2 Full Disk Access
        echo "Section 2.6.2 - Full Disk Access"
            # 2.6.2.1 Audit Full Disk Access for Applications
            echo "Section 2.6.2.1 - 2.6.2.1 Audit Full Disk Access for Applications (Manually Check)"
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
        # 2.6.4 Ensure Limit Ad Tracking Is Enabled
        echo "Section 2.6.4 - Ensure Limit Ad Tracking Is Enabled"
            sudo defaults write /Library/Preferences/com.apple.applicationaccess.plist allowApplePersonalizedAdvertising -bool false
        # 2.6.5 Ensure Gatekeeper Is Enabled
        echo "Section 2.6.5 - Ensure Gatekeeper Is Enabled"
            sudo defaults write /Library/Preferences/com.apple.systempolicy.control.plist AllowIdentifiedDevelopers -bool true
            sudo defaults write /Library/Preferences/com.apple.systempolicy.control.plist EnableAssessment -bool true
        # 2.6.6 Ensure FileVault Is Enabled
        echo "Section 2.6.6 - Ensure FileVault Is Enabled (Manually Check)"
            echo "Enable FileVault manually and place key into password store"
        # 2.6.7 Audit Lockdown Mode
        echo "Section 2.6.7 - Audit Lockdown Mode (Manually Check)"
            echo "To audit Lockdown Mode on macOS 15 via Terminal, use the following command:"
            echo "sudo /usr/bin/defaults read /Library/Managed\ Preferences/com.apple.security.lockdownmode Enabled"
        # 2.6.8 Ensure an Administrator Password Is Required to Access System-Wide Preferences
        echo "Section 2.6.8 - Ensure an Administrator Password Is Required to Access System-Wide Preferences"
            authDBs=(
                "system.preferences"
                "system.preferences.energysaver"
                "system.preferences.network"
                "system.preferences.printing"
                "system.preferences.sharing"
                "system.preferences.softwareupdate"
                "system.preferences.startupdisk"
                "system.preferences.timemachine"
            )
            
            for section in "${authDBs[@]}"; do
                TMP_PLIST="/tmp/$section.plist"
                /usr/bin/security -q authorizationdb read "$section" > "$TMP_PLIST"
                class_key_value=$(/usr/libexec/PlistBuddy -c "Print :class" "$TMP_PLIST" 2>&1)
                if [[ "$class_key_value" == *"Does Not Exist"* ]]; then
                    /usr/libexec/PlistBuddy -c "Add :class string user" "$TMP_PLIST"
                else
                    /usr/libexec/PlistBuddy -c "Set :class user" "$TMP_PLIST"
                fi
                key_value=$(/usr/libexec/PlistBuddy -c "Print :shared" "$TMP_PLIST" 2>&1)
                if [[ "$key_value" == *"Does Not Exist"* ]]; then
                    /usr/libexec/PlistBuddy -c "Add :shared bool false" "$TMP_PLIST"
                else
                    /usr/libexec/PlistBuddy -c "Set :shared false" "$TMP_PLIST"
                fi
                auth_user_key=$(/usr/libexec/PlistBuddy -c "Print :authenticate-user" "$TMP_PLIST" 2>&1)
                if [[ "$auth_user_key" == *"Does Not Exist"* ]]; then
                    /usr/libexec/PlistBuddy -c "Add :authenticate-user bool true" "$TMP_PLIST"
                else
                    /usr/libexec/PlistBuddy -c "Set :authenticate-user true" "$TMP_PLIST"
                fi
                session_owner_key=$(/usr/libexec/PlistBuddy -c "Print :session-owner" "$TMP_PLIST" 2>&1)
                if [[ "$session_owner_key" == *"Does Not Exist"* ]]; then
                    /usr/libexec/PlistBuddy -c "Add :session-owner bool false" "$TMP_PLIST"
                else
                    /usr/libexec/PlistBuddy -c "Set :session-owner false" "$TMP_PLIST"
                fi
                group_key=$(/usr/libexec/PlistBuddy -c "Print :group" "$TMP_PLIST" 2>&1)
                if [[ "$group_key" == *"Does Not Exist"* ]]; then
                    /usr/libexec/PlistBuddy -c "Add :group string admin" "$TMP_PLIST"
                else
                    /usr/libexec/PlistBuddy -c "Set :group admin" "$TMP_PLIST"
                fi
                /usr/bin/security -q authorizationdb write "$section" < "$TMP_PLIST"
                rm -f "$TMP_PLIST"
                echo "Policy updated for $section"
            done
    # 2.7 Desktop & Dock
    echo "Section 2.7 - Desktop & Dock"
        # 2.7.1 Ensure Screen Saver Corners Are Secure
        echo "Section 2.7.1 - Ensure Screen Saver Corners Are Secure"
            Check if the :Forced entry exists
            if ! sudo /usr/libexec/PlistBuddy -c "Print :Forced" /Library/Preferences/com.apple.dock.plist &>/dev/null; then
                sudo /usr/libexec/PlistBuddy -c "Add :Forced array" /Library/Preferences/com.apple.dock.plist
            fi
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
            sudo /usr/bin/defaults write com.apple.screensaver askForPassword -int 1
            sudo /usr/bin/defaults write com.apple.screensaver askForPasswordDelay -int 5
            askForPassword=$(defaults read com.apple.screensaver askForPassword)
            askForPasswordDelay=$(defaults read com.apple.screensaver askForPasswordDelay)
            if [[ "$askForPassword" == "1" && "$askForPasswordDelay" == "5" ]]; then
                echo "Password requirement after screen saver or display off is correctly configured."
            else
                echo "There was an issue applying the settings."
            fi
            killall cfprefsd
            echo "Settings have been applied and preferences refreshed."
        # 2.10.3 Ensure a Custom Message for the Login Screen Is Enabled
        echo "Section 2.10.3 - Ensure a Custom Message for the Login Screen Is Enabled"
            sudo /usr/bin/defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText "WARNING: Unauthorized use of Somerset Bridge Group computers and networking resources is prohibited. If you log on to this computer system, you acknowledge your awareness of and concurrence with the Somerset Bridge Group IT Security Policy. Somerset Bridge Group will prosecute violators to the full extent of the law. If you suspect that your computer has been tampered with or modified in any way, please contact the Somerset Bridge Shared Services Ltd IT Team."
        # 2.10.4 Ensure Login Window Displays as Name and Password Is Enabled
        echo "Section 2.10.4 - Ensure Login Window Displays as Name and Password Is Enabled"
            sudo defaults write "/Library/Preferences/com.apple.loginwindow" "SHOWFULLNAME" -bool true
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
            # Skipped - Touch ID audit isn't as straightforward through Terminal commands because its tied into both FileVault and system preferences.
    # 2.12 Users & Groups
    echo "Section 2.12 - Users & Groups"
        # 2.12.1 Ensure Guest Account Is Disabled
        echo "Section 2.12.1 - Ensure Guest Account Is Disabled"
            #sudo defaults write "/Library/Preferences/com.apple.loginwindow" "GuestEnabled" -bool false
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
    # 2.14 Game Center
    echo "Section 2.14 - Game Center"
        # 2.14.1 Audit Game Center Settings
        echo "Section 2.14.1 - Audit Game Center Settings"
            sudo defaults write com.apple.applicationaccess allowGameCenter -bool false
    # 2.15 Notifications
    echo "Section 2.15 - Notifications"
        # 2.15.1 Audit Notification & Focus Settings
        echo "Section 2.15.1 - Audit Notification & Focus Settings (Manually Check)"
    # 2.16 Wallet & Apple Pay
    echo "Section 2.16 - Wallet & Apple Pay"
        # 2.16.1 Audit Wallet & Apple Pay Settings
        echo "Section 2.16.1 - Audit Wallet & Apple Pay Settings (Manually Check)"
    # 2.17 Internet Accounts
    echo "Section 2.17 - Internet Accounts"
        # 2.17.1 Audit Internet Accounts for Authorized Use
        echo "Section 2.17.1 - Audit Internet Accounts for Authorized Use (Manually Check)"
    # 2.18 Keyboard
    echo "Section 2.18 - Keyboard"
        # 2.18.1 Ensure On-Device Dictation Is Enabled
        echo "Section 2.18.1 - Ensure On-Device Dictation Is Enabled"
            sudo defaults write com.apple.applicationaccess forceOnDeviceOnlyDictation -bool true
            killall SystemUIServer
            
############################
# 3 Logging and Auditing
############################
#Skipped due to errors login into MacOS after applying

############################    
# 4 Network Configurations
############################
echo "Section 4 - Network Configurations"
    # 4.1 Ensure Bonjour Advertising Services Is Disabled
    echo "Section 4.1 - Ensure Bonjour Advertising Services Is Disabled"
        sudo /usr/bin/defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true
    # 4.2 Ensure HTTP Server Is Disabled
    echo "Section 4.2 - Ensure HTTP Server Is Disabled"
        sudo launchctl unload -w /System/Library/LaunchDaemons/org.apache.httpd.plist
    # 4.3 Ensure NFS Server Is Disabled
    echo "Section 4.3 - Ensure NFS Server Is Disabled"
        sudo launchctl disable system/com.apple.nfsd

############################
# 5 System Access, Authentication and Authorization
############################
echo "Section 5 - System Access, Authentication and Authorization"
    # 5.1 File System Permissions and Access Controls
    echo "Section 5.1 - File System Permissions and Access Controls"
        # 5.1.1 Ensure Home Folders Are Secure
        echo "Section 5.1.1 - Ensure Home Folders Are Secure"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                home_dir="/Users/$user"
                if [ -d "$home_dir" ]; then
                    perms=$(stat -f %Lp "$home_dir")
                    if [ "$perms" != "700" ]; then
                        echo "Fixing permissions for $home_dir"
                        sudo chmod 700 "$home_dir"
                    fi
                    owner=$(stat -f %Su "$home_dir")
                    group=$(stat -f %Sg "$home_dir")
                    if [ "$owner" != "$user" ] || [ "$group" != "staff" ]; then
                        echo "Fixing ownership for $home_dir"
                        sudo chown "$user:staff" "$home_dir"
                    fi
                fi
            done
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
        # 5.1.7 Ensure No World Writable Folders Exist in the Library Folder
        echo "Section 5.1.7 - Ensure No World Writable Folders Exist in the Library Folder"  
            world_writable_dirs=$(sudo find /Library -type d -perm -002)
            if [ -z "$world_writable_dirs" ]; then
                echo "No world-writable directories found in /Library."
            else
                echo "World-writable directories found in /Library:"
                echo "$world_writable_dirs"
                for dir in $world_writable_dirs; do
                    echo "Fixing permissions for $dir"
                    sudo chmod o-w "$dir"
                done
                echo "All world-writable directories have been fixed. (FIXED)"
            fi
    # 5.2 Password Management
    echo "Section 5.2 - Password Management"
        # 5.2.1 Ensure Password Account Lockout Threshold Is Configured
        echo "Section 5.2.1 - Ensure Password Account Lockout Threshold Is Configured"
            sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "maxFailedLoginAttempts=5 policyAttributeMinutesUntilFailedAuthenticationReset=5"
        # 5.2.2 Ensure Password Minimum Length Is Configured
        echo "Section 5.2.2 - Ensure Password Minimum Length Is Configured"
            sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "policyAttributePasswordMatches=14"
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
        echo "Section 5.2.8 - Ensure Password History Is Configured"
            sudo /usr/bin/pwpolicy -n /Local/Default -setglobalpolicy "usingHistory=15"
    # 5.3 Encryption
    echo "Section 5.3 - Encryption"
        # 5.3.1 Ensure all user storage APFS volumes are encrypted
        echo "Section 5.3.1 - Ensure all user storage APFS volumes are encrypted (Manually Check)"
        # 5.3.2 Ensure all user storage CoreStorage volumes are encrypted
        echo "Section 5.3.2 - Ensure all user storage CoreStorage volumes are encrypted  (Manually Check)"
    # 5.4 Ensure the Sudo Timeout Period Is Set to Zero
    echo "Section 5.4 - Ensure the Sudo Timeout Period Is Set to Zero"
        sudoers_file="/etc/sudoers"
        timestamp_setting="Defaults    timestamp_timeout=0"
        if sudo grep -q "$timestamp_setting" "$sudoers_file"; then
            echo "Sudo timeout is already set to zero."
        else
            echo "Setting sudo timeout period to zero..."
            # Edit sudoers file safely using visudo to ensure proper syntax checking
            sudo visudo -c && echo "$timestamp_setting" | sudo tee -a "$sudoers_file" > /dev/null
            echo "Sudo timeout period has been set to zero."
        fi
        echo "Sudo timeout period configuration complete."
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
    
############################
# 6 Applications
############################
echo "Section 6 - Applications"
    # 6.1 Finder
    echo "Section 6.1 - Finder"
        # 6.1.1	Ensure Show All Filename Extensions Setting is Enabled
        echo "Section 6.1.1 - Ensure Show All Filename Extensions Setting is Enabled"
            for user in $(ls /Users); do
                if [[ "$user" != "Shared" && "$user" != "Guest" && -d "/Users/$user" ]]; then
                    echo "Enabling 'Show All Filename Extensions' for user: $user"
                    sudo -u "$user" /usr/bin/defaults write /Users/"$user"/Library/Preferences/.GlobalPreferences.plist AppleShowAllExtensions -bool true
                fi
            done
    # 6.2 Mail
    echo "Section 6.2 - Mail"
        # 6.2.1 Ensure Protect Mail Activity in Mail Is Enabled
        echo "Section 6.2.1 - Ensure Protect Mail Activity in Mail Is Enabled (Manually Check)"
    # 6.3 Safari
    echo "Section 6.3 - Safari"
        # 6.3.1	Ensure Automatic Opening of Safe Files in Safari Is Disabled
        echo "Section 6.3.1 - Ensure Automatic Opening of Safe Files in Safari Is Disabled"
            sudo defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
            defaults write com.apple.Safari AutoOpenSafeDownloads -bool false
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Automatic opening of safe files in Safari is now disabled."
        # 6.3.2 Audit History and Remove History Items
        echo "Section 6.3.2 - Audit History and Remove History Items"
            # Replace <value> with one of the allowed integers: 1, 7, 14, 31, 365, 36500
            value=31
            sudo defaults write com.apple.Safari HistoryAgeInDaysLimit -int $value
        # 6.3.3 Ensure Warn When Visiting A Fraudulent Website in Safari Is Enabled
        echo "Section 6.3.3 - Ensure Warn When Visiting A Fraudulent Website in Safari Is Enabled"
            sudo defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
            defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Warn when visiting fraudulent websites is now enabled in Safari."
        # 6.3.4 Ensure Prevent Cross-site Tracking in Safari Is Enabled
        echo "Section 6.3.4 - Ensure Prevent Cross-site Tracking in Safari Is Enabled"
            sudo defaults write com.apple.Safari BlockStoragePolicy -int 2
            defaults write com.apple.Safari BlockStoragePolicy -int 2
            sudo defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1
            defaults write com.apple.Safari WebKitPreferences.storageBlockingPolicy -int 1
            sudo defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1
            defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Prevent Cross-site Tracking is now enabled in Safari."
        # 6.3.5 Audit Hide IP Address in Safari Setting
        echo "Section 6.3.5 - Audit Hide IP Address in Safari Setting (Skipped)"
            # Skipped
        # 6.3.6 Ensure Advertising Privacy Protection in Safari Is Enabled
        echo "Section 6.3.6 - Ensure Advertising Privacy Protection in Safari Is Enabled"
            sudo defaults write com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool true
            defaults write com.apple.Safari WebKitPreferences.privateClickMeasurementEnabled -bool true
            sudo defaults write -g WebKitPreferences.privateClickMeasurementEnabled -bool true
            defaults write -g WebKitPreferences.privateClickMeasurementEnabled -bool true
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Advertising Privacy Protection is now enabled in Safari."
        # 6.3.7 Ensure Show Full Website Address in Safari Is Enabled
        echo "Section 6.3.7 - Ensure Show Full Website Address in Safari Is Enabled"
            sudo defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
            defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Full website address is now enabled in Safari."
        # 6.3.8 Audit AutoFill
        echo "Section 6.3.8 - Audit AutoFill (Skipped)"
            # Skipped
        # 6.3.9 Audit Pop-up Windows
        echo "Section 6.3.9 - Audit Pop-up Windows (Skipped)"
            # Skipped
        # 6.3.10 Ensure Show Status Bar Is Enabled
        echo "Section 6.3.10 - Ensure Show Status Bar Is Enabled"
            sudo defaults write com.apple.finder ShowOverlayStatusBar -bool true
            defaults write com.apple.finder ShowOverlayStatusBar -bool true
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Show Status Bar in Safari is now enabled."
    # 6.4 Terminal
    echo "Section 6.4 - Terminal"
        # 6.4.1 Ensure Secure Keyboard Entry Terminal.app Is Enabled
        echo "Section 6.4.1 - Ensure Secure Keyboard Entry Terminal.app Is Enabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                sudo -u "$user" /usr/bin/defaults write com.apple.Terminal SecureKeyboardEntry -bool true
            done

############################
# 7 Supplemental
############################
echo "Section 7 - Supplemental"
    # 7.1 CIS Apple macOS Benchmark development collaboration with mSCP
    echo "Section 7.1 CIS Apple macOS Benchmark development collaboration with mSCP (Skipped)"
        # Skipped
        # No recommendations
    # 7.2 Apple Push Notification Service (APNs)
    echo "Section 7.2 - Apple Push Notification Service (APNs) (Skipped)"
        # Skipped    
        # No recommendations
    # 7.3 Mobile Configuration Profiles
    echo "Section 7.3 - Mobile Configuration Profiles (Skipped)"
        # Skipped    
        # No recommendations

echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
