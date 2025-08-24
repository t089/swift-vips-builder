# swift-vips-builder

Docker images for Swift development with libvips and image processing libraries.

## Available Images

Pre-built images are available at `ghcr.io/t089/swift-docker-builder` with combinations of:
- Swift: 6.1.2, 6.0.3
- libvips: 8.15.5, 8.16.1, 8.17.1

Example: `ghcr.io/t089/swift-docker-builder:swift-6.1.2-vips-8.16.1`

## What's Included

- libvips with meson build
- libjxl (JPEG XL)
- libjasper (JPEG 2000)
- LibRaw (RAW formats)
- Standard image libraries (PNG, JPEG, WebP, TIFF, HEIF)

## Usage

```dockerfile
FROM ghcr.io/t089/swift-docker-builder:swift-6.1.2-vips-8.16.1
# Your Swift app here
```

## Build Locally

```bash
docker build --build-arg SWIFT_VERSION=6.1.2 --build-arg VIPS_VERSION=8.16.1 -t swift-vips .
```