-- 在 Supabase Dashboard > SQL Editor 執行一次。
-- 所有資料依登入者分隔；RLS 會阻止使用者讀寫其他人的資產。

create table public.asset_records (
  user_id uuid not null references auth.users(id) on delete cascade,
  record_date date not null,
  twd_sec bigint not null default 0 check (twd_sec >= 0),
  twd_bank bigint not null default 0 check (twd_bank >= 0),
  usd_sec bigint not null default 0 check (usd_sec >= 0),
  usd_bank bigint not null default 0 check (usd_bank >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, record_date)
);

create table public.asset_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  goal_amount bigint not null default 5000000 check (goal_amount > 0),
  updated_at timestamptz not null default now()
);

alter table public.asset_records enable row level security;
alter table public.asset_settings enable row level security;

revoke all on table public.asset_records from anon;
revoke all on table public.asset_settings from anon;
grant select, insert, update, delete on table public.asset_records to authenticated;
grant select, insert, update, delete on table public.asset_settings to authenticated;

create policy "Users can read their own asset records"
on public.asset_records for select to authenticated
using ((select auth.uid()) = user_id);
create policy "Users can insert their own asset records"
on public.asset_records for insert to authenticated
with check ((select auth.uid()) = user_id);
create policy "Users can update their own asset records"
on public.asset_records for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Users can delete their own asset records"
on public.asset_records for delete to authenticated
using ((select auth.uid()) = user_id);

create policy "Users can read their own asset settings"
on public.asset_settings for select to authenticated
using ((select auth.uid()) = user_id);
create policy "Users can insert their own asset settings"
on public.asset_settings for insert to authenticated
with check ((select auth.uid()) = user_id);
create policy "Users can update their own asset settings"
on public.asset_settings for update to authenticated
using ((select auth.uid()) = user_id)
with check ((select auth.uid()) = user_id);
create policy "Users can delete their own asset settings"
on public.asset_settings for delete to authenticated
using ((select auth.uid()) = user_id);
