# Quick Reference Guide

## 🚀 Quick Start

```bash
# Run locally
./setup.sh init MyApp

# Install globally
./setup.sh install
rn-setup init MyApp
```

## 📁 File Locations

| What You Want to Modify | File Location |
|------------------------|---------------|
| ESLint rules | `templates/config/eslintrc.js` |
| Prettier formatting | `templates/config/prettierrc.js` |
| TypeScript config | `templates/config/tsconfig.json` |
| Babel plugins | `templates/config/babel.config.js` |
| React Native CLI config | `templates/config/react-native.config.js` |
| App entry point | `templates/config/index.js` |
| Redux example slice | `templates/redux/userSlice.ts` |
| Redux store setup | `templates/redux/store-index.ts` |
| Redux hooks | `templates/redux/useAppSelector.ts`<br>`templates/redux/useAppDispatch.ts` |
| Axios configuration | `templates/axios/axiosConfig.ts` |
| Axios environment settings | `templates/axios/axiosEnv.ts` |
| Axios service layer | `templates/axios/axiosService.ts` |
| Axios types | `templates/axios/axiosResponseType.d.ts` |
| Project README | `templates/project-README.md` |
| Package list | `lib/install-deps.sh` |
| Logging/utilities | `lib/utils.sh` |
| Config logic | `lib/configure.sh` |

## 🔧 Common Modifications

### Add a New Dependency

Edit `lib/install-deps.sh`:

```bash
# Add to appropriate function or create new one
install_ui_deps() {
  log_package "Installing UI dependencies..."
  yarn add react-native-paper
}

# Then add to install_all_deps()
install_all_deps() {
  install_navigation_deps
  install_state_management_deps
  install_utility_deps
  install_ui_deps  # <-- Add here
  install_dev_deps
}
```

### Add a New Configuration File

1. Create template: `templates/config/myconfig.json`
2. Edit `lib/configure.sh`:

```bash
configure_myconfig() {
  log_step "Writing myconfig.json..."
  copy_template "config/myconfig.json" "myconfig.json"
}

# Add to configure_all()
configure_all() {
  configure_index_js
  configure_eslint
  # ... other configs
  configure_myconfig  # <-- Add here
}
```

### Modify ESLint Rules

Edit `templates/config/eslintrc.js`:

```javascript
module.exports = {
  root: true,
  extends: '@react-native',
  rules: {
    "semi": ["error", "never"],
    "object-curly-spacing": ["error", "always"],
    "array-bracket-spacing": ["error", "never"],
    "your-new-rule": ["error", "value"],  // <-- Add here
  }
}
```

### Change Folder Structure

Edit `lib/utils.sh`:

```bash
create_folder_structure() {
  log_folder "Creating folder structure..."
  mkdir -p src/{components,store,utils,screens,assets,api,hooks,navigator,types}
  mkdir -p src/store/slices
  mkdir -p src/theme  # <-- Add new folder
}
```

### Add Custom Logging

Edit `lib/utils.sh`:

```bash
log_custom() {
  echo "🎯 $1"
}
```

## 📝 Logging Functions Reference

| Function | Emoji | Use Case |
|----------|-------|----------|
| `log_info()` | ℹ️ | General information |
| `log_success()` | ✅ | Successful completion |
| `log_warning()` | ⚠️ | Warnings |
| `log_error()` | ❌ | Errors |
| `log_step()` | 📝 | Step description |
| `log_rocket()` | 🚀 | Starting process |
| `log_package()` | 📦 | Package operations |
| `log_folder()` | 📁 | Directory operations |
| `log_phone()` | 📱 | iOS operations |
| `log_tools()` | 🛠 | Dev tools |
| `log_party()` | 🎉 | Completion |
| `log_arrow()` | 👉 | Next steps |
| `log_art()` | 🎨 | Creative operations |

## 🧪 Testing Changes

```bash
# Test specific module (bash)
source lib/utils.sh
log_success "Testing logging"

# Test dependency installation
source lib/install-deps.sh
# install_navigation_deps  # Don't run unless in project

# Test the full script
./setup.sh init TestProject
```

## 🔍 Debugging

