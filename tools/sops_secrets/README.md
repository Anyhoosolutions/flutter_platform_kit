# SOPS Secrets Management Tools

Reusable scripts for encrypting and decrypting sensitive files using [SOPS](https://github.com/mozilla/sops) with [age](https://github.com/FiloSottile/age) encryption. These scripts can be used from any repository, with each repository maintaining its own encryption keys.

## Features

- 🔐 Encrypt sensitive files (API keys, certificates, config files, etc.)
- 🔓 Decrypt files for local development or CI/CD
- 🗂️ Support for multiple file types (JSON, YAML, .env, plist, etc.)
- 🔄 Automatic secret replacement in files after decryption
- 📦 Store encrypted files in version control safely
- 🏢 Per-repository encryption keys

## Prerequisites

1. **Install SOPS**:
   ```bash
     # macOS
   brew install sops
   
     # Linux
     # See: https://github.com/mozilla/sops#install
   ```

2. **Install age** (for key generation):
   ```bash
     # macOS
   brew install age
   
     # Linux
     # See: https://github.com/FiloSottile/age#installation
   ```

## Setup for a New Repository

### 1. Generate Age Keys

Each repository should have its own age key pair. Generate one:

```bash
  # Generate a new key pair
age-keygen -o age-key.txt

  # The output will show your public key (save this!)
  # Example output:
  # Public key: age1jdgm6w6u36mejy7dy9cf45wvuv5v56ldxvautxg65rkgxpe7u94sp7gzrc
```

**Important**: 
- Save `age-key.txt` securely (DO NOT commit it to git)
- Save the public key (you'll need it for `.sops.yaml`)
- Consider using a password manager or secure key storage

### 2. Create `.sops.yaml` in Repository Root

Create a `.sops.yaml` file in your repository root with your age public key:

```yaml
creation_rules:
    - age: 'YOUR_PUBLIC_KEY_HERE'
```

**Example**:
```yaml
creation_rules:
    - age: 'age1jdgm6w6u36mejy7dy9cf45wvuv5v56ldxvautxg65rkgxpe7u94sp7gzrc'
```

### 3. Add `.sops.yaml` and `secrets/` to `.gitignore`

Add these entries to your `.gitignore`:
```
  # SOPS configuration (contains public key - OK to commit)
  # .sops.yaml  # Actually, this can be committed since it only contains the public key

  # Age private key (NEVER commit this!)
age-key.txt

  # Decrypted secrets (never commit these)
.env
*.jks
google-services.json
GoogleService-Info.plist
firebase_service_account.json
firebase_options.dart
key.properties

  # Encrypted secrets directory (commit this)
  # secrets/  # Actually, commit the encrypted files
```

### 4. Create `scripts/secrets-config.txt`

Create a configuration file that lists which files to encrypt/decrypt:

```
  # Secrets Configuration
  # Format: |filename|directory|
  # filename: name of the unencrypted file
  # directory: where the file can be found (relative to project root, use . for current directory)

|.env|.|
|firebase_service_account.json|.|
|firebase_options.dart|lib|
|google-services.json|android/app|
|GoogleService-Info.plist|ios/Runner|
|my-app-key.jks|android|
|key.properties|android|
|.env|functions|
```

**Format**:
- Each line: `|filename|directory|`
- Use `.` for files in the project root
- Use relative paths for subdirectories
- Lines starting with `#` are comments

### 5. (Optional) Create `scripts/secrets-replace-config.txt`

If you want to replace placeholders in files after decryption:

```
  # Secrets Replacement Configuration
  # Format: |variable name|filepath|
  # variable name: the name of the variable in .env
  # filepath: the path to the file in which to replace the variable

|YOUR_GOOGLE_SIGN_IN_OAUTH_CLIENT_ID|web/index.html|
|YOUR_API_KEY|android/app/src/main/res/values/strings.xml|
```

This is useful for replacing placeholders in files like `index.html` or XML files with actual values from your `.env` file.

## Usage

You can use these scripts in several ways:

### Option 1: Download from GitHub (Recommended for CI/CD)

Download and execute the script directly from GitHub:

```bash
  # From your repository root
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/encrypt-secrets.sh | bash

  # Or specify the project directory explicitly
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/encrypt-secrets.sh | bash -s -- /path/to/your/repo
```

For decryption:
```bash
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash
```

### Option 2: Clone and Use Locally

If you have the `flutter_platform_kit` repository cloned locally:

```bash
  # From your repository root
/path/to/flutter_platform_kit/tools/sops_secrets/encrypt-secrets.sh

  # Or specify the project directory explicitly
/path/to/flutter_platform_kit/tools/sops_secrets/encrypt-secrets.sh /path/to/your/repo
```

### Option 3: Download to a Local Script

Download the scripts once and keep them locally:

```bash
  # Download the scripts
mkdir -p ~/bin/sops-scripts
curl -o ~/bin/sops-scripts/encrypt-secrets.sh https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/encrypt-secrets.sh
curl -o ~/bin/sops-scripts/decrypt-secrets.sh https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh
chmod +x ~/bin/sops-scripts/*.sh

  # Use them from anywhere
~/bin/sops-scripts/encrypt-secrets.sh /path/to/your/repo
```

### Encrypt Files

Encrypt files using any of the methods above:

The script will:
1. Read `scripts/secrets-config.txt` to find files to encrypt
2. Encrypt each file and save it to `secrets/` directory
3. Create `secrets/{directory}/{filename}.enc` for each file

**Example output**:
```
🔐 Encrypting sensitive files with SOPS...
📁 Project directory: /Users/dev/my-app
📋 Reading secrets configuration...
📁 Encrypting .env...
✅ Encrypted .env -> secrets/.env.enc
📁 Encrypting firebase_options.dart...
✅ Encrypted lib/firebase_options.dart -> secrets/lib/firebase_options.dart.enc
🎉 Encryption complete!
```

### Decrypt Files

Decrypt files for local development:

```bash
  # Make sure you have your age key available
  # Option 1: Place age-key.txt in repository root
cp /path/to/secure/storage/age-key.txt /path/to/your/repo/age-key.txt

  # Option 2: Use environment variable (recommended for CI/CD)
export SOPS_AGE_KEY=$(cat /path/to/secure/storage/age-key.txt)

  # Option 3: Set SOPS_AGE_KEY_FILE
export SOPS_AGE_KEY_FILE=/path/to/secure/storage/age-key.txt

  # Decrypt using GitHub raw URL (recommended)
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash

  # Or specify the project directory explicitly
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash -s -- /path/to/your/repo

  # Or if using a local clone
/path/to/flutter_platform_kit/tools/sops_secrets/decrypt-secrets.sh /path/to/your/repo
```

The script will:
1. Read `scripts/secrets-config.txt` to find encrypted files
2. Decrypt each file to its original location
3. (Optional) Replace placeholders in files if `secrets-replace-config.txt` exists

**Example output**:
```
🔓 Decrypting sensitive files with SOPS...
📁 Project directory: /Users/dev/my-app
✅ Using age key from age-key.txt
📋 Reading secrets configuration...
📁 Decrypting secrets/.env.enc...
✅ Decrypted secrets/.env.enc -> .env
📁 Decrypting secrets/lib/firebase_options.dart.enc...
✅ Decrypted secrets/lib/firebase_options.dart.enc -> lib/firebase_options.dart
🎉 Decryption complete!
```

### Creating a Convenience Script

You can create a local wrapper script in your repository for easier access:

**`scripts/encrypt.sh`**:
```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  # Using GitHub raw URL (recommended)
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/encrypt-secrets.sh | bash -s -- "$PROJECT_ROOT"
  # Or using a local clone (if available):
  # /path/to/flutter_platform_kit/tools/sops_secrets/encrypt-secrets.sh "$PROJECT_ROOT"
```

**`scripts/decrypt.sh`**:
```bash
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
  # Using GitHub raw URL (recommended)
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash -s -- "$PROJECT_ROOT"
  # Or using a local clone (if available):
  # /path/to/flutter_platform_kit/tools/sops_secrets/decrypt-secrets.sh "$PROJECT_ROOT"
```

Make them executable:
```bash
chmod +x scripts/encrypt.sh scripts/decrypt.sh
```

Then use them from your repository:
```bash
./scripts/encrypt.sh
./scripts/decrypt.sh
```

## CI/CD Integration

### GitHub Actions Example

```yaml
name: Build and Deploy

on:
  push:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Install SOPS
        run: |
          wget -O sops-v3.7.3.linux https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux
          chmod +x sops-v3.7.3.linux
          sudo mv sops-v3.7.3.linux /usr/local/bin/sops
      
      - name: Decrypt secrets
        env:
          SOPS_AGE_KEY: ${{ secrets.AGE_KEY }}
        run: |
          curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash
      
      - name: Build app
        run: flutter build apk
```

**Important**: Store your age private key as a GitHub secret named `AGE_KEY`. Never commit the private key to git!

### GitLab CI Example

```yaml
build:
  stage: build
  before_script:
    - wget -O sops-v3.7.3.linux https://github.com/mozilla/sops/releases/download/v3.7.3/sops-v3.7.3.linux
    - chmod +x sops-v3.7.3.linux
    - sudo mv sops-v3.7.3.linux /usr/local/bin/sops
    - |
      # Decrypt secrets
      export SOPS_AGE_KEY="$AGE_KEY"
      curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash
  script:
    - flutter build apk
  variables:
    AGE_KEY: $AGE_KEY  # Set as CI/CD variable in GitLab settings
```

## File Types Supported

The scripts automatically detect and handle different file types:

- **JSON** (`.json`) - Output as JSON
- **YAML** (`.yaml`, `.yml`) - Output as YAML
- **Environment files** (`.env`) - Output as dotenv format
- **Property lists** (`.plist`) - Output as binary
- **Other files** - Auto-detect format

## Best Practices

1. **Separate Keys Per Repository**: Each repository should have its own age key pair for better security isolation.

2. **Backup Your Keys**: Store your `age-key.txt` files securely (password manager, encrypted backup, etc.).

3. **Never Commit Private Keys**: Always add `age-key.txt` to `.gitignore`.

4. **Commit Encrypted Files**: The encrypted files in `secrets/` are safe to commit since they're encrypted with your public key.

5. **Use Secrets in CI/CD**: Store the age private key as a secret in your CI/CD system (GitHub Secrets, GitLab CI/CD variables, etc.).

6. **Review Before Committing**: Before committing encrypted files, verify they're actually encrypted and not accidentally committed in plain text.

7. **Rotate Keys**: If a key is compromised, generate a new key pair and re-encrypt all files with the new key.

## Troubleshooting

### "SOPS is not installed"
Install SOPS using the instructions in the Prerequisites section.

### ".sops.yaml not found"
Create `.sops.yaml` in your repository root with your age public key.

### "No age key found"
Make sure you have one of:
- `age-key.txt` file in repository root (for local development)
- `SOPS_AGE_KEY` environment variable set (for CI/CD)
- `SOPS_AGE_KEY_FILE` environment variable pointing to key file

### "Failed to decrypt"
Possible causes:
- Wrong age key (using key from different repository)
- Encrypted file is corrupted
- File was encrypted with a different key

Verify your `.sops.yaml` contains the correct public key that matches your private key.

### "File not found"
Make sure:
- The file paths in `secrets-config.txt` are correct
- Files exist in the expected locations
- Paths are relative to repository root

## Example Repository Structure

```
my-app/
├── .sops.yaml                 # SOPS configuration (public key)
├── .gitignore                 # Excludes age-key.txt and decrypted files
├── age-key.txt                # Age private key (NOT in git)
├── .env                       # Decrypted file (NOT in git)
├── scripts/
│   ├── secrets-config.txt     # List of files to encrypt/decrypt
│   ├── secrets-replace-config.txt  # Optional: secret replacements
│   ├── encrypt.sh             # Optional: convenience script
│   └── decrypt.sh             # Optional: convenience script
└── secrets/
    ├── .env.enc               # Encrypted files (IN git)
    └── lib/
        └── firebase_options.dart.enc
```

## Security Notes

- 🔒 Age keys use strong encryption (X25519 and ChaCha20Poly1305)
- 🔐 Each repository should use its own key pair
- 🚫 Never share private keys between repositories
- 📝 Public keys (in `.sops.yaml`) are safe to commit
- 🔑 Private keys must be kept secret and backed up securely
- ✅ Encrypted files are safe to commit to version control

## License

These scripts are part of the flutter_platform_kit project and follow the same license.
