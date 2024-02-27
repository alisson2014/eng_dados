CREATE OR REPLACE VIEW vw_todos_clientes AS
SELECT 
    c.id AS id_cliente,
	c.nome,
    c.cpf,
    GET_GENDER(c.sexo) AS genero,
    c.data_nascimento,
    c.telefone,
    c.email,
   	vwe.cep,
    vwe.logradouro,
    vwe.bairro,
    vwe.cidade,
    vwe.sigla_estado
FROM cliente c
	INNER JOIN vw_todos_enderecos vwe ON c.endereco_id = vwe.id
ORDER BY data_nascimento;