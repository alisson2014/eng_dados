START TRANSACTION;

# CRIAR A TABELA INICIAL DE CLIENTE:
CREATE TABLE IF NOT EXISTS cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('m', 'f') NULL COMMENT 'm = masculino, f = feminino e NULL = não definido',
    data_nascimento DATE NOT NULL
);

# POPULAR A TABELA:
INSERT INTO cliente (cpf, nome, sexo, data_nascimento) VALUES 
('119.466.877-17', 'Juan Oliveira', 'm', '2001-02-12'),
('411.651.788-15', 'Ana júlia', NULL, '1999-11-02'),
('155.468.880-01', 'João gustavo', 'm', '2002-12-24'),
('115.016.897-10', 'Gustavo arcanjo', 'm', '2001-11-13'),
('411.651.788-19', 'Jennifer ferreira', 'f', '1996-06-07'),
('153.185.020-11', 'Alisson Vinicius', 'm', '1995-05-30'),
('188.125.780-55', 'Erica paes', 'f', '2003-08-22');


# ADICIONAR NOVAS COLUNAS DE EMAIL E TELEFONE

ALTER TABLE cliente 
ADD email VARCHAR(60),
ADD telefone VARCHAR(20) NULL;

CREATE TEMPORARY TABLE tmp_infos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(60) UNIQUE NOT NULL,
    telefone VARCHAR(20) NULL
);

INSERT INTO tmp_infos (email, telefone) VALUES
('juan2001@gmail.com', '(44) 99822-1541'),
('ana5@hotmail.com', '(55) 97114-4511'),
('joao489@gmail.com', '(15) 77499-1541'),
('gustaU5@gmail.com', NULL),
('asterisco@hotmail.com', '(41) 99192-0821'),
('teste45698@gmail.com', NULL),
('momosuke466@gmail.com', '(44) 99858-5166');

UPDATE cliente c
INNER JOIN tmp_infos tmp ON c.id = tmp.id
SET c.email = tmp.email, c.telefone = tmp.telefone;

DROP TEMPORARY TABLE IF EXISTS tmp_infos;

ALTER TABLE cliente
MODIFY email VARCHAR(60) NOT NULL,
ADD CONSTRAINT unique_email UNIQUE (email);


# CRIAR TABELA DE ESTADOS:
CREATE TABLE IF NOT EXISTS estado (
    id INT AUTO_INCREMENT PRIMARY KEY,
    uf CHAR(2) NOT NULL UNIQUE,
    descricao VARCHAR(50) NOT NULL
);

# POPULAR A TABELA DE ESTADOS:
INSERT INTO estado (uf, descricao) VALUES
('AC', 'Acre'),
('AL', 'Alagoas'),
('AP', 'Amapá'),
('AM', 'Amazonas'),
('BA', 'Bahia'),
('CE', 'Ceará'),
('DF', 'Distrito Federal'),
('ES', 'Espírito Santo'),
('GO', 'Goiás'),
('MA', 'Maranhão'),
('MT', 'Mato Grosso'),
('MS', 'Mato Grosso do Sul'),
('MG', 'Minas Gerais'),
('PA', 'Pará'),
('PB', 'Paraíba'),
('PR', 'Paraná'),
('PE', 'Pernambuco'),
('PI', 'Piauí'),
('RJ', 'Rio de Janeiro'),
('RN', 'Rio Grande do Norte'),
('RS', 'Rio Grande do Sul'),
('RO', 'Rondônia'),
('RR', 'Roraima'),
('SC', 'Santa Catarina'),
('SP', 'São Paulo'),
('SE', 'Sergipe'),
('TO', 'Tocantins');

# CRIAR TABELA DE CIDADES:
CREATE TABLE IF NOT EXISTS cidade (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE,
    estado_id INT NOT NULL,
    FOREIGN KEY (estado_id) REFERENCES estado(id)
);

# POPULAR TABELA DE CIDADES:
INSERT INTO cidade (nome, estado_id) VALUES 
('Londrina', 16),
('Canoas', 21),
('Colombo', 16),
('São Paulo', 25),
('Santana de Parnaíba', 25),
('Ipatinga', 13),
('Campo Mourão', 16);

# CRIAR A TABELA INICIAL DE ENDEREÇO:
CREATE TABLE IF NOT EXISTS endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rua VARCHAR(80) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    bairro VARCHAR(80) NOT NULL,
    cidade_id INT NOT NULL,
    cep VARCHAR(9) NOT NULL UNIQUE,
    FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

