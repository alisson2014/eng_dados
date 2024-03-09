CREATE OR REPLACE VIEW vw_todos_clientes AS
SELECT 
    c.id,
	c.nome AS nome_cliente,
    c.cpf,
    c.sexo,
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