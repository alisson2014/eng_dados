# FUNÇÃO PARA CALCULAR O AJUSTE NO SALÁRIO:

DELIMITER $$

CREATE OR REPLACE FUNCTION CALCULATE_ADJUSTMENT(
    valor DECIMAL(8,2), 
    initial_date DATE, 
    end_date DATE, 
    percentage DECIMAL(4, 2),
    date DATE
) RETURNS DECIMAL(8, 2)
BEGIN
    IF (date BETWEEN initial_date AND end_date) THEN
        RETURN ROUND(valor * percentage, 2);
    ELSE
        RETURN valor;
    END IF;
END $$

DELIMITER ;