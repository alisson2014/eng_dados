# FUNÇÃO PARA OBTER O GENÊRO DE UM CLIENTE:

DELIMITER $$
CREATE OR REPLACE FUNCTION GET_GENDER(sexo CHAR(1))
    RETURNS VARCHAR(20)
    BEGIN
        DECLARE genero VARCHAR(20);
        
        CASE
            WHEN sexo IS NULL THEN SET genero = 'Não informado';
            WHEN sexo = 'f' THEN SET genero = 'Feminino';
            WHEN sexo = 'm' THEN SET genero = 'Masculino';
            ELSE SET genero = 'Não informado';
        END CASE;
        
        RETURN genero;
    END$$
DELIMITER ;