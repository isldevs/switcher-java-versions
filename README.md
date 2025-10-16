## Java Version Switcher

Tired of manually editing environment variables to switch Java versions? This tool automates the process!
Java version manager for Windows/macOS. Auto-scans JDKs, interactive selection, updates environment vars system-wide. Works with Oracle/OpenJDK/Adoptium. Apple Silicon ready.
Simple CLI tool saves hours of manual config!

### What it does:

- **Auto-detects** all installed JDKs (ignores JREs)
- **Interactive menu** to select your version
- ️**Updates JAVA_HOME** and **PATH** automatically
- **Permanent changes** to system/shell config
- **Windows**: System-wide environment variables
- **macOS**: Shell profile updates (.zshrc/.bash_profile)

### Supported Platforms:

- Windows 10/11 (requires admin rights)
- macOS 10.15+ (Intel & Apple Silicon M1/M2)

### Quick Start:

1. Download the script for your OS
2. Run as admin (Windows) or make executable (macOS)
3. Select your JDK version
4. Open new terminal - done!

**Install multiple JDKs from Oracle, OpenJDK, Adoptium, or Homebrew!**

## **File Structure**

```bash
java-version-switcher/
├── README.md                 # This comprehensive documentation
├── java-switcher-win.bat     # Windows batch script (Run as Admin)
├── java-switcher-mac.sh      # macOS bash script (chmod +x required)