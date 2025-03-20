#!/bin/bash
# CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0
# Level 1 - Security Settings
# https://workbench.cisecurity.org/benchmarks/18636/

# 6 Applications
echo "Section 6 - Applications"
    # 6.1 Finder
    echo "Section 6.1 - Finder"
        # 6.1.1	Ensure Show All Filename Extensions Setting is Enabled
        echo "Section 6.1.1 - Ensure Show All Filename Extensions Setting is Enabled"
            defaults write com.apple.finder AppleShowAllExtensions -bool true
            killall Finder
    # 6.2 Mail
    echo "Section 6.2 - Mail"
        # 6.2.1 Ensure Protect Mail Activity in Mail Is Enabled
        echo "Section 6.2.1 - Ensure Protect Mail Activity in Mail Is Enabled (Manually Check)"
    # 6.3 Safari
    echo "Section 6.3 - Safari"
        # 6.3.1	Ensure Automatic Opening of Safe Files in Safari Is Disabled
        echo "Section 6.3.1 - Ensure Automatic Opening of Safe Files in Safari Is Disabled"
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
            defaults write com.apple.Safari ContentBlockersEnabled -bool true
            if pgrep -x "Safari" > /dev/null; then
                echo "Restarting Safari to apply changes..."
                killall Safari
            else
                echo "Safari is not running, changes will take effect the next time Safari is launched."
            fi
            echo "Advertising Privacy Protection is now enabled in Safari."
        # 6.3.7 Ensure Show Full Website Address in Safari Is Enabled
        echo "Section 6.3.7 - Ensure Show Full Website Address in Safari Is Enabled"
            defaults write com.apple.Safari ShowFullURL -bool true
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
            defaults write com.apple.Safari ShowStatusBar -bool true
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
echo "All CIS Policies have been applied, and this is the end of the script."
exit 0
