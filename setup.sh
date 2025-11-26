#!/bin/bash

set -euo pipefail

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
    echo "❌ Error: Please provide a project name."
    echo "👉 Usage: $0 init MyProject"
    exit 1
  fi

  PROJECT_NAME="$1"
  echo "🚀 Creating React Native project: $PROJECT_NAME..."

  # Create React Native App
  npx @react-native-community/cli@latest init "$PROJECT_NAME" --install-pods true

  echo "✅ Project created successfully."

  cd "$PROJECT_NAME"

  # Install Dependencies
  echo "📦 Installing dependencies..."

  yarn add \
    @react-navigation/native \
    react-native-screens \
    react-native-safe-area-context

  yarn add @react-navigation/stack

  yarn add \
    react-native-gesture-handler \
    react-native-reanimated \
    react-native-worklets

  yarn add \
    @reduxjs/toolkit \
    react-redux

  yarn add @tanstack/react-query

  # Install Dev Dependencies
  echo "🛠 Installing dev dependency: babel-plugin-module-resolver"
  yarn add --dev babel-plugin-module-resolver

  # Install Pods
  echo "📱 Installing iOS pods..."
  if [ -d ios ]; then
    (cd ios && pod install)
  else
    echo "⚠️  No ios folder found (non-iOS template?). Skipping pod install."
  fi

  # Create src folder structure (store instead of redux)
  echo "📁 Creating folder structure..."
  mkdir -p src/{components,store,utils,screens,assets,api,hooks,navigator,types}
  mkdir -p src/store/slices

  echo "📦 Moving App.tsx → src/App.tsx..."
  if [ -f App.tsx ]; then
    mv App.tsx src/App.tsx
  elif [ -f App.js ]; then
    # If JS template, move App.js but leave warning
    mv App.js src/App.js
    echo "⚠️  Moved App.js (JS template). Consider converting to TypeScript if you want App.tsx."
  else
    echo "⚠️  App.tsx/App.js not found. Skipping move."
  fi

  # Replace index.js
  echo "📝 Replacing index.js..."
  cat > index.js <<'EOL'
/**
 * @format
 */

import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';

AppRegistry.registerComponent(appName, () => App);
EOL

  # Replace .eslintrc.js
  echo "📝 Writing .eslintrc.js..."
  cat > .eslintrc.js <<'EOL'
module.exports = {
  root: true,
  extends: '@react-native',
  rules: {
    "semi": ["error", "never"],
    "object-curly-spacing": ["error", "always"],
    "array-bracket-spacing": ["error", "never"],
  }
}
EOL

  # Replace .prettierrc.js
  echo "📝 Writing .prettierrc.js..."
  cat > .prettierrc.js <<'EOL'
module.exports = {
  arrowParens: 'avoid',
  singleQuote: true,
  trailingComma: 'all',
  bracketSpacing: true,
  semi: false,
  objectCurlySpacing: true,
};
EOL

  # tsconfig.json
  echo "📝 Writing tsconfig.json..."
  cat > tsconfig.json <<'EOL'
{
  "extends": "@react-native/typescript-config",
  "include": ["**/*.ts", "**/*.tsx", "**/*.json"],
  "exclude": ["**/node_modules", "**/Pods"],
  "resolveJsonModule": true,
  "compilerOptions": {
    "baseUrl": ".",
    "paths": {
      "assets/*": ["./src/assets/*"],
      "theme/*": ["./src/theme/*"],
      "hooks/*": ["./src/hooks/*"],
      "store/*": ["./src/store/*"],
      "screens/*": ["./src/screens/*"],
      "utils/*": ["./src/utils/*"],
      "types/*": ["./src/types/*"],
      "components/*": ["./src/components/*"]
    }
  }
}
EOL

  # babel.config.js (proper babel config with module-resolver + reanimated plugin)
  echo "📝 Writing babel.config.js..."
  cat > babel.config.js <<'EOL'
module.exports = {
  presets: ['module:@react-native/babel-preset'],
  plugins: [
    [
      'babel-plugin-module-resolver',
      {
        root: ['.'],
        alias: {
          assets: './src/assets/',
          theme: './src/theme/',
          hooks: './src/hooks/',
          store: './src/store/',
          screens: './src/screens/',
          utils: './src/utils/',
          types: './src/types/',
          components: './src/components/'
        }
      }
    ],
    'react-native-worklets/plugin'
  ]
};
EOL

  echo " Configuring Redux Store..."
  mkdir -p src/store
  cat > src/store/slices/userSlice.ts <<'EOL'
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
EOL

  cat > src/store/index.ts <<'EOL'
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
EOL

