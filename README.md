<h3>To Run manually on device</h3>
CHMOD 755 ~/Downloads/macOS15_SecurityBaseline.sh <br/>
sudo ~/Downloads/macOS15_SecurityBaseline.sh <br/>
<br/>
<h1>CIS Apple macOS 15.0 Sequoia Benchmark v1.0.0</h1>
https://workbench.cisecurity.org/benchmarks/18636/ <br/>

<br/>
<h3>1. Install Updates, Patches, and Additional Security Software</h3>
<ul>
  <li>Ensure all Apple-provided software is current</li>
  <li>Ensure auto-update is enabled</li>
  <li>Ensure download new updates when available is enabled</li>
  <li>Ensure install of macOS updates is enabled</li>
  <li>Ensure install application updates from the App Store is enabled</li>
  <li>Ensure install security responses and system files is enabled</li>
  <li>Ensure software update deferment is less than or equal to 30 days</li>
  <li>Ensure the system is managed by a Mobile Device Management (MDM) software</li>
</ul>

<h3>2. System Settings</h3>
<ul>
  <li>Apple Account (iCloud, App Store Password Settings)</li>
  <li>Networking (Firewall settings)</li>
  <li>General (AirDrop, AirPlay, Date & Time, Sharing settings)</li>
  <li>Control Center (Wi-Fi and Bluetooth status)</li>
  <li>Siri settings</li>
  <li>Privacy & Security (Location Services, Full Disk Access, Analytics & Improvements, Limit Ad Tracking, Gatekeeper, FileVault, Lockdown Mode, Administrator Password)</li>
  <li>Desktop & Dock (Screen Saver Corners, iPhone Mirroring)</li>
  <li>Displays (Universal Control settings)</li>
  <li>Battery (Energy Saver settings)</li>
  <li>Lock Screen (Inactivity interval, password requirements, login window settings)</li>
  <li>Touch ID & Password (Password hint settings)</li>
  <li>Users & Groups (Guest account, automatic login)</li>
  <li>Passwords (System preference settings)</li>
  <li>Game Center settings</li>
  <li>Notifications settings</li>
  <li>Wallet & Apple Pay settings</li>
  <li>Internet Accounts settings</li>
  <li>Keyboard settings</li>
</ul>

<h3>3. Logging and Auditing</h3>
<ul>
  <li>Skipped due to errors logging into macOS after applying</li>
</ul>

<h3>4. Network Configurations</h3>
<ul>
  <li>Bonjour advertising services
  <li>HTTP server
  <li>NFS server
</ul>

<h3>5. System Access, Authentication, and Authorization</h3>
<ul>
  <li>File system permissions and access controls</li>
  <li>Password management</li>
  <li>Encryption</li>
  <li>Sudo timeout period</li>
  <li>Separate timestamp for each user/tty combo</li>
  <li>Root account settings</li>
  <li>Administrator account settings</li>
  <li>Guest home folder</li>
  <li>XProtect settings</li>
  <li>Logging for sudo</li>
</ul>

<h3>6. Applications</h3>
<ul>
  <li>Finder settings</li>
  <li>Mail settings</li>
  <li>Safari settings</li>
  <li>Terminal settings</li>
</ul>

<h3>7. Supplemental</h3>
<ul>
  <li>CIS Apple macOS Benchmark development collaboration with mSCP</li>
  <li>Apple Push Notification Service (APNs)</li>
  <li>Mobile configuration profiles</li>
</ul>
