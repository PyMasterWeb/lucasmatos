# 📚 Guia de Configuração do Supabase

## Instruções para Configurar Tabelas e Políticas RLS

### ⚠️ IMPORTANTE: Ordem de Execução

Execute os comandos SQL **na seguinte ordem**:

---

## PASSO 1: Executar as Políticas de Storage (Bucket)

Acesse: **Supabase Console → SQL Editor**

Cole e execute este bloco primeiro:

```sql
-- REMOVER POLÍTICAS ANTIGAS (opcional)
DROP POLICY IF EXISTS "Upload autenticado DBEscola" ON storage.objects;
DROP POLICY IF EXISTS "Allow INSERT for authenticated users only" ON storage.objects;

-- CRIAR NOVAS POLÍTICAS PARA UPLOAD
CREATE POLICY "Allow authenticated users to upload to DBEscola"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'DBEscola');

-- POLICY PARA DOWNLOAD
CREATE POLICY "Allow public download from DBEscola"
ON storage.objects
FOR SELECT
USING (bucket_id = 'DBEscola');

-- POLICY PARA ATUALIZAR
CREATE POLICY "Allow authenticated users to update DBEscola"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'DBEscola')
WITH CHECK (bucket_id = 'DBEscola');

-- POLICY PARA DELETAR
CREATE POLICY "Allow authenticated users to delete from DBEscola"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'DBEscola');
```

✅ **Resultado esperado**: Todas as queries foram bem-sucedidas.

---

## PASSO 2: Criar Tabela e Políticas para Mensagens da Turma

Cole e execute este bloco:

```sql
-- 1. CRIAR TABELA mensagens_turma
CREATE TABLE IF NOT EXISTS public.mensagens_turma (
  id BIGSERIAL PRIMARY KEY,
  turma VARCHAR(50) NOT NULL UNIQUE,
  conteudo TEXT,
  data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  professor_id UUID REFERENCES auth.users(id) ON DELETE SET NULL
);

-- 2. CRIAR ÍNDICE
CREATE INDEX IF NOT EXISTS idx_mensagens_turma ON public.mensagens_turma(turma);

-- 3. HABILITAR RLS
ALTER TABLE public.mensagens_turma ENABLE ROW LEVEL SECURITY;

-- 4. CRIAR POLÍTICA RLS
CREATE POLICY "Allow authenticated users to manage mensagens_turma"
ON public.mensagens_turma
FOR ALL
TO authenticated
USING (true)
WITH CHECK (true);
```

✅ **Resultado esperado**: Todas as queries foram bem-sucedidas.

---

## PASSO 3: Verificar Configurações (Opcional)

Para confirmar que tudo está funcionando:

```sql
-- Verificar tabela
SELECT * FROM public.mensagens_turma;

-- Verificar RLS habilitado
SELECT * FROM pg_tables 
WHERE tablename = 'mensagens_turma' AND schemaname = 'public';

-- Verificar políticas
SELECT * FROM pg_policies 
WHERE tablename = 'mensagens_turma';
```

---

## 🔒 Políticas RLS Explicadas

### Storage (Bucket DBEscola)
- **INSERT**: Usuários autenticados podem fazer upload
- **SELECT**: Público pode fazer download
- **UPDATE**: Usuários autenticados podem atualizar
- **DELETE**: Usuários autenticados podem deletar

### Tabela mensagens_turma
- **Todas as operações (ALL)**: Apenas usuários autenticados podem ler/escrever

---

## 🐛 Troubleshooting

### Erro: "relation public.mensagens_turma does not exist"
✅ **Solução**: Execute o PASSO 2 completo

### Erro: "new row violates row-level security policy"
✅ **Solução**: Certifique-se de que o usuário está autenticado no Supabase

### Erro ao salvar mensagem na UI
✅ **Solução**: 
1. Abra DevTools (F12)
2. Vá para a aba Console
3. Procure por mensagens de erro
4. Verifique se as políticas foram criadas corretamente

---

## 📱 Testando a Funcionalidade

1. Acesse a página do professor (`professor.html` ou `professor-linguaportuguesa.html`)
2. Selecione uma turma
3. No bloco azul "Mensagem/Instrução para a Turma", escreva uma mensagem
4. Clique em "Salvar Mensagem"
5. A mensagem deve aparecer na área cinza abaixo com sucesso ✓

---

## 📝 Notas Importantes

- As políticas permitem que **qualquer usuário autenticado** acesse mensagens de **qualquer turma**
- Para segurança mais rigorosa, você pode associar professores a turmas específicas
- Os timestamps de criação e atualização são automáticos
- A coluna `professor_id` é opcional e pode ser usada para filtros futuros

---

**Última atualização**: 24/01/2026
