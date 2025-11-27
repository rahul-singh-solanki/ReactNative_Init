#!/bin/bash

# Utility functions for the setup script

# Get the script directory (where setup.sh and lib/ are located)
get_script_dir() {
  echo "$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
}

# Log functions with emojis
log_info() {
  echo "ℹ️  $1"
}

log_success() {
  echo "✅ $1"
}

log_warning() {
  echo "⚠️  $1"
}

log_error() {
  echo "❌ $1"
}

log_step() {
  echo "📝 $1"
}

log_rocket() {
  echo "🚀 $1"
}

log_package() {
  echo "📦 $1"
}

log_folder() {
  echo "📁 $1"
}

log_phone() {
  echo "📱 $1"
}

log_tools() {
  echo "🛠 $1"
}

log_party() {
  echo "🎉 $1"
}

log_arrow() {
  echo "👉 $1"
}

log_art() {
  echo "🎨 $1"
}

# Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Copy a template file to destination
copy_template() {
  local template_file="$1"
  local destination="$2"
  local script_dir
  script_dir="$(get_script_dir)"
  
  if [ -f "$script_dir/templates/$template_file" ]; then
    cp "$script_dir/templates/$template_file" "$destination"
    return 0
  else
    log_error "Template file not found: $template_file"
    return 1
  fi
}

# Create directory structure
create_folder_structure() {
  log_folder "Creating folder structure..."
  mkdir -p src/{components,store,utils,screens,assets,api,hooks,navigator,types}
  mkdir -p src/store/slices
  mkdir -p src/api/{config,services,types}
}

# Move App file to src directory
move_app_file() {
  log_package "Moving App.tsx → src/App.tsx..."
  if [ -f App.tsx ]; then
    mv App.tsx src/App.tsx
  elif [ -f App.js ]; then
    mv App.js src/App.js
    log_warning "Moved App.js (JS template). Consider converting to TypeScript if you want App.tsx."
  else
    log_warning "App.tsx/App.js not found. Skipping move."
  fi
}

# Check if iOS directory exists and run pod install
install_pods() {
  log_phone "Installing iOS pods..."
  if [ -d ios ]; then
    (cd ios && pod install)
  else
    log_warning "No ios folder found (non-iOS template?). Skipping pod install."
  fi
}
