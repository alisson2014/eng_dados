CREATE OR REPLACE VIEW vw_todos_produtos AS
SELECT 
	p.id, 
    p.nome, 
    IF((CURDATE() BETWEEN cp.data_inicio AND cp.data_fim), ROUND(p.valor * cp.percentual, 2), p.valor) AS valorRecalculado,
    p.categoria_id,
    c.nome AS categoria
FROM produto p
	LEFT JOIN correcao_produto cp ON p.id = cp.produto_id
	INNER JOIN categoria c ON p.categoria_id = c.id;