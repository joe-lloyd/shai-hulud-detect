# Shai-Hulud NPM Supply Chain Attack Detector

[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-Bash-blue)](#requirements)
[![Status](https://img.shields.io/badge/status-Active-success)](../../)
[![Contributions](https://img.shields.io/badge/contributions-Welcome-orange)](CONTRIBUTING.md)
[![Last Commit](https://img.shields.io/github/last-commit/Cobenian/shai-hulud-detect)](https://github.com/Cobenian/shai-hulud-detect/commits/main)
[![Security Tool](https://img.shields.io/badge/type-Security%20Tool-red)](#overview)

<img src="shai_hulu_detector.jpg" alt="sshd" width="80%" />

A high-performance bash script to detect indicators of compromise from the September 2025 npm supply chain attacks, including the Shai-Hulud self-replicating worm and the chalk/debug crypto theft attack. This detector covers 571+ compromised package versions and is optimized for scanning large monorepos quickly and efficiently.

## Overview

This detector covers multiple npm supply chain attacks from September 2025:

### 🎯 **Chalk/Debug Crypto Theft Attack** (September 8, 2025)

- **Scope**: 18+ packages with 2+ billion weekly downloads
- **Attack**: Cryptocurrency wallet address replacement in browsers
- **Packages**: `chalk`, `debug`, `ansi-styles`, and others

### 🐛 **Shai-Hulud Self-Replicating Worm** (September 14-16, 2025)

- **Scope**: 517+ packages across multiple namespaces
- **Attack**: Credential harvesting and self-propagation
- **Packages**: `@ctrl/*`, `@crowdstrike/*`, `@operato/*`, and many others

This script detects indicators from both attacks to provide comprehensive protection. It has been optimized with parallel processing and directory exclusion to handle even the largest codebases without crashing.

-----

## Quick Start

### Main Detector (`shai-hulud-detector.sh`)

This is the primary, deep-scanning tool that inspects file contents, hashes, and git history.

```bash
# Clone the repository (required for compromised package list)
git clone https://github.com/username/shai-hulud-detector.git
cd shai-hulud-detector

# Make the script executable
chmod +x shai-hulud-detector.sh

# Scan your project for indicators
./shai-hulud-detector.sh /path/to/your/project

# Scan while skipping a large submodule or vendor directory
./shai-hulud-detector.sh --skip-dir /path/to/your/project/submodule /path/to/your/project

# Skip multiple directories
./shai-hulud-detector.sh \
  --skip-dir ./node_modules \
  --skip-dir ./vendor \
  /path/to/your/project
```

### Companion Script: Quick Dependency Check (`check-npm-deps.sh`)

This is a faster, separate script that **only** checks your installed `node_modules` against the compromised list. It's perfect for a quick check in CI/CD pipelines.

```bash
# Make the second script executable
chmod +x check-npm-deps.sh

# Run it from inside your project directory
cd /path/to/your/project
../check-npm-deps.sh ../compromised-packages.txt
```

-----

## Latest Updates (As of Sept 19, 2025)

- **v2.1.0 (2025-09-19): Performance & Usability Overhaul**
  - **Directory Exclusion**: Added `--skip-dir` flag to exclude directories (like submodules or `node_modules`) from scans, preventing crashes on large projects. Can be used multiple times.
  - **Real-Time Logging**: The script now creates a `shai-hulud-findings.log` file to save findings instantly. This allows you to see partial results even if the script is cancelled or fails.
  - **Parallel Processing**: Core scanning functions (like `check_content`) were rewritten to use `xargs` to spread the workload across all available CPU cores, resulting in a massive speedup.
  - **Enhanced Error Handling**: Improved functions to catch common errors (like unparseable `package.json` files) and report them gracefully instead of silently crashing.
  - **Added `check-npm-deps.sh`**: A new, fast companion script that uses `npm ls` for a quick check of installed dependencies.

-----

## Output Interpretation

In addition to the final report in your terminal, the script now provides real-time updates.

### Real-Time Log File

- A file named **`shai-hulud-findings.log`** is created in the directory where you run the script.
- It contains every finding the moment it is discovered.
- You can "watch" this file live from a second terminal window to see results as they come in:

    ```bash
    tail -f shai-hulud-findings.log
    ```

### Final Report

The final report in your terminal remains the same, categorizing findings by risk level.

- **🚨 HIGH RISK**: Definitive indicators of compromise.
- **⚠️ MEDIUM RISK**: Suspicious patterns requiring manual review.

-----

## How it Works

The script performs these comprehensive checks:

1. **Package Database Loading**: Loads 571+ compromised packages from `compromised-packages.txt`.
2. **Real-Time Logging**: Initializes `shai-hulud-findings.log` to record findings instantly.
3. **Content Scanning**: Uses parallel processing (`find` and `xargs`) to grep for suspicious URLs, webhook endpoints, and malicious patterns across all available CPU cores for maximum speed.
4. **Package Analysis**: Parses `package.json` files for compromised versions and namespaces, now with a progress bar and robust error handling.
5. **Hash Verification**: Calculates SHA-256 hashes of key files against known malicious hashes.
6. ...and all other checks as previously described (Git Analysis, Postinstall Hooks, etc.).

-----

*(The rest of the README, including sections on "What it Detects", "Requirements", "Contributing", and "References", remains accurate and does not need changes.)*

## What it Detects

### High Risk Indicators

- **Malicious workflow files**: `shai-hulud-workflow.yml` files in `.github/workflows/`
- **Known malicious file hashes**: Files matching SHA-256 hash `46faab8ab153fae6e80e7cca38eab363075bb524edd79e42269217a083628f09`
- **Compromised package versions**: Specific versions of 571+ packages from multiple attacks
- **Suspicious postinstall hooks**: Package.json files with postinstall scripts containing curl, wget, or eval commands
- **Trufflehog activity**: Files containing trufflehog references or credential scanning patterns
- **Shai-Hulud repositories**: Git repositories named "Shai-Hulud" (used for data exfiltration)

### Medium Risk Indicators

- **Suspicious content patterns**: References to `webhook.site` and the malicious endpoint `bb8ca5f6-4175-45d2-b042-fc9ebb8170b7`
- **Suspicious git branches**: Branches named "shai-hulud"
- **Compromised namespaces**: Packages from namespaces known to be affected (@ctrl, @crowdstrike, @art-ws, @ngx, @nativescript-community)

## Compromised Packages Detected

The script detects compromised packages from multiple September 2025 attacks. **Our current detection covers 571+ confirmed compromised packages** with specific version numbers, plus broader namespace detection for comprehensive protection.

### Package Detection Method

The script loads compromised packages from an external file (`compromised-packages.txt`) which contains:

- **571+ confirmed compromised package versions** with exact version numbers
- **11 affected namespaces** for broader detection of packages from compromised maintainer accounts

### Key Compromised Packages Include

- `@ctrl/tinycolor@4.1.1, 4.1.2` - Shai-Hulud attack vector (2M+ weekly downloads)
- `chalk@5.6.1`, `debug@4.4.2` - Chalk/Debug crypto theft attack (2B+ weekly downloads)
- `@art-ws/*` packages (16+ packages) - Art workspace utilities
- `@crowdstrike/*` packages (25+ packages) - CrowdStrike-related packages
- `@nativescript-community/*` packages (40+ packages) - NativeScript community tools
- `ngx-bootstrap`, `angulartics2`, `koa2-swagger-ui` - Popular standalone packages

### Affected Namespaces (Complete List)

- `@ctrl/*` - Control utility packages
- `@crowdstrike/*` - CrowdStrike-related packages
- `@art-ws/*` - Art workspace packages
- `@ngx/*` - Angular-related packages
- `@nativescript-community/*` - NativeScript community packages
- `@ahmedhfarag/*`, `@operato/*`, `@teselagen/*`, `@things-factory/*`, `@hestjs/*`, `@nstudio/*` - Additional affected namespaces

### Maintaining and Updating the Package List

**Important**: The Shai-Hulud attack was self-replicating, meaning new compromised packages may still be discovered. The compromised packages list is stored in `compromised-packages.txt` for easy maintenance:

- **Format**: `package_name:version` (one per line)
- **Comments**: Lines starting with `#` are ignored
- **Updates**: The file can be updated as new compromised packages are discovered
- **Fallback**: If the file is missing, the script uses a core embedded list

### Staying Updated on New Compromised Packages

Check these security advisories regularly for newly discovered compromised packages:

- **[StepSecurity Blog](https://www.stepsecurity.io/blog/ctrl-tinycolor-and-40-npm-packages-compromised)** - Original comprehensive analysis
- **[Semgrep Security Advisory](https://semgrep.dev/blog/2025/security-advisory-npm-packages-using-secret-scanning-tools-to-steal-credentials/)** - Detailed technical analysis
- **[JFrog Security Research](https://jfrog.com/blog/shai-hulud-npm-supply-chain-attack-new-compromised-packages-detected/)** - Ongoing detection of new packages
- **[Wiz Security Blog](https://www.wiz.io/blog/shai-hulud-npm-supply-chain-attack)** - Attack analysis with package appendix
- **[Socket.dev Blog](https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages)** - CrowdStrike package analysis

### How to Add Newly Discovered Packages

1. Check the security advisories above for new compromised packages
2. Add them to `compromised-packages.txt` in the format `package_name:version`
3. Test the script to ensure detection works
4. Consider contributing updates back to this repository

**Coverage Note**: Multiple September 2025 attacks affected 571+ packages total. Our detection aims to provide **comprehensive coverage** across both the Shai-Hulud worm (517+ packages) and Chalk/Debug crypto theft (26+ packages) attacks. Combined with namespace-based detection, this should provide excellent protection against these sophisticated supply chain compromises.

## Latest Updates

- **2025-09-18 v2.0.0**: **Multi-Attack Coverage** - Added 26 packages from Chalk/Debug crypto theft attack (571+ total). Now covers cryptocurrency wallet replacement patterns, XMLHttpRequest hijacking, and malicious function detection. Added JFrog and Aikido blog references as primary sources
- **2025-09-17 v1.3.0**: **Complete JFrog integration** - Added 273 additional packages (540+ total) with comprehensive coverage of the complete JFrog 517-package analysis. Added 6 new namespaces: @yoobic, @basic-ui-components-stc, @nexe, @thangved, @tnf-dev, and @ui-ux-gang
- **2025-09-17 v1.2.0**: Expanded to 270+ packages with @operato, @teselagen, @things-factory, @nstudio, and @crowdstrike namespaces
- **2025-09-16 v1.1.0**: Externalized compromised package list to `compromised-packages.txt` for easier maintenance and updates
- **2025-09-16 v1.1.0**: Added paranoid mode with typosquatting detection and network exfiltration pattern analysis

*For complete version history, see [CHANGELOG.md](CHANGELOG.md)*

### Core vs Paranoid Mode

**Core Mode (Default)**

- Focuses specifically on Shai-Hulud attack indicators
- Recommended for most users checking for this specific threat
- Clean, focused output with minimal false positives

**Paranoid Mode (`--paranoid`)**

- Includes all core Shai-Hulud detection PLUS additional security checks
- Adds typosquatting detection and network exfiltration pattern analysis
- ⚠️ **Important**: Paranoid features are general security tools, not specific to Shai-Hulud
- May produce more false positives from legitimate code
- Useful for comprehensive security auditing

## Requirements

- macOS or Unix-like system
- Bash shell
- Standard Unix tools: `find`, `grep`, `shasum`

## Output Interpretation

### Clean System

```
✅ No indicators of Shai-Hulud compromise detected.
Your system appears clean from this specific attack.
```

### Compromised System

The script will show:

- **🚨 HIGH RISK**: Definitive indicators of compromise
- **⚠️ MEDIUM RISK**: Suspicious patterns requiring manual review
- **Summary**: Count of issues found

### What to Do if Issues are Found

#### High Risk Issues

- **Immediate action required**
- Update or remove compromised packages
- Review and remove malicious workflow files
- Scan for credential theft
- Consider full system audit

#### Medium Risk Issues

- **Manual investigation needed**
- Review flagged files for legitimacy
- Check if webhook.site usage is intentional
- Verify git branch purposes

## Testing

The repository includes test cases to validate the script:

```bash
# Test on clean project (should show no issues)
./shai-hulud-detector.sh test-cases/clean-project

# Test on infected project (should show multiple issues)
./shai-hulud-detector.sh test-cases/infected-project

# Test on mixed project (should show medium risk issues)
./shai-hulud-detector.sh test-cases/mixed-project

# Test legitimate crypto libraries (should show MEDIUM risk only)
./shai-hulud-detector.sh test-cases/legitimate-crypto

# Test chalk/debug attack patterns (should show HIGH risk)
./shai-hulud-detector.sh test-cases/chalk-debug-attack

# Test common crypto libraries (should not trigger HIGH risk false positives)
./shai-hulud-detector.sh test-cases/common-crypto-libs
```

## How it Works

The script performs these comprehensive checks:

1. **Package Database Loading**: Loads the complete list of 571+ compromised packages from `compromised-packages.txt`
2. **Workflow Detection**: Searches for `shai-hulud-workflow.yml` files in `.github/workflows/`
3. **Hash Verification**: Calculates SHA-256 hashes of JavaScript/JSON files against known malicious hashes
4. **Package Analysis**: Parses `package.json` files for specific compromised versions and affected namespaces
5. **Postinstall Hook Detection**: Identifies suspicious postinstall scripts that could be used for malware propagation
6. **Content Scanning**: Greps for suspicious URLs, webhook endpoints, and malicious patterns
7. **Cryptocurrency Theft Detection**: Identifies wallet address replacement patterns, XMLHttpRequest hijacking, and known crypto theft functions from the September 8 attack
8. **Trufflehog Activity Detection**: Looks for evidence of credential scanning tools and secret harvesting
9. **Git Analysis**: Checks for suspicious branch names and repository names
10. **Repository Detection**: Identifies "Shai-Hulud" repositories used for data exfiltration
11. **Package Integrity Checking**: Analyzes package-lock.json and yarn.lock files for compromised packages and suspicious modifications

## Limitations

- **Hash Detection**: Only detects files with the exact known malicious hash
- **Package Versions**: Detects specific compromised versions and namespace warnings, but new compromised versions may not be detected
- **False Positives**: Legitimate use of webhook.site, Trufflehog for security, or postinstall hooks will trigger alerts
- **Worm Evolution**: The self-replicating nature means new variants may emerge with different signatures
- **Coverage**: Covers known compromised packages from major September 2025 attacks
- **Package Integrity**: Relies on lockfile analysis to detect compromised packages, but sophisticated attacks may evade detection

## Contributing

If you discover additional IoCs or compromised packages related to the Shai-Hulud attack, please update the arrays in the script and test thoroughly.

## Security Note

This script is for **detection only**. It does not:

- Automatically remove malicious code
- Fix compromised packages
- Prevent future attacks

Always verify findings manually and take appropriate remediation steps.

## Latest Threat Intelligence Updates

### s1ngularity/Nx Connection (September 2025)

Recent investigations have revealed a potential connection between the Shai-Hulud campaign and the Nx package ecosystem:

- **Repository Migration Patterns**: Attackers are using repositories with "-migration" suffixes to distribute malicious packages
- **Advanced Package Integrity Checks**: Double base64-encoded `data.json` files have been discovered in compromised package versions
- **Additional Compromised Versions**: `tinycolor@4.1.1` and `tinycolor@4.1.2` have been identified as compromised
- **New Package Targets**: `angulartics2` and `koa2-swagger-ui` packages have been added to the compromised list

### Enhanced Detection Capabilities

The script now includes:

- Repository migration pattern detection
- Package-lock.json integrity verification
- Context-aware Trufflehog detection to reduce false positives
- Risk level classification (HIGH/MEDIUM/LOW) for better triage

## References

### Primary Sources

- [StepSecurity Blog: CTRL, tinycolor and 40 NPM packages compromised](https://www.stepsecurity.io/blog/ctrl-tinycolor-and-40-npm-packages-compromised)
- [JFrog: New compromised packages in largest npm attack in history](https://jfrog.com/blog/new-compromised-packages-in-largest-npm-attack-in-history/)
- [Aikido: NPM debug and chalk packages compromised](https://www.aikido.dev/blog/npm-debug-and-chalk-packages-compromised)
- [Semgrep Security Advisory: NPM packages using secret scanning tools to steal credentials](https://semgrep.dev/blog/2025/security-advisory-npm-packages-using-secret-scanning-tools-to-steal-credentials/)
- [Aikido: S1ngularity-nx attackers strike again](https://www.aikido.dev/blog/s1ngularity-nx-attackers-strike-again)

### Additional Resources

- [Socket: Ongoing supply chain attack targets CrowdStrike npm packages](https://socket.dev/blog/ongoing-supply-chain-attack-targets-crowdstrike-npm-packages)
- [Ox Security: NPM 2.0 hack: 40+ npm packages hit in major supply chain attack](https://www.ox.security/blog/npm-2-0-hack-40-npm-packages-hit-in-major-supply-chain-attack/)
- [Phoenix Security: NPM tinycolor compromise](https://phoenix.security/npm-tinycolor-compromise/)

### Attack Details

- **Initial Discovery**: September 15, 2025
- **Scale**: 571+ packages compromised across multiple attack campaigns
- **Attack Type**: Self-replicating worm using postinstall hooks
- **Malicious Endpoint**: `https://webhook.site/bb8ca5f6-4175-45d2-b042-fc9ebb8170b7`
- **Exfiltration Method**: GitHub repositories named "Shai-Hulud"

## Contributing

We welcome contributions to improve the Shai-Hulud detector! The community's help is crucial for keeping pace with this evolving threat.

### How to Contribute

#### Adding New Compromised Packages

1. **Fork the repository**

   ```bash
   git clone https://github.com/yourusername/shai-hulud-detector.git
   cd shai-hulud-detector
   ```

2. **Update the package list**
   - Add new packages to `compromised-packages.txt` in the format `package_name:version`
   - Include a source/reference for where you found the compromised package
   - Group packages by namespace for organization

3. **Test your changes**

   ```bash
   # Test that the script loads the new packages
   ./shai-hulud-detector.sh test-cases/clean-project

   # Run all test cases to ensure nothing breaks
   ./shai-hulud-detector.sh test-cases/infected-project
   ./shai-hulud-detector.sh test-cases/mixed-project
   ```

4. **Submit a Pull Request**
   - Create a descriptive PR title (e.g., "Add @example/package compromised versions")
   - Include details about the source of the information
   - Reference any security advisories or reports
   - Explain any version patterns or attack details

#### Other Contributions

- **Bug fixes**: Report and fix issues with detection accuracy
- **New IoCs**: Add detection for additional indicators of compromise
- **Documentation**: Improve clarity and add examples
- **Test cases**: Add new test scenarios for edge cases

### Contribution Guidelines

- **Verify sources**: Only add packages confirmed by reputable security firms
- **Test thoroughly**: Ensure changes don't break existing functionality
- **Document changes**: Update relevant documentation and changelog
- **Follow patterns**: Match existing code style and organization
- **Security first**: Never include actual malicious code in test cases

### Reporting New Compromised Packages

If you can't submit a PR, you can still help by reporting new compromised packages:

1. Open an issue with the title "New compromised package: [package-name]"
2. Include the package name, version, and source of information
3. Provide links to security advisories or reports
4. We'll review and add verified packages to the detection list

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