echo " Configuring Redux Hooks..."
  cat > src/hooks/useAppSelector.ts <<'EOL'
import { useSelector } from 'react-redux'
import type { RootState } from 'store'

export const useAppSelector = useSelector.withTypes<RootState>()
EOL

  cat > src/hooks/useAppDispatch.ts <<'EOL'
import { useDispatch } from 'react-redux'
import type { AppDispatch } from 'store'

export const useAppDispatch = useDispatch.withTypes<AppDispatch>()
EOL

echo "✅ Redux setup completed."

echo "🎨 Adding Default README.md ..."
  cat > README.md <<EOL
This is a new [**React Native**](https://reactnative.dev) project, bootstrapped using [\`@react-native-community/cli\`](https://github.com/react-native-community/cli).

# Getting Started

> **Note**: Make sure you have completed the [Set Up Your Environment](https://reactnative.dev/docs/set-up-your-environment) guide before proceeding.

## Step 1: Install Node Modules

First, you will need to install **Node Modules**.

To install the __node_modules__, run the following command from the root of your React Native project:

\`\`\`sh
yarn
\`\`\`

## Step 2: Build and run your app

Once you have installed \`node_modules\` you can run below command to build and run your app on your connected device or emulator.

### Android

\`\`\`sh
yarn android
\`\`\`

### iOS

For iOS, remember to install CocoaPods dependencies (this only needs to be run on first clone or after updating native deps).

The first time you create a new project, run the Ruby bundler to install CocoaPods itself:

\`\`\`sh
bundle install
\`\`\`

Then, and every time you update your native dependencies, run:

\`\`\`sh
bundle exec pod install
\`\`\`

For more information, please visit [CocoaPods Getting Started guide](https://guides.cocoapods.org/using/getting-started.html).

\`\`\`sh
# Using npm
npm run ios

# OR using Yarn
yarn ios
\`\`\`
# Project Structure
Below directory structure is followed in the project.

\`\`\`
src/
├── assets
│   ├── fonts
│   └── img
├── components
├── hooks
├── navigator
├── screens
├── store
├── theme
├── types
└── utils
\`\`\`

| Directory | Details |
| ------- | ------- |
| assets | Asset directory contains images, json, fonts files used in the project. |
| components | The components directory contains reusable components used in the project. |
| hooks | Hooks directory contains all the reusable hooks i.e. \`useAppDispatch\`, \`useAppSelector\` |
| navigator | Navigator directory contains router logic and screen declaration using \`react-navigation\` library. |
| screens | The screens directory contains implementation of the screens declared in navigator. |
| store | The store directory contains \`slice\` and store configuration. \`Slices\` exported their \`reducer\` & \`actions\` for uses in the code. |
| theme | The theme directory has files related to text configuration, sizes, font and colors used through out the app. These are defined to have consistent design system in the app. |
| types | The types directory contains \`typescript\` declaration using \`.ts\` & \`.d.ts\`. It has \`react-navigation\` type safety declarations as well. |
| utils | The utils directory contains utility method used inside app i.e. \`date\`, \`platform\` and \`string constants\`. |

EOL

  echo "🎉 Setup complete for project: $PROJECT_NAME"
  echo "👉 Next steps:"
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
    echo "❌ Unable to locate the script file to install."
    echo "Run: sudo cp ./setup.sh $TARGET_PATH && sudo chmod +x $TARGET_PATH"
    exit 1
  fi

  echo "📥 Installing script as global command '$GLOBAL_NAME'..."

  # Ensure target dir exists
  if [ ! -d "$TARGET_DIR" ]; then
    echo "🔧 Creating $TARGET_DIR..."
    if ! mkdir -p "$TARGET_DIR"; then
      echo "⚠️  Could not create $TARGET_DIR. Trying with sudo..."
      sudo mkdir -p "$TARGET_DIR"
    fi
  fi

  # Copy with fallback to sudo if permission denied
  if cp "$SCRIPT_PATH" "$TARGET_PATH" 2>/dev/null; then
    chmod +x "$TARGET_PATH"
    echo "✅ Installed to $TARGET_PATH"
  else
    echo "⚠️  Permission denied while copying to $TARGET_PATH. Trying with sudo..."
    sudo cp "$SCRIPT_PATH" "$TARGET_PATH"
    sudo chmod +x "$TARGET_PATH"
    echo "✅ Installed to $TARGET_PATH (via sudo)"
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
    echo "❌ Unknown command: $COMMAND"
    usage
    ;;
esac
