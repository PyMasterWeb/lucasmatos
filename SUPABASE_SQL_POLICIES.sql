-- Execute estes comandos no SQL Editor do Supabase Console
-- Vá em: Supabase Console → SQL Editor → Cole e execute cada comando

-- 1. REMOVER POLÍTICAS ANTIGAS (OPCIONAL - se quiser limpar)
DROP POLICY IF EXISTS "Upload autenticado DBEscola" ON storage.objects;
DROP POLICY IF EXISTS "Allow INSERT for authenticated users only" ON storage.objects;

-- 2. CRIAR POLÍTICAS NOVAS PARA O BUCKET DBEscola

-- Política para UPLOAD (INSERT) - Permite usuários autenticados fazer upload
CREATE POLICY "Allow authenticated users to upload to DBEscola"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'DBEscola');

-- Política para DOWNLOAD (SELECT) - Permite qualquer um fazer download
CREATE POLICY "Allow public download from DBEscola"
ON storage.objects
FOR SELECT
USING (bucket_id = 'DBEscola');

-- Política para ATUALIZAR (UPDATE) - Permite usuários autenticados atualizar
CREATE POLICY "Allow authenticated users to update DBEscola"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'DBEscola')
WITH CHECK (bucket_id = 'DBEscola');

-- Política para DELETAR (DELETE) - Permite usuários autenticados deletar
CREATE POLICY "Allow authenticated users to delete from DBEscola"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'DBEscola');

-- 3. ALTERNATIVA MAIS PERMISSIVA (se as políticas acima não funcionarem)
-- Descomente e execute se tiver problemas:

/*
-- Remover todas as políticas
DROP POLICY IF EXISTS "Allow authenticated users to upload to DBEscola" ON storage.objects;
DROP POLICY IF EXISTS "Allow public download from DBEscola" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated users to update DBEscola" ON storage.objects;
DROP POLICY IF EXISTS "Allow authenticated users to delete from DBEscola" ON storage.objects;

-- Criar política muito permissiva (APENAS PARA TESTE)
CREATE POLICY "Allow all operations on DBEscola"
ON storage.objects
USING (bucket_id = 'DBEscola')
WITH CHECK (bucket_id = 'DBEscola');
*/

-- ====================================================================
-- 4. CRIAR TABELA mensagens_turma (se não existir)
-- ====================================================================

CREATE TABLE IF NOT EXISTS public.mensagens_turma (
  id BIGSERIAL PRIMARY KEY,
  turma VARCHAR(50) NOT NULL UNIQUE,
  conteudo TEXT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  professor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- Criar índice para melhor performance
CREATE INDEX IF NOT EXISTS idx_mensagens_turma ON public.mensagens_turma(turma);

-- ====================================================================
-- 5. HABILITAR RLS E CRIAR POLÍTICAS PARA mensagens_turma
-- ====================================================================

-- Habilitar RLS na tabela
ALTER TABLE public.mensagens_turma ENABLE ROW LEVEL SECURITY;

-- Política para permitir usuários autenticados visualizarem e editarem mensagens
CREATE POLICY "Allow authenticated users to manage mensagens_turma"
ON public.mensagens_turma
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);

-- Nota: Se quiser segurança adicional no futuro, use esta política (requer professor_id):
-- DROP POLICY "Allow authenticated users to manage mensagens_turma" ON public.mensagens_turma;
-- CREATE POLICY "Allow professors to manage their turma messages"
-- ON public.mensagens_turma
-- FOR ALL
-- TO authenticated
-- USING (professor_id = auth.uid())
-- WITH CHECK (professor_id = auth.uid());
