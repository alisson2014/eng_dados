/* 1. Trazer o valor total dos orçamentos do cliente de id 6. */
SELECT 
    SUM(vwo.total) AS total_orcamentos 
FROM vw_todos_orcamentos vwo 
WHERE vwo.id_cliente = 6;

/* 2. Trazer o valor total dos orçamentos feitos em 2024. */
SELECT 
    SUM(vwo.total) AS total_orcamentos
FROM vw_todos_orcamentos vwo 
WHERE YEAR(vwo.data) = 2024; 


/* 3. Selecione a média de todos os orçamentos feitos em 2024, o menor e o maior orçamento. */

SELECT
	'media_2024' AS tipo,
	ROUND(AVG(vto.total), 2) AS valor
FROM vw_todos_orcamentos vto
WHERE YEAR(vto.data) = 2024
UNION
SELECT
	'menor_2024' AS tipo,
	MIN(vto.total) AS valor
FROM vw_todos_orcamentos vto
WHERE YEAR(vto.data) = 2024
UNION
SELECT
	'maior_2024' AS tipo,
	MAX(vto.total) AS valor
FROM vw_todos_orcamentos vto
WHERE YEAR(vto.data) = 2024;