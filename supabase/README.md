# Database Setup

This directory contains SQL migration files for setting up the Supabase database schema.

## Running the Migration

### Option 1: Using Supabase Dashboard (Recommended)

1. Go to your Supabase project dashboard: https://supabase.com/dashboard
2. Navigate to **SQL Editor** in the left sidebar
3. Click **New Query**
4. Copy and paste the contents of `migrations/001_initial_schema.sql`
5. Click **Run** to execute the migration

### Option 2: Using Supabase CLI

If you have the Supabase CLI installed:

```bash
# Link to your project (if not already linked)
supabase link --project-ref your-project-ref

# Run the migration
supabase db push
```

## What This Migration Creates

- **boards** table: Stores user boards with title, description, color, and user association
- **columns** table: Stores columns within boards (e.g., "To Do", "In Progress")
- **tasks** table: Stores tasks within columns with details like title, description, assignee, due date, and priority

The migration also:
- Creates indexes for better query performance
- Sets up Row Level Security (RLS) policies
- Creates triggers to automatically update `updated_at` timestamps

## Security Note

This migration uses permissive RLS policies because the app uses Clerk for authentication (not Supabase Auth). The application code handles user isolation by filtering queries by `user_id`. 

For production, consider:
1. Configuring Supabase to validate Clerk JWT tokens
2. Implementing custom RLS policies based on JWT claims
3. Using Supabase Auth instead of Clerk

## Troubleshooting

If you get an error about tables already existing, you can either:
- Drop the existing tables first (be careful - this will delete all data!)
- Modify the migration to use `CREATE TABLE IF NOT EXISTS` (already included)

If you get RLS policy errors, you can temporarily disable RLS:
```sql
ALTER TABLE public.boards DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.columns DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks DISABLE ROW LEVEL SECURITY;
```

