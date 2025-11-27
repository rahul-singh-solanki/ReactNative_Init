# Project Structure Documentation

This document explains the modular structure of the React Native setup script.

## Directory Structure

```
rn_init/
├── setup.sh                    # Main entry point
├── lib/                        # Reusable shell modules
│   ├── utils.sh               # Utility functions (logging, helpers)
│   ├── install-deps.sh        # Dependency installation logic
│   └── configure.sh           # Configuration file setup logic
├── templates/                  # Template files for project setup
│   ├── config/                # Configuration templates
│   │   ├── babel.config.js
│   │   ├── eslintrc.js
│   │   ├── prettierrc.js
│   │   ├── tsconfig.json
│   │   ├── react-native.config.js
│   │   └── index.js
│   ├── redux/                 # Redux setup templates
│   │   ├── userSlice.ts
│   │   ├── store-index.ts
│   │   ├── useAppSelector.ts
│   │   └── useAppDispatch.ts
│   ├── axios/                 # Axios API configuration templates
│   │   ├── axiosConfig.ts
│   │   ├── axiosEnv.ts
│   │   ├── axiosService.ts
│   │   └── axiosResponseType.d.ts
│   └── project-README.md      # Project README template
└── README.md                   # This repository's documentation
```

## Module Breakdown

### 1. `setup.sh` - Main Entry Point

The main script that orchestrates the entire setup process. It:
- Sources all library modules
- Handles command-line arguments (`init`, `install`, `help`)
- Coordinates the React Native project creation
- Calls functions from the modules to perform setup tasks

**Key Functions:**
- `do_init()`: Creates and sets up a new React Native project
- `do_install()`: Installs the script globally as `rn-setup`
- `usage()`: Displays help information

### 2. `lib/utils.sh` - Utility Functions

Contains reusable helper functions used throughout the setup process.

**Logging Functions:**
- `log_info()` - Information messages with ℹ️
- `log_success()` - Success messages with ✅
- `log_warning()` - Warning messages with ⚠️
- `log_error()` - Error messages with ❌
- `log_step()` - Step messages with 📝
- `log_rocket()` - Rocket messages with 🚀
- `log_package()` - Package messages with 📦
- `log_folder()` - Folder messages with 📁
- `log_phone()` - Phone messages with 📱
- `log_tools()` - Tools messages with 🛠
- `log_party()` - Party messages with 🎉
- `log_arrow()` - Arrow messages with 👉
- `log_art()` - Art messages with 🎨

**Helper Functions:**
- `get_script_dir()` - Returns the script's directory path
- `command_exists()` - Checks if a command is available
- `copy_template()` - Copies a template file to destination
- `create_folder_structure()` - Creates the src/ directory structure
- `move_app_file()` - Moves App.tsx/App.js to src/
- `install_pods()` - Installs iOS CocoaPods dependencies

### 3. `lib/install-deps.sh` - Dependency Installation

Manages all npm/yarn package installations, organized by category.

**Functions:**
- `install_navigation_deps()` - Installs React Navigation and related packages
  - @react-navigation/native
  - @react-navigation/stack
  - react-native-screens
  - react-native-safe-area-context
  - react-native-gesture-handler
  - react-native-reanimated
  - react-native-worklets

- `install_state_management_deps()` - Installs state management libraries
  - @reduxjs/toolkit
  - react-redux
  - @tanstack/react-query

- `install_utility_deps()` - Installs utility packages
  - axios
  - react-native-size-matters
  - @d11/react-native-fast-image

- `install_dev_deps()` - Installs development dependencies
  - babel-plugin-module-resolver

- `install_all_deps()` - Orchestrates all dependency installations

### 4. `lib/configure.sh` - Configuration Setup

Handles all configuration file creation and setup tasks.

**Functions:**
- `configure_index_js()` - Sets up the main index.js entry point
- `configure_eslint()` - Creates .eslintrc.js with linting rules
- `configure_prettier()` - Creates .prettierrc.js with formatting rules
- `configure_typescript()` - Creates tsconfig.json with path aliases
- `configure_babel()` - Creates babel.config.js with plugins
- `configure_rn_config()` - Creates react-native.config.js for React Native configuration
- `setup_redux_store()` - Creates Redux store and slice files
- `setup_redux_hooks()` - Creates typed Redux hooks (useAppSelector, useAppDispatch)
- `setup_axios_config()` - Creates axios configuration and service files with proper directory structure
  - Creates `src/api/config/` for configuration files
  - Creates `src/api/services/` for service layer
  - Creates `src/api/types/` for type definitions
  - Organizes axios setup by concern