```bash
# Enable bash debugging
bash -x setup.sh init TestProject

# Check if modules are sourced correctly
bash -c "source lib/utils.sh && log_success 'Works!'"

# Verify template exists
ls -la templates/config/
ls -la templates/redux/

# Check permissions
ls -la setup.sh lib/*.sh
```

## 📦 What Gets Installed

### Navigation (8 packages)
- @react-navigation/native
- @react-navigation/stack
- react-native-screens
- react-native-safe-area-context
- react-native-gesture-handler
- react-native-reanimated
- react-native-worklets

### State Management (3 packages)
- @reduxjs/toolkit
- react-redux
- @tanstack/react-query

### Utilities (3 packages)
- axios
- react-native-size-matters
- @d11/react-native-fast-image

### Dev Dependencies (1 package)
- babel-plugin-module-resolver

**Total: 15 packages**

## 📄 What Gets Configured

### Configuration Files
- ✅ index.js (app entry)
- ✅ .eslintrc.js
- ✅ .prettierrc.js
- ✅ tsconfig.json
- ✅ babel.config.js
- ✅ react-native.config.js

### Redux Setup
- ✅ src/store/index.ts
- ✅ src/store/slices/userSlice.ts
- ✅ src/hooks/useAppSelector.ts
- ✅ src/hooks/useAppDispatch.ts

### Axios API Configuration
- ✅ src/api/config/axiosConfig.ts
- ✅ src/api/config/axiosEnv.ts
- ✅ src/api/services/axiosService.ts
- ✅ src/api/types/axiosResponseType.d.ts

### Documentation
- ✅ README.md (project-specific)

### Folder Structure
```
src/
├── api/
│   ├── config/
│   ├── services/
│   └── types/
├── components/
├── screens/
├── navigator/
├── hooks/
├── store/
│   └── slices/
├── utils/
├── types/
└── assets/
    ├── config/
    ├── services/
    └── types/
```

## ⚡ Command Reference

| Command | Description |
|---------|-------------|
| `./setup.sh init <Name>` | Create new project |
| `./setup.sh install` | Install globally |
| `./setup.sh help` | Show help |
| `rn-setup init <Name>` | Run after global install |

## 🛠️ Maintenance Tasks

### Update All Dependencies
Edit `lib/install-deps.sh` and update package names/versions

### Update Configuration Templates
Edit files in `templates/config/` and `templates/redux/`

### Update Generated README
Edit `templates/project-README.md`

### Add New Module
1. Create `lib/new-module.sh`
2. Add functions
3. Source in `setup.sh`: `source "$SCRIPT_DIR/lib/new-module.sh"`
4. Call functions in `do_init()`

## 📚 Documentation Files

| File | Purpose |
|------|---------|
| README.md | User documentation |
| STRUCTURE.md | Developer documentation |
| ARCHITECTURE.md | Visual diagrams |
| REFACTORING_SUMMARY.md | Migration notes |
| QUICK_REFERENCE.md | This file |

## 🎯 Best Practices

1. **Always test** after modifications
2. **Use logging functions** for output
3. **Keep modules focused** on one responsibility
4. **Update templates** instead of inline heredocs
5. **Document changes** in appropriate files
6. **Maintain backward compatibility**
7. **Version control** your changes

## 🚨 Common Issues

### Module not found
```bash
# Solution: Check paths and ensure sourcing is correct
source "$SCRIPT_DIR/lib/utils.sh"
```

### Template not found
```bash
# Solution: Verify template exists
ls -la templates/config/yourfile
```

### Permission denied
```bash
# Solution: Make scripts executable
chmod +x setup.sh lib/*.sh
```

### Function not defined
```bash
# Solution: Ensure module is sourced before use
source lib/utils.sh
log_success "Now it works"
```

## 💡 Tips

- Use `setup.sh.backup` as reference for original code
- Test in a separate directory before committing
- Keep templates simple and focused
- Use descriptive function names
- Comment complex logic
- Leverage existing utility functions

## 📞 Need Help?

1. Read [STRUCTURE.md](STRUCTURE.md) for detailed architecture
2. Check [ARCHITECTURE.md](ARCHITECTURE.md) for visual diagrams
3. Review [REFACTORING_SUMMARY.md](REFACTORING_SUMMARY.md) for context
4. Compare with `setup.sh.backup` for original implementation
