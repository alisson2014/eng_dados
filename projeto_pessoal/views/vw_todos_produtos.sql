CREATE OR REPLACE VIEW vw_todos_produtos AS
SELECT 
	p.id, 
    p.nome, 
    p.valor,
    p.categoria_id,
    c.nome AS categoria
FROM produto p
	INNER JOIN categoria c ON p.categoria_id = c.id;