-- Run this once in Supabase: SQL Editor > New query > paste > Run

create table profiles (
  id uuid primary key references auth.users on delete cascade,
  name text, emoji text default '🧑‍🚀',
  services jsonb default '[]', live boolean default false,
  lat double precision, lng double precision,
  seen timestamptz default now(),
  xp int default 0, deals int default 0, ready boolean default false,
  rating numeric default 0, rcount int default 0
);
create table offers (
  id bigint generated always as identity primary key,
  req text, client uuid default auth.uid() references profiles(id),
  provider uuid references profiles(id),
  cname text, pname text, pemoji text, prating numeric, pcount int,
  q text, min_pay int, max_pay int, service text, price int,
  status text default 'pending', dist numeric,
  created timestamptz default now()
);
create table reviews (
  id bigint generated always as identity primary key,
  provider uuid references profiles(id), author uuid default auth.uid(),
  author_name text, stars int check (stars between 1 and 5), body text,
  created timestamptz default now()
);

alter table profiles enable row level security;
alter table offers enable row level security;
alter table reviews enable row level security;

create policy "profiles readable" on profiles for select to authenticated using (true);
create policy "own profile insert" on profiles for insert to authenticated with check (auth.uid() = id);
create policy "own profile update" on profiles for update to authenticated using (auth.uid() = id);

create policy "offers visible to both sides" on offers for select to authenticated using (auth.uid() in (client, provider));
create policy "clients create offers" on offers for insert to authenticated with check (auth.uid() = client);
create policy "both sides update" on offers for update to authenticated using (auth.uid() in (client, provider));

create policy "reviews readable" on reviews for select to authenticated using (true);
create policy "review as yourself" on reviews for insert to authenticated with check (auth.uid() = author and auth.uid() <> provider);

create function upd_rating() returns trigger language plpgsql security definer set search_path = public as $$
begin
  update profiles set
    rating = (select round(avg(stars)::numeric, 1) from reviews where provider = new.provider),
    rcount = (select count(*) from reviews where provider = new.provider)
  where id = new.provider;
  return new;
end $$;
create trigger t_rating after insert on reviews for each row execute function upd_rating();

alter publication supabase_realtime add table offers;
