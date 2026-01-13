-- Add cost column to products table
ALTER TABLE public.products
ADD COLUMN IF NOT EXISTS cost NUMERIC(12, 2) DEFAULT 0;

