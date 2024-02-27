/* 
    1. Trazer todos os clientes, com cpf, com a data de nascimento formatada 'd/m/Y' e
    com o respectivo sexo 'masculino',  'feminino' ou 'não informado'. Ordenando a seleção
    do mais velho até o mais novo.
*/

SELECT * FROM vw_todos_clientes;

/* 2. Trazer o total de clientes cadastrados por sexo. */

SELECT 
	GET_GENDER(sexo) AS genero,
    COUNT(id) AS total_clientes
FROM cliente
GROUP BY sexo
ORDER BY total_clientes;

/* 3. Trazer todos os clientes nascidos no ano 2001 */

SELECT 
    *
FROM vw_todos_clientes 
    WHERE YEAR(data_nascimento) = 2001;

/* 4. Selecionar todos os clientes que não possuem telefone cadastrado */

SELECT 
	id_cliente,
    nome,
    cpf,
    genero,
    DATE_FORMAT(data_nascimento, '%d/%m/%Y') AS dataNascimento,
    email
FROM vw_todos_clientes 
WHERE telefone IS NULL
ORDER BY id_cliente;

/* 5. Selecionar todos os clientes que usam o host de email 'hotmail' */

SELECT 
	*
FROM vw_todos_clientes 
	WHERE email LIKE '%@hotmail%';

/* 6. Selecionar todos os clientes que moram no estado do paraná. */

SELECT * FROM vw_todos_clientes WHERE sigla_estado = 'PR'; 

/* 6. Selecionar todos os clientes que moram no estado de são paulo ou no paraná. */

SELECT * FROM vw_todos_clientes WHERE sigla_estado IN('PR', 'SP'); 

/* 6. Selecionar todos os clientes que moram no estado de são paulo ou no paraná que nasceram antes dos anos 2000. */

SELECT 
    * 
FROM vw_todos_clientes 
    WHERE sigla_estado IN('PR', 'SP') AND YEAR(data_nascimento) < 2000;

/* 7. Selecione todos os clientes nascidos depois do mês 10. */

SELECT 
    *
FROM vw_todos_clientes
    WHERE MONTH(data_nascimento) > 10;

/* 8. Selecione a contagem de clientes que usa hotmail e gmail. */

SELECT 
	'gmail' as host,
	COUNT(id_cliente) AS total
FROM vw_todos_clientes 
WHERE email LIKE '%@gmail%'
UNION 
SELECT
	'hotmail' AS host,
   	COUNT(id_cliente) AS total
FROM vw_todos_clientes 
WHERE email LIKE '%@hotmail%';