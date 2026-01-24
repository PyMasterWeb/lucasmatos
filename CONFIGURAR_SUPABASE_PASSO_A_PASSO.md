# Configuração do Supabase - Passo a Passo

## 🔧 Pré-requisitos
- Supabase Console aberto: https://app.supabase.com
- Seu projeto selecionado

---

## 📋 PASSO 1: Executar as Políticas SQL

1. No Supabase Console, vá para **SQL Editor** (menu lateral esquerdo)
2. Clique em **"New Query"**
3. Copie TODO o conteúdo do arquivo `SUPABASE_SQL_POLICIES.sql` do seu projeto
4. Cole no editor do Supabase
5. Clique em **"Run"** (ou Ctrl+Enter)

⚠️ **Ignore qualquer erro sobre tabelas já existentes** - é normal se já foram criadas antes.

---

## 🔐 PASSO 2: Verificar as Políticas RLS

Após executar o SQL, verifique se as políticas foram criadas:

### Para o Storage (Bucket DBEscola):
1. Vá para **Storage** → **Buckets** (menu lateral)
2. Clique no bucket **"DBEscola"**
3. Vá para a aba **"Policies"**
4. Você deve ver estas 4 políticas:
   - ✅ "Allow authenticated users to upload to DBEscola"
   - ✅ "Allow public download from DBEscola"
   - ✅ "Allow authenticated users to update DBEscola"
   - ✅ "Allow authenticated users to delete from DBEscola"

### Para a Tabela mensagens_turma (Banco de Dados):
1. Vá para **Database** → **Tables** (menu lateral)
2. Procure pela tabela **"mensagens_turma"**
3. Clique nela
4. Vá para a aba **"RLS"** ou **"Policies"**
5. Você deve ver uma política:
   - ✅ "Allow authenticated users to manage mensagens_turma"

---

## 🧪 PASSO 3: Testar a Funcionalidade

### Teste de Upload de Arquivos:
1. Abra a página do professor: `professor-linguaportuguesa.html`
2. Faça login
3. Selecione uma turma
4. Tente fazer upload de um arquivo na aba **"Atividade Diária"**
5. Verifique se funciona

### Teste de Mensagens:
1. Na mesma página, localize o bloco **"Mensagem/Instrução para a Turma"**
2. Digite uma mensagem de teste
3. Clique em **"Salvar Mensagem"**
4. Você deve ver: **"Mensagem salva com sucesso! ✓"**

---

## ❌ Se Algo Não Funcionar

### Erro ao salvar mensagens:
- Verifique se a tabela `mensagens_turma` existe em **Database** → **Tables**
- Se não existir, execute novamente o SQL inteiro do arquivo `SUPABASE_SQL_POLICIES.sql`
- Verifique se RLS está **habilitado** na tabela

### Erro ao fazer upload:
- Confirme que o bucket `DBEscola` existe
- Verifique se as 4 políticas de upload estão presentes
- Tente usar a política **"Allow all operations on DBEscola"** (mais permissiva, para teste)

### Erro de autenticação:
- Verifique se você está **logado** antes de testar
- Limpe o cache do navegador: `Ctrl+Shift+Delete`
- Tente fazer login novamente

---

## 📝 Resumo das Políticas

| Recurso | Permissão | Usuários |
|---------|-----------|---------|
| **Storage DBEscola** | Upload, Download, Update, Delete | Autenticados |
| **Tabela mensagens_turma** | Leitura, Escrita, Atualização | Autenticados |
| **Tabela mensagens_turma** | RLS Habilitado | Sim |

---

## 🆘 Suporte

Se continuar com problemas:
1. Abra o **Console do Navegador** (F12)
2. Procure por mensagens de erro em **Console** e **Network**
3. Copie a mensagem de erro exata
4. Verifique se todas as políticas foram criadas corretamente

---

**Data da configuração:** 24 de janeiro de 2026
