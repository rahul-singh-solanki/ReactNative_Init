#!/bin/bash

# Dependency installation module

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Install navigation dependencies
install_navigation_deps() {
  log_package "Installing navigation dependencies..."
  yarn add \
    @react-navigation/native \
    react-native-screens \
    react-native-safe-area-context

  yarn add @react-navigation/stack

  yarn add \
    react-native-gesture-handler \
    react-native-reanimated \
    react-native-worklets
}

# Install state management dependencies
install_state_management_deps() {
  log_package "Installing state management dependencies..."
  yarn add \
    @reduxjs/toolkit \
    react-redux

  yarn add @tanstack/react-query
}

# Install utility dependencies
install_utility_deps() {
  log_package "Installing utility dependencies..."
  yarn add \
    axios \
    react-native-size-matters \
    @d11/react-native-fast-image
}

# Install dev dependencies
install_dev_deps() {
  log_tools "Installing dev dependency: babel-plugin-module-resolver"
  yarn add --dev babel-plugin-module-resolver
}

# Install all dependencies
install_all_deps() {
  log_package "Installing dependencies..."
  install_navigation_deps
  install_state_management_deps
  install_utility_deps
  install_dev_deps
  log_success "All dependencies installed successfully."
}
