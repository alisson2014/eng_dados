# FUNÇÃO PARA CALCULAR O AJUSTE NO SALÁRIO:

DELIMITER $$

CREATE FUNCTION CALCULATE_ADJUSTMENT(
    valor DECIMAL(8,2), 
    initial_date DATE, 
    end_date DATE, 
    percentage DECIMAL(4, 2)
) RETURNS DECIMAL(8, 2)
BEGIN
    IF (CURDATE() BETWEEN initial_date AND end_date) THEN
        RETURN ROUND(valor * percentage, 2);
    ELSE
        RETURN valor;
    END IF;
END $$

DELIMITER ;