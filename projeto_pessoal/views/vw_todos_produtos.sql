CREATE OR REPLACE VIEW vw_todos_produtos AS
SELECT 
	p.id, 
    p.nome, 
    CALCULATE_ADJUSTMENT(p.valor, cp.data_inicio, cp.data_fim, cp.percentual) AS valorFinal,
    p.categoria_id,
    c.nome AS categoria,
    cp.data_inicio AS inicio_reajuste,
    cp.data_fim AS fim_reajuste
FROM produto p
	LEFT JOIN correcao_produto cp ON p.id = cp.produto_id
	INNER JOIN categoria c ON p.categoria_id = c.id;