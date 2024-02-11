#Criar um banco de dados chamado videogame_seunome
CREATE DATABASE videogame_alisson;

#Usar o banco de dados (Utilizar o USE)
USE videogame_alisson;

#Crie as tabelas console, tipo, produto, cliente, venda e item. Todos os campos são NOT NULL.
#As tabelas devem ser formadas pelo nome da tabela e seu nome
CREATE TABLE IF NOT EXISTS console_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(25) NOT NULL
);

CREATE TABLE IF NOT EXISTS tipo_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    descricao VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS cliente_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(40) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS produto_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    valor FLOAT NOT NULL,
    console_id INT NOT NULL,
    tipo_id INT NOT NULL,
    FOREIGN KEY (console_id) REFERENCES console_alisson(id),
    FOREIGN KEY (tipo_id) REFERENCES tipo_alisson(id)
);

CREATE TABLE IF NOT EXISTS venda_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    data DATE NOT NULL,
    cliente_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente_alisson(id)
);

CREATE TABLE IF NOT EXISTS item_alisson (
    id INT PRIMARY KEY AUTO_INCREMENT,
    venda_id INT NOT NULL,
    produto_id INT NOT NULL,
    quantidade INT NOT NULL,
    valor FLOAT NOT NULL,
    FOREIGN KEY (produto_id) REFERENCES produto_alisson(id),
    FOREIGN KEY (venda_id) REFERENCES venda_alisson(id)
);

#Adicione ao menos 3 cadastros para console, tipo, produto e cliente
INSERT INTO console_alisson (nome) VALUES 
('Nintendo'),
('Playstation'),
('X-box');

INSERT INTO tipo_alisson (descricao) VALUES 
('Console'),
('Perifericos'),
('Jogos');

INSERT INTO produto_alisson (nome, valor, console_id, tipo_id) VALUES 
('Produto teste 1', 40, 1, 3),
('Produto teste 2', 60, 2, 2),
('Produto teste 2', 10, 3, 1);

INSERT INTO cliente_alisson (nome, email) VALUES 
('João', 'joao@email.com'),
('Juscelino', 'jusc2015@gmail.com'),
('Douglas', 'douglas123@gmail.com');

#Adicione ao menos 5 vendas, com 2 produtos em cada item de venda
INSERT INTO venda_alisson (data, cliente_id) VALUES 
('2023-12-02', 1),
('2023-10-10', 2),
('2022-12-10', 2),
('2023-01-10', 3),
('2023-09-10', 1);

INSERT INTO item_alisson (venda_id, produto_id, quantidade, valor) VALUES 
(1, 2, 2, 120),
(1, 1, 1, 40),
(2, 3, 2, 80),
(2, 3, 2, 20),
(3, 1, 1, 40),
(3, 2, 1, 60),
(4, 1, 1, 40),
(4, 3, 1, 10),
(5, 2, 2, 120),
(5, 1, 2, 40);

#Mostre todas as vendas realizadas, com a data no formato brasileiro
SELECT 
    date_format(v.data, '%d/%m/%Y') AS dataFormatada,
    c.nome AS nomeCliente,
    v.id AS idVenda
FROM venda_alisson v
INNER JOIN cliente_alisson c ON v.cliente_id = c.id
ORDER BY c.nome;

#Mostre todos as vendas realizadas para o cliente número 2
SELECT 
    v.*,
    c.nome AS nomeCliente,
    i.produto_id,
    p.nome AS nomeProduto
FROM venda_alisson v
INNER JOIN cliente_alisson c ON v.cliente_id = c.id
INNER JOIN item_alisson i ON v.id = i.venda_id
INNER JOIN produto_alisson p ON i.produto_id = p.id
WHERE cliente_id = 2
GROUP BY v.id;

#Mostre todos os produtos vendidos para a venda 2, com seu nome
SELECT 
    i.produto_id,
    i.venda_id,
    p.nome AS nomeProduto,
    p.valor AS valorProduto,
    c.nome AS nomeConsole,
    t.descricao 
FROM item_alisson i 
INNER JOIN produto_alisson p ON i.produto_id = p.id
INNER JOIN console_alisson c ON p.console_id = c.id
INNER JOIN tipo_alisson t ON p.tipo_id = t.id
WHERE venda_id = 2;