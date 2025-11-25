#!/bin/bash

set -e  # stop script on any error

# -------------------- Read Project Name --------------------
if [ -z "$1" ]; then
  echo "❌ Error: Please provide a project name."
  echo "👉 Usage: ./setup.sh MyProject"
  exit 1
fi

PROJECT_NAME="$1"

echo "🚀 Creating React Native project: $PROJECT_NAME..."

# -------------------- Create React Native App --------------------
npx @react-native-community/cli@latest init "$PROJECT_NAME" --install-pods true

echo "✅ Project created successfully."

cd "$PROJECT_NAME"

# -------------------- Replace ESLint Config --------------------
echo "📝 Replacing .eslintrc.js..."

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

# -------------------- Replace Prettier Config --------------------
echo "📝 Replacing .prettierrc.js..."

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

# -------------------- Make Initial Commit --------------------

git add .
git commit -m \"init\"

# -------------------- Install Dependencies --------------------
echo "📦 Installing dependencies..."

yarn add \
  @react-navigation/native \
  react-native-screens \
  react-native-safe-area-context

yarn add @react-navigation/stack

yarn add \
  react-native-gesture-handler \
  react-native-reanimated

yarn add \
  @reduxjs/toolkit \
  react-redux

yarn add @tanstack/react-query

# -------------------- Install Dev Dependencies --------------------
echo "🛠 Installing dev dependency: babel-plugin-module-resolver"

yarn add --dev babel-plugin-module-resolver

# -------------------- Install Pods --------------------
echo "📱 Installing iOS pods..."
cd ios && pod install && cd ..

# -------------------- Create src Folder Structure --------------------
echo "📁 Creating folder structure..."

mkdir -p src/{components,store,utils,screens,assets,api,hooks,navigator,types}

# -------------------- Move App.tsx into src --------------------
echo "📦 Moving App.tsx → src/App.tsx..."

if [ -f App.tsx ]; then
  mv App.tsx src/App.tsx
else
  echo "⚠️  App.tsx not found. Maybe using JavaScript template?"
fi

# -------------------- Replace index.js --------------------
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

# -------------------- Create or Replace tsconfig.json --------------------
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

# -------------------- Create or Replace babel.config.js --------------------
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
    'react-native-reanimated/plugin'
  ]
};
EOL

echo "🎉 Setup complete!"
echo "👉 Next steps:"
echo "   cd $PROJECT_NAME"
echo "   npx react-native run-ios  OR  npx react-native run-android"
