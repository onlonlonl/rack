-- Rack · Setup SQL
-- Run in Supabase SQL Editor

-- Lines (renamed from work_lines, already exists)
-- ALTER TABLE work_lines RENAME TO lines;
-- ALTER TABLE lines ADD COLUMN category TEXT DEFAULT 'work';
-- ALTER TABLE lines ADD COLUMN icon TEXT;
-- ALTER TABLE lines ADD COLUMN direction TEXT;

-- Ensure columns exist (safe to re-run)
DO $$ BEGIN
  ALTER TABLE lines ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'work';
  ALTER TABLE lines ADD COLUMN IF NOT EXISTS icon TEXT;
  ALTER TABLE lines ADD COLUMN IF NOT EXISTS direction TEXT;
EXCEPTION WHEN others THEN NULL;
END $$;

-- Tasks (add category if not exists)
DO $$ BEGIN
  ALTER TABLE tasks ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'work';
EXCEPTION WHEN others THEN NULL;
END $$;

-- Context items (add category, topic if not exists)
DO $$ BEGIN
  ALTER TABLE context_items ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'work';
  ALTER TABLE context_items ADD COLUMN IF NOT EXISTS topic TEXT;
EXCEPTION WHEN others THEN NULL;
END $$;

-- Decisions (add category if not exists)
DO $$ BEGIN
  ALTER TABLE decisions ADD COLUMN IF NOT EXISTS category TEXT DEFAULT 'work';
EXCEPTION WHEN others THEN NULL;
END $$;

-- Learnings table
CREATE TABLE IF NOT EXISTS learnings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  category TEXT DEFAULT 'self',
  source TEXT,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_learnings_category ON learnings(category);

-- Ideas table
CREATE TABLE IF NOT EXISTS ideas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  line_id TEXT,
  category TEXT DEFAULT 'lux',
  status TEXT DEFAULT 'active',
  created_at TIMESTAMPTZ DEFAULT now()
);
CREATE INDEX IF NOT EXISTS idx_ideas_status ON ideas(status);

-- RLS: open for personal tool
ALTER TABLE learnings ENABLE ROW LEVEL SECURITY;
ALTER TABLE ideas ENABLE ROW LEVEL SECURITY;
CREATE POLICY IF NOT EXISTS "open_learnings" ON learnings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS "open_ideas" ON ideas FOR ALL USING (true) WITH CHECK (true);
