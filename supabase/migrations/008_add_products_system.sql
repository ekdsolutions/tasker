-- Create saved_products table for reusable product names
CREATE TABLE IF NOT EXISTS public.saved_products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id TEXT NOT NULL,
    name TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id, name)
);

-- Create products table for board products
CREATE TABLE IF NOT EXISTS public.products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    board_id UUID NOT NULL REFERENCES public.boards(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    started_date DATE NOT NULL,
    period NUMERIC(3, 1) NOT NULL CHECK (period IN (0.5, 1, 2, 3)),
    price NUMERIC(12, 2) NOT NULL,
    sort_order INTEGER NOT NULL DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes
CREATE INDEX IF NOT EXISTS idx_saved_products_user_id ON public.saved_products(user_id);
CREATE INDEX IF NOT EXISTS idx_products_board_id ON public.products(board_id);
CREATE INDEX IF NOT EXISTS idx_products_started_date ON public.products(started_date);

-- Clear all annual values (as requested)
UPDATE public.boards SET annual = 0;

-- Add ending_date column to boards (will be calculated dynamically)
-- Note: This column will store the closest ending date for quick reference
ALTER TABLE public.boards
ADD COLUMN IF NOT EXISTS ending_date DATE;

