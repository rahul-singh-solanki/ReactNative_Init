#!/bin/bash

# Configuration file setup module

# Source utilities
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/lib/utils.sh"

# Configure index.js
configure_index_js() {
  log_step "Replacing index.js..."
  copy_template "config/index.js" "index.js"
}

# Configure ESLint
configure_eslint() {
  log_step "Writing .eslintrc.js..."
  copy_template "config/eslintrc.js" ".eslintrc.js"
}

# Configure Prettier
configure_prettier() {
  log_step "Writing .prettierrc.js..."
  copy_template "config/prettierrc.js" ".prettierrc.js"
}

# Configure TypeScript
configure_typescript() {
  log_step "Writing tsconfig.json..."
  copy_template "config/tsconfig.json" "tsconfig.json"
}

# Configure Babel
configure_babel() {
  log_step "Writing babel.config.js..."
  copy_template "config/babel.config.js" "babel.config.js"
}

# Configure React Native Config
configure_rn_config() {
  log_step "Writing react-native.config.js..."
  copy_template "config/react-native.config.js" "react-native.config.js"
}

# Setup Redux Store
setup_redux_store() {
  log_info "Configuring Redux Store..."
  mkdir -p src/store/slices
  
  # Copy userSlice
  copy_template "redux/userSlice.ts" "src/store/slices/userSlice.ts"
  
  # Copy store index
  copy_template "redux/store-index.ts" "src/store/index.ts"
  
  log_success "Redux store configured."
}

# Setup Redux Hooks
setup_redux_hooks() {
  log_info "Configuring Redux Hooks..."
  
  # Copy useAppSelector
  copy_template "redux/useAppSelector.ts" "src/hooks/useAppSelector.ts"
  
  # Copy useAppDispatch
  copy_template "redux/useAppDispatch.ts" "src/hooks/useAppDispatch.ts"
  
  log_success "Redux hooks configured."
}

# Setup Axios API Configuration
setup_axios_config() {
  log_info "Configuring Axios API..."
  
  # Create API directories
  mkdir -p src/api/{config,services,types}
  
  # Copy axios configuration files
  copy_template "axios/axiosConfig.ts" "src/api/config/axios.ts"
  copy_template "axios/axiosEnv.ts" "src/api/config/env.ts"
  
  # Copy axios service
  copy_template "axios/axiosService.ts" "src/api/services/auth.ts"
  
  # Copy axios types
  copy_template "axios/axiosResponseType.d.ts" "src/api/types/api.d.ts"
  
  log_success "Axios API configuration completed."
}

# Setup project README
setup_project_readme() {
  log_art "Adding Default README.md ..."
  copy_template "project-README.md" "README.md"
}

# Run all configuration tasks
configure_all() {
  configure_index_js
  configure_eslint
  configure_prettier
  configure_typescript
  configure_babel
  configure_rn_config
  setup_redux_store
  setup_redux_hooks
  setup_axios_config
  setup_project_readme
  log_success "All configuration files created successfully."
}
