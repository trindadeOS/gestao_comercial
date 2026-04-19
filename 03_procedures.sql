DELIMITER $$
CREATE PROCEDURE EXEC_VENDA (
IN p_cliente_id INT,
IN p_produto_id INT,
IN p_quantidade INT,
IN p_usuario_id INT
)
BEGIN 
DECLARE v_estoque INT;
DECLARE v_preco DECIMAL(12,2);
DECLARE v_venda_id INT;
START TRANSACTION;
SET @usuario_id = p_usuario_id;
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
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (p_usuario_id,'Vendas',v_venda_id,'INSERT','NULL','NULL');
COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel registrar a venda.';
END IF; 
END$$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE EXEC_DEVOLUCAO(
IN p_usuario_id INT,
IN p_produto_id INT,
IN p_venda_id INT,
IN p_quantidade INT,
IN p_cliente_id INT
)
BEGIN
DECLARE v_qtd_vendida INT DEFAULT 0;
START TRANSACTION;
SELECT quantidade
INTO v_qtd_vendida 
FROM Vendas_Itens 
WHERE venda_id = p_venda_id
AND produto_id = p_produto_id
LIMIT 1;
IF v_qtd_vendida IS NOT NULL AND v_qtd_vendida >= p_quantidade THEN
INSERT INTO Devolucoes (venda_id,produto_id,quantidade) VALUES (p_venda_id,p_produto_id,p_quantidade);
UPDATE Produtos SET estoque = estoque + p_quantidade WHERE id = p_produto_id;
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (p_usuario_id,'Devoluções',p_venda_id,'UPDATE',NULL,NULL);
COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel realizar a devolução.';
END IF;
END$$

DELIMITER ;
