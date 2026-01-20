# Configuração do Supabase para Upload de Arquivos

## Solução para o erro: "row-level security policy"

O erro de segurança está acontecendo porque o bucket `DBEscola` não tem as permissões corretas.

### Passos para resolver:

1. **Acesse o Supabase Console** → https://app.supabase.com
2. **Vá para Storage** (menu lateral esquerdo)
3. **Clique no bucket `DBEscola`**
4. **Vá para a aba "Policies"** (ou RLS - Row Level Security)
5. **Clique em "New Policy"** e selecione um destes templates:
   - **"Enable INSERT for authenticated users only"** 
   - ou selecione **"Custom"** e crie uma policy assim:

### Opção A: Policy Simples (Recomendado para teste)

```sql
CREATE POLICY "Allow all users to upload files"
ON storage.objects
FOR INSERT
WITH CHECK (true);

CREATE POLICY "Allow all users to download files"
ON storage.objects
FOR SELECT
USING (true);
```

### Opção B: Policy Mais Restritiva (Produção)

```sql
CREATE POLICY "Allow authenticated users to upload"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'DBEscola');

CREATE POLICY "Allow public download"
ON storage.objects
FOR SELECT
USING (bucket_id = 'DBEscola');
```

### Opção C: Usar o editor gráfico do Supabase

6. Clique em **"New Policy"**
7. Selecione **"CREATE"** (INSERT)
8. Marque **"WITH CHECK"** e deixe a expressão como `true`
9. Clique **"Review"** e **"Save policy"**
10. Repita os passos 6-9 para **"SELECT"**

---

## Alternativa: Usar upload direto sem autenticação

Se preferir, modifique o código para usar:

```javascript
const { error } = await supabaseClient.storage
  .from('DBEscola')
  .upload(filePath, file, {
    cacheControl: '3600',
    upsert: false
  })
```

**Depois de fazer qualquer alteração, limpe o cache do navegador (Ctrl+Shift+Delete) e tente novamente.**
