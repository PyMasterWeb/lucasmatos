-- ================================================================
-- COPIE E COLE ESTE BLOCO INTEIRO NO SUPABASE SQL EDITOR
-- Supabase Console → SQL Editor → Cole TUDO E CLIQUE EM RUN
-- ================================================================

-- 1. CRIAR TABELA professores
CREATE TABLE IF NOT EXISTS public.professores (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  disciplina VARCHAR(100) NOT NULL,
  email VARCHAR(255),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(email)
);

-- 2. CRIAR TABELA mensagens_turma
CREATE TABLE IF NOT EXISTS public.mensagens_turma (
  id BIGSERIAL PRIMARY KEY,
  turma VARCHAR(50) NOT NULL,
  conteudo TEXT,
  professor_nome VARCHAR(255),
  professor_disciplina VARCHAR(100),
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  professor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 3. ADICIONAR COLUNAS SE NÃO EXISTIREM
ALTER TABLE public.mensagens_turma
ADD COLUMN IF NOT EXISTS professor_nome VARCHAR(255);

ALTER TABLE public.mensagens_turma
ADD COLUMN IF NOT EXISTS professor_disciplina VARCHAR(100);

-- 4. CRIAR ÍNDICES PARA MELHOR PERFORMANCE
CREATE INDEX IF NOT EXISTS idx_mensagens_turma ON public.mensagens_turma(turma);
CREATE INDEX IF NOT EXISTS idx_professores_email ON public.professores(email);

-- 5. HABILITAR RLS (Row Level Security)
ALTER TABLE public.mensagens_turma ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.professores ENABLE ROW LEVEL SECURITY;

-- 6. CRIAR POLÍTICAS RLS PARA mensagens_turma
DROP POLICY IF EXISTS "Allow authenticated users to manage mensagens_turma" ON public.mensagens_turma;
CREATE POLICY "Allow authenticated users to manage mensagens_turma"
ON public.mensagens_turma
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- 7. CRIAR POLÍTICAS RLS PARA professores
DROP POLICY IF EXISTS "Allow users to view professors" ON public.professores;
CREATE POLICY "Allow users to view professors"
ON public.professores
FOR SELECT
TO authenticated
USING (true);

DROP POLICY IF EXISTS "Allow professors to update their own data" ON public.professores;
CREATE POLICY "Allow professors to update their own data"
ON public.professores
FOR UPDATE
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

DROP POLICY IF EXISTS "Allow new professors to insert" ON public.professores;
CREATE POLICY "Allow new professors to insert"
ON public.professores
FOR INSERT
TO authenticated
WITH CHECK (id = auth.uid());

-- ================================================================
-- ADICIONE OS PROFESSORES MANUALMENTE DEPOIS:
-- INSERT INTO public.professores (id, nome, disciplina, email)
-- VALUES (uuid_coluna_aqui, 'Nome Professor', 'Disciplina', 'email@mail.com');
-- ================================================================
