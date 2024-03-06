START TRANSACTION;

-- Criar a tabela seguinte:
CREATE TABLE IF NOT EXISTS `correcao_valor_produto` (
  `cod_correcao` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(60) DEFAULT NULL,
  `percentual` decimal(11,2) DEFAULT NULL,
  `dt_inicio` date DEFAULT NULL,
  `dt_fim` date DEFAULT NULL,
  `CODIGO_CLASSIFICACAO` varchar(3) DEFAULT NULL,
  PRIMARY KEY (`cod_correcao`),
  KEY `correcao_valor_produto_classificacao_FK` (`CODIGO_CLASSIFICACAO`),
  CONSTRAINT `correcao_valor_produto_classificacao_FK` FOREIGN KEY (`CODIGO_CLASSIFICACAO`) REFERENCES `classificacao` (`CODIGO`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci


/* 1) Criar uma Procedure onde, ao serem informados os parâmetros da tabela acima, grave o registro. 
O mesmo será utilizado para determinar o valor do produto com seu reajuste em um determinado período da sua venda.
Ex: produto X 10 reais em janeiro 2023 e fevereiro o mesmo custa 11; */

DELIMITER $$
CREATE OR REPLACE PROCEDURE reajuste (
    IN descricao VARCHAR(60), 
    IN percentual DECIMAL(11,2), 
    IN data_inicio DATE, 
    IN data_fim DATE,
    IN cod_classificacao VARCHAR(3)
)
BEGIN
    DECLARE cod_exists INT;

    -- Verifica se existe algum produto com a classificação passada por parâmetro 
    SELECT COUNT(CODIGO) INTO cod_exists FROM produto WHERE CODIGO_CLASSIFICACAO = cod_classificacao;

    IF cod_exists = 0 THEN
        SELECT 'Classificação inválida ou inexistente' AS ERRO;
    ELSE
        INSERT INTO correcao_valor_produto (descricao, percentual, dt_inicio, dt_fim, CODIGO_CLASSIFICACAO) 
        VALUES (descricao, ROUND(percentual, 2), data_inicio, data_fim, cod_classificacao);
    END IF;
END $$

DELIMITER ;

CALL reajuste('reajuste janeiro 2023', 1.1, '2023-01-01', '2023-01-31', '005');
CALL reajuste('reajuste fevereiro 2023', 1.2, '2023-02-01', '2023-02-28', '005');
CALL reajuste('reajuste março 2023', 1.3, '2023-03-01', '2023-03-31', '005');
CALL reajuste('reajuste março 2024', 0.1, '2024-01-01', '2024-01-31', '005');
CALL reajuste('reajuste março 2024', 1.1, '2024-03-01', '2024-03-31','005');

/* 2) Criar uma function que retorne o valor do produto atualizado conforme o período da sua venda; */

DELIMITER $$

CREATE OR REPLACE FUNCTION valor_ajustado_2(produto INT, venda INT, data_comparacao DATE) 
RETURNS DECIMAL(11, 2)
BEGIN
    DECLARE valor_ajustado DECIMAL(11, 2);

    SELECT 
        CASE
            WHEN cvp.cod_correcao IS NULL THEN p.VALOR * p.QUANTIDADE
            ELSE ((p.VALOR * p.QUANTIDADE) * cvp.percentual)
        END AS 'ajustado' INTO valor_ajustado
    FROM vendas v 
        INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
        INNER JOIN produto p ON iv.codproduto = p.CODIGO
        LEFT JOIN correcao_valor_produto cvp ON cvp.CODIGO_CLASSIFICACAO = p.CODIGO_CLASSIFICACAO
        AND data_comparacao >= cvp.dt_inicio AND data_comparacao <= cvp.dt_fim
    WHERE p.CODIGO = produto AND v.codvenda = venda;

    RETURN valor_ajustado;
END $$

DELIMITER ;

/* 3.1) criar  uma view que traga o valor atualizado do produto na data atual; */
CREATE OR REPLACE VIEW vw_valor_produto_hoje AS
SELECT	
	v.codvenda,
    v.datavenda, 
    p.*, 
    p.QUANTIDADE * p.VALOR AS valor_sem_reajuste,
    valor_ajustado_2(p.CODIGO, v.codvenda, CURDATE()) AS valor_ajustado
FROM vendas v 
	INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
    INNER JOIN produto p ON iv.codproduto = p.CODIGO
ORDER BY v.datavenda;


/* 3.2) criar uma view das vendas com o valor dos produtos atualizados por período; */
CREATE OR REPLACE VIEW vw_vendas_periodo AS
SELECT	
	v.codvenda,
    v.datavenda, 
    p.*, 
    p.QUANTIDADE * p.VALOR AS valor_sem_reajuste,
    valor_ajustado_2(p.CODIGO, v.codvenda, v.datavenda) AS valor_ajustado
FROM vendas v 
	INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
    INNER JOIN produto p ON iv.codproduto = p.CODIGO
ORDER BY v.datavenda;


/* 3.3) criar uma view que retorne o valor total da venda com os produtos atualizado; */
CREATE OR REPLACE VIEW vw_vendas_totais AS
SELECT	
	v.codvenda,
    SUM(p.VALOR * p.QUANTIDADE) AS valor_total_sem_reajuste,
    SUM(valor_ajustado_2(p.CODIGO, v.codvenda, v.datavenda)) AS valor_total_ajustado
FROM vendas v 
	INNER JOIN itens_venda iv ON v.codvenda = iv.codvenda
    INNER JOIN produto p ON iv.codproduto = p.CODIGO
GROUP BY v.codvenda;

COMMIT;