# React Native Project Setup Script

A comprehensive bash script to bootstrap React Native projects with a pre-configured tech stack including navigation, state management, and code organization best practices.

## Features

- 🚀 Creates a new React Native project with automatic pod installation
- 📦 Installs essential dependencies (Navigation, State Management, etc.)
- 📁 Sets up organized folder structure
- ⚙️ Configures Babel, ESLint, Prettier, and TypeScript
- 🔧 Sets up path aliases for cleaner imports
- 🌍 Can be installed globally for easy reuse

## Quick Start

### Option 1: Run Locally

```bash
chmod +x setup.sh
./setup.sh init MyAwesomeApp
```

### Option 2: Install Globally

```bash
chmod +x setup.sh
./setup.sh install
rn-setup init MyAwesomeApp
```

## Commands

### `init <ProjectName>`

Creates a new React Native project with the complete setup.

```bash
./setup.sh init DemoApp
```

This command will:
1. Create a new React Native project using the official CLI
2. Install all dependencies
3. Set up the folder structure
4. Configure all config files
5. Install iOS pods (if on macOS)

### `install`

Installs the script globally as `rn-setup` command.

```bash
./setup.sh install
```

After installation, you can run:
```bash
rn-setup init MyProject
```

The script will be installed to `/usr/local/bin/rn-setup`. If permission is denied, it will automatically retry with `sudo`.

### `help`

Displays usage information and examples.

```bash
./setup.sh help
```

## Installed Dependencies

### Navigation
- `@react-navigation/native` - Core navigation library
- `@react-navigation/stack` - Stack navigator
- `react-native-screens` - Native screen optimization
- `react-native-safe-area-context` - Safe area handling
- `react-native-gesture-handler` - Gesture support
- `react-native-reanimated` - Advanced animations
- `react-native-worklets` - High-performance worklets for animations

### State Management
- `@reduxjs/toolkit` - Redux state management with pre-configured store
- `react-redux` - React bindings for Redux
- `@tanstack/react-query` - Server state management

### Development Tools
- `babel-plugin-module-resolver` - Path alias support

## Folder Structure

The script creates the following organized structure:

```
src/
├── components/     # Reusable UI components
├── store/         # Redux store configuration and slices
│   ├── slices/    # Redux slices (e.g., userSlice.ts)
│   └── index.ts   # Store configuration
├── utils/         # Utility functions and helpers
├── screens/       # Screen components
├── assets/        # Images, fonts, and other static files
├── api/           # API calls and services
├── hooks/         # Custom React hooks (includes Redux hooks)
├── navigator/     # Navigation configuration
├── types/         # TypeScript type definitions
└── App.tsx        # Main application component
```

## Configuration Files

### Redux Store Setup

The script automatically configures a complete Redux store with:

**`src/store/slices/userSlice.ts`** - Example Redux slice:
```typescript
import { createSlice } from '@reduxjs/toolkit'

interface UserState {
  name: string
}

const userSlice = createSlice({
  name: 'user',
  initialState: {
    name: '',
  } as UserState,
  reducers: {
    setName(state, action) {
      state.name = action.payload
    },
  },
})
export const UserActions = userSlice.actions
export default userSlice.reducer
```

**`src/store/index.ts`** - Store configuration:
```typescript
import { configureStore } from '@reduxjs/toolkit'
import userReducer from './slices/userSlice'

const store = configureStore({
  reducer: {
    user: userReducer,
  },
})

export type RootState = ReturnType<typeof store.getState>
export type AppDispatch = typeof store.dispatch
export default store
```

**`src/hooks/useAppSelector.ts`** - Typed selector hook:
```typescript
import { useSelector } from 'react-redux'
import type { RootState } from 'store'

export const useAppSelector = useSelector.withTypes<RootState>()
```

**`src/hooks/useAppDispatch.ts`** - Typed dispatch hook:
```typescript
import { useDispatch } from 'react-redux'
import type { AppDispatch } from 'store'

export const useAppDispatch = useDispatch.withTypes<AppDispatch>()
```

### ESLint Configuration

The script sets up `.eslintrc.js` with:
- No semicolons (semi: never)
- Object curly spacing enabled
- Array bracket spacing disabled

### Prettier Configuration

The script configures `.prettierrc.js` with:
- Single quotes
- No semicolons
- Trailing commas
- Arrow function parentheses avoided
- Bracket spacing enabled

### TypeScript Configuration

The `tsconfig.json` includes:
- Path aliases for all src folders
- JSON module resolution
- Proper React Native extends

### Babel Configuration

The `babel.config.js` includes:
- Module resolver plugin for path aliases
- React Native Worklets plugin for high-performance animations

## Path Aliases

The following import aliases are configured (note: `theme` alias is available for future use):

```typescript
import Button from 'components/Button'
import { useAuth } from 'hooks/useAuth'
import { useAppSelector } from 'hooks/useAppSelector'
import { useAppDispatch } from 'hooks/useAppDispatch'
import store from 'store'
import HomeScreen from 'screens/HomeScreen'
import { formatDate } from 'utils/helpers'
import { User } from 'types/User'
import logo from 'assets/logo.png'
// import colors from 'theme/colors' // theme folder not created by default
```

Instead of:
```typescript
import Button from '../../components/Button'
import { useAuth } from '../../../hooks/useAuth'
// etc.
```

## After Setup

Once the setup is complete, navigate to your project and start developing:

```bash
cd YourProjectName

# For iOS
npx react-native run-ios

# For Android
npx react-native run-android
```

## Requirements

- Node.js and npm/yarn installed
- React Native CLI prerequisites:
  - For iOS: Xcode, CocoaPods
  - For Android: Android Studio, JDK
- macOS (for iOS development)

## Troubleshooting

### Permission Denied during Global Install

If you see permission errors during `./setup.sh install`, the script will automatically retry with `sudo`. You may be prompted for your password.

### iOS Pods Installation Fails

Make sure you have CocoaPods installed:
```bash
sudo gem install cocoapods
```

### Module Not Found Errors

If you encounter module resolution errors after setup:
1. Clear Metro bundler cache: `npx react-native start --reset-cache`
2. Clean and rebuild the project

### Reanimated Plugin Issues

The `react-native-worklets/plugin` is configured in the Babel plugins array. The script handles this automatically.

### Using Redux in Your App

After setup, wrap your app with the Redux Provider. Update `src/App.tsx`:

```typescript
import React from 'react'
import { Provider } from 'react-redux'
import store from 'store'
// your components

function App() {
  return (
    <Provider store={store}>
      {/* Your app content */}
    </Provider>
  )
}

export default App
```

Then use the typed hooks in your components:

```typescript
import { useAppSelector } from 'hooks/useAppSelector'
import { useAppDispatch } from 'hooks/useAppDispatch'
import { UserActions } from 'store/slices/userSlice'

function MyComponent() {
  const name = useAppSelector(state => state.user.name)
  const dispatch = useAppDispatch()
  
  const updateName = () => {
    dispatch(UserActions.setName('John Doe'))
  }
  
  // ...
}
```

## Customization

You can modify the `setup.sh` script to:
- Add more dependencies
- Change folder structure
- Modify linting rules
- Add additional configuration files
- Change path aliases

## License

This script is provided as-is for project initialization purposes.

## Contributing

Feel free to fork and customize this script for your team's needs.

---

**Happy Coding! 🎉**
