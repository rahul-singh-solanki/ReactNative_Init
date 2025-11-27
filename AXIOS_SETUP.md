# Axios Configuration Setup

## Overview

The setup script now automatically configures axios for API calls with proper TypeScript support and environment-based configuration. Files are organized into a structured API directory.

## Folder Structure

```
src/api/
├── config/
│   ├── axiosConfig.ts      # Main axios instance configuration
│   └── axiosEnv.ts         # Environment-specific configurations
├── services/
│   └── axiosService.ts     # Axios service with interceptors
└── types/
    └── axiosResponseType.d.ts  # TypeScript type definitions
```

## What Gets Created

### 1. `src/api/config/axiosConfig.ts`
Contains the main axios instance configuration:
- Base URL setup
- Default headers
- Request/response interceptors
- Timeout settings

### 2. `src/api/config/axiosEnv.ts`
Environment-specific configurations:
- Development environment settings
- Production environment settings
- Staging environment settings
- API endpoints

### 3. `src/api/services/axiosService.ts`
Service layer for HTTP requests:
- GET requests
- POST requests
- PUT requests
- DELETE requests
- Request/response handling
- Error handling

### 4. `src/api/types/axiosResponseType.d.ts`
TypeScript type definitions:
- API response types
- Error response types
- Request body types
- Generic response wrapper types

## Automatic Setup

When you run `./setup.sh init MyApp`, the script automatically:

1. ✅ Creates all required directories under `src/api/`
2. ✅ Copies axios configuration from templates
3. ✅ Sets up TypeScript types
4. ✅ Creates service layer with interceptors
5. ✅ Organizes files by concern (config, services, types)

## Usage Example

After project setup, you can use axios like this:

```typescript
import { axiosService } from 'api/services/axiosService'

// GET request
const fetchUsers = async () => {
  try {
    const response = await axiosService.get('/users')
    console.log(response.data)
  } catch (error) {
    console.error('Error fetching users:', error)
  }
}

// POST request
const createUser = async (userData) => {
  try {
    const response = await axiosService.post('/users', userData)
    return response.data
  } catch (error) {
    console.error('Error creating user:', error)
  }
}
```

## Environment-Based Configuration

The `axiosEnv.ts` file allows you to set different API endpoints based on environment:

```typescript
// In your app
import { getAxiosConfig } from 'api/config/axiosEnv'

const config = getAxiosConfig()
// Returns appropriate config based on __DEV__ flag or environment variable
```

## TypeScript Support

The `axiosResponseType.d.ts` provides full TypeScript support:

```typescript
interface ApiResponse<T> {
  success: boolean
  data: T
  message?: string
}

interface ApiError {
  status: number
  message: string
  code: string
}
```

## Integration with Redux

You can use axios service in Redux thunks:

```typescript
// src/store/slices/userSlice.ts
import { axiosService } from 'api/services/axiosService'

const fetchUsers = createAsyncThunk(
  'users/fetchUsers',
  async () => {
    const response = await axiosService.get('/users')
    return response.data
  }
)
```

## Request Interceptors

The axios configuration includes interceptors for:
- Adding authentication tokens
- Adding custom headers
- Request logging
- Error handling

## Response Interceptors

Response interceptors handle:
- Data transformation
- Error standardization
- Token refresh on 401
- Response logging

## Adding API Endpoints

Create new API services in `src/api/services/`:

```typescript
// src/api/services/userService.ts
import { axiosService } from './axiosService'

export const userService = {
  getUsers: () => axiosService.get('/users'),
  getUserById: (id: string) => axiosService.get(`/users/${id}`),
  createUser: (data) => axiosService.post('/users', data),
  updateUser: (id: string, data) => axiosService.put(`/users/${id}`, data),
  deleteUser: (id: string) => axiosService.delete(`/users/${id}`),
}
```

## Environment Variables

Create a `.env` file in your project root:

```env
REACT_APP_API_BASE_URL=https://api.example.com
REACT_APP_API_TIMEOUT=10000
```

Then reference in `axiosEnv.ts`:

