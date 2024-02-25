# VIEW PARA RETORNAR OS DADOS DOS ORÇAMENTOS:

CREATE VIEW vw_todos_orcamentos AS
SELECT 
	o.id,
	o.data,
    c.nome AS nome_cliente,
    p.nome AS nome_produto,
    p.valor,
    po.quantidade,
    SUM(p.valor * po.quantidade) AS total
FROM orcamento o
	INNER JOIN cliente c ON o.cliente_id = c.id
    INNER JOIN produtosorcamento po ON o.id = po.orcamento_id
    INNER JOIN produto p ON po.produto_id = p.id
GROUP BY o.id
ORDER BY o.data DESC;