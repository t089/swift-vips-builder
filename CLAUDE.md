# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository contains a Dockerfile that builds Docker images for Swift development with libvips and various image processing dependencies. The images are designed to provide a complete environment for Swift projects that need advanced image processing capabilities.

## Build and Push Workflow

The GitHub Actions workflow (`.github/workflows/build-and-push.yml`) uses Hetzner Cloud self-hosted runners to build native AMD64 and ARM64 images separately, then creates multi-arch manifests. This approach is much faster than emulated multi-arch builds.

### Hetzner Cloud Setup
Before using the workflow, you need to configure secrets as described in `HETZNER_SETUP.md`:
- `PERSONAL_ACCESS_TOKEN`: GitHub PAT with repository administration access
- `HCLOUD_TOKEN`: Hetzner Cloud API token with read/write permissions

### Available Version Combinations
- Swift versions: 6.1.2, 6.0.3
- libvips versions: 8.15.5, 8.16.1, 8.17.1

Images are tagged as: `ghcr.io/t089/swift-docker-builder:swift-{swift-version}-vips-{vips-version}`

## Common Commands

### Build Docker image locally
```bash
docker build --build-arg SWIFT_VERSION=6.1.2 --build-arg VIPS_VERSION=8.16.0 -t swift-vips .
```

### Run workflow manually
The workflow can be triggered manually via GitHub Actions UI or automatically on pushes to main branch.

## Architecture

The Dockerfile:
1. Uses official Swift Docker images as base (Ubuntu Noble)
2. Builds the following libraries from source:
   - libjxl (JPEG XL support)
   - libjasper (JPEG 2000 support)
   - LibRaw (RAW image format support)
   - libvips (main image processing library)
3. Configures environment variables for proper library linking
4. Uses meson build system for libvips and CMake for dependencies

The build process is optimized for multi-platform support (linux/amd64 and linux/arm64) using Docker Buildx.