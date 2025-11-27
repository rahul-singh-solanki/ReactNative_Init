# Architecture Diagram

## Execution Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                          setup.sh                                │
│                      (Main Orchestrator)                         │
│                                                                   │
│  Commands: init <ProjectName> | install | help                  │
└───────────────────────┬─────────────────────────────────────────┘
                        │
                        │ sources modules
                        ▼
        ┌───────────────┴───────────────┐
        │                               │
        ▼                               ▼
┌───────────────┐              ┌────────────────┐
│  lib/utils.sh │              │ lib/configure.sh│
│               │              │                 │
│ • Logging     │              │ • Config Files  │
│ • Helpers     │◄─────────────┤ • Redux Setup  │
│ • Templates   │   uses       │ • README Gen   │
└───────┬───────┘              └────────┬────────┘
        │                               │
        │                               │ uses templates
        ▼                               ▼
┌──────────────────┐          ┌──────────────────────┐
│lib/install-deps.sh│          │   templates/         │
│                   │          │                      │
│ • Navigation      │          │  config/             │
│ • State Mgmt      │          │  ├── babel.config.js │
│ • Utilities       │          │  ├── eslintrc.js     │
│ • Dev Tools       │          │  ├── prettierrc.js   │
└───────────────────┘          │  ├── tsconfig.json   │
                               │  └── index.js        │
                               │                      │
                               │  redux/              │
                               │  ├── userSlice.ts    │
                               │  ├── store-index.ts  │
                               │  ├── useAppSelector.ts│
                               │  └── useAppDispatch.ts│
                               │                      │
                               │  project-README.md   │
                               └──────────────────────┘
```

## Module Interaction Diagram

```
╔═══════════════════════════════════════════════════════════════╗
║                         User Command                           ║
║                    ./setup.sh init MyApp                       ║
╚═══════════════════════════════════════════════════════════════╝
                              │
                              ▼
╔═══════════════════════════════════════════════════════════════╗
║                          setup.sh                              ║
║  1. Parse command                                              ║
║  2. Call do_init()                                             ║
╚═══════════════════════════════════════════════════════════════╝
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
        ┌──────────┐   ┌──────────┐   ┌──────────┐
        │  utils    │   │ install   │   │configure  │
        │  .sh      │   │ -deps.sh  │   │  .sh      │
        └──────────┘   └──────────┘   └──────────┘
              │               │               │
              │               │               │
              └───────────────┼───────────────┘
                              │
                              ▼
        ╔═════════════════════════════════════╗
        ║      React Native Project           ║
        ║                                     ║
        ║  ✅ Dependencies installed          ║
        ║  ✅ Configuration files created     ║
        ║  ✅ Redux store configured          ║
        ║  ✅ Folder structure setup          ║
        ║  ✅ Path aliases configured         ║
        ║  ✅ README generated                ║
        ╚═════════════════════════════════════╝
```

## Data Flow

```
┌──────────────┐
│ Template     │
│ Files        │
│              │
│ *.js, *.ts   │
│ *.json, *.md │
└──────┬───────┘
       │
       │ read by
       ▼
┌──────────────────┐
│ lib/configure.sh │
│                  │
│ copy_template()  │
└──────┬───────────┘
       │
       │ copies to
       ▼
┌──────────────────┐
│ New React        │
│ Native Project   │
│                  │
│ /MyApp           │
└──────────────────┘
```

## Dependency Installation Flow

```
install_all_deps()
       │
       ├─► install_navigation_deps()
       │   ├─► yarn add @react-navigation/native
       │   ├─► yarn add @react-navigation/stack
       │   ├─► yarn add react-native-screens
       │   └─► yarn add react-native-safe-area-context
       │
       ├─► install_state_management_deps()
       │   ├─► yarn add @reduxjs/toolkit
       │   ├─► yarn add react-redux
       │   └─► yarn add @tanstack/react-query
       │
       ├─► install_utility_deps()
       │   ├─► yarn add axios
       │   ├─► yarn add react-native-size-matters
       │   └─► yarn add @d11/react-native-fast-image
       │
       └─► install_dev_deps()
           └─► yarn add --dev babel-plugin-module-resolver
