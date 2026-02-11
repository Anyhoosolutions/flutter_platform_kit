# Setup Guide: Prerequisites for Manual Full Deploy

This guide covers the required setup for using the reusable full deploy workflow. You need to configure two main components: **age-key** (for SOPS secret decryption) and **Firebase service account** (for Firebase deployments).

---

## Table of Contents

1. [SOPS Age Key Setup](#sops-age-key-setup)
2. [Firebase Service Account Setup](#firebase-service-account-setup)
3. [Encrypting Secrets](#encrypting-secrets)
4. [GitHub Secrets Configuration](#github-secrets-configuration)
5. [Verification](#verification)

---

## SOPS Age Key Setup

The deploy workflow uses [SOPS](https://github.com/mozilla/sops) with [age](https://github.com/FiloSottile/age) encryption to decrypt sensitive files (like `firebase_service_account.json` and `firebase_options.dart`) during the build. You need to generate an age key pair for your app repository.

### 1. Install age

```bash
# macOS
brew install age

# Linux (Ubuntu/Debian)
sudo apt-get install age

# Or download from: https://github.com/FiloSottile/age#installation
```

### 2. Generate an Age Key Pair

Each repository should have its **own** age key pair. Generate one:

```bash
age-keygen -o age-key.txt
```

**Example output:**
```
# Public key: age1jdgm6w6u36mejy7dy9cf45wvuv5v56ldxvautxg65rkgxpe7u94sp7gzrc
```

**Important:**
- Save the **public key** (you'll need it for `.sops.yaml`)
- Save `age-key.txt` securely — **never commit it to git**
- Store the private key in a password manager or secure backup
- The entire contents of `age-key.txt` will become your GitHub secret `SOPS_AGE_KEY`

### 3. Create `.sops.yaml` in Your Repository Root

Create a `.sops.yaml` file with your age **public** key:

```yaml
creation_rules:
  - age: 'YOUR_PUBLIC_KEY_HERE'
```

**Example:**
```yaml
creation_rules:
  - age: 'age1jdgm6w6u36mejy7cf45wvuv5v56ldxvautxg65rkgxpe7u94sp7gzrc'
```

### 4. Add to `.gitignore`

Ensure these are in your `.gitignore`:

```
# Age private key - NEVER commit
age-key.txt

# Decrypted secrets
firebase_service_account.json
firebase_options.dart
google-services.json
GoogleService-Info.plist
```

### 5. Add `SOPS_AGE_KEY` to GitHub Secrets

Copy the **entire contents** of `age-key.txt` (including the `# created:` and `# public key:` comment lines) and add it as a repository secret:

1. Go to your repo → **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `SOPS_AGE_KEY`
4. Value: Paste the full content of `age-key.txt`

**Reference:** See [SOPS Secrets tools documentation](../../../docs/sops_secrets/README.md) for more details.

---

## Firebase Service Account Setup

The deploy workflow uses a Firebase service account JSON file for authentication. This file is decrypted during the workflow from SOPS-encrypted storage. You need to create the service account in Google Cloud and grant it the appropriate IAM roles.

### 1. Create the Service Account

1. Open the [Google Cloud Console → Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
2. Select your Firebase project (or [switch project](https://console.cloud.google.com/projectselector2/iam-admin/serviceaccounts) if needed)
3. Click **Create Service Account**
4. Enter a name (e.g., `github-actions-deploy`)
5. Click **Create and Continue**

### 2. Assign IAM Roles

Grant roles based on what you deploy. **You need to be a project Owner** to add roles.

| Deployment Target | Required Role | Role ID |
|-------------------|---------------|---------|
| **Firebase App Distribution** (Android/iOS) | Firebase App Distribution Admin | `roles/firebaseappdistro.admin` |
| **Firebase Hosting** (Web) | Firebase Hosting Admin | `roles/firebasehosting.admin` |
| **Firebase Hosting** (Web) | API Keys Viewer *(required for Firebase CLI deploy)* | `roles/serviceusage.apiKeysViewer` |
| **Firebase Functions** | Cloud Functions Admin | `roles/cloudfunctions.admin` |
| **Firestore rules** | Firebase Admin or custom role with `firebaserules.*` | `roles/firebase.admin` or custom |
| **Storage rules** | Storage Admin | `roles/storage.admin` |

**Minimum setup for typical deployments:**

- **Android/iOS only:** Add `Firebase App Distribution Admin`
- **Web only:** Add `Firebase Hosting Admin` + `API Keys Viewer`  
- **Web + Functions:** Add `Firebase Hosting Admin` + `API Keys Viewer` + `Cloud Functions Admin`
- **Full deployment:** Add all roles listed above

**Links:**
- [Firebase App Distribution – Authenticate with service account](https://firebase.google.com/docs/app-distribution/authenticate-service-account?platform=ios)
- [Firebase product-level predefined roles](https://firebase.google.com/docs/projects/iam/roles-predefined-product)
- [Firebase App Distribution IAM roles](https://cloud.google.com/iam/docs/roles-permissions/firebaseappdistro)
- [Firebase Hosting IAM roles](https://docs.cloud.google.com/iam/docs/roles-permissions/firebasehosting)

### 3. Enable Firebase App Distribution API (if using Android/iOS)

If your app was created **before September 20, 2019**, enable the API:

1. Go to [Firebase App Distribution API](https://console.developers.google.com/apis/api/firebaseappdistribution.googleapis.com/overview)
2. Select your project
3. Click **Enable**

### 4. Create and Download the JSON Key

1. In the Service Accounts list, click the service account you created
2. Go to the **Keys** tab
3. Click **Add key** → **Create new key**
4. Choose **JSON**
5. Click **Create** — the key file will download

**Security:** Keep this file secure. It grants full access to the services you configured. Store it encrypted with SOPS (see below).

### 5. Encrypt and Store the Service Account File

Place the downloaded JSON file in your repository root as `firebase_service_account.json`, then encrypt it with SOPS (see [Encrypting Secrets](#encrypting-secrets)) so it can be decrypted during CI/CD.

---

## Encrypting Secrets

Secrets are encrypted with SOPS and stored in the `secrets/` directory. The deploy workflow decrypts them at runtime using `SOPS_AGE_KEY`.

### 1. Create `scripts/secrets-config.txt`

Create a configuration file listing files to encrypt/decrypt:

```
# Format: |filename|directory|
# Use . for repository root

|firebase_service_account.json|.|
|lib/firebase_options.dart|lib|
```

### 2. Encrypt Files

From your repository root:

```bash
# Ensure SOPS and age are installed
# Set your age key for encryption (use the private key)
export SOPS_AGE_KEY=$(cat age-key.txt)

# Run the encrypt script (from flutter_platform_kit)
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/encrypt-secrets.sh | bash
```

This creates `secrets/firebase_service_account.json.enc`, `secrets/lib/firebase_options.dart.enc`, etc. **Commit these encrypted files** to git — they are safe to store in version control.

### 3. Configure `deploy-config.json` to Verify

Add `verify_files` under `sops` in your `.github/deploy-config.json` so the workflow fails fast if decryption fails:

```json
{
  "sops": {
    "verify_files": [
      "lib/firebase_options.dart",
      "firebase_service_account.json"
    ]
  }
}
```

---

## GitHub Secrets Configuration

| Secret | Description | Required |
|--------|-------------|----------|
| `SOPS_AGE_KEY` | The full contents of your `age-key.txt` (age private key) | **Yes** |

Your workflow must pass secrets to the reusable workflow:

```yaml
jobs:
  deploy:
    uses: Anyhoosolutions/flutter_platform_kit/.github/workflows/reusable-full-deploy.yml@main
    with:
      version: ${{ inputs.version }}
      # ... other inputs
    secrets: inherit
```

The `secrets: inherit` passes `SOPS_AGE_KEY` from your repository secrets to the workflow.

---

## Verification

### Local decryption test

```bash
# Set age key
export SOPS_AGE_KEY=$(cat age-key.txt)

# Decrypt (from your app repo)
curl -sSL https://raw.githubusercontent.com/Anyhoosolutions/flutter_platform_kit/main/tools/sops_secrets/decrypt-secrets.sh | bash

# Verify files exist
ls -la firebase_service_account.json lib/firebase_options.dart
```

### Workflow check

1. Go to Actions → your Deploy workflow
2. Run workflow with a test version
3. The "Setup SOPS and decrypt secrets" step should succeed
4. If it fails with "Failed to decrypt", verify:
   - `SOPS_AGE_KEY` matches the key used to encrypt the files
   - `.sops.yaml` contains the correct public key
   - `scripts/secrets-config.txt` matches the encrypted file paths

---

## Quick Reference

| Item | Location |
|------|----------|
| Age key generation | `age-keygen -o age-key.txt` |
| SOPS tools docs | [docs/sops_secrets/README.md](../../../docs/sops_secrets/README.md) |
| Firebase App Distribution auth | [firebase.google.com/docs/app-distribution/authenticate-service-account](https://firebase.google.com/docs/app-distribution/authenticate-service-account?platform=ios) |
| Firebase IAM roles | [firebase.google.com/docs/projects/iam/roles-predefined-product](https://firebase.google.com/docs/projects/iam/roles-predefined-product) |
| Google Cloud Service Accounts | [console.cloud.google.com/iam-admin/serviceaccounts](https://console.cloud.google.com/iam-admin/serviceaccounts) |
