# 1) Quantidade de produtos vendidos ?
SELECT 
	SUM(p.QUANTIDADE) AS quantidade_total
FROM produto p
	INNER JOIN itens_venda iv ON iv.codproduto = p.CODIGO;


# 2) Quantidade de vendas por vendedor ?

SET @qtdvenda := 0; 

SELECT 
	ve.nome as vendedor,
	COUNT(v.codVenda) AS qtd_vendas_vendedor
FROM vendas v
	RIGHT JOIN vendedores ve ON v.codvendedor = ve.codvendedor
GROUP BY ve.codvendedor
HAVING COUNT(v.codvenda) >= @qtdvenda
ORDER BY qtd_vendas_vendedor DESC;


# 3) Melhor vendedor nos 3 primeiros meses do ano ? 


# 4) A melhor venda ( valor mais alto) ?

SELECT MAX(vm.valor_mais_alto) AS melhor_venda FROM (
	SELECT 
		SUM(p.QUANTIDADE * p.VALOR) AS valor_mais_alto
    FROM vendas v
        INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
        INNER JOIN produto p ON p.CODIGO = iv.codproduto
    GROUP BY v.codvenda
) vm;


# 5) Qual é o valor da Média de vendas por mês ? 
SELECT AVG(vm.total_mes) AS media_mes FROM (
	SELECT 
        SUM(p.QUANTIDADE * p.VALOR) AS total_mes
    FROM vendas v
        INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
        INNER JOIN produto p ON iv.codproduto = p.CODIGO
    GROUP BY MONTH(v.datavenda)
) vm;


# 6) Qual cidade compra mais ?
SELECT 
	ci.descricao as cidade,
	COUNT(v.codvenda) AS total_vendas
FROM produto p
	INNER JOIN itens_venda iv ON iv.codproduto = p.CODIGO
    INNER JOIN vendas v ON v.codvenda = iv.codvenda
    INNER JOIN cliente c ON v.codcliente = c.codcliente
    INNER JOIN cidades ci ON c.codcidade = ci.codcidade
GROUP BY c.codcidade, ci.descricao
ORDER BY total_vendas DESC
LIMIT 1;


# 7) Qual é o melhor cliente ?

# 8) O pior vendedor ?
SELECT 
	ve.nome as vendedor,
	COUNT(v.codVenda) AS qtd_vendas_vendedor
FROM vendas v
	RIGHT JOIN vendedores ve ON v.codvendedor = ve.codvendedor
GROUP BY ve.codvendedor
HAVING COUNT(v.codvenda) >= @qtdvenda
ORDER BY qtd_vendas_vendedor ASC
LIMIT 1;


/** 9) Comissão de 10% para o vendedor que seu total 
de vendas que for acima da média do mês de 
todos vendedores ? */