```typescript
const API_BASE_URL = process.env.REACT_APP_API_BASE_URL || 'http://localhost:3000'
const API_TIMEOUT = process.env.REACT_APP_API_TIMEOUT || 10000
```

## Error Handling

The axios service includes centralized error handling:

```typescript
try {
  const data = await axiosService.post('/endpoint', payload)
} catch (error) {
  if (error.response) {
    // Server responded with error status
    console.error('Error:', error.response.data)
  } else if (error.request) {
    // Request made but no response
    console.error('No response:', error.request)
  } else {
    // Error setting up request
    console.error('Error:', error.message)
  }
}
```

## Testing API Calls

Mock axios in your tests:

```typescript
import { axiosService } from 'api/services/axiosService'

jest.mock('api/services/axiosService')

describe('User API', () => {
  it('should fetch users', async () => {
    (axiosService.get as jest.Mock).mockResolvedValue({
      data: [{ id: 1, name: 'John' }]
    })
    
    const result = await axiosService.get('/users')
    expect(result.data).toHaveLength(1)
  })
})
```

## Customization

### Modify Request Headers

Edit `src/api/config/axiosConfig.ts`:

```typescript
const instance = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
    'Custom-Header': 'value', // Add custom header
  },
})
```

### Add Response Transformation

Modify interceptors in `src/api/services/axiosService.ts`:

```typescript
instance.interceptors.response.use(
  response => {
    // Transform response data
    return response.data // Return only data, not full response
  },
  error => {
    // Handle error
    return Promise.reject(error)
  }
)
```

### Update Types

Add new types to `src/api/types/axiosResponseType.d.ts`:

```typescript
export interface User {
  id: string
  name: string
  email: string
}

export interface UsersResponse extends ApiResponse<User[]> {}
```

## Integration with Other Libraries

### With React Query

```typescript
import { useQuery } from '@tanstack/react-query'
import { axiosService } from 'api/services/axiosService'

export const useUsers = () => {
  return useQuery({
    queryKey: ['users'],
    queryFn: () => axiosService.get('/users'),
  })
}
```

### With React Navigation

Pass axios service to screen components:

```typescript
const UsersScreen = ({ navigation }) => {
  useEffect(() => {
    axiosService.get('/users')
      .then(response => setUsers(response.data))
      .catch(error => navigation.goBack())
  }, [])
}
```

## Performance Optimization

### Caching Responses

```typescript
const cache = {}

export const cachedGet = async (url, cacheDuration = 5000) => {
  if (cache[url] && Date.now() - cache[url].timestamp < cacheDuration) {
    return cache[url].data
  }
  
  const data = await axiosService.get(url)
  cache[url] = { data, timestamp: Date.now() }
  return data
}
```

### Request Debouncing

```typescript
import { debounce } from 'lodash'

export const debouncedSearch = debounce(
  (query) => axiosService.get(`/search?q=${query}`),
  300
)
```

## Troubleshooting

### CORS Issues

If you get CORS errors, ensure:
1. Backend allows your domain in CORS headers
2. Request credentials are properly set
3. Preflight requests are handled

### Timeout Errors

Adjust timeout in `axiosEnv.ts`:

```typescript
const API_TIMEOUT = 30000 // 30 seconds
```

### Token Refresh

Add token refresh logic in request interceptor:

```typescript
instance.interceptors.request.use(
  async config => {
    const token = await getAuthToken()
    if (token) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  }
)
```

## Files Reference

| File | Purpose | Location |
|------|---------|----------|
| axiosConfig.ts | Instance configuration | src/api/config/ |
| axiosEnv.ts | Environment settings | src/api/config/ |
| axiosService.ts | Service layer | src/api/services/ |
| axiosResponseType.d.ts | Type definitions | src/api/types/ |

## Next Steps

1. Update `src/api/config/axiosEnv.ts` with your API base URL
2. Modify request/response interceptors as needed
3. Create specific service files in `src/api/services/`
4. Update types in `src/api/types/` for your API
5. Use axios service in Redux thunks or React Query

---

**Setup completed automatically!** Your project now has a fully configured, production-ready axios setup with TypeScript support and proper file organization.
