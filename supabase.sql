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
