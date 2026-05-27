DROP DATABASE IF EXISTS questoes_certas;
CREATE DATABASE questoes_certas;
USE questoes_certas;

CREATE TABLE BANCA (
  id_banca   INT          NOT NULL AUTO_INCREMENT,
  nome_banca VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_banca)
);

CREATE TABLE DISCIPLINA (
  id_disciplina   INT          NOT NULL AUTO_INCREMENT,
  nome_disciplina VARCHAR(100) NOT NULL,
  PRIMARY KEY (id_disciplina)
);

CREATE TABLE USUARIO (
  id_usuario      INT          NOT NULL AUTO_INCREMENT,
  nome_completo   VARCHAR(100) NOT NULL,
  email           VARCHAR(100) NOT NULL UNIQUE,
  senha           VARCHAR(255) NOT NULL,
  data_nascimento DATE         NOT NULL,
  area_interesse  ENUM('fiscal','policial','administrativa','educacao') NOT NULL,
  PRIMARY KEY (id_usuario)
);

CREATE TABLE CONCURSO (
  id_concurso   INT          NOT NULL AUTO_INCREMENT,
  nome_concurso VARCHAR(150) NOT NULL,
  cargo         VARCHAR(100) NOT NULL,
  id_banca      INT          NOT NULL,
  PRIMARY KEY (id_concurso),
  CONSTRAINT fk_concurso_banca
    FOREIGN KEY (id_banca) REFERENCES BANCA (id_banca)
);

CREATE TABLE QUESTAO (
  id_questao        INT     NOT NULL AUTO_INCREMENT,
  enunciado         TEXT    NOT NULL,
  gabarito          CHAR(1) NOT NULL,
  comentario        TEXT,
  nivel_dificuldade ENUM('facil','medio','dificil') NOT NULL,
  id_banca          INT     NOT NULL,
  id_disciplina     INT     NOT NULL,
  id_concurso       INT     NOT NULL,
  PRIMARY KEY (id_questao),
  CONSTRAINT fk_questao_banca
    FOREIGN KEY (id_banca)      REFERENCES BANCA      (id_banca),
  CONSTRAINT fk_questao_disciplina
    FOREIGN KEY (id_disciplina) REFERENCES DISCIPLINA (id_disciplina),
  CONSTRAINT fk_questao_concurso
    FOREIGN KEY (id_concurso)   REFERENCES CONCURSO   (id_concurso)
);

CREATE TABLE SIMULADO (
  id_simulado INT          NOT NULL AUTO_INCREMENT,
  titulo      VARCHAR(150) NOT NULL,
  tema        VARCHAR(100) NOT NULL,
  id_usuario  INT          NOT NULL,
  PRIMARY KEY (id_simulado),
  CONSTRAINT fk_simulado_usuario
    FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario)
);

CREATE TABLE RESULTADO (
  id_resultado  INT          NOT NULL AUTO_INCREMENT,
  total_acertos INT          NOT NULL DEFAULT 0,
  total_erros   INT          NOT NULL DEFAULT 0,
  tempo_medio   DECIMAL(5,2) NOT NULL DEFAULT 0.00,
  id_simulado   INT          NOT NULL UNIQUE,
  id_usuario    INT          NOT NULL,
  PRIMARY KEY (id_resultado),
  CONSTRAINT fk_resultado_simulado
    FOREIGN KEY (id_simulado) REFERENCES SIMULADO (id_simulado),
  CONSTRAINT fk_resultado_usuario
    FOREIGN KEY (id_usuario)  REFERENCES USUARIO  (id_usuario)
);

CREATE TABLE SIMULADO_QUESTAO (
  id_simulado INT NOT NULL,
  id_questao  INT NOT NULL,
  PRIMARY KEY (id_simulado, id_questao),
  CONSTRAINT fk_sq_simulado
    FOREIGN KEY (id_simulado) REFERENCES SIMULADO (id_simulado),
  CONSTRAINT fk_sq_questao
    FOREIGN KEY (id_questao)  REFERENCES QUESTAO  (id_questao)
);

CREATE TABLE HISTORICO (
  id_usuario     INT          NOT NULL,
  id_questao     INT          NOT NULL,
  acerto         BOOLEAN      NOT NULL,
  tempo_resposta DECIMAL(5,2) NOT NULL,
  data_resposta  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_usuario, id_questao, data_resposta),
  CONSTRAINT fk_hist_usuario
    FOREIGN KEY (id_usuario) REFERENCES USUARIO (id_usuario),
  CONSTRAINT fk_hist_questao
    FOREIGN KEY (id_questao) REFERENCES QUESTAO (id_questao)
);

INSERT INTO BANCA (nome_banca) VALUES
  ('CESPE/CEBRASPE'),
  ('FCC');

INSERT INTO DISCIPLINA (nome_disciplina) VALUES
  ('Lingua Portuguesa'),
  ('Matematica'),
  ('Direito Constitucional'),
  ('Direito Administrativo'),
  ('Raciocinio Logico'),
  ('Informatica'),
  ('Direito Penal');

INSERT INTO USUARIO (nome_completo, email, senha, data_nascimento, area_interesse) VALUES
  ('Ruan Thomaz',   'ruan.thomaz@email.com', SHA2('senha123', 256), '2007-05-07', 'fiscal'),
  ('Pedro David',   'pedro.david@email.com', SHA2('senha456', 256), '2005-07-02', 'policial'),
  ('Matheus Gomes', 'matheus.gos@email.com', SHA2('senha789', 256), '2008-11-08', 'administrativa');

