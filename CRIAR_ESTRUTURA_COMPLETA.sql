-- ESTRUTURA COMPLETA DO BANCO - EXECUTE NO SUPABASE SQL EDITOR
-- Vá em: Supabase Console → SQL Editor → Novo Query

-- 1. CRIAR TABELA DE TURMAS
CREATE TABLE IF NOT EXISTS turmas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome TEXT UNIQUE NOT NULL,
  nivel TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 2. CRIAR TABELA DE DISCIPLINAS
CREATE TABLE IF NOT EXISTS disciplinas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nome TEXT UNIQUE NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 3. ATUALIZAR TABELA DE ALUNOS (sem coluna disciplina)
-- A coluna disciplina será removida da tabela alunos
-- Se a coluna já existe, execute:
ALTER TABLE alunos DROP COLUMN IF EXISTS disciplina;

-- Adicione turma_id se ainda não existir
ALTER TABLE alunos ADD COLUMN IF NOT EXISTS turma_id UUID REFERENCES turmas(id);

-- 4. CRIAR TABELA DE RELAÇÃO ALUNO-DISCIPLINA
CREATE TABLE IF NOT EXISTS aluno_disciplinas (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  aluno_id UUID NOT NULL REFERENCES alunos(id) ON DELETE CASCADE,
  disciplina_id UUID NOT NULL REFERENCES disciplinas(id) ON DELETE CASCADE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(aluno_id, disciplina_id)
);

-- 5. CRIAR TABELA DE MATERIAIS
CREATE TABLE IF NOT EXISTS materiais (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  professor_id UUID NOT NULL REFERENCES professores(id) ON DELETE CASCADE,
  disciplina_id UUID NOT NULL REFERENCES disciplinas(id) ON DELETE CASCADE,
  turma_id UUID NOT NULL REFERENCES turmas(id) ON DELETE CASCADE,
  titulo TEXT NOT NULL,
  arquivo_url TEXT,
  arquivo_path TEXT,
  tipo TEXT NOT NULL, -- 'material' ou 'atividade'
  data_criacao TIMESTAMP DEFAULT NOW(),
  created_at TIMESTAMP DEFAULT NOW()
);

-- 6. ATIVAR ROW LEVEL SECURITY
ALTER TABLE turmas ENABLE ROW LEVEL SECURITY;
ALTER TABLE disciplinas ENABLE ROW LEVEL SECURITY;
ALTER TABLE aluno_disciplinas ENABLE ROW LEVEL SECURITY;
ALTER TABLE materiais ENABLE ROW LEVEL SECURITY;

-- 7. CRIAR POLÍTICAS DE SEGURANÇA

-- Turmas: Todos podem ver
CREATE POLICY "Turmas são públicas"
ON turmas FOR SELECT
USING (true);

-- Disciplinas: Todos podem ver
CREATE POLICY "Disciplinas são públicas"
ON disciplinas FOR SELECT
USING (true);

-- Aluno_disciplinas: Alunos veem suas próprias disciplinas
CREATE POLICY "Alunos veem suas próprias disciplinas"
ON aluno_disciplinas FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM alunos 
    WHERE alunos.id = aluno_disciplinas.aluno_id 
    AND alunos.email = auth.email()
  )
);

-- Materiais: Alunos veem materiais das disciplinas que estão matriculados
CREATE POLICY "Alunos veem materiais das suas disciplinas"
ON materiais FOR SELECT
TO authenticated
USING (
  EXISTS (
    SELECT 1 
    FROM alunos a
    JOIN aluno_disciplinas ad ON a.id = ad.aluno_id
    WHERE a.email = auth.email()
    AND ad.disciplina_id = materiais.disciplina_id
    AND a.turma_id = materiais.turma_id
  )
);

-- Materiais: Professores veem/criam/atualizam seus próprios materiais
CREATE POLICY "Professores gerenciam seus materiais"
ON materiais FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM professores 
    WHERE professores.id = materiais.professor_id 
    AND professores.email = auth.email()
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM professores 
    WHERE professores.id = materiais.professor_id 
    AND professores.email = auth.email()
  )
);

-- 8. INSERIR DADOS DE EXEMPLO
INSERT INTO turmas (nome, nivel) VALUES
('6ano', '6º Ano'),
('7ano', '7º Ano'),
('8ano', '8º Ano'),
('9ano', '9º Ano')
ON CONFLICT DO NOTHING;

INSERT INTO disciplinas (nome) VALUES
('Português'),
('Matemática'),
('Ciências'),
('História'),
('Geografia'),
('Artes'),
('Educação Física'),
('Inglês'),
('Socioemocional')
ON CONFLICT DO NOTHING;
