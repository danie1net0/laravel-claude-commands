# Contribuindo

Obrigado por considerar contribuir com Laravel Claude Commands! 🎉

## Como Contribuir

### Reportando Bugs

1. Verifique se o bug já não foi reportado nas [Issues](https://github.com/danie1net0/laravel-claude-commands/issues)
2. Abra uma nova issue com:
   - Título descritivo
   - Passos para reproduzir
   - Comportamento esperado vs atual
   - Versão do Laravel, PHP, Claude Code

### Sugerindo Novos Comandos

Tem uma ideia de comando útil? Ótimo!

1. Abra uma issue com tag `enhancement`
2. Descreva o comando e o que ele automatizaria
3. Liste os pacotes/ferramentas envolvidos

### Enviando Pull Requests

1. Fork o repositório
2. Crie uma branch descritiva:
   ```bash
   git checkout -b feat/meu-novo-comando
   ```

3. Para adicionar um novo comando:
   - Crie `commands/setup-nome-do-comando.md`
   - Siga a estrutura dos comandos existentes
   - Adicione ao array `COMMANDS` em `install.sh` e `update.sh`
   - Atualize o README.md

4. Para melhorar comando existente:
   - Edite o arquivo `.md` correspondente
   - Teste o comando em projeto Laravel limpo
   - Documente as mudanças

5. Commit com mensagem descritiva:
   ```bash
   git commit -m "feat(setup-xyz): adiciona comando para configurar XYZ"
   ```

6. Push e abra Pull Request:
   ```bash
   git push origin feat/meu-novo-comando
   ```

## Estrutura de um Comando

Comandos seguem este template:

```markdown
# Nome do Comando

Breve descrição do que o comando faz.

## O que é [Ferramenta]?

Explicação da ferramenta/pacote sendo configurado.

## Instruções

Execute as seguintes etapas em ordem:

### 1. Verificação Inicial
- Verificar requisitos (Laravel, PHP, etc.)
- Perguntar preferências ao usuário

### 2. Instalação
[Comandos de instalação]

### 3. Configuração
[Arquivos de configuração]

### 4. Testes
[Como testar se funcionou]

### 5. Resumo Final
Mostre ao usuário o que foi instalado e próximos passos.
```

## Diretrizes de Código

- Use comandos Bash compatíveis com Linux/macOS
- Prefira `composer` e `npm` nativos ao invés de `sail`
- Sempre valide se está em projeto Laravel antes de executar
- Forneça mensagens claras de erro
- Teste em Laravel 11+ com PHP 8.2+

## Padrão de Commits

Seguimos [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - Nova funcionalidade
- `fix:` - Correção de bug
- `docs:` - Mudanças na documentação
- `chore:` - Tarefas de manutenção
- `refactor:` - Refatoração de código

Exemplos:
```
feat(setup-horizon): adiciona comando para Laravel Horizon
fix(setup-pint): corrige configuração do pint.json
docs(readme): atualiza instruções de instalação
```

## Processo de Review

1. Pull Requests são revisados por mantenedores
2. Podem solicitar mudanças ou melhorias
3. Após aprovação, serão merged para `main`
4. Releases seguem Semantic Versioning

## Dúvidas?

Abra uma [Discussion](https://github.com/danie1net0/laravel-claude-commands/discussions) para:
- Tirar dúvidas
- Discutir ideias
- Pedir ajuda

Obrigado por contribuir! 🚀
