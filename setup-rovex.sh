#!/bin/bash
set -e

# Variables
PROJECT_NAME="rovex-frontend"
SUPABASE_URL="https://your-project.supabase.co"
SUPABASE_ANON_KEY="your-anon-key"

echo "Creating Next.js app: $PROJECT_NAME"
npx create-next-app@latest $PROJECT_NAME --typescript --eslint --src-dir --app=false --use-npm --no-tailwind

cd $PROJECT_NAME

echo "Installing dependencies..."
npm install @supabase/supabase-js react-hook-form

echo "Setting up project structure..."
mkdir -p lib pages

echo "Creating lib/supabaseClient.ts..."
cat > lib/supabaseClient.ts <<EOL
import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL!;
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!;

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
EOL

echo "Creating pages/signup.tsx..."
cat > pages/signup.tsx <<EOL
import { useState } from 'react';
import { supabase } from '../lib/supabaseClient';

export default function Signup() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  const handleSignup = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.auth.signUp({ email, password });
    if (error) setMessage(error.message);
    else setMessage('Signup successful! Please check your email to confirm.');
  };

  return (
    <div className="max-w-md mx-auto mt-20 p-6 border rounded">
      <h1 className="text-xl font-bold mb-4">Sign Up</h1>
      <form onSubmit={handleSignup}>
        <input
          className="border p-2 mb-4 w-full"
          type="email"
          placeholder="Email"
          required
          onChange={(e) => setEmail(e.target.value)}
          value={email}
        />
        <input
          className="border p-2 mb-4 w-full"
          type="password"
          placeholder="Password"
          required
          onChange={(e) => setPassword(e.target.value)}
          value={password}
        />
        <button
          type="submit"
          className="bg-blue-600 text-white py-2 px-4 rounded hover:bg-blue-700"
        >
          Sign Up
        </button>
      </form>
      {message && <p className="mt-4 text-red-600">{message}</p>}
    </div>
  );
}
EOL

echo "Creating pages/login.tsx..."
cat > pages/login.tsx <<EOL
import { useState } from 'react';
import { supabase } from '../lib/supabaseClient';

export default function Login() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [message, setMessage] = useState('');

  const handleLogin = async (e: React.FormEvent) => {
    e.preventDefault();
    const { error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) setMessage(error.message);
    else setMessage('Login successful!');
  };

  return (
    <div className="max-w-md mx-auto mt-20 p-6 border rounded">
      <h1 className="text-xl font-bold mb-4">Log In</h1>
      <form onSubmit={handleLogin}>
        <input
          className="border p-2 mb-4 w-full"
          type="email"
          placeholder="Email"
          required
          onChange={(e) => setEmail(e.target.value)}
          value={email}
        />
        <input
          className="border p-2 mb-4 w-full"
          type="password"
          placeholder="Password"
          required
          onChange={(e) => setPassword(e.target.value)}
          value={password}
        />
        <button
          type="submit"
          className="bg-green-600 text-white py-2 px-4 rounded hover:bg-green-700"
        >
          Log In
        </button>
      </form>
      {message && <p className="mt-4 text-red-600">{message}</p>}
    </div>
  );
}
EOL

echo "Creating pages/dashboard.tsx..."
cat > pages/dashboard.tsx <<EOL
import { useEffect, useState } from 'react';
import { useRouter } from 'next/router';
import { supabase } from '../lib/supabaseClient';

export default function Dashboard() {
  const [user, setUser] = useState<any>(null);
  const router = useRouter();

  useEffect(() => {
    supabase.auth.getSession().then(({ data }) => {
      if (!data.session) router.push('/login');
      else setUser(data.session.user);
    });
  }, [router]);

  if (!user) return <p>Loading...</p>;

  return (
    <div className="p-6">
      <h1 className="text-2xl font-bold">Welcome, {user.email}</h1>
      {/* Dashboard content goes here */}
    </div>
  );
}
EOL

echo "Creating .env.local..."
cat > .env.local <<EOL
NEXT_PUBLIC_SUPABASE_URL=$SUPABASE_URL
NEXT_PUBLIC_SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY
EOL

echo "Setup complete! To start the dev server, run:"
echo "cd $PROJECT_NAME"
echo "npm run dev"
