# 1) Criar uma Função que receba o ID da venda e retorne o nome do vendedor; 
DELIMITER //

CREATE OR REPLACE FUNCTION vendedorFromVenda(v_id INT(11))
RETURNS VARCHAR(50)
BEGIN
    DECLARE nomeVendedor VARCHAR(50);
    
    SELECT 
        ve.nome AS vendedorVenda INTO nomeVendedor
    FROM vendedores ve
        INNER JOIN vendas v ON v.codvendedor = ve.codvendedor
    WHERE v.codvenda = v_id;
    
    RETURN nomeVendedor;
END//

DELIMITER ;

# 2) Criar uma Função que receba o ID da venda e retorne o nome do cliente;
DELIMITER //

CREATE OR REPLACE FUNCTION clienteFromVenda(v_id INT(11))
RETURNS VARCHAR(50)
BEGIN
    DECLARE nomeCliente VARCHAR(50);
    
    SELECT 
        cl.nome INTO nomeCliente
    FROM cliente cl
        INNER JOIN vendas v ON v.codcliente = cl.codcliente
    WHERE v.codvenda = v_id;
    
    RETURN nomeCliente;
END//

DELIMITER ;

# 3) Criar uma Função que receba o ID da venda e retorne a Quantidade de produtos vendidos;

DELIMITER //

CREATE OR REPLACE FUNCTION produtosVendidos(v_id INT(11))
RETURNS DECIMAL(10,0)
BEGIN
    DECLARE produtosVendidos DECIMAL(10,0);
    
    SELECT 
        SUM(p.QUANTIDADE) INTO produtosVendidos
    FROM itens_venda iv
        INNER JOIN produto p ON p.CODIGO = iv.codproduto
    WHERE iv.codvenda = v_id;
    
    RETURN produtosVendidos;
END//

DELIMITER ;

# 4) Criar uma Função que receba o ID da venda e retorne o Total da venda;

DELIMITER //

CREATE OR REPLACE FUNCTION totalVenda(v_id INT(11))
RETURNS DECIMAL(10,0)
BEGIN
    DECLARE totalVenda DECIMAL(10,0);
    
    SELECT 
        SUM(p.QUANTIDADE * p.VALOR) INTO totalVenda
    FROM itens_venda iv
        INNER JOIN produto p ON p.CODIGO = iv.codproduto
    WHERE iv.codvenda = v_id;
    
    RETURN totalVenda;
END//

DELIMITER ;