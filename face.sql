-- Run AFTER schema.sql (safe to run on an existing project). Adds photos, face verification and private face templates.

alter table profiles
  add column if not exists photo text,
  add column if not exists verified boolean default false,
  add column if not exists verified_at timestamptz;

-- The face template lives in its own table. Only its owner can ever read or change it.
create table if not exists face_refs (
  uid uuid primary key default auth.uid() references profiles(id) on delete cascade,
  descriptor jsonb not null,
  consent_at timestamptz default now(),
  updated timestamptz default now()
);
alter table face_refs enable row level security;
create policy "own face read" on face_refs for select to authenticated using (auth.uid() = uid);
create policy "own face insert" on face_refs for insert to authenticated with check (auth.uid() = uid);
create policy "own face update" on face_refs for update to authenticated using (auth.uid() = uid);
create policy "own face delete" on face_refs for delete to authenticated using (auth.uid() = uid);
