CREATE VIEW vw_todos_clientes AS
SELECT 
    c.id AS id_cliente,
	c.nome,
    c.cpf,
    GET_GENDER(c.sexo) AS genero,
    DATE_FORMAT(c.data_nascimento, '%d/%m/%Y') AS dataNascimento,
    IFNULL(c.telefone, 'Não cadastrado') AS telefone,
    c.email,
   	vwe.cep,
    vwe.logradouro,
    vwe.bairro,
    vwe.cidade,
    vwe.estado
FROM cliente c
	INNER JOIN vw_todos_enderecos vwe ON c.endereco_id = vwe.id
ORDER BY data_nascimento;