# 📚 Questões Certas — Banco de Questões para Concursos

Sistema web para gerenciamento de um **banco de questões de concursos públicos**, permitindo cadastrar usuários, organizar questões por disciplina/banca/concurso, montar simulados e acompanhar estatísticas de desempenho.

O projeto foi desenvolvido em **Python (Flask)** no back-end, **MySQL** como banco de dados e **HTML/CSS** no front-end, utilizando o motor de templates **Jinja2** para renderização das páginas.

> Projeto com fins acadêmicos, focado em praticar modelagem de banco de dados relacional e integração com uma aplicação web full-stack simples.

---

## 🗂️ Sumário

- [Visão Geral](#-visão-geral)
- [Funcionalidades](#-funcionalidades)
- [Tecnologias Utilizadas](#-tecnologias-utilizadas)
- [Estrutura do Projeto](#-estrutura-do-projeto)
- [Modelagem do Banco de Dados](#-modelagem-do-banco-de-dados)
- [Instalação e Configuração](#-instalação-e-configuração)
- [Variáveis de Ambiente](#-variáveis-de-ambiente)
- [Executando o Projeto](#-executando-o-projeto)

---

## 🔎 Visão Geral

O **Questões Certas** simula uma plataforma de estudos para concursos públicos, onde é possível:

- Visualizar um **dashboard** com indicadores gerais (total de questões, disciplinas, usuários e simulados);
- Listar e **resolver questões** organizadas por disciplina, banca examinadora e nível de dificuldade;
- Montar e acessar **simulados** temáticos compostos por várias questões;
- Consultar **estatísticas** de desempenho (acertos, erros e tempo médio de resposta);
- Listar **usuários** cadastrados na plataforma.

---

## ⚙️ Funcionalidades

| Módulo | Descrição |
|---|---|
| **Dashboard** | Exibe contadores gerais: nº de questões, disciplinas, usuários e simulados cadastrados. |
| **Banco de Questões** | Lista todas as questões com filtros visuais (disciplina, banca, dificuldade) e botão para resolver cada uma. |
| **Resolução de Questão** | Exibe o enunciado, o nível de dificuldade, o gabarito e o comentário/explicação da resposta correta. |
| **Simulados** | Lista simulados cadastrados, exibindo título e tema de cada um. |
| **Estatísticas** | Mostra o total de acertos, total de erros e o tempo médio de resposta. |
| **Usuários** | Lista os usuários cadastrados, com nome, e-mail e área de interesse. |
| **Cadastro** | Formulário de cadastro de novos usuários (front-end pronto, sem rota Flask correspondente). |

---

## 🛠️ Tecnologias Utilizadas

**Back-end**
- Python 3 + [Flask](https://flask.palletsprojects.com/)
- [mysql-connector-python](https://dev.mysql.com/doc/connector-python/en/)
- [python-dotenv](https://pypi.org/project/python-dotenv/) (variáveis de ambiente)

**Front-end**
- HTML5 + Jinja2 (templates dinâmicos)
- CSS3 puro, com layout responsivo
- Google Fonts (Poppins)

**Banco de Dados**
- MySQL (modelagem relacional com chaves estrangeiras)

---

## 📁 Estrutura do Projeto

```
Question_Bank-main/
│
├── app.py                     # Aplicação Flask (rotas e lógica de negócio)
├── .gitignore
│
├── database/
│   └── script.sql             # Criação do banco + dados de exemplo (seed)
│
├── static/
│   └── css/
│       └── style.css          # Estilização geral da aplicação
│
└── templates/
    ├── index.html              # Dashboard
    ├── questoes.html           # Listagem do banco de questões
    ├── resolver_questao.html   # Página de resolução/gabarito
    ├── simulado.html           # Listagem de simulados
    ├── estatisticas.html       # Estatísticas de desempenho
    ├── usuarios.html           # Listagem de usuários
    └── cadastro.html           # Formulário de cadastro
```

---

## 🗃️ Modelagem do Banco de Dados

Banco `questoes_certas`, composto pelas tabelas:

| Tabela | Descrição |
|---|---|
| **BANCA** | Bancas organizadoras de concursos (ex: CESPE, FCC). |
| **DISCIPLINA** | Disciplinas/matérias das questões. |
| **USUARIO** | Usuários da plataforma (senha com hash SHA-256). |
| **CONCURSO** | Concursos públicos, vinculados a uma banca. |
| **QUESTAO** | Enunciado, gabarito, comentário e dificuldade, ligada a banca/disciplina/concurso. |
| **SIMULADO** | Simulados criados por um usuário. |
| **SIMULADO_QUESTAO** | Tabela associativa N:N entre simulados e questões. |
| **RESULTADO** | Acertos, erros e tempo médio de um simulado. |
| **HISTORICO** | Registro de cada resposta individual do usuário a uma questão. |

**Relacionamentos principais:** um Concurso pertence a uma Banca; uma Questão pertence a uma Banca, Disciplina e Concurso; um Simulado pertence a um Usuário e pode ter várias Questões (N:N); um Resultado está ligado a um Simulado e a um Usuário.

O script completo está em [`database/script.sql`](database/script.sql), já com dados de exemplo (bancas, disciplinas, usuários, concursos, questões, simulados e históricos) para testar a aplicação imediatamente.

---

## ⚙️ Instalação e Configuração

**1. Instale as dependências**
```bash
pip install flask mysql-connector-python python-dotenv
```

**2. Crie o banco de dados**
```bash
mysql -u root -p < database/script.sql
```
> ⚠️ O script executa `DROP DATABASE IF EXISTS questoes_certas;` antes de recriá-lo — cuidado se já existir um banco com esse nome.

---

## 🔐 Variáveis de Ambiente

Crie um arquivo `.env` na raiz do projeto:

```env
SECRET_KEY=uma_chave_secreta_qualquer
DB_HOST=localhost
DB_USER=root
DB_PASSWORD_New=sua_senha_do_mysql
DB_NAME=questoes_certas
```

> 💡 Atenção ao nome `DB_PASSWORD_New` (com "New" no final) — é exatamente como a variável é lida em `app.py`.

---

## ▶️ Executando o Projeto

```bash
python app.py
```

A aplicação roda em modo debug e fica disponível em `http://127.0.0.1:5000/`.

---
<p align="center">
  Desenvolvido como projeto acadêmico de banco de dados e desenvolvimento web 💻
</p>
