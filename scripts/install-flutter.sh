#!/bin/bash
set -e

echo "=== Installing Flutter SDK for Vercel Build ==="

# Fix git safe.directory issue on Vercel
git config --global --add safe.directory '*'

# Flutter version to install
FLUTTER_VERSION="3.27.0"

# Install Flutter in a temporary location
export FLUTTER_HOME="$HOME/flutter"
export PATH="$FLUTTER_HOME/bin:$PATH"

if [ ! -d "$FLUTTER_HOME" ]; then
  echo "Downloading Flutter SDK v${FLUTTER_VERSION}..."
  curl -sL "https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz" -o flutter.tar.xz
  tar xf flutter.tar.xz -C "$HOME"
  rm flutter.tar.xz
else
  echo "Flutter SDK already cached"
fi

# Verify installation
flutter --version

# Get dependencies
echo "Installing dependencies..."
flutter pub get

# Build for web with environment variables
echo "Building Flutter web release..."
flutter build web --release \
  --dart-define=EMAILJS_SERVICE_ID="${EMAILJS_SERVICE_ID:-}" \
  --dart-define=EMAILJS_TEMPLATE_ID="${EMAILJS_TEMPLATE_ID:-}" \
  --dart-define=EMAILJS_PUBLIC_KEY="${EMAILJS_PUBLIC_KEY:-}" \
  --web-renderer html \
  --base-href "/"

echo "=== Flutter build completed successfully ==="
ls -la build/web/
