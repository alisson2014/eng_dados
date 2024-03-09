CREATE OR REPLACE VIEW vw_todos_produtos_orcamento AS
SELECT 
	p.id, 
    p.nome, 
    CALCULATE_ADJUSTMENT(p.valor, cp.data_inicio, cp.data_fim, cp.percentual, CURDATE()) AS valor_ajustado,
    p.categoria_id,
    c.nome AS categoria
FROM produto p
	LEFT JOIN correcao_produto cp ON p.id = cp.produto_id
	INNER JOIN categoria c ON p.categoria_id = c.id;