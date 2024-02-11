#1 - Criar um banco de dados com seu nome e sobre nome ex: "JohnnySantos"
CREATE DATABASE IF NOT EXISTS AlissonVinicius;
USE AlissonVinicius;

#Criar criar uma tabela para armazenar registros de pessoas, a mesma deve conter no mínimo 5 atributos
CREATE TABLE IF NOT EXISTS usuario (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(50) NOT NULL UNIQUE,
    data_nascimento DATE NOT NULL,
    sexo enum('m', 'f', 'n') NOT NULL DEFAULT 'n',
);

#3 - Inserir 10 pessoas;
INSERT INTO usuario (nome, email, data_nascimento, sexo) VALUES 
('Ana garcia', 'anagarcia2020@gmail.com', '2001-10-02', 'f'),
('José alberto', 'josealberto020@gmail.com', '2000-11-19', 'm'),
('Johnny santos', 'johnny020@gmail.com', '1997-06-02', 'm'),
('Gabriela pietra', 'gabpit0@gmail.com', '2003-01-06', 'f'),
('Ingryd', 'ingrid0@outlook.com.br', '2000-12-06', 'f'),
('Alisson Gabriel', 'gabalisson@gmail.com', '2003-11-04', 'm'),
('João Kleber', 'joaoklebe@hotmail.com', '1999-03-02', 'n'),
('Evelyn lorraine', 'evelyny@gmail.com', '2005-12-25', 'f'),
('Joana', 'joanacia2020@gmail.com', '2001-12-06', 'f'),
('Burnes Fernandes', 'burnes@hotmail.com', '1988-10-09', 'm');

#4 - Incluir no nome da pessoa que contem "a" no nome um @ no inicio do nome

#Exibe o total de nomes com a letra a
SELECT 
    COUNT(*) AS total_nomes_com_a 
FROM usuario 
    WHERE nome LIKE '%a%';


#Solução exercicio 4:
START TRANSACTION;
UPDATE usuario 
    SET nome = CONCAT('@', nome) 
WHERE id IN (SELECT id FROM usuario WHERE nome LIKE '%a%');
COMMIT;

#5 - Excluir as pessoas do sexo masculino
START TRANSACTION;
DELETE FROM usuario WHERE sexo = 'm';
COMMIT;