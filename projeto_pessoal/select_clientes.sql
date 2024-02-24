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
GROUP BY sexo;

/* 3. Trazer todos os clientes nascidos no ano 2001 */

SELECT 
    *
FROM vw_todos_clientes 
    WHERE YEAR(STR_TO_DATE(dataNascimento, '%d/%m/%Y')) = 2001;

/* 4. Selecionar todos os clientes que não possuem telefone cadastrado */

SELECT 
	nome,
    cpf,
    GET_GENDER(sexo) AS genero,
    DATE_FORMAT(data_nascimento, '%d/%m/%Y') AS dataNascimento,
    telefone,
    email
FROM cliente 
WHERE telefone IS NULL;

/* 5. Selecionar todos os clientes que usam o host de email 'hotmail' */

SELECT 
	*
FROM vw_todos_clientes 
	WHERE email LIKE '%@hotmail%';