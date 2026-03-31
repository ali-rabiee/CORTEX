#!/bin/bash
# CORTEX — Ubuntu Setup Script
# Run with: bash scripts/setup_ubuntu.sh

set -e

echo "=== CORTEX Setup for Ubuntu ==="
echo ""

# 1. System dependencies for Flutter Linux desktop
echo "--- Installing system dependencies ---"
sudo apt update
sudo apt install -y \
  clang cmake git ninja-build pkg-config \
  libgtk-3-dev liblzma-dev libstdc++-12-dev \
  mesa-utils

# 2. Verify Flutter
echo ""
echo "--- Checking Flutter ---"
if ! command -v flutter &> /dev/null; then
  echo "ERROR: Flutter not found. Install Flutter first:"
  echo "  sudo snap install flutter --classic"
  exit 1
fi
flutter config --enable-linux-desktop
flutter doctor

# 3. Set up Flutter app
echo ""
echo "--- Setting up Flutter app ---"
cd app
flutter pub get
echo "Running build_runner for code generation..."
dart run build_runner build --delete-conflicting-outputs
cd ..

# 4. Set up conda environment
echo ""
echo "--- Setting up conda environment ---"
if command -v conda &> /dev/null; then
  conda env create -f environment.yml || echo "Conda env 'cortex' may already exist"
  echo "Activate with: conda activate cortex"
else
  echo "WARNING: conda not found. Install miniforge/miniconda for Python backend."
fi

echo ""
echo "=== Setup complete ==="
echo "Run the app: cd app && flutter run -d linux"
echo "Run backend: conda activate cortex && cd backend && uvicorn main:app --reload"
