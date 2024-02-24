#QUICKDRAW
CREATE VIEW vw_todos_clientes AS
SELECT 
    c.id AS id_cliente,
	c.nome,
    c.cpf,
    GET_GENDER(c.sexo) AS genero,
    DATE_FORMAT(c.data_nascimento, '%d/%m/%Y') AS dataNascimento,
    IFNULL(c.telefone, 'Não cadastrado') AS telefone,
    c.email,
    e.cep,
    CONCAT(e.rua, ', ', e.numero) AS logradouro,
    e.bairro,
    cd.nome AS cidade,
    uf.descricao AS estado
FROM cliente c
	INNER JOIN endereco e ON c.endereco_id = e.id
    INNER JOIN cidade cd ON cd.id = e.cidade_id
    INNER JOIN estado uf ON cd.estado_id = uf.id
ORDER BY data_nascimento;