```

## Configuration Setup Flow

```
configure_all()
       │
       ├─► configure_index_js()
       │   └─► Copy templates/config/index.js
       │
       ├─► configure_eslint()
       │   └─► Copy templates/config/eslintrc.js
       │
       ├─► configure_prettier()
       │   └─► Copy templates/config/prettierrc.js
       │
       ├─► configure_typescript()
       │   └─► Copy templates/config/tsconfig.json
       │
       ├─► configure_babel()
       │   └─► Copy templates/config/babel.config.js
       │
       ├─► configure_rn_config()
       │   └─► Copy templates/config/react-native.config.js
       │
       ├─► setup_redux_store()
       │   ├─► Copy templates/redux/userSlice.ts
       │   └─► Copy templates/redux/store-index.ts
       │
       ├─► setup_redux_hooks()
       │   ├─► Copy templates/redux/useAppSelector.ts
       │   └─► Copy templates/redux/useAppDispatch.ts
       │
       ├─► setup_axios_config()
       │   ├─► Copy templates/axios/axiosConfig.ts → src/api/config/axios.ts
       │   ├─► Copy templates/axios/axiosEnv.ts → src/api/config/env.ts
       │   ├─► Copy templates/axios/axiosService.ts → src/api/services/auth.ts
       │   └─► Copy templates/axios/axiosResponseType.d.ts → src/api/types/api.d.ts
       │
       └─► setup_project_readme()
           └─► Copy templates/project-README.md
```

## File System Layout After Execution

```
MyApp/                              (New React Native Project)
├── node_modules/                   (Installed by yarn)
├── ios/                            (React Native iOS)
│   └── Pods/                       (CocoaPods installed)
├── android/                        (React Native Android)
├── src/                            (Created by script)
│   ├── components/
│   ├── screens/
│   ├── navigator/
│   ├── hooks/
│   │   ├── useAppSelector.ts      (From template)
│   │   └── useAppDispatch.ts      (From template)
│   ├── store/
│   │   ├── index.ts               (From template)
│   │   └── slices/
│   │       └── userSlice.ts       (From template)
│   ├── utils/
│   ├── types/
│   ├── assets/
│   ├── api/
│   │   ├── config/
│   │   │   ├── axios.ts           (From template)
│   │   │   └── env.ts             (From template)
│   │   ├── services/
│   │   │   └── auth.ts            (From template)
│   │   └── types/
│   │       └── api.d.ts           (From template)
│   └── App.tsx                     (Moved from root)
├── index.js                        (From template)
├── babel.config.js                 (From template)
├── tsconfig.json                   (From template)
├── .eslintrc.js                    (From template)
├── .prettierrc.js                  (From template)
├── react-native.config.js          (From template)
├── package.json                    (Updated with deps)
└── README.md                       (From template)
```

## Logging System Architecture

```
┌─────────────────────────────────────┐
│         All Modules                  │
│  (setup.sh, configure.sh, etc.)     │
└──────────────┬──────────────────────┘
               │
               │ call logging functions
               ▼
┌─────────────────────────────────────┐
│        lib/utils.sh                  │
│                                      │
│  log_info()    ℹ️  Information      │
│  log_success() ✅  Success          │
│  log_warning() ⚠️  Warning          │
│  log_error()   ❌  Error            │
│  log_step()    📝  Step             │
│  log_rocket()  🚀  Starting         │
│  log_package() 📦  Package          │
│  log_folder()  📁  Directory        │
│  log_phone()   📱  iOS              │
│  log_tools()   🛠  Dev Tools        │
│  log_party()   🎉  Complete         │
│  log_arrow()   👉  Next Steps       │
│  log_art()     🎨  Creative         │
└──────────────┬──────────────────────┘
               │
               │ outputs to
               ▼
        ┌──────────────┐
        │   Terminal    │
        │   (stdout)    │
        └───────────────┘
```

## Module Responsibilities

```
┌──────────────────────────────────────────────────────────────┐
│                         setup.sh                              │
│  Responsibility: Orchestration & CLI                          │
│  - Parse commands                                             │
│  - Coordinate modules                                         │
│  - Handle global installation                                 │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                       lib/utils.sh                            │
│  Responsibility: Shared Utilities                             │
│  - Logging functions                                          │
│  - File operations                                            │
│  - Common helpers                                             │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                    lib/install-deps.sh                        │
│  Responsibility: Package Management                           │
│  - Navigation packages                                        │
│  - State management                                           │
│  - Utility libraries                                          │
│  - Dev dependencies                                           │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                     lib/configure.sh                          │
│  Responsibility: Project Configuration                        │
│  - Config files (babel, eslint, prettier, typescript, etc.) │
│  - React Native CLI configuration                            │
│  - Redux store setup                                          │
│  - Axios API configuration                                    │
│  - Project README                                             │
└──────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────┐
│                       templates/                              │
│  Responsibility: Boilerplate Code                             │
│  - Configuration templates (config/)                          │
│  - Redux boilerplate (redux/)                                 │
│  - Axios API templates (axios/)                               │
│  - Documentation templates                                    │
└──────────────────────────────────────────────────────────────┘
```
