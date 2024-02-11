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
