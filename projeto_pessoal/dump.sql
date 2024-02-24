# CRIAR A TABELA INICIAL DE CLIENTE:
CREATE TABLE IF NOT EXISTS cliente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nome VARCHAR(100) NOT NULL,
    sexo ENUM('m', 'f') NULL COMMENT 'm = masculino, f = feminino e NULL = não definido',
    data_nascimento DATE NOT NULL
);

# POPULAR A TABELA:
START TRANSACTION;
INSERT INTO cliente (cpf, nome, sexo, data_nascimento) VALUES 
('119.466.877-17', 'Juan Oliveira', 'm', '2001-02-12'),
('411.651.788-15', 'Ana júlia', NULL, '1999-11-02'),
('155.468.880-01', 'João gustavo', 'm', '2002-12-24'),
('115.016.897-10', 'Gustavo arcanjo', 'm', '2001-11-13'),
('411.651.788-19', 'Jennifer ferreira', 'f', '1996-06-07'),
('153.185.020-11', 'Alisson Vinicius', 'm', '1995-05-30'),
('188.125.780-55', 'Erica paes', 'f', '2003-08-22');
COMMIT;


# ADICIONAR NOVAS COLUNAS DE EMAIL E TELEFONE
START TRANSACTION;

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

COMMIT;