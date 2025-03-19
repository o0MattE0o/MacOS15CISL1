https://workbench.cisecurity.org/benchmarks/18636/

https://www.shellcheck.net/ - No Errors

CHMOD 755 ~/Downloads/macOS15_SecurityBaseline.sh

CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0

1. Install Updates, Patches, and Additional Security Software
- Ensure all Apple-provided software is current
- Ensure auto-update is enabled
- Ensure download new updates when available is enabled
- Ensure install of macOS updates is enabled
- Ensure install application updates from the App Store is enabled
- Ensure install security responses and system files is enabled
- Ensure software update deferment is less than or equal to 30 days
- Ensure the system is managed by a Mobile Device Management (MDM) software

2. System Settings
- Apple Account (iCloud, App Store Password Settings)
- Networking (Firewall settings)
- General (AirDrop, AirPlay, Date & Time, Sharing settings)
- Control Center (Wi-Fi and Bluetooth status)
- Siri settings
- Privacy & Security (Location Services, Full Disk Access, Analytics & Improvements, Limit Ad Tracking, Gatekeeper, FileVault, Lockdown Mode, Administrator Password)
- Desktop & Dock (Screen Saver Corners, iPhone Mirroring)
- Displays (Universal Control settings)
- Battery (Energy Saver settings)
- Lock Screen (Inactivity interval, password requirements, login window settings)
- Touch ID & Password (Password hint settings)
- Users & Groups (Guest account, automatic login)
- Passwords (System preference settings)
- Game Center settings
- Notifications settings
- Wallet & Apple Pay settings
- Internet Accounts settings
- Keyboard settings

3. Logging and Auditing
- Skipped due to errors logging into macOS after applying

4. Network Configurations
- Bonjour advertising services
- HTTP server
- NFS server

5. System Access, Authentication, and Authorization
- File system permissions and access controls
- Password management
- Encryption
- Sudo timeout period
- Separate timestamp for each user/tty combo
- Root account settings
- Administrator account settings
- Guest home folder
- XProtect settings
- Logging for sudo

6. Applications
- Finder settings
- Mail settings
- Safari settings
- Terminal settings

7. Supplemental
- CIS Apple macOS Benchmark development collaboration with mSCP
- Apple Push Notification Service (APNs)
- Mobile configuration profiles
