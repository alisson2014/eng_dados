/* 1. Trazer todos os produtos com as respectivas categorias. */

SELECT 
    vwp.id,
    vwp.nome,
    CURRENCY_FORMAT(vwp.valor_ajustado) AS valor,
    vwp.categoria 
FROM vw_todos_produtos_hoje vwp;

/* 2. Trazer todos os produtos acima de 500 reais. */

SELECT 
    vwp.id,
    vwp.nome,
    CURRENCY_FORMAT(vwp.valor_ajustado) AS valor,
    vwp.categoria 
FROM vw_todos_produtos_hoje vwp
WHERE vwp.valor_ajustado > 500;

/* 3. Trazer todos os produtos da categoria 'Eletrônicos'. */

SET @idEletronico = (SELECT c.id FROM categoria c WHERE c.nome = 'Eletrônicos');

SELECT 
    vwp.id,
    vwp.nome,
    CURRENCY_FORMAT(vwp.valor_ajustado) AS valor,
    vwp.categoria 
FROM vw_todos_produtos_hoje vwp
WHERE vwp.categoria_id = @idEletronico;

/* 4. Trazer o total de produtos cadastrados. */
SELECT COUNT(vwp.id) AS produtos_cadastrados FROM vw_todos_produtos_hoje vwp;

/* 5. Trazer o total de produtos cadastrados por categoria. */
SELECT 
	vwp.categoria,
	COUNT(vwp.id) AS produtos_cadastrados 
FROM vw_todos_produtos_hoje vwp
GROUP BY vwp.categoria_id;

/* 6. Trazer os produtos de menor e maior valor. */

# Solução usando ORDER BY em conjunto com LIMIT
(
    SELECT 
        'menor_valor' AS tipo,
        vwp.nome,
        CURRENCY_FORMAT(vwp.valor_ajustado) AS valor 
    FROM vw_todos_produtos_hoje vwp
    ORDER BY vwp.valor_ajustado ASC
    LIMIT 1
) UNION (
    SELECT 
        'maior_valor' AS tipo,
        vwp.nome,
        CURRENCY_FORMAT(vwp.valor_ajustado) AS valor
    FROM vw_todos_produtos_hoje vwp
    ORDER BY vwp.valor_ajustado DESC
    LIMIT 1
);

# Solução usando as funções MIN e MAX e subconsultas para selecionar o nome do produto
SELECT 
	'menor_valor' AS tipo,
	(SELECT nome FROM vw_todos_produtos_hoje WHERE valor_ajustado = (SELECT MIN(valor_ajustado) FROM vw_todos_produtos_hoje)) AS nome,
	MIN(vwp.valor_ajustado) AS valor
FROM vw_todos_produtos_hoje vwp
UNION
SELECT 
	'maior_valor' AS tipo,
	(SELECT nome FROM vw_todos_produtos_hoje WHERE valor_ajustado = (SELECT MAX(valor_ajustado) FROM vw_todos_produtos_hoje)) AS nome,
  	MAX(vwp.valor_ajustado) AS valor
FROM vw_todos_produtos_hoje vwp;

/* 7. Trazer todos os produtos que possuem um reajuste ativo. */
SELECT 
	* 
FROM vw_todos_produtos_hoje vwp 
	INNER JOIN correcao_produto cp ON vwp.id = cp.produto_id
WHERE CURDATE() BETWEEN cp.data_inicio AND cp.data_fim;

/* 8. Trazer todos os produtos com reajuste previsto. */
SELECT 
	* 
FROM vw_todos_produtos_hoje vwp 
	INNER JOIN correcao_produto cp ON vwp.id = cp.produto_id
WHERE cp.data_inicio > CURDATE();

/* 9. Trazer todos os produtos que receberão um aumento no reajuste. */
SELECT 
	* 
FROM vw_todos_produtos_hoje vwp 
	INNER JOIN correcao_produto cp ON vwp.id = cp.produto_id
WHERE percentual > 1;

/* 10. Trazer todos os produtos que receberão um orçamento no ultimo mês. */
SELECT * FROM vw_todos_orcamentos WHERE MONTH(data) = (MONTH(CURDATE()) - 1);