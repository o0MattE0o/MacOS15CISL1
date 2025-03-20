#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

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
                sudo defaults write "com.apple.NetworkBrowser" "DisableAirDrop" -bool true
                killall Finder
            # 2.3.1.2 Ensure AirPlay Receiver Is Disabled
            echo "Section 2.3.1.2 - Ensure AirPlay Receiver Is Disabled"
                sudo defaults write /Library/Preferences/com.apple.airplay disableAirPlayReceiver -bool true
                killall -HUP SystemUIServer
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
                sudo systemsetup -setremotelogin off > /dev/null 2>&1
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
                /usr/bin/defaults -currentHost write com.apple.Bluetooth PrefKeyServicesEnabled -bool false > /dev/null 2>&1
                sudo launchctl kickstart -k system/com.apple.bluetoothd > /dev/null 2>&1
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
            sudo defaults write com.apple.systemuiserver menuExtras -array-add "/System/Library/CoreServices/Menu Extras/AirPort.menu"
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
            /usr/bin/defaults write com.apple.assistant.support "Assistant Enabled" -bool false > /dev/null 2>&1
            killall Siri > /dev/null 2>&1
            killall Assistant > /dev/null 2>&1
        # 2.5.2 Ensure Listen for (Siri) Is Disabled
        echo "Section 2.5.2 - Ensure Listen for (Siri) Is Disabled"
            for user in $(dscl . list /Users | grep -v '^_' | grep -v 'daemon' | grep -v 'nobody'); do
                user_pref_path="/Users/$user/Library/Preferences/com.apple.assistant.support"
                if [ -f "$user_pref_path" ]; then
                    sudo -u "$user" /usr/bin/defaults write "$user_pref_path" 'Assistant Enabled' -bool false
                    echo "Disabled Listen for Siri for user: $user"
                else
                    echo "No Siri preferences found for user: $user"
                fi
            done
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
            current_setting=$(sudo security authorizationdb read system.preferences 2>/dev/null)
            if [ $? -eq 0 ]; then
                if echo "$current_setting" | grep -q '"shared" = true'; then
                    echo "System preferences are accessible without an admin password. Changing to require admin password."
                    sudo security authorizationdb write system.preferences authenticate-admin
                    echo "System preferences now require an admin password."
                else
                    echo "System preferences already require an admin password."
                fi
            else
                echo "Error: Unable to read system.preferences authorization. The rule may not exist."
                echo "Attempting to configure system preferences to require admin password."
                sudo security authorizationdb write system.preferences authenticate-admin
                echo "System preferences now require an admin password."
            fi
    # 2.7 Desktop & Dock
    echo "Section 2.7 - Desktop & Dock"
        # 2.7.1 Ensure Screen Saver Corners Are Secure
        echo "Section 2.7.1 - Ensure Screen Saver Corners Are Secure"
            Check if the :Forced entry exists
            if ! sudo /usr/libexec/PlistBuddy -c "Print :Forced" /Library/Preferences/com.apple.dock.plist &>/dev/null; then
                sudo /usr/libexec/PlistBuddy -c "Add :Forced array" /Library/Preferences/com.apple.dock.plist
            fi
            Add the necessary entries
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
            sudo defaults write "com.apple.screensaver" "askForPassword" -int 1
            sudo defaults write "com.apple.screensaver" "askForPasswordDelay" -int 5
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
            sudo defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMEnabled -bool true
            sudo defaults write com.apple.speech.recognition.AppleSpeechRecognition.prefs DictationIMLocaleIdentifier -string "en_US"
            killall SystemUIServer
echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
