type Env = {
  API_BASE_URL: string;
};

function getEnv(): Env {
  // keep this simple; use react-native-config / dotenv in real projects
  return {
    API_BASE_URL: 'https://api.example.com',
  };
}

export { getEnv };
