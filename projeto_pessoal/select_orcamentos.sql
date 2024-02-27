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