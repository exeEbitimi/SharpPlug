# Nearby

Static site (no build step). Files: index.html, config.js, schema.sql, face.sql, vercel.json.

## Demo mode
Leave config.js empty. Accounts, photos and face templates stay in the browser; providers are simulated.
The face scan still needs a camera and an internet connection (it downloads the free face-api models once).

## Live mode (real users)
1. Create a free Supabase project.
2. SQL Editor: run schema.sql, then run face.sql.
3. Authentication > Providers > Email: turn off "Confirm email" while testing.
4. Project Settings > API: paste the Project URL and anon key into config.js.
5. Authentication > URL Configuration: set the Site URL to your Vercel address.
6. Commit and push; Vercel redeploys.

## Face verification (how it works)
- Photo upload: must contain exactly one face.
- First scan: random liveness prompts (blink, turn head), then the live face must match the uploaded photo.
- A numeric face template is saved in the private face_refs table (only its owner can read it). Scan images are never stored.
- Going live needs a fresh scan that matches the template. Sending a ping needs a verified account.
- Only verified, live providers appear in search. Photos that do not match the verified face are rejected.
- Users can delete their face data in Me.

## Important
Matching runs in the browser, which is fine for testing but can be bypassed by a determined attacker.
For production, add server-side checks or a KYC provider (Smile ID, Youverify, Dojah, Prembly).