INSERT INTO CONCURSO (nome_concurso, cargo, id_banca) VALUES
  ('Concurso Receita Federal 2024', 'Auditor Fiscal',           1),
  ('Concurso TRF 5a Regiao 2023',   'Analista Judiciario',      2),
  ('Concurso TCU 2024',             'Auditor Federal',          1),
  ('Concurso INSS 2024',            'Tecnico do Seguro Social', 2),
  ('Concurso STJ 2024',             'Analista Judiciario',      1),
  ('Concurso TRT 2023',             'Tecnico Judiciario',       2);

INSERT INTO QUESTAO (enunciado, gabarito, comentario, nivel_dificuldade, id_banca, id_disciplina, id_concurso) VALUES
  ('Assinale a alternativa que apresenta o emprego correto da virgula: (A) Joao, foi ao mercado. (B) Maria comprou pao, leite e ovos. (C) O aluno, estudioso, reprovou. (D) Nos, fomos ao cinema.', 'B', 'A virgula e usada corretamente para separar itens de uma enumeracao.', 'facil', 1, 1, 1),
  ('Um trem parte de A em direcao a B, distantes 300 km, a 60 km/h. Outro parte de B em direcao a A a 90 km/h. Em quanto tempo se encontram? (A) 1h (B) 2h (C) 3h (D) 4h', 'B', 'A velocidade relativa e 60+90=150 km/h. Tempo = 300/150 = 2 horas.', 'medio', 2, 2, 2),
  ('Nos termos da CF/88, sao clausulas petreas, EXCETO: (A) Forma federativa de Estado. (B) Voto secreto. (C) Separacao dos Poderes. (D) Sistema parlamentarista.', 'D', 'O sistema de governo nao e clausula petrea.', 'medio', 1, 3, 3),
  ('Sobre os principios da Administracao Publica previstos na CF/88, o acronimo LIMPE representa: (A) Legalidade, Impessoalidade, Moralidade, Publicidade, Eficiencia. (B) Liberdade, Igualdade, Moralidade, Proporcionalidade, Eficiencia. (C) Legalidade, Impessoalidade, Merito, Publicidade, Economicidade. (D) Nenhuma das anteriores.', 'A', 'O art. 37 da CF/88 elenca os principios LIMPE.', 'facil', 2, 4, 4),
  ('Se todos os X sao Y e nenhum Y e Z, entao: (A) Nenhum X e Z. (B) Algum X e Z. (C) Todo Z e X. (D) Nenhuma conclusao e possivel.', 'A', 'Por silogismo: X subconjunto de Y e Y interseccao Z = vazio, entao X interseccao Z = vazio.', 'dificil', 1, 5, 3),
  ('Em relacao aos crimes contra a administracao publica, o peculato e definido como: (A) Subtrair dinheiro publico. (B) Exigir vantagem indevida. (C) Retardar ato de oficio. (D) Solicitar vantagem indevida.', 'A', 'O peculato esta previsto no art. 312 do Codigo Penal.', 'dificil', 1, 7, 1),
  ('Qual comando SQL e utilizado para recuperar dados de uma tabela? (A) INSERT (B) UPDATE (C) SELECT (D) DELETE', 'C', 'O comando SELECT retorna dados de uma ou mais tabelas.', 'facil', 2, 6, 6),
  ('Assinale a alternativa correta sobre concordancia verbal: (A) Fazem dois anos. (B) Faz dois anos. (C) Fazia dois anos. (D) Faziam dois anos.', 'B', 'O verbo fazer indica tempo e e impessoal, fica no singular.', 'medio', 2, 1, 2),
  ('Uma loja vendeu 240 produtos em janeiro e 300 em fevereiro. Qual o percentual de aumento? (A) 20% (B) 25% (C) 30% (D) 15%', 'B', 'Aumento = (300-240)/240 x 100 = 25%.', 'facil', 2, 2, 4),
  ('O principio da legalidade na Adm. Publica significa que: (A) O administrador pode fazer tudo que a lei nao proibe. (B) O administrador so pode fazer o que a lei autoriza. (C) A lei se aplica apenas aos particulares. (D) O Estado esta acima da lei.', 'B', 'Na Adm. Publica vigora a legalidade estrita.', 'medio', 1, 4, 5);

INSERT INTO SIMULADO (titulo, tema, id_usuario) VALUES
  ('Simulado Receita Federal - Portugues e Logica', 'Lingua Portuguesa',      1),
  ('Simulado TRF - Direito Constitucional',         'Direito Constitucional', 2),
  ('Simulado TCU - Direito Administrativo',         'Direito Administrativo', 3);

INSERT INTO SIMULADO_QUESTAO (id_simulado, id_questao) VALUES
  (1, 1), (1, 5), (1, 6),
  (2, 3), (2, 4), (2, 10),
  (3, 4), (3, 10),(3, 7);

INSERT INTO RESULTADO (total_acertos, total_erros, tempo_medio, id_simulado, id_usuario) VALUES
  (2, 1, 45.50, 1, 1),
  (1, 2, 60.30, 2, 2),
  (3, 0, 38.75, 3, 3);

INSERT INTO HISTORICO (id_usuario, id_questao, acerto, tempo_resposta, data_resposta) VALUES
  (1, 1,  TRUE,  40.00, '2024-06-01 10:00:00'),
  (1, 5,  TRUE,  50.00, '2024-06-01 10:05:00'),
  (1, 6,  FALSE, 46.50, '2024-06-01 10:10:00'),
  (2, 3,  FALSE, 65.00, '2024-06-02 14:00:00'),
  (2, 4,  TRUE,  55.00, '2024-06-02 14:08:00'),
  (2, 10, FALSE, 61.00, '2024-06-02 14:15:00'),
  (3, 4,  TRUE,  35.00, '2024-06-03 09:00:00'),
  (3, 10, TRUE,  42.00, '2024-06-03 09:06:00'),
  (3, 7,  TRUE,  39.25, '2024-06-03 09:12:00');