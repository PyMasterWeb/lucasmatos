-- Execute este comando no Supabase SQL Editor
-- Vá em: Supabase Console → SQL Editor → Novo Query → Cole e Execute

CREATE TABLE IF NOT EXISTS alunos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  turma TEXT NOT NULL,
  nome TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

ALTER TABLE alunos ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Alunos podem ver suas próprias informações"
ON alunos
FOR SELECT
TO authenticated
USING (email = auth.email());
