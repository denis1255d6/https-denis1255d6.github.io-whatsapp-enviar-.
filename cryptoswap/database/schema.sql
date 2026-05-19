create extension if not exists pgcrypto;

create table if not exists swaps (
  id uuid primary key default gen_random_uuid(),
  user_email text,
  from_currency text not null,
  to_currency text not null,
  amount numeric not null,
  estimated_receive numeric,
  commission numeric default 0,
  status text default 'pending',
  provider_swap_id text,
  created_at timestamp default now()
);

create table if not exists profiles (
  id uuid primary key default gen_random_uuid(),
  email text unique not null,
  created_at timestamp default now()
);
