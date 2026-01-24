# Como Adicionar Professores no Supabase

## Passo 1: Executar o SQL de Setup
Primeiro, execute o arquivo `SUPABASE_QUICK_SETUP.sql` no SQL Editor do Supabase.

## Passo 2: Obter o UUID do Professor

Para adicionar um professor, você precisa do UUID da conta dele no Supabase Auth.

1. Vá em **Supabase Console → Authentication → Users**
2. Procure pelo email do professor
3. Clique no usuário e copie o **UUID** (está no topo da página)

## Passo 3: Adicionar o Professor à Tabela

Vá em **SQL Editor** e execute o comando abaixo, substituindo os valores:

```sql
INSERT INTO public.professores (id, nome, disciplina, email)
VALUES (
  'UUID_AQUI',
  'Nome do Professor',
  'Disciplina',
  'email@mail.com'
);
```

### Exemplo:

```sql
INSERT INTO public.professores (id, nome, disciplina, email)
VALUES (
  'f47ac10b-58cc-4372-a567-0e02b2c3d479',
  'João Silva',
  'Português',
  'joao@mail.com'
);
```

## Passo 4: Verificar

Para ver todos os professores cadastrados:

```sql
SELECT * FROM public.professores;
```

## Notas Importantes

- O campo `id` deve ser exatamente o UUID do usuário no Auth
- O campo `email` deve ser único
- Se o professor não estiver na tabela, o sistema usará o email como fallback
- A disciplina será exibida ao lado do nome nas mensagens da turma
