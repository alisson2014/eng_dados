#Função auxiliar para buscar o codigo da classificação via descrição:
DELIMITER //

CREATE FUNCTION IF NOT EXISTS codigoClassificacao(c_descricao VARCHAR(200))
RETURNS VARCHAR(3)
BEGIN
    DECLARE codigo_result VARCHAR(3);
    
    SELECT c.CODIGO INTO codigo_result 
    FROM classificacao c 
    WHERE c.DESCRICAO = c_descricao;
    
    RETURN codigo_result;
END//

DELIMITER ;


#1 - Retornar os produtos da Classificação 003 e que a unidade de medida não seja 'UN'
SELECT 
    * 
    FROM produto 
WHERE CODIGO_CLASSIFICACAO = '003' AND NOT(UNIDADE = 'UN');

#Contador:
SELECT 
    COUNT(*) AS total_registros 
    FROM produto 
WHERE CODIGO_CLASSIFICACAO = '003' AND NOT(UNIDADE = 'UN');


/* 2 - Retornar os produtos da Classificação 003, com a unidade de medida 'UN'
em que a quantidade seja entre 5 e 7 com o valor menor que 10;
R: 27 registros; */
SELECT 
	* 
	FROM produto 
WHERE CODIGO_CLASSIFICACAO = '003' AND UNIDADE = 'UN' AND QUANTIDADE BETWEEN 5 AND 7 AND VALOR < 10;

#Contador
SELECT 
	COUNT(*) AS total_registros 
	FROM produto 
WHERE CODIGO_CLASSIFICACAO = '003' AND UNIDADE = 'UN' AND QUANTIDADE BETWEEN 5 AND 7 AND VALOR < 10;


#3 - Valor total dos 'biscoito' da base de dados;
SELECT 
    SUM(VALOR * QUANTIDADE) AS VALOR_TOTAL 
    FROM produto 
WHERE DESCRICAO LIKE '%biscoito%';


#4 - Validar se existe algum 'martelo' que não pertença a classificação material de Construção;
SELECT 
	IF(COUNT(*) > 0, CONCAT('EXISTE: ', COUNT(*)), 'NÃO EXISTE') AS STATUS 
    FROM produto 
WHERE DESCRICAO LIKE '%martelo%' 
AND NOT(CODIGO_CLASSIFICACAO = '001');

#5 - Retornar os produtos da classificação EPI que estejam em menos de 5 caixas;
SELECT 
	p.* 
    FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('EPI/EPC') AND (UNIDADE = 'CX' AND QUANTIDADE < 5);

#Contador
SELECT 
	COUNT(*) AS total_registros 
    FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('EPI/EPC') AND (UNIDADE = 'CX' AND QUANTIDADE < 5);


#6 - Retornar os produtos da Classificação EPI que NÃO ESTEJA em caixas e sua quantidade esteja em 10 e 50;
SELECT 
	*
    FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('EPI/EPC') AND (UNIDADE <> 'CX' AND QUANTIDADE BETWEEN 10 AND 50);

#Contador
SELECT 
	COUNT(*) AS total_registros
    FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = (SELECT c.CODIGO FROM classificacao c WHERE c.DESCRICAO = 'EPI/EPC') AND (UNIDADE <> 'CX' AND QUANTIDADE BETWEEN 10 AND 50);

/*7 - Retornar todos registros da classificação UNIFORMES com o nome
'camiseta e todos os produtos da classificação MATERIAL ESPORTIVO
e com nome 'bola' */
SELECT 
	* 
	FROM produto p 
WHERE P.CODIGO_CLASSIFICACAO = codigoClassificacao('UNIFORMES') AND p.DESCRICAO LIKE '%camiseta%'
UNION
SELECT 
	* 
	FROM produto p 
WHERE P.CODIGO_CLASSIFICACAO = codigoClassificacao('Materiais Esportivos') AND p.DESCRICAO LIKE '%bola%'
ORDER BY CODIGO_CLASSIFICACAO, DESCRICAO;

/*8 - Retornar a média do valor dos produtos que a quantidade esteja entre
2 e 4, com valor inferior a 50, que não seja material de construção e que
não seja um 'copo'; */
SELECT 
	AVG(p.VALOR) AS media_valor
	FROM produto p 
WHERE p.QUANTIDADE BETWEEN 2 AND 4 
AND p.VALOR < 50
AND p.CODIGO_CLASSIFICACAO <> codigoClassificacao('Materiais de Construção') AND p.DESCRICAO NOT LIKE '%copo%';

#9 - Retornar o quantidade total de pacotes (PCT) dos produtos alimenticios
SELECT 
	SUM(p.QUANTIDADE) AS qtd_total
FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('Produtos Alimentícios') AND p.UNIDADE = 'PCT';

/*10 - Retornar apenas o numero total de produtos cadastrados com
unidade pacote e que seja da classificação de alimentos
R: 23 produtos; */
SELECT 
	COUNT(*) AS qtd_total
FROM produto p 
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('Produtos Alimentícios') AND p.UNIDADE = 'PCT';

/*11 - Retornar qual é o maior valor de um produto do estoque, este deve
ser o produto que sua quantidade * valor seja o maior
R: 14832; */


/*12 - Retornar o menor valor de um produto que a quantidade seja maior
que 0 e que a unidade seja ‘UN’ e classificação alimentos
R: 1; */
SELECT 
	MIN(p.VALOR) AS menor_valor 
FROM produto p
	WHERE p.QUANTIDADE > 0
    AND p.UNIDADE = 'UN'
    AND p.CODIGO_CLASSIFICACAO = codigoClassificacao('Produtos Alimentícios');
    

/*13 - Retornar qual é o valor total dos produtos da categoria ‘Material Hospitalares’
R: 406355; */
SELECT 
	SUM(p.VALOR * p.QUANTIDADE) AS valor_total 
FROM produto p WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('Materiais Hospitalares');


/*14 - Retornar TODOS os valores totais por categoria e ordenar por
categoria */
SELECT
    c.CODIGO,
    c.DESCRICAO AS CATEGORIA,
	p.DESCRICAO,
	SUM(p.VALOR * p.QUANTIDADE) AS valor_total 
FROM produto p
	INNER JOIN classificacao c ON c.CODIGO = p.CODIGO_CLASSIFICACAO
GROUP BY p.CODIGO_CLASSIFICACAO
ORDER BY c.DESCRICAO;


/*15 - Retornar todos os tipos de ‘UNIDADE’ da classificação Veterinária
R: 12; */
SELECT
	DISTINCT p.UNIDADE
FROM produto p
WHERE p.CODIGO_CLASSIFICACAO = codigoClassificacao('Veterinária');


/*16 - Contar Quantos produtos são da categoria de Aviamentos por
unidade. EX: (20 produtos - UN; 2 PRODUTOS - PCT) */