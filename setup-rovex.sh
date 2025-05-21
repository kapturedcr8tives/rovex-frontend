#!/usr/bin/env bash
set -e

echo "Creating project directories..."
mkdir -p app/(auth)/login app/(auth)/register app/api/cars app/booking/[id] app/car/[id] app/dashboard components models supabase styles

echo "Adding package.json..."
cat > package.json << 'EOF'
{
  "name": "rovex",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev",
    "build": "next build",
    "lint": "next lint"
  },
  "dependencies": {
    "@supabase/supabase-js": "^2.39.0",
    "next": "^14.0.3",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-datepicker": "^4.25.0",
    "zod": "^3.22.2",
    "react-icons": "^4.10.1"
  },
  "devDependencies": {
    "typescript": "^5.3.2",
    "tailwindcss": "^3.3.5",
    "postcss": "^8.4.31",
    "autoprefixer": "^10.4.16",
    "eslint": "^8.55.0",
    "eslint-config-next": "^14.0.3"
  }
}
EOF

echo "Adding tailwind.config.js..."
cat > tailwind.config.js << 'EOF'
module.exports = {
  content: [
    './app/**/*.{js,ts,jsx,tsx}',
    './components/**/*.{js,ts,jsx,tsx}'
  ],
  theme: { extend: {} },
  plugins: []
}
EOF

echo "Adding postcss.config.js..."
cat > postcss.config.js << 'EOF'
module.exports = { plugins: { tailwindcss: {}, autoprefixer: {} }}
EOF

echo "Adding tsconfig.json..."
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "target": "es5",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "module": "esnext",
    "moduleResolution": "node",
    "resolveJsonModule": true,
    "esModuleInterop": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "noEmit": true,
    "baseUrl": ".",
    "paths": {
      "@/*": ["./*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx"],
  "exclude": ["node_modules"]
}
EOF

echo "Adding globals.css..."
mkdir -p styles
cat > styles/globals.css << 'EOF'
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

echo "Setup script finished. Run 'npm install' then 'npm run dev'."
