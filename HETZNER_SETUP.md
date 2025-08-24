# Hetzner Cloud Setup for GitHub Actions

This guide explains how to set up the required secrets for using Hetzner Cloud self-hosted runners.

## Required Secrets

You need to add two secrets to your GitHub repository:

### 1. GitHub Personal Access Token (PAT)

1. Go to [GitHub Settings > Personal access tokens > Fine-grained tokens](https://github.com/settings/personal-access-tokens/new)
2. Create a new token with:
   - **Repository access**: Select this repository
   - **Permissions**: Repository permissions > Administration > Read and write
   - **Expiration**: Set according to your needs
3. Copy the generated token

### 2. Hetzner Cloud API Token

1. Log in to [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. Select your project (or create a new one)
3. Go to Security → API Tokens
4. Generate new token with **Read & Write** permissions
5. Copy the generated token

## Add Secrets to GitHub Repository

1. Go to your repository on GitHub
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Add the following secrets:
   - **Name**: `PERSONAL_ACCESS_TOKEN`  
     **Value**: Your GitHub PAT from step 1
   - **Name**: `HCLOUD_TOKEN`  
     **Value**: Your Hetzner Cloud API token from step 2

## Cost Estimates

With the current configuration using:
- `cpx31` (4 vCPU, 8GB RAM) for AMD64: ~€0.013/hour
- `cax21` (4 vCPU, 8GB RAM) for ARM64: ~€0.012/hour

Building 6 version combinations (2 architectures each) will cost approximately €0.30-0.50 per workflow run, depending on build times.

## Server Types Reference

If you need different performance characteristics:

**AMD64 Options:**
- `cpx21`: 3 vCPU, 4GB RAM (€0.008/hr) - Slower but cheaper
- `cpx31`: 4 vCPU, 8GB RAM (€0.013/hr) - Current choice
- `cpx41`: 8 vCPU, 16GB RAM (€0.025/hr) - Faster builds

**ARM64 Options:**
- `cax11`: 2 vCPU, 4GB RAM (€0.007/hr) - Slower but cheaper
- `cax21`: 4 vCPU, 8GB RAM (€0.012/hr) - Current choice
- `cax31`: 8 vCPU, 16GB RAM (€0.023/hr) - Faster builds