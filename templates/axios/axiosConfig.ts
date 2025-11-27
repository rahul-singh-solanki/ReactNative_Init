import axios, { AxiosInstance, AxiosRequestConfig } from 'axios';
import { getEnv } from './env';

const env = getEnv();

const defaultConfig: AxiosRequestConfig = {
  baseURL: env.API_BASE_URL,
  timeout: 15000, // ms
  headers: {
    'Content-Type': 'application/json',
  },
};

function createAxiosInstance(config?: AxiosRequestConfig): AxiosInstance {
  const instance = axios.create(Object.assign({}, defaultConfig, config));

  // Request interceptor (attach token etc.)
  instance.interceptors.request.use(
    function (cfg) {
      // Example: attach auth token if present
      const token = null; // retrieve from secure storage
      if (token) {
        if (!cfg.headers) cfg.headers = {};
        cfg.headers.Authorization = `Bearer ${token}`;
      }
      return cfg;
    },
    function (error) {
      return Promise.reject(error);
    }
  );

  // Response interceptor (global error handling, refresh token, logging)
  instance.interceptors.response.use(
    function (response) {
      return response;
    },
    function (error) {
      // Example: centralize 401 handling or transform error shape
      return Promise.reject(error);
    }
  );

  return instance;
}

const apiClient = createAxiosInstance();

export { createAxiosInstance, apiClient };
export default apiClient;
