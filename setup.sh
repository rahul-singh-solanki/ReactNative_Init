#!/bin/bash

set -euo pipefail

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions and modules
source "$SCRIPT_DIR/lib/utils.sh"
source "$SCRIPT_DIR/lib/install-deps.sh"
source "$SCRIPT_DIR/lib/configure.sh"

# Name used for global install
GLOBAL_NAME="rn-setup"
TARGET_DIR="/usr/local/bin"
TARGET_PATH="$TARGET_DIR/$GLOBAL_NAME"

usage() {
  cat <<USAGE
Usage:
  $0 init <ProjectName>     Create project '<ProjectName>' and run full setup
  $0 install                Install this script globally as '$GLOBAL_NAME'
  $0 help                   Show this help
Examples:
  ./setup.sh init DemoApp
  ./setup.sh install
  rn-setup init DemoApp     # after running install
USAGE
  exit 1
}

# ---------- Core setup function ----------
do_init() {
  if [ -z "${1:-}" ]; then
    log_error "Error: Please provide a project name."
    log_arrow "Usage: $0 init MyProject"
    exit 1
  fi

  PROJECT_NAME="$1"
  log_rocket "Creating React Native project: $PROJECT_NAME..."

  # Create React Native App
  npx @react-native-community/cli@latest init "$PROJECT_NAME" --install-pods true

  log_success "Project created successfully."

  cd "$PROJECT_NAME"

  # Install all dependencies using the module
  install_all_deps

  # Install iOS pods
  install_pods

  # Create folder structure
  create_folder_structure

  # Move App file to src
  move_app_file

  # Configure all files using the module
  configure_all

  log_party "Setup complete for project: $PROJECT_NAME"
  log_arrow "Next steps:"
  echo "   cd $PROJECT_NAME"
  echo "   npx react-native run-ios  OR  npx react-native run-android"
}

# ---------- Install script globally ----------
do_install() {
  # Identify absolute path to this script
  SCRIPT_PATH="$(command -v "$0" || echo "$0")"

  # If $0 is not an absolute path, try to expand
  if [ ! -f "$SCRIPT_PATH" ]; then
    # maybe running via relative path
    SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"
  fi

  if [ ! -f "$SCRIPT_PATH" ]; then
    log_error "Unable to locate the script file to install."
    echo "Run: sudo cp ./setup.sh $TARGET_PATH && sudo chmod +x $TARGET_PATH"
    exit 1
  fi

  echo "📥 Installing script as global command '$GLOBAL_NAME'..."

  # Ensure target dir exists
  if [ ! -d "$TARGET_DIR" ]; then
    echo "🔧 Creating $TARGET_DIR..."
    if ! mkdir -p "$TARGET_DIR"; then
      log_warning "Could not create $TARGET_DIR. Trying with sudo..."
      sudo mkdir -p "$TARGET_DIR"
    fi
  fi

  # Copy with fallback to sudo if permission denied
  if cp "$SCRIPT_PATH" "$TARGET_PATH" 2>/dev/null; then
    chmod +x "$TARGET_PATH"
    log_success "Installed to $TARGET_PATH"
  else
    log_warning "Permission denied while copying to $TARGET_PATH. Trying with sudo..."
    sudo cp "$SCRIPT_PATH" "$TARGET_PATH"
    sudo chmod +x "$TARGET_PATH"
    log_success "Installed to $TARGET_PATH (via sudo)"
  fi

  echo "You can now run: $GLOBAL_NAME init <ProjectName>"
}

# ---------- Main CLI ----------
if [ "${1:-}" = "help" ] || [ "${1:-}" = "" ]; then
  usage
fi

COMMAND="$1"
shift || true

case "$COMMAND" in
  init)
    do_init "$@"
    ;;
  install)
    do_install
    ;;
  *)
    log_error "Unknown command: $COMMAND"
    usage
    ;;
esac