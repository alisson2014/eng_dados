#Caso tenha problemas em criar os dados execute este comando:
#SET FOREIGN_KEY_CHECKS = 0;

#Para reativar a validação de chaves estrangeiras:
#SET FOREIGN_KEY_CHECKS = 1;

CREATE DATABASE NerdTeste;

USE NerdTeste;

CREATE TABLE IF NOT EXISTS categoria (
    id INT PRIMARY KEY AUTO_INCREMENT,
   	nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS tipo (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS midia (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    categoria_id INT NOT NULL,
    tipo_id INT NOT NULL,
    FOREIGN KEY(categoria_id) REFERENCES categoria(id),
    FOREIGN KEY(tipo_id) REFERENCES tipo(id)
);

CREATE TABLE IF NOT EXISTS ator (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL UNIQUE,
    midia_id INT NOT NULL,
    FOREIGN KEY(midia_id) REFERENCES midia(id)
);

CREATE TABLE IF NOT EXISTS diretor (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    midia_id INT NOT NULL,
    FOREIGN KEY(midia_id) REFERENCES midia(id)
);

CREATE TABLE IF NOT EXISTS trailler (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(50) NOT NULL,
    midia_id INT NOT NULL,
    FOREIGN KEY(midia_id) REFERENCES midia(id)
);

INSERT INTO categoria (nome)
VALUES ('Filmes'), ('Séries'), ('Mini-Séries');

INSERT INTO tipo (nome)
VALUES ('Ação'), ('Comédia'), ('Terror'), ('Outros');

INSERT INTO ator (nome, midia_id)
VALUES ('Brad pitt', 1), ('Ryan gosling', 1), ('Tiago portéz', 2), ('Margot robie', 3);

INSERT INTO diretor (nome, midia_id)
VALUES ('Cristofer Nolan', 1), ('Joãozinho', 2), ('Francis copalo', 2), ('Tiago ferreira', 3);

INSERT INTO trailler (nome, midia_id)
VALUES ("Narnia", 2), ("Traler 1", 2), ('tralier 2', 1), ('trailer teste', 3);

INSERT INTO midia (categoria_id, tipo_id, nome) VALUES
(1, 4, "De volta para o futuro"),
(2, 2, "The big bang theory"),
(3, 1, "Aposentados e perigosos"),
(1, 2, "Gente grande");

#Selecione todos os atores por ordem alfabética
SELECT nome AS nomeAtor FROM ator ORDER BY nome;

#Selecione todos os diretores por ordem alfabética
SELECT nome AS nomeDiretor FROM diretor ORDER BY nome;

#Selecione todas as mídias em ordem alfabética
SELECT 
    m.nome AS nomeMidia,
    c.nome AS nomeCategoria,
    t.nome AS nomeTipo
FROM midia m
	INNER JOIN categoria c ON m.categoria_id = c.id
	INNER JOIN tipo t ON m.tipo_id = t.id
ORDER BY m.nome;

#Selecione todos os trailers da primeira mídia cadastrada
SELECT 
    m.id,
    t.nome AS nomeTrailler,
    m.nome AS midia
FROM trailler t
INNER JOIN midia m ON t.midia_id = m.id
WHERE midia_id = 1;

#Selecione todos os filmes do ator de código 2 (se este existir)
SELECT 
    m.nome AS nomeFilme,
    a.nome AS nomeAtor,
    a.id
	FROM midia m
INNER JOIN ator a ON m.id = a.midia_id
WHERE a.id = 2;

#Selecione todos os diretores do filme número 3 (se este existir)
SELECT 
    d.nome AS nomeDiretor,
    m.nome AS nomeFime,
    m.id
FROM diretor d
INNER JOIN midia m ON d.midia_id = m.id
WHERE d.midia_id = 3;

#Exclua os trailers da primeira mídia cadastrada
DELETE FROM trailler WHERE midia_id = 1;

#Crie a tabela cliente, para o cadastro do cliente do site, 
#com id, nome, email, senha e um campo ativo, que deverá gravar S para Sim e N para não;
CREATE TABLE IF NOT EXISTS cliente (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    senha VARCHAR(100) NOT NULL,
    ativo ENUM('S', 'N') DEFAULT 'N'
);

#Crie uma tabela log, para cadastro do log dos filmes assistidos pelo cliente, 
#esta deverá conter um id, o id do cliente, id da mídia, data (data e hora)
CREATE TABLE IF NOT EXISTS log (
    id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    midia_id INT NOT NULL,
    data DATETIME NOT NULL,
    FOREIGN KEY (midia_id) REFERENCES midia(id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

INSERT INTO cliente (nome, email, senha, ativo) VALUES 
('Irineu', 'irineu20@gmail.com', md5('cavalo'), 'N'),
('Jonas Vitor', 'jonaV0@gmail.com', md5('palmeras'), 'S'),
('Alisson', 'alisson_al20@gmail.com', md5('corintia'), 'S'),
('Burnes Do bacon', 'amobaconfrito@gmail.com', md5('Bacon'), 'N'),
('Marcelo', 'marcelo2@gmail.com', md5('123456'), 'S');

INSERT INTO log (cliente_id, midia_id, data) VALUES 
(4, 1, NOW()),
(2, 2, NOW());

#Faça um SQL que liste as mídias e mostre os tipos que elas são
SELECT 
    m.nome AS nomeMidia,
    t.nome AS nomeTipo,
    m.tipo_id,
    t.id
FROM midia m
    INNER JOIN tipo t ON m.tipo_id = t.id
ORDER BY m.nome;

#Faça um SQL que liste sobre as mídias do tipo Ação
SELECT 
    m.nome AS nomeMidia,
    t.nome AS nomeTipo,
    m.tipo_id,
    t.id
FROM midia m
    INNER JOIN tipo t ON m.tipo_id = t.id
    WHERE tipo_id = 1
ORDER BY m.nome;

#Solução usando o nome da categoria
SELECT 
    m.nome AS nomeMidia,
    t.nome AS nomeTipo,
    m.tipo_id,
    t.id
FROM midia m
    INNER JOIN tipo t ON m.tipo_id = t.id
    WHERE t.nome = 'Ação'
ORDER BY m.nome;

#Faça um SQL que liste as mídias e mostre as 
#categorias (Filmes, Séries ou Mini-séries) de cada uma
SELECT 
    m.categoria_id,
    m.nome AS nomeMidia,
    c.nome AS nomeCategoria,
    c.id
FROM midia m
    INNER JOIN categoria c ON m.categoria_id = c.id
ORDER BY m.nome;

#Faça um SQL que liste somente as séries
SELECT 
    m.nome AS nomeMidia,
    m.categoria_id,
    c.id,
    c.nome AS nomeCategoria 
FROM midia m
    INNER JOIN categoria c ON m.categoria_id = c.id
    WHERE m.categoria_id = 2
ORDER BY m.nome;

#Faça um SQL que liste as mídias mostrando os tipos e categorias
SELECT 
    m.nome AS nomeMidia,
    c.nome AS nomeCategoria,
    t.nome AS nomeTiop
FROM midia m
    INNER JOIN categoria c ON m.categoria_id = c.id
    INNER JOIN tipo t ON m.tipo_id = t.id
ORDER BY m.nome;

#Liste os atores da mídia, mostrando também o nome da mídia
SELECT 
    a.nome AS nomeAtor,
    m.nome AS nomeMidia 
FROM ator a
    INNER JOIN midia m ON a.midia_id = m.id
ORDER BY a.nome;

#Atualize com update, pelo menos 2 atores da sua lista
UPDATE ator SET nome = 'Frank Moses' WHERE id = 4;
UPDATE ator SET midia_id = 2 WHERE id = 3;

#Liste os diretores da mídia, mostrando também o nome da mídia
SELECT 
    d.nome AS nomeDiretor,
    m.nome AS nomeMidia 
FROM diretor d 
    INNER JOIN midia m ON d.midia_id = m.id
ORDER BY d.nome;

#Liste somente os diretores da mídia 4
SELECT * FROM diretor WHERE midia_id = 4;

#Liste somente os atores da mídia 5
SELECT * FROM diretor WHERE midia_id = 5;

#Exclua todos os atores da mídia 5
DELETE FROM ator WHERE midia_id = 5;

#Exclua a mídia 5
DELETE FROM midia WHERE id = 5;

#Insira 2 novas mídias
INSERT INTO midia (nome, categoria_id, tipo_id) VALUES 
('Clube da luta', 1, 4),
('Scot pilgrim', 1, 4);


#Adicione um novo campo na mídia chamado ativo, que deverá guardar S ou N
ALTER TABLE midia ADD COLUMN ativo ENUM('S', 'N') DEFAULT 'N';

#Dê um update para que todas as mídias fiquem com ativo = S
UPDATE midia SET ativo = 'S';

#Liste as mídias mostrando a categoria e o tipo delas (nome da categoria e nome do tipo)
SELECT 
    m.id,
    m.nome AS nomeMidia,
    t.nome AS nomeTipo,
    c.nome AS nomeCategoria 
FROM midia m
INNER JOIN tipo t ON m.tipo_id = t.id
INNER JOIN categoria c ON m.categoria_id = c.id;

# Atualize o nome da Mídia 2 ou 3 para “Rambo II”, 
#e atualize o tipo para Ação e a categoria para Filme
INSERT INTO categoria (nome) VALUES ('Filme');
UPDATE midia 
    SET nome = 'Rambo II', 
    tipo_id = (SELECT id FROM tipo WHERE nome = 'Ação'),
    categoria_id = (SELECT id FROM categoria WHERE nome = 'Filme')
    WHERE id = 2;

#Mostre os filmes assistidos (tabela log) com o nome e a data do registro
#em português, além do nome do cliente que assistiu o filme
SELECT 
    l.id AS logId,
    m.nome AS nomeFilme,
    date_format(l.data, '%d/%m/%Y %H:%i:%s') AS dataFormatada,
    c.nome AS nomeCliente
    FROM log l
INNER JOIN midia m ON l.midia_id = m.id
INNER JOIN cliente c ON l.cliente_id = c.id;

#Mostre os clientes e as datas de quem assistiu o filme 2 ou 3
SELECT 
    c.*,
    date_format(l.data, '%d/%m/%Y %H:%i:%s') AS dataFormatada,
    l.midia_id
FROM log l 
    INNER JOIN cliente c ON l.cliente_id = c.id
WHERE l.midia_id = 2 OR l.midia_id = 3;

#Busque as mídias assistidas entre 01/11/2023 e 20/11/2023
SELECT 
    m.*,
    date_format(l.data, '%d/%m/%Y %H:%i:%s') AS dataFormatada       
FROM log l 
INNER JOIN midia m ON l.midia_id = m.id
WHERE data BETWEEN '01/11/2023' AND '20/11/2023';

#Liste todos os filmes (com nome) assistidos pelo cliente 2
SELECT 
    l.*,
    m.nome AS nomeFilme,
    c.nome AS categoria
FROM log l 
INNER JOIN midia m ON l.midia_id = m.id
INNER JOIN categoria c ON m.categoria_id = c.id
WHERE cliente_id = 2;

#Liste todas as mídias (com nome) assistidas pelo cliente 3
SELECT 
    l.*,
    m.nome AS nomeFilme
FROM log l 
INNER JOIN midia m ON l.midia_id = m.id
WHERE cliente_id = 3;

#Liste os clientes que assistiram mídias entre 10/11/2013 e 20/11/2023
SELECT 
    c.*,
    l.data
    FROM log l 
INNER JOIN cliente c ON l.cliente_id = c.id
    WHERE l.data BETWEEN '10/11/2013' AND '20/11/2023';

#Crie uma tabela de favoritos, 
#adicionando a mídia e o cliente como chave estrangeiras

CREATE TABLE IF NOT EXISTS favoritos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    midia_id INT NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (midia_id) REFERENCES midia(id),
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

#Grave pelo menos 4 cadastros nos favoritos para os clientes 2 e 3
INSERT INTO favoritos (midia_id, cliente_id) VALUES 
(1, 2),
(2, 3),
(2, 2),
(3, 1);

#Liste as mídias favoritas do cliente 2
SELECT 
    f.*,
    c.nome AS nomeCliente,
    m.nome AS nomeMidia
    FROM favoritos f 
INNER JOIN cliente c ON f.cliente_id = c.id
INNER JOIN midia m ON f.midia_id = m.id
WHERE f.cliente_id = 2;

#Liste as mídias favoritas do cliente 3, em ordem alfabética
SELECT 
    f.*,
    c.nome AS nomeCliente,
    m.nome AS nomeMidia
    FROM favoritos f 
INNER JOIN cliente c ON f.cliente_id = c.id
INNER JOIN midia m ON f.midia_id = m.id
WHERE f.cliente_id = 3
ORDER BY m.nome;

#Liste as mídias mostrando a 
#categoria e o tipo delas (nome da categoria e nome do tipo)
SELECT 
    m.*,
    c.nome AS nomeCategoria,
    t.nome AS nomeTipo 
FROM midia m
INNER JOIN categoria c ON m.categoria_id = c.id
INNER JOIN tipo t ON m.tipo_id = t.id;

#Adicione a categoria Guerra ao banco de dados. 
#Atualize o nome da Mídia 2 ou 3 para “Bradock 3”, e atualize o tipo para Guerra e a categoria para Filme
INSERT INTO tipo (nome) VALUES ('Guerra');
UPDATE midia 
    SET nome = 'Bradock 3', 
    tipo_id = (SELECT id FROM tipo WHERE nome = 'Guerra'),
    categoria_id = (SELECT id FROM categoria WHERE nome = 'Filme')
WHERE id = 3;

#Mostre os filmes assistidos (tabela log) com o nome e a data do 
#registro em português, além do nome do cliente que assistiu o filme
SELECT 
    date_format(l.data, '%d/%m/%Y') AS dataPortugues,
    m.nome AS nomeMidia,
    c.nome AS nomeCliente
FROM log l
INNER JOIN cliente c ON l.cliente_id = c.id
INNER JOIN midia m ON l.midia_id = m.id; 

#Mostre os clientes e as datas de quem assistiu o filme 4 ou 5
SELECT 
    date_format(l.data, '%d/%m/%Y') AS dataPortugues,
    c.nome AS nomeCliente
FROM log l
INNER JOIN cliente c ON l.cliente_id = c.id
INNER JOIN midia m ON l.midia_id = m.id
WHERE l.midia_id = 4 OR l.midia_id = 5;

#Busque as mídias assistidas entre 01/11/2023 e 10/11/2023
SELECT * FROM log WHERE data BETWEEN '2020-11-01' AND '2023-11-10';

#Liste todas as mídias, mostrando sua categoria e tipo (descrição)
SELECT 
    m.* ,
    t.nome AS tipo,
    c.nome AS descricao
FROM midia m
INNER JOIN categoria c ON m.categoria_id = c.id
INNER JOIN tipo t ON m.tipo_id = t.id;

#Liste todos as mídias, com sua categoria e tipo (descrição) 
#assistidos por algum cliente, mostrando também o seu nome
SELECT  
    m.*,
    t.nome AS tipo,
    c.nome AS categoria,
    cl.nome AS cliente 
    FROM log l
INNER JOIN cliente cl ON l.cliente_id = cl.id
INNER JOIN midia m ON l.midia_id = m.id
INNER JOIN categoria c ON m.categoria_id = c.id
INNER JOIN tipo t ON m.tipo_id = t.id;