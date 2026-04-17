DELIMITER $$
CREATE PROCEDURE EXEC_VENDA (
IN p_cliente_id INT,
IN p_produto_id INT,
IN p_quantidade INT
)
BEGIN
DECLARE v_estoque INT;
DECLARE v_preco DECIMAL(12,2);
DECLARE v_venda_id INT;
START TRANSACTION;
SELECT estoque INTO v_estoque
FROM Produtos
WHERE id = p_produto_id;
IF v_estoque >= p_quantidade THEN
SELECT preco INTO v_preco
FROM Produtos
WHERE id = p_produto_id;
INSERT INTO Vendas (cliente_id,total) VALUES (p_cliente_id,v_preco * p_quantidade);
SET v_venda_id = LAST_INSERT_ID();
INSERT INTO Vendas_Itens (venda_id,produto_id,quantidade,preco_unitario) VALUES (v_venda_id,p_produto_id,p_quantidade,v_preco);
INSERT INTO pagamentos (venda_id,valor) VALUES (v_venda_id,v_preco * p_quantidade);
COMMIT;
ELSE
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Estoque insuficiente para realizar a venda.';
ROLLBACK;
END IF; 
END$$
DELIMITER ;
