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
CREATE PROCEDURE CORRECAO_PRODUTO (
    cod_classificacao VARCHAR(3),
    percentual DECIMAL(11,2), 
    descricao VARCHAR(60), 
    data_inicio DATE, 
    data_fim DATE
)
BEGIN
    DECLARE cod_exists INT;

    -- Verifica se o produto existe 
    SELECT COUNT(CODIGO) INTO cod_exists FROM produto WHERE CODIGO_CLASSIFICACAO = cod_classificacao;

    IF cod_exists = 0 THEN
        SELECT 'Classificação inválida ou inexistente' AS ERRO;
    ELSE
        INSERT INTO correcao_valor_produto (descricao, percentual, dt_inicio, dt_fim, CODIGO_CLASSIFICACAO) 
        VALUES (descricao, ROUND(percentual / 100, 2), data_inicio, data_fim, cod_classificacao);
    END IF;
END $$

DELIMITER ;

CALL CORRECAO_PRODUTO('013', 101.5, 'Aumento março/2024', CURDATE(), '2024-03-31');
CALL CORRECAO_PRODUTO('020', 98, 'Desconto março/2024', CURDATE(), '2024-03-31');
CALL CORRECAO_PRODUTO('999', 100.5, 'Aumento março/2024', CURDATE(), '2024-03-31');
CALL CORRECAO_PRODUTO('001', 97, 'Desconto abril/2023', '2023-04-01', '2024-04-30');
CALL CORRECAO_PRODUTO('005', 102, 'Aumento janeiro/2023', '2023-01-01', '2024-01-31');

/* 2) Criar uma function que retorne o valor do produto atualizado conforme o período da sua venda; */

DELIMITER $$

CREATE OR REPLACE FUNCTION CALCULA_CORRECAO(
    valor DECIMAL(10, 0), 
    data_inicial DATE, 
    data_final DATE,
    data_venda DATE, 
    porcentagem DECIMAL(11, 2)
) RETURNS DECIMAL(11, 2)
BEGIN
    IF (data_venda >= data_inicial AND data_venda <= data_final) THEN
        RETURN ROUND(valor * porcentagem, 2);
    ELSE
        RETURN valor;
    END IF;
END $$

DELIMITER ;

/* 3.1) criar  uma view que traga o valor atualizado do produto na data atual; */
CREATE OR REPLACE VIEW vw_valor_produto_hoje AS
SELECT 
	p.DESCRICAO,
    p.TIPO,
    p.CODIGO_CLASSIFICACAO,
    p.UNIDADE,
    p.QUANTIDADE,
    p.VALOR,
    CALCULA_CORRECAO(p.VALOR, cvp.dt_inicio, cvp.dt_fim, CURDATE(), cvp.percentual) AS VALOR_ATUALIZADO,
    IF(CURDATE() <= cvp.dt_fim AND CURDATE() >= cvp.dt_inicio, cvp.percentual, NULL) AS PORCENTAGEM
FROM produto p
	LEFT JOIN correcao_valor_produto cvp ON p.CODIGO_CLASSIFICACAO = cvp.CODIGO_CLASSIFICACAO
ORDER BY p.CODIGO_CLASSIFICACAO, p.DESCRICAO;

/* 3.2) criar uma view das vendas com o valor dos produtos atualizados por período; */
CREATE OR REPLACE VIEW vw_vendas_periodo AS
SELECT 
	p.DESCRICAO,
    p.TIPO,
    p.CODIGO_CLASSIFICACAO,
    p.UNIDADE,
    p.QUANTIDADE,
    p.VALOR,
    CALCULA_CORRECAO(p.VALOR, cvp.dt_inicio, cvp.dt_fim, vd.datavenda, cvp.percentual) AS VALOR_ATUALIZADO,
    IF(vd.datavenda <= cvp.dt_fim AND vd.datavenda >= cvp.dt_inicio, cvp.percentual, NULL) AS PORCENTAGEM,
    vd.datavenda
FROM produto p
	INNER JOIN itens_venda iv ON p.CODIGO = iv.codproduto
	INNER JOIN vendas vd ON iv.codvenda = vd.codvenda
	LEFT JOIN correcao_valor_produto cvp ON p.CODIGO_CLASSIFICACAO = cvp.CODIGO_CLASSIFICACAO
ORDER BY p.CODIGO_CLASSIFICACAO, p.DESCRICAO;

/* 3.3) criar uma view que retorne o valor total da venda com os produtos atualizado; */
CREATE OR REPLACE VIEW vw_vendas_totais AS
SELECT 
	p.DESCRICAO,
    p.TIPO,
    p.CODIGO_CLASSIFICACAO,
    p.UNIDADE,
    p.QUANTIDADE,
    p.VALOR,
    SUM(CALCULA_CORRECAO(p.VALOR, cvp.dt_inicio, cvp.dt_fim, vd.datavenda, cvp.percentual) * p.QUANTIDADE) AS VALOR_VENDA,
    IF(vd.datavenda <= cvp.dt_fim AND vd.datavenda >= cvp.dt_inicio, cvp.percentual, NULL) AS PORCENTAGEM,
    vd.datavenda
FROM produto p
	INNER JOIN itens_venda iv ON p.CODIGO = iv.codproduto
	INNER JOIN vendas vd ON iv.codvenda = vd.codvenda
	LEFT JOIN correcao_valor_produto cvp ON p.CODIGO_CLASSIFICACAO = cvp.CODIGO_CLASSIFICACAO
GROUP BY vd.codvenda, p.CODIGO
ORDER BY p.CODIGO_CLASSIFICACAO, vd.datavenda;

COMMIT;