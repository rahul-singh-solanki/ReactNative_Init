import apiClient from '../config/axios';
import type { LoginPayload, LoginResponse } from '../types/api';

function login(payload: LoginPayload): Promise<LoginResponse> {
  return apiClient
    .post<LoginResponse>('/auth/login', payload)
    .then(function (res) {
      return res.data;
    });
}

function logout(): Promise<void> {
  return apiClient.post('/auth/logout').then(function () {
    return;
  });
}

function refreshToken(): Promise<LoginResponse> {
  return apiClient.post<LoginResponse>('/auth/refresh').then(function (res) {
    return res.data;
  });
}

export { login, logout, refreshToken };
