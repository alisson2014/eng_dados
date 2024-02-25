/* 1. Trazer todos os produtos com as respectivas categorias. */
SELECT 
    vwp.id,
    vwp.nome,
    vwp.valorMoeda,
    vwp.categoria 
FROM vw_todos_produtos vwp;

/* 2. Trazer todos os produtos acima de 500 reais. */
SELECT 
    vwp.id,
    vwp.nome,
    vwp.valorMoeda,
    vwp.categoria 
FROM vw_todos_produtos vwp
WHERE vwp.valorNumerico > 500;

/* 3. Trazer todos os produtos da categoria 'Eletrônicos'. */
SET @idEletronico = (SELECT c.id FROM categoria c WHERE c.nome = 'Eletrônicos');

SELECT 
    vwp.id,
    vwp.nome,
    vwp.valorMoeda,
    vwp.categoria 
FROM vw_todos_produtos vwp
WHERE vwp.categoria_id = @idEletronico;

/* 4. Trazer o total de produtos cadastrados. */
SELECT COUNT(vwp.id) AS produtos_cadastrados FROM vw_todos_produtos vwp;

/* 5. Trazer o total de produtos cadastrados por categoria. */
SELECT 
	vwp.categoria,
	COUNT(vwp.id) AS produtos_cadastrados 
FROM vw_todos_produtos vwp
GROUP BY vwp.categoria_id;

/* 6. Trazer os produtos de menor e maior valor. */

# Solução usando ORDER BY em conjunto com LIMIT
(
    SELECT 
        'menor_valor' AS tipo,
        vwp.nome,
        vwp.valorMoeda AS valor
    FROM vw_todos_produtos vwp
    ORDER BY vwp.valorNumerico ASC
    LIMIT 1
) UNION (
    SELECT 
        'maior_valor' AS tipo,
        vwp.nome,
        vwp.valorMoeda AS valor
    FROM vw_todos_produtos vwp
    ORDER BY vwp.valorNumerico DESC
    LIMIT 1
);

# Solução usando as funções MIN e MAX e subconsultas para selecionar o nome do produto
SELECT 
	'menor_valor' AS tipo,
	(SELECT nome FROM vw_todos_produtos WHERE valorNumerico = (SELECT MIN(valorNumerico) FROM vw_todos_produtos)) AS nome,
	MIN(vwp.valorNumerico) AS valor
FROM vw_todos_produtos vwp
UNION
SELECT 
	'maior_valor' AS tipo,
	(SELECT nome FROM vw_todos_produtos WHERE valorNumerico = (SELECT MAX(valorNumerico) FROM vw_todos_produtos)) AS nome,
  	MAX(vwp.valorNumerico) AS valor
FROM vw_todos_produtos vwp;