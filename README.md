# Nearby

Static site (no build step). Files: index.html, config.js, schema.sql, vercel.json.

## Run in demo mode
Open index.html or deploy as is. Leave config.js empty. Accounts and data stay in the browser, providers are simulated.

## Go live (real accounts, real multi-user)
1. Create a free project at supabase.com.
2. SQL Editor > New query > paste schema.sql > Run.
3. Authentication > Providers > Email: for testing, turn off "Confirm email".
4. Project Settings > API: copy the Project URL and the anon public key into config.js.
5. Authentication > URL Configuration: set Site URL to your Vercel address (needed for password reset links).
6. Redeploy.

## Deploy to Vercel
Drag the folder onto vercel.com/new, or run `npx vercel --prod` inside it.
