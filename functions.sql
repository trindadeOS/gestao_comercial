DELIMITER $$

CREATE FUNCTION Calcular_Total (p_venda_id INT)
RETURNS DECIMAL (10,2)
DETERMINISTIC 
BEGIN
DECLARE v_total_geral DECIMAL (10,2);
SELECT SUM(quantidade * preco_unitario)
INTO v_total_geral
FROM Vendas_Itens
WHERE venda_id = p_venda_id;

RETURN IFNULL(v_total_geral, 0);

END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION Classificar_Cliente (p_cliente_id INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
DECLARE v_total_geral DECIMAL (10,2);
SELECT SUM(total)
INTO v_total_geral
FROM vendas
WHERE cliente_id = p_cliente_id
AND status = 'Ativa';

SET v_total_geral = IFNULL(v_total_geral, 0);
RETURN
CASE
WHEN v_total_geral < 500 THEN 'Bronze'
WHEN v_total_geral BETWEEN 500 AND 2000 THEN 'Prata'
ELSE 'Ouro'
END;
end$$

delimiter ;

DELIMITER $$

CREATE FUNCTION Total_Vendido (p_cliente_id INT)
RETURNS VARCHAR (100)
DETERMINISTIC
BEGIN
DECLARE v_total_geral DECIMAL (10,2);
DECLARE v_cliente_nome VARCHAR (40);
SELECT SUM(total)
INTO v_total_geral
FROM vendas
WHERE cliente_id = p_cliente_id
AND status = 'Ativa';
SET v_total_geral = IFNULL(v_total_geral, 0);

SELECT clientes.nome
INTO v_cliente_nome
FROM clientes
WHERE id = p_cliente_id;

RETURN CONCAT(v_cliente_nome, ' gastou ', v_total_geral);

END$$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION TOTAL_VENDIDO_PRODUTO (p_produto_id INT)
RETURNS VARCHAR (100)
DETERMINISTIC
BEGIN
DECLARE v_total_produto DECIMAL (10,2);
DECLARE v_nome_produto VARCHAR (30);

SELECT SUM(quantidade)
INTO v_total_produto
FROM Vendas_Itens
JOIN vendas on Vendas_Itens.venda_id = vendas.id
WHERE produto_id = p_produto_id
AND vendas.status = 'Ativa';
SET v_total_produto = IFNULL(v_total_produto, 0);

SELECT nome
INTO v_nome_produto
FROM produtos
WHERE id = p_produto_id;

RETURN CONCAT(v_nome_produto, ' vendeu ', v_total_produto);
end$$

