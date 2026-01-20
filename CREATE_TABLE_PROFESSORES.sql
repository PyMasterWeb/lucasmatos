-- Execute este comando no Supabase SQL Editor
-- Vá em: Supabase Console → SQL Editor → Novo Query → Cole e Execute

CREATE TABLE IF NOT EXISTS professores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  disciplina TEXT NOT NULL,
  nome TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE professores ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Professores podem ver sua própria disciplina"
ON professores
FOR SELECT
TO authenticated
USING (email = auth.email());
