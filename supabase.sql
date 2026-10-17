-- Kjør i Supabase: SQL Editor → New query → lim inn → Run.

-- Lagerlista (reagenser som bestilles)
create table if not exists public.reagens_katalog (
  id          text primary key,
  tittel      text not null,
  leverandor  text not null default '',
  updated_at  timestamptz not null default now()
);

alter table public.reagens_katalog enable row level security;

-- Appen bruker anon public key. Disse reglene lar alle som har nøkkelen
-- lese og endre lagerlista. Bruk de samme reglene som tabellen reagenser har.
create policy "anon kan lese"   on public.reagens_katalog for select to anon using (true);
create policy "anon kan legge til" on public.reagens_katalog for insert to anon with check (true);
create policy "anon kan endre"  on public.reagens_katalog for update to anon using (true) with check (true);
create policy "anon kan slette" on public.reagens_katalog for delete to anon using (true);

-- Innstillinger som gjelder hele laboratoriet (PIN-kode for Admin og Oppsett)
create table if not exists public.app_innstillinger (
  nokkel      text primary key,
  verdi       text not null,
  updated_at  timestamptz not null default now()
);

alter table public.app_innstillinger enable row level security;

create policy "anon kan lese"      on public.app_innstillinger for select to anon using (true);
create policy "anon kan legge til" on public.app_innstillinger for insert to anon with check (true);
create policy "anon kan endre"     on public.app_innstillinger for update to anon using (true) with check (true);

-- Glemt PIN-kode? Kjør denne linjen. Da er Admin og Oppsett åpne igjen,
-- og en ny kode kan settes under Admin:
--   delete from public.app_innstillinger where nokkel = 'admin_pin';
