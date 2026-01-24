# Sistema de Atividades e Notas - Guia de Implementação

## O que foi implementado

### 1. Funcionalidade do Aluno
- Botão "📤 Enviar Atividade" em cada disciplina
- Modal para seleção e envio de arquivo
- Atividade registrada no banco de dados

### 2. Funcionalidade do Professor (a implementar)
- Visualizar atividades enviadas pelos alunos
- Atribuir notas às atividades
- Feedback para o aluno

### 3. Funcionalidade de Boletim (a implementar)
- Visualizar notas de todas as disciplinas
- Modal/página do boletim do aluno

## Tabelas Criadas

1. **alunos** - Dados dos alunos (nome, email, turma)
2. **atividades** - Registro de atividades enviadas
3. **notas** - Notas atribuídas pelos professores

## Próximos Passos

1. Execute o SQL em `SUPABASE_ATIVIDADES_NOTAS.sql`
2. Modifique `professor.html` para visualizar e atribuir notas
3. Adicione botão de boletim na página do aluno

## Estrutura de Pastas de Arquivos

```
aluno/
  atividades/
    (disciplina)/
      (turma)/
        timestamp_arquivo.pdf
```

Professor já tinha:
```
professor/
  (disciplina)/(turma)/
    atividade/
    material/
```