# POPULAR TABELA DE ENDEREÇOS:
INSERT INTO endereco (rua, numero, bairro, cidade_id, cep) VALUES 
('Rua Professor João Cândido', '150b', 'Centro', 1, '86010-001'),
('Travessa Dona Leopoldina', '1616', 'Fátima', 2, '92200-590'),
('Rua Antônio Falavinha', '11', 'São Gabriel', 3, '83406-190'),
('Rua Lucas Gassel', '18c', 'Vila Guarani (Z Sul)', 4, '04310-090'),
('Alameda das Roseiras', '109', 'Morada dos Pinheiros (Aldeia da Serra)', 5, '06519-315'),
('Rua dos Caldeus', '80', 'Canaã', 6, '35164-143'),
('Rua Getúlio Ribeiro de Carvalho', '150', 'Conjunto Cafezal 1', 1, '86049-160');

# ADICIONAR ENDEREÇOS NOS CLIENTES CADASTRADOS:
ALTER TABLE cliente
ADD COLUMN endereco_id INT NULL;

UPDATE cliente 
LEFT JOIN endereco e ON cliente.id = e.id
SET cliente.endereco_id = e.id
WHERE cliente.id IN(2, 3, 4, 6, 7);

UPDATE cliente SET endereco_id = 1 WHERE id IN(1, 5);
UPDATE cliente SET endereco_id = 5 WHERE id = 7;

ALTER TABLE cliente
MODIFY endereco_id INT NOT NULL,
ADD FOREIGN KEY (endereco_id) REFERENCES endereco(id);

# CRIAR TABELA DE CATEGORIA:
CREATE TABLE IF NOT EXISTS categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(50) NOT NULL UNIQUE 
);

# POPULAR TABELA DE CATEGORIA:
INSERT INTO categoria (nome) VALUES 
('Eletrônicos'),
('Eletrodomésticos'),
('Segurança'),
('Automação'),
('Ferramentas'),
('Moda');

# CRIAR TABELA DE PRODUTOS:
CREATE TABLE IF NOT EXISTS produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    valor DECIMAL(8, 2) NOT NULL,
    categoria_id INT NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

# POPULAR TABELA DE PRODUTOS:
INSERT INTO produto (nome, valor, categoria_id) VALUES 
('Iphone 12', 3899.90, 1),
('Gelageira Consul', 3599.99, 2),
('Câmera de segurança', 600, 3),
('Alexa', 899.90, 4),
('Furadeira com bateria', 290.50, 5),
('Tênis nike preto', 260, 6),
('Samsung Galaxy S22+', 2999.10, 1),
('Iphone 14 pro max', 6900.89, 1),
('Kit 5 chaves multiuso', 459.90, 5),
('Aspirador robô', 990.99, 2),
('Kit 3 camisas dry fit', 200, 6);

# CRIAR A TABELA DE ORÇAMENTOS
CREATE TABLE IF NOT EXISTS orcamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    data DATE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id) 
);

# POPULAR TABELA DE ORÇAMENTOS:
INSERT INTO orcamento (cliente_id, data) VALUES 
(4, '2024-02-15'),
(5, '2024-02-22'),
(6, '2024-02-24'),
(6, '2024-02-25'),
(7, '2023-09-25');

# CRIAR TABELA DE PRODUTOS ORÇAMENTOS:
CREATE TABLE IF NOT EXISTS produtosorcamento (
    produto_id INT(11) NOT NULL,
    orcamento_id INT(11) NOT NULL,
    quantidade INT(11) NOT NULL,
    PRIMARY KEY (produto_id, orcamento_id),
    KEY orcamento_id(orcamento_id),
    CONSTRAINT produtosorcamento_ibfk_1 FOREIGN KEY (orcamento_id) REFERENCES orcamento(id),
    CONSTRAINT produtosorcamento_ibfk_2 FOREIGN KEY (produto_id) REFERENCES produto(id)
);

# POPULAR A TABELA DE ProdutosOrcamentos:
INSERT INTO produtosorcamento (orcamento_id, produto_id, quantidade) VALUES 
(1, 1, 1),
(1, 4, 2),
(2, 3, 3),
(3, 2, 1),
(4, 10, 2),
(5, 6, 2);

COMMIT;