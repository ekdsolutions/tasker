-- Create boards table
CREATE TABLE IF NOT EXISTS public.boards (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    description TEXT,
    color TEXT NOT NULL DEFAULT 'bg-blue-500',
    user_id TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create columns table
CREATE TABLE IF NOT EXISTS public.columns (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID NOT NULL REFERENCES public.boards(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    user_id TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tasks table
CREATE TABLE IF NOT EXISTS public.tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    column_id UUID NOT NULL REFERENCES public.columns(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    assignee TEXT,
    due_date TIMESTAMP WITH TIME ZONE,
    priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high')),
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_boards_user_id ON public.boards(user_id);
CREATE INDEX IF NOT EXISTS idx_columns_board_id ON public.columns(board_id);
CREATE INDEX IF NOT EXISTS idx_tasks_column_id ON public.tasks(column_id);

-- Enable Row Level Security (RLS)
-- IMPORTANT: This app uses Clerk for authentication, not Supabase Auth.
-- The RLS policies below allow operations, but rely on application-level
-- security (filtering by user_id). For production, you should either:
-- 1. Configure Supabase to validate Clerk JWT tokens and create proper RLS policies
-- 2. Use Supabase Auth instead of Clerk
-- 3. Implement a custom JWT validation function
--
-- For now, RLS is disabled to allow the app to work. The application code
-- filters all queries by user_id, providing application-level security.

-- Option 1: Disable RLS (current approach - relies on app-level security)
-- ALTER TABLE public.boards DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.columns DISABLE ROW LEVEL SECURITY;
-- ALTER TABLE public.tasks DISABLE ROW LEVEL SECURITY;

-- Option 2: Enable RLS with permissive policies (requires app-level filtering)
ALTER TABLE public.boards ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.columns ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;

-- Permissive policies - application code must filter by user_id
-- WARNING: These policies allow any authenticated request. Ensure your
-- application code always filters by user_id to prevent data leaks.
CREATE POLICY "Allow all operations on boards"
    ON public.boards
    FOR ALL
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow all operations on columns"
    ON public.columns
    FOR ALL
    USING (true)
    WITH CHECK (true);

CREATE POLICY "Allow all operations on tasks"
    ON public.tasks
    FOR ALL
    USING (true)
    WITH CHECK (true);

-- Create function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers to automatically update updated_at
CREATE TRIGGER update_boards_updated_at
    BEFORE UPDATE ON public.boards
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_tasks_updated_at
    BEFORE UPDATE ON public.tasks
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

