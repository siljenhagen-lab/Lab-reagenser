-- Oppsett av databasen for Lab reagenser.
-- Kjør i Supabase: SQL Editor → New query → lim inn hele fila → Run.
-- Fila kan kjøres flere ganger uten å skade eksisterende data.
--
-- Appen bruker anon public key. Reglene under lar alle som har
-- Project URL og nøkkelen, lese og endre dataene.

-- ── Registreringer (hovedrader og glass) ────────────────────────────────────
-- Et glass peker på sin hovedrad med parent_id. Datoer lagres som tekst (ÅÅÅÅ-MM-DD).
create table if not exists public.reagenser (
  id          text primary key,
  parent_id   text,
  navn        text not null default '',
  storage     text not null default 'kjol',
  ventana     text not null default '',
  lot         text not null default '',
  exp         text not null default '',
  "mDato"     text not null default '',
  "mSign"     text not null default '',
  "kDato"     text not null default '',
  "kSign"     text not null default '',
  "tDato"     text not null default '',
  "tSign"     text not null default '',
  komm        text not null default '',
  updated_at  timestamptz not null default now()
);

alter table public.reagenser enable row level security;

drop policy if exists "anon kan lese"      on public.reagenser;
drop policy if exists "anon kan legge til" on public.reagenser;
drop policy if exists "anon kan endre"     on public.reagenser;
drop policy if exists "anon kan slette"    on public.reagenser;
create policy "anon kan lese"      on public.reagenser for select to anon using (true);
create policy "anon kan legge til" on public.reagenser for insert to anon with check (true);
create policy "anon kan endre"     on public.reagenser for update to anon using (true) with check (true);
create policy "anon kan slette"    on public.reagenser for delete to anon using (true);

-- ── Lagerlista (reagenser som bestilles) ────────────────────────────────────
create table if not exists public.reagens_katalog (
  id          text primary key,
  tittel      text not null,
  leverandor  text not null default '',
  updated_at  timestamptz not null default now()
);

alter table public.reagens_katalog enable row level security;

drop policy if exists "anon kan lese"      on public.reagens_katalog;
drop policy if exists "anon kan legge til" on public.reagens_katalog;
drop policy if exists "anon kan endre"     on public.reagens_katalog;
drop policy if exists "anon kan slette"    on public.reagens_katalog;
create policy "anon kan lese"      on public.reagens_katalog for select to anon using (true);
create policy "anon kan legge til" on public.reagens_katalog for insert to anon with check (true);
create policy "anon kan endre"     on public.reagens_katalog for update to anon using (true) with check (true);
create policy "anon kan slette"    on public.reagens_katalog for delete to anon using (true);

-- ── Innstillinger for hele laboratoriet (PIN-kode for Admin og Oppsett) ────
create table if not exists public.app_innstillinger (
  nokkel      text primary key,
  verdi       text not null,
  updated_at  timestamptz not null default now()
);

alter table public.app_innstillinger enable row level security;

-- Ingen sletteregel: PIN-koden kan bare nullstilles her i Supabase.
drop policy if exists "anon kan lese"      on public.app_innstillinger;
drop policy if exists "anon kan legge til" on public.app_innstillinger;
drop policy if exists "anon kan endre"     on public.app_innstillinger;
create policy "anon kan lese"      on public.app_innstillinger for select to anon using (true);
create policy "anon kan legge til" on public.app_innstillinger for insert to anon with check (true);
create policy "anon kan endre"     on public.app_innstillinger for update to anon using (true) with check (true);

-- Glemt PIN-kode? Kjør denne linjen. Da er Admin og Oppsett åpne igjen,
-- og en ny kode kan settes under Admin:
--   delete from public.app_innstillinger where nokkel = 'admin_pin';
