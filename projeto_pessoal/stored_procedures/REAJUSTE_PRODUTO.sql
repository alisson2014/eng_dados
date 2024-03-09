# ROTINA PARA ADICIONAR REAJUSTES NOS PRODUTOS:

DELIMITER $$
CREATE OR REPLACE PROCEDURE REAJUSTE_PRODUTO (
    produto_id INT,
    percentual DECIMAL(4,2), 
    descricao VARCHAR(60), 
    data_inicio DATE, 
    data_fim DATE
)
BEGIN
    DECLARE p_exists INT;
    DECLARE descricao_completa VARCHAR(80);
    DECLARE tipo_reajuste VARCHAR(20);

    -- Verifica se o produto existe 
    SELECT COUNT(id) INTO p_exists FROM produto WHERE id = produto_id;

    IF p_exists = 0 THEN
        SELECT 'Produto inválido ou inexistente';
    ELSE
        IF percentual > 1 THEN 
            SET tipo_reajuste = 'ACRÉSCIMO';
        ELSE 
            SET tipo_reajuste = 'DESCONTO';
        END IF;
        
        SET descricao_completa = CONCAT(descricao, ' - ', tipo_reajuste);

        INSERT INTO correcao_produto (descricao, percentual, data_inicio, data_fim, produto_id) 
        VALUES (descricao_completa, percentual, data_inicio, data_fim, produto_id);
    END IF;
END $$

DELIMITER ;