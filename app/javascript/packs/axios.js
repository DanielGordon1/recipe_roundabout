import axios from 'axios';

const api = axios.create({
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
});

api.interceptors.request.use((config) => {
  const csrfToken = document.querySelector('[name="csrf-token"]').content;
  config.headers['X-CSRF-Token'] = csrfToken;
  return config;
});

export default api;
