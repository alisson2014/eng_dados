/* 
    1. Trazer todos os clientes, com cpf, com a data de nascimento formatada 'd/m/Y' e
    com o respectivo sexo 'masculino',  'feminino' ou 'não informado'. Ordenando a seleção
    do mais velho até o mais novo.
*/

SELECT 
	vtc.nome_cliente,
    vtc.cpf,
    GET_GENDER(vtc.sexo) AS genero,
    DATE_FORMAT(vtc.data_nascimento, "%d/%m/%Y") AS data_nascimento,
    IFNULL(vtc.telefone, "SEM REGISTRO") AS telefone,
    vtc.email,
    vtc.cep,
    vtc.logradouro,
    vtc.bairro,
    vtc.cidade,
    vtc.sigla_estado
FROM vw_todos_clientes vtc
ORDER BY vtc.data_nascimento;

/* 2. Trazer o total de clientes cadastrados por sexo. */

SELECT 
	GET_GENDER(sexo) AS genero,
    COUNT(id) AS total_clientes
FROM cliente
GROUP BY sexo
ORDER BY total_clientes;

/* 3. Trazer todos os clientes nascidos no ano 2001 */

SELECT 
    vtc.*
FROM vw_todos_clientes vtc
    WHERE YEAR(vtc.data_nascimento) = 2001;

/* 4. Selecionar todos os clientes que não possuem telefone cadastrado */

SELECT 
	vtc.id,
    vtc.nome_cliente,
    vtc.cpf,
    GET_GENDER(vtc.sexo) AS genero,
    DATE_FORMAT(vtc.data_nascimento, '%d/%m/%Y') AS dataNascimento,
    vtc.email
FROM vw_todos_clientes vtc
WHERE vtc.telefone IS NULL
ORDER BY vtc.id;

/* 5. Selecionar todos os clientes que usam o host de email 'hotmail' */

SELECT 
	vtc.nome_cliente,
    vtc.cpf,
    GET_GENDER(vtc.sexo) AS genero,
    DATE_FORMAT(vtc.data_nascimento, "%d/%m/%Y") AS data_nascimento,
    IFNULL(vtc.telefone, "SEM REGISTRO") AS telefone,
    vtc.email
FROM vw_todos_clientes vtc
	WHERE vtc.email LIKE '%@hotmail%';

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
	COUNT(id) AS total
FROM vw_todos_clientes 
WHERE email LIKE '%@gmail%'
UNION 
SELECT
	'hotmail' AS host,
   	COUNT(id) AS total
FROM vw_todos_clientes 
WHERE email LIKE '%@hotmail%';

/* 9. Selecione todos os clientes que tem entre 19 e 22 anos de idade. */

SELECT 
	vtc.id,
	vtc.nome_cliente,
    DATE_FORMAT(vtc.data_nascimento, "%d/%m/%Y") AS data_nascimento,
    GET_GENDER(vtc.sexo) AS genero,
    vtc.email,
    vtc.cep,
	TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade 
FROM vw_todos_clientes vtc
HAVING idade BETWEEN 19 AND 22
ORDER BY idade;

/* 10. Selecione todos os clientes que possuem telefone cadastrados e morem no parana. Estes clientes tem que ter mais de 22 anos. */

SELECT 
	vtc.id,
	vtc.nome_cliente,
    DATE_FORMAT(vtc.data_nascimento, "%d/%m/%Y") AS data_nascimento,
    GET_GENDER(vtc.sexo) AS genero,
    vtc.email,
    vtc.cep,
    vtc.telefone,
	TIMESTAMPDIFF(YEAR, data_nascimento, CURDATE()) AS idade 
FROM vw_todos_clientes vtc
WHERE telefone IS NOT NULL AND vtc.sigla_estado = 'PR'
HAVING idade > 22
ORDER BY id;