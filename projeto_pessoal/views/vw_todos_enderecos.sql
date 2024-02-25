CREATE VIEW vw_todos_enderecos AS
SELECT 
	e.id,
	e.cep,
    CONCAT(e.rua, ', ', e.numero) AS logradouro,
    e.bairro,
    cd.id as cidade_id,
    cd.nome AS cidade,
    uf.id as uf_id,
    uf.descricao AS estado,
    uf.uf AS sigla_estado
FROM endereco e
	INNER JOIN cidade cd ON e.cidade_id = cd.id
    INNER JOIN estado uf ON cd.estado_id = uf.id;