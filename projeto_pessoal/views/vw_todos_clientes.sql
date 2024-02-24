CREATE VIEW vw_todos_clientes AS
SELECT 
    id,
	nome,
    cpf,
    GET_GENDER(sexo) AS genero,
    DATE_FORMAT(data_nascimento, '%d/%m/%Y') AS dataNascimento,
    IFNULL(telefone, 'Não cadastrado') AS telefone,
    email
FROM cliente
ORDER BY data_nascimento;