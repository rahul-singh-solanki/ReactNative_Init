# Axios File Organization Guide

## Visual File Structure

```
src/
│
├── api/                                    ← Main API directory
│   │
│   ├── config/                            ← Configuration files
│   │   ├── axiosConfig.ts                 ← Axios instance setup
│   │   │   - Base URL configuration
│   │   │   - Default headers
│   │   │   - Request/response interceptors
│   │   │   - Timeout settings
│   │   │
│   │   └── axiosEnv.ts                    ← Environment settings
│   │       - Development configuration
│   │       - Production configuration
│   │       - API endpoints
│   │       - Environment variables
│   │
│   ├── services/                          ← Business logic layer
│   │   └── axiosService.ts                ← Main service
│   │       - GET method wrapper
│   │       - POST method wrapper
│   │       - PUT method wrapper
│   │       - DELETE method wrapper
│   │       - Error handling
│   │
│   └── types/                             ← TypeScript types
│       └── axiosResponseType.d.ts         ← Type definitions
│           - API response types
│           - Error types
│           - Request body types
│           - Generic response wrappers
│
├── store/                                 ← Redux store
│   └── slices/
│       └── userSlice.ts
│
├── hooks/                                 ← Custom React hooks
│   ├── useAppSelector.ts
│   ├── useAppDispatch.ts
│   └── (other custom hooks)
│
├── components/                            ← Reusable components
├── screens/                               ← Screen components
├── navigator/                             ← Navigation config
├── utils/                                 ← Utility functions
├── types/                                 ← TypeScript types
└── assets/                                ← Images, fonts, etc.
```

## File Purposes

### 📝 `src/api/config/axiosConfig.ts`

**Purpose**: Core axios instance configuration

**Contains**:
```typescript
- import axios from 'axios'
- import { API_BASE_URL, API_TIMEOUT } from './axiosEnv'
- axios.create() configuration
- Default headers setup
- Request interceptors
- Response interceptors
```

**Usage**:
```typescript
export const instance = axios.create({
  baseURL: API_BASE_URL,
  timeout: API_TIMEOUT,
  headers: {
    'Content-Type': 'application/json',
  },
})
```

---

### ⚙️ `src/api/config/axiosEnv.ts`

**Purpose**: Environment-specific configuration

**Contains**:
```typescript
- API base URL for different environments
- API timeout settings
- Other environment variables
- Environment detection logic
```

**Usage**:
```typescript
const API_BASE_URL = __DEV__ 
  ? 'http://localhost:3000'
  : 'https://api.production.com'

const API_TIMEOUT = 10000
```

---

### 🔧 `src/api/services/axiosService.ts`

**Purpose**: Service layer for HTTP operations

**Contains**:
```typescript
- GET method
- POST method
- PUT method
- DELETE method
- PATCH method (optional)
- Error handling
- Request logging (optional)
- Response transformation (optional)
```

**Usage**:
```typescript
export const axiosService = {
  get: (url, config) => instance.get(url, config),
  post: (url, data, config) => instance.post(url, data, config),
  put: (url, data, config) => instance.put(url, data, config),
  delete: (url, config) => instance.delete(url, config),
}
```

---

### 📚 `src/api/types/axiosResponseType.d.ts`

**Purpose**: TypeScript type definitions for API communication

**Contains**:
```typescript
- Generic ApiResponse<T> interface
- Error response interface
- Request body interface
- Status codes
- Common response patterns
```

**Usage**:
```typescript
export interface ApiResponse<T> {
  success: boolean
  data: T
  message?: string
  timestamp?: number
}

export interface ApiError {
  status: number
  message: string
  code: string
  details?: any
}
```

---

## Data Flow Diagram

```
┌─────────────────────┐
│  React Component    │
│  or Redux Thunk     │
└──────────┬──────────┘
           │
           │ calls
           ▼
┌──────────────────────────┐
│  axiosService            │
│  (src/api/services/)     │
│                          │
│  - axiosService.get()    │
│  - axiosService.post()   │
│  - axiosService.put()    │
│  - axiosService.delete() │
└──────────┬───────────────┘
           │
           │ uses
           ▼
┌──────────────────────────┐
│  axios instance          │
│  (src/api/config/)       │
│                          │
│  - Base URL              │
│  - Headers               │
│  - Interceptors          │
│  - Timeout               │
└──────────┬───────────────┘
           │
           │ sends request
           ▼
      ┌─────────┐
      │   API   │
      │ Server  │
      └─────────┘
```

## Folder Organization Benefits

### 1. **config/** Directory
- **Centralizes** all configuration in one place
- **Separates** environment settings from implementation
- **Easy to maintain** - only edit config when changing API
- **Clear intent** - someone looking at `config/` knows what to modify

### 2. **services/** Directory
- **Encapsulates** API logic
- **Easy to test** - mock the service layer
- **Easy to reuse** - import service anywhere in app
- **Extensible** - add more services as needed

### 3. **types/** Directory
- **Centralized types** - one place for all API types
- **Type safety** - full TypeScript support
- **Documentation** - types serve as API documentation
- **Consistency** - ensures same types across app

## Comparison: Before vs After

### Before (Without Organization)
```
src/
├── api.ts                ← Mixed concerns
├── apiConfig.ts          ← Buried with other files
├── apiTypes.ts           ← Hard to find
└── ...
```

**Issues**:
- ❌ Not immediately clear what's API vs business logic
- ❌ Hard to extend with new services
- ❌ Types scattered around

### After (With Organization)
```
src/api/
├── config/               ← Crystal clear
│   ├── axiosConfig.ts
│   └── axiosEnv.ts
├── services/             ← Easy to add more
│   ├── axiosService.ts
│   ├── userService.ts    ← Easy to add!
│   └── productService.ts ← Easy to add!
└── types/                ← All in one place
    ├── axiosResponseType.d.ts
    ├── user.types.ts     ← Easy to add!
    └── product.types.ts  ← Easy to add!
```

**Benefits**:
- ✅ Clear separation of concerns
- ✅ Easy to find what you need
- ✅ Scalable for multiple services
- ✅ Professional structure

## Creating Additional Services

As your app grows, add new service files:

```typescript
// src/api/services/userService.ts
import { axiosService } from './axiosService'
import { User, UsersResponse } from 'api/types/user.types'

export const userService = {
  getUsers: () => 
    axiosService.get<UsersResponse>('/users'),
  
  getUserById: (id: string) => 
    axiosService.get<User>(`/users/${id}`),
  
  createUser: (data: Omit<User, 'id'>) => 
    axiosService.post<User>('/users', data),
  
  updateUser: (id: string, data: Partial<User>) => 
    axiosService.put<User>(`/users/${id}`, data),
  
  deleteUser: (id: string) => 
    axiosService.delete(`/users/${id}`),
}
```

```typescript
// src/api/types/user.types.ts
import { ApiResponse } from './axiosResponseType'

export interface User {
  id: string
  name: string
  email: string
  createdAt: string
}

export interface UsersResponse extends ApiResponse<User[]> {}
```

## Import Patterns

### From Components
```typescript
import { userService } from 'api/services/userService'
import { User } from 'api/types/user.types'

const fetchUser = async (id: string): Promise<User> => {
  const response = await userService.getUserById(id)
  return response.data
}
```

### From Redux Thunks
```typescript
import { createAsyncThunk } from '@reduxjs/toolkit'
import { userService } from 'api/services/userService'

export const fetchUsers = createAsyncThunk(
  'users/fetchUsers',
  async () => {
    const response = await userService.getUsers()
    return response.data
  }
)
```

### From React Query
```typescript
import { useQuery } from '@tanstack/react-query'
import { userService } from 'api/services/userService'

export const useUsers = () => {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => userService.getUsers(),
  })
}
```

## Summary

The organized structure ensures:

| Aspect | Benefit |
|--------|---------|
| **Maintainability** | Know exactly where each piece of API logic is |
| **Scalability** | Add new services without cluttering the codebase |
| **Testability** | Mock services independently |
| **Type Safety** | Full TypeScript support throughout |
| **Reusability** | Import services anywhere in the app |
| **Readability** | Clear folder structure = clear intent |
| **Professionalism** | Follows industry best practices |

---

**Result**: A production-ready, scalable API architecture that grows with your app.
