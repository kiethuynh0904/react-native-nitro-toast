import { defineConfig } from 'eslint/config'
import eslintPluginPrettierRecommended from 'eslint-plugin-prettier/recommended'

export default defineConfig([
  // Generated / build output — never lint these.
  { ignores: ['lib/**', 'nitrogen/**', 'node_modules/**'] },
  eslintPluginPrettierRecommended,
])
