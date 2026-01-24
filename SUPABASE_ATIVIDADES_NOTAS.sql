-- ================================================================
-- TABELAS PARA SISTEMA DE ATIVIDADES E NOTAS
-- COPIE E COLE NO SUPABASE SQL EDITOR
-- ================================================================

-- 1. CRIAR TABELA alunos (se não existir)
CREATE TABLE IF NOT EXISTS public.alunos (
  id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  nome VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  turma VARCHAR(50) NOT NULL,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. CRIAR TABELA atividades
CREATE TABLE IF NOT EXISTS public.atividades (
  id BIGSERIAL PRIMARY KEY,
  aluno_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  aluno_nome VARCHAR(255) NOT NULL,
  turma VARCHAR(50) NOT NULL,
  disciplina VARCHAR(100) NOT NULL,
  arquivo_path VARCHAR(500),
  data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. CRIAR TABELA notas
CREATE TABLE IF NOT EXISTS public.notas (
  id BIGSERIAL PRIMARY KEY,
  atividade_id BIGINT NOT NULL REFERENCES public.atividades(id) ON DELETE CASCADE,
  aluno_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  professor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  professor_nome VARCHAR(255),
  disciplina VARCHAR(100) NOT NULL,
  turma VARCHAR(50) NOT NULL,
  valor NUMERIC(5,2),
  feedback TEXT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(atividade_id, disciplina)
);

-- 4. CRIAR ÍNDICES
CREATE INDEX IF NOT EXISTS idx_atividades_aluno ON public.atividades(aluno_id);
CREATE INDEX IF NOT EXISTS idx_atividades_turma ON public.atividades(turma);
CREATE INDEX IF NOT EXISTS idx_atividades_disciplina ON public.atividades(disciplina);
CREATE INDEX IF NOT EXISTS idx_notas_aluno ON public.notas(aluno_id);
CREATE INDEX IF NOT EXISTS idx_notas_disciplina ON public.notas(disciplina);

-- 5. HABILITAR RLS
ALTER TABLE public.alunos ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notas ENABLE ROW LEVEL SECURITY;

-- 6. POLÍTICAS RLS - ALUNOS
DROP POLICY IF EXISTS "Allow users to view alunos" ON public.alunos;
CREATE POLICY "Allow users to view alunos"
ON public.alunos FOR SELECT TO authenticated USING (true);

DROP POLICY IF EXISTS "Allow alunos to update own data" ON public.alunos;
CREATE POLICY "Allow alunos to update own data"
ON public.alunos FOR UPDATE TO authenticated USING (id = auth.uid());

-- 7. POLÍTICAS RLS - ATIVIDADES
DROP POLICY IF EXISTS "Allow alunos to insert own atividades" ON public.atividades;
CREATE POLICY "Allow alunos to insert own atividades"
ON public.atividades FOR INSERT TO authenticated WITH CHECK (aluno_id = auth.uid());

DROP POLICY IF EXISTS "Allow alunos to view own atividades" ON public.atividades;
CREATE POLICY "Allow alunos to view own atividades"
ON public.atividades FOR SELECT TO authenticated USING (aluno_id = auth.uid());

DROP POLICY IF EXISTS "Allow professors to view atividades" ON public.atividades;
CREATE POLICY "Allow professors to view atividades"
ON public.atividades FOR SELECT TO authenticated USING (true);

-- 8. POLÍTICAS RLS - NOTAS
DROP POLICY IF EXISTS "Allow alunos to view own notas" ON public.notas;
CREATE POLICY "Allow alunos to view own notas"
ON public.notas FOR SELECT TO authenticated USING (aluno_id = auth.uid());

DROP POLICY IF EXISTS "Allow professors to manage notas" ON public.notas;
CREATE POLICY "Allow professors to manage notas"
ON public.notas FOR ALL TO authenticated USING (true) WITH CHECK (true);

-- ================================================================
-- PRONTO! As tabelas foram criadas.
-- Agora execute também a política para storage de atividades.
-- ================================================================
