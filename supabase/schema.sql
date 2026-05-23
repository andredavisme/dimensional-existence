-- ============================================================
-- DIMENSIONAL EXISTENCE — Supabase Schema
-- Project: Web App Development Course (nmemmfblpzrkwyljpmvp)
-- ============================================================

-- 1. PAGE VIEWS COUNTER
CREATE TABLE IF NOT EXISTS page_views (
  id BIGSERIAL PRIMARY KEY,
  page TEXT UNIQUE NOT NULL,
  views BIGINT DEFAULT 1,
  last_viewed_at TIMESTAMPTZ DEFAULT NOW()
);

-- Increment view count on conflict
CREATE OR REPLACE FUNCTION increment_page_view(p_page TEXT)
RETURNS VOID AS $$
BEGIN
  INSERT INTO page_views (page, views, last_viewed_at)
  VALUES (p_page, 1, NOW())
  ON CONFLICT (page)
  DO UPDATE SET
    views = page_views.views + 1,
    last_viewed_at = NOW();
END;
$$ LANGUAGE plpgsql;

-- 2. DIMENSIONS TABLE (core concept model)
CREATE TABLE IF NOT EXISTS dimensions (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  dimension_number INT NOT NULL UNIQUE,
  description TEXT,
  is_binary BOOLEAN DEFAULT FALSE,
  polyhedron_faces INT  -- NULL = continuous/extensive dimension
);

INSERT INTO dimensions (name, dimension_number, description, is_binary, polyhedron_faces) VALUES
  ('x-axis', 1, 'First spatial dimension', FALSE, NULL),
  ('y-axis', 2, 'Second spatial dimension', FALSE, NULL),
  ('z-axis', 3, 'Third spatial dimension', FALSE, NULL),
  ('quantum-binary', 4, 'Binary 4th dimension — quantum superposition', TRUE, 2),
  ('schema-meta', 5, 'The relational schema itself as a meta-dimension', FALSE, NULL)
ON CONFLICT DO NOTHING;

-- 3. POLYHEDRA TABLE
CREATE TABLE IF NOT EXISTS polyhedra (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  die_notation TEXT NOT NULL UNIQUE,  -- d4, d6, d8...
  faces INT NOT NULL,
  solid_type TEXT,  -- platonic, archimedean, custom
  dimension_id INT REFERENCES dimensions(id) ON DELETE SET NULL
);

INSERT INTO polyhedra (name, die_notation, faces, solid_type) VALUES
  ('Coin/Disk', 'd2', 2, 'degenerate'),
  ('Tetrahedron', 'd4', 4, 'platonic'),
  ('Cube', 'd6', 6, 'platonic'),
  ('Octahedron', 'd8', 8, 'platonic'),
  ('Pentagonal Trapezohedron', 'd10', 10, 'trapezohedron'),
  ('Dodecahedron', 'd12', 12, 'platonic'),
  ('Icosahedron', 'd20', 20, 'platonic'),
  ('Zocchihedron', 'd100', 100, 'custom')
ON CONFLICT DO NOTHING;

-- 4. FACES TABLE (discrete states per polyhedron)
CREATE TABLE IF NOT EXISTS faces (
  id SERIAL PRIMARY KEY,
  polyhedron_id INT NOT NULL REFERENCES polyhedra(id) ON DELETE CASCADE,
  face_number INT NOT NULL,
  label TEXT,
  UNIQUE(polyhedron_id, face_number)
);

-- 5. QUIZ ATTEMPTS (leaderboard backend)
CREATE TABLE IF NOT EXISTS quiz_attempts (
  id BIGSERIAL PRIMARY KEY,
  player_name TEXT NOT NULL,
  quiz_id TEXT NOT NULL,
  score INT NOT NULL,
  total_questions INT NOT NULL,
  pct_score INT NOT NULL,
  attempted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_quiz_attempts_pct ON quiz_attempts(pct_score DESC);
CREATE INDEX IF NOT EXISTS idx_quiz_attempts_quiz ON quiz_attempts(quiz_id);

-- 6. ROW LEVEL SECURITY
ALTER TABLE page_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE quiz_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE dimensions ENABLE ROW LEVEL SECURITY;
ALTER TABLE polyhedra ENABLE ROW LEVEL SECURITY;
ALTER TABLE faces ENABLE ROW LEVEL SECURITY;

-- Public read on all, public insert on page_views and quiz_attempts
CREATE POLICY "public_read_dimensions" ON dimensions FOR SELECT USING (TRUE);
CREATE POLICY "public_read_polyhedra" ON polyhedra FOR SELECT USING (TRUE);
CREATE POLICY "public_read_faces" ON faces FOR SELECT USING (TRUE);
CREATE POLICY "public_read_quiz_attempts" ON quiz_attempts FOR SELECT USING (TRUE);
CREATE POLICY "public_insert_quiz_attempts" ON quiz_attempts FOR INSERT WITH CHECK (TRUE);
CREATE POLICY "public_read_page_views" ON page_views FOR SELECT USING (TRUE);
CREATE POLICY "public_insert_page_views" ON page_views FOR INSERT WITH CHECK (TRUE);
CREATE POLICY "public_update_page_views" ON page_views FOR UPDATE USING (TRUE);