- `setup_project_readme()` - Copies the project README template
- `configure_all()` - Runs all configuration tasks

### 5. `templates/` Directory

Contains all template files that are copied into new projects.

#### `templates/config/`
- **babel.config.js** - Babel configuration with module resolver and worklets plugin
- **eslintrc.js** - ESLint rules (no semicolons, spacing preferences)
- **prettierrc.js** - Prettier formatting rules
- **tsconfig.json** - TypeScript configuration with path aliases
- **index.js** - Main app entry point
- **react-native.config.js** - React Native CLI configuration

#### `templates/redux/`
- **userSlice.ts** - Example Redux slice for user state
- **store-index.ts** - Redux store configuration
- **useAppSelector.ts** - Typed useSelector hook
- **useAppDispatch.ts** - Typed useDispatch hook

#### `templates/axios/`
- **axiosConfig.ts** - Main axios instance configuration
- **axiosEnv.ts** - Environment-specific axios settings
- **axiosService.ts** - Service layer with request/response handling
- **axiosResponseType.d.ts** - TypeScript type definitions for API responses

#### `templates/project-README.md`
- Template for the generated project's README with setup instructions and folder structure documentation

## Benefits of Modular Structure

### 1. **Maintainability**
- Each module has a single responsibility
- Easy to locate and update specific functionality
- Changes to one module don't affect others

### 2. **Reusability**
- Functions can be reused across different parts of the script
- Template files can be updated independently
- Logging functions provide consistent output format

### 3. **Testability**
- Individual modules can be tested separately
- Easier to debug specific functionality
- Can mock or replace modules for testing

### 4. **Scalability**
- Easy to add new dependencies in `install-deps.sh`
- Simple to add new configuration files in `configure.sh`
- Can extend with new modules without touching main script

### 5. **Readability**
- Main setup.sh is clean and easy to understand
- Logic is organized by purpose
- Template files show exact content being generated

## How to Extend

### Adding New Dependencies

Edit `lib/install-deps.sh` and add a new function or extend existing ones:

```bash
install_ui_library_deps() {
  log_package "Installing UI library dependencies..."
  yarn add react-native-paper
  yarn add react-native-vector-icons
}
```

Then call it in `install_all_deps()`.

### Adding New Configuration Files

1. Create the template in `templates/config/yourfile.ext`
2. Add a function in `lib/configure.sh`:

```bash
configure_your_file() {
  log_step "Writing yourfile.ext..."
  copy_template "config/yourfile.ext" "yourfile.ext"
}
```

3. Call it in `configure_all()`.

### Adding New Templates

Simply add files to the appropriate template directory:
- Configuration files → `templates/config/`
- Redux/State files → `templates/redux/`
- Other templates → `templates/`

### Customizing Logging

Modify or add new logging functions in `lib/utils.sh`:

```bash
log_custom() {
  echo "🎯 $1"
}
```

## Usage Examples

### Basic Setup
```bash
./setup.sh init MyNewApp
```

### Global Installation
```bash
./setup.sh install
rn-setup init MyNewApp
```

### Testing Specific Module

You can source and test individual modules:

```bash
source lib/utils.sh
log_success "Testing logging function"
```

## Migration from Monolithic Script

The original `setup.sh.backup` contained all logic in a single file. The refactored version:

1. **Extracted repetitive logging** into reusable functions
2. **Separated concerns** into dedicated modules
3. **Moved inline heredocs** to template files
4. **Organized dependencies** into logical groups
5. **Simplified main script** to orchestration logic only

This makes the codebase more professional, maintainable, and easier to collaborate on.

## Troubleshooting

If you encounter issues with the modular setup:

1. **Module not found errors**: Ensure you're running `setup.sh` from its directory or that paths are correct
2. **Permission errors**: Make sure all `.sh` files are executable (`chmod +x lib/*.sh`)
3. **Template not found**: Verify template files exist in the correct `templates/` subdirectories
4. **Function not found**: Check that modules are properly sourced at the top of `setup.sh`

## Contributing

When contributing to this project:

1. Keep modules focused on a single responsibility
2. Use the logging functions for consistent output
3. Add new templates to appropriate directories
4. Document new functions with comments
5. Test individual modules before integrating
6. Update this documentation when adding major features
