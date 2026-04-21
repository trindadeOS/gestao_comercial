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


SELECT estoque INTO v_estoque
FROM Produtos
WHERE id = p_produto_id;

IF v_estoque < p_quantidade THEN
    ROLLBACK;
    SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Estoque insuficiente';
END IF;


SELECT id INTO v_venda_id
FROM vendas
WHERE cliente_id = p_cliente_id
AND status = 'Pendente'
LIMIT 1;


IF v_venda_id IS NULL THEN
    INSERT INTO Vendas (cliente_id, status, total)
    VALUES (p_cliente_id, 'Pendente', 0);

    SET v_venda_id = LAST_INSERT_ID();
END IF;


SELECT preco INTO v_preco
FROM Produtos
WHERE id = p_produto_id;


INSERT INTO Vendas_Itens (venda_id, produto_id, quantidade, preco_unitario)
VALUES (v_venda_id, p_produto_id, p_quantidade, v_preco);
UPDATE vendas
SET total = (
    SELECT SUM(preco_unitario * quantidade)
    FROM Vendas_Itens
    WHERE venda_id = v_venda_id
)
WHERE id = v_venda_id;
COMMIT;

END$$

DELIMITER ;


DELIMITER $$
CREATE PROCEDURE FINALIZAR_VENDA(
p_venda_id INT,
p_quantidade INT,
p_cliente_id INT,
p_usuario_id INT

)
BEGIN
DECLARE v_status VARCHAR(20);
DECLARE v_venda_id INT;
DECLARE v_preco DECIMAL (10,2);
DECLARE v_total_geral DECIMAL (10,2);
START TRANSACTION;


SELECT id
INTO v_venda_id
FROM vendas
WHERE ID = p_venda_id;


SELECT status
INTO v_status
FROM vendas
WHERE id = v_venda_id;

SELECT SUM(preco_unitario * quantidade) AS total_geral
INTO v_total_geral
FROM Vendas_Itens
WHERE venda_id = v_venda_id;


IF v_venda_id IS NOT NULL AND v_status = 'Pendente' THEN
UPDATE vendas SET status = 'Ativa' WHERE id = v_venda_id;

UPDATE Produtos
JOIN Vendas_Itens on Produtos.id = Vendas_Itens.produto_id
 SET produtos.estoque = produtos.estoque - Vendas_Itens.quantidade
 WHERE Vendas_Itens.venda_id = v_venda_id;

INSERT INTO Pagamentos (venda_id,valor) VALUES (v_venda_id,v_total_geral);
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (p_usuario_id,'Vendas/Produtos',v_venda_id,'INSERT','Pendente','Ativa');
COMMIT;
ELSE 
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel finalizar a venda.';
END IF;

END$$



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

DELIMITER $$

CREATE PROCEDURE CANCELAR_VENDA (
IN p_cliente_id INT,
IN p_venda_id INT,
IN p_usuario_id INT
)
BEGIN
DECLARE v_cliente_id INT;
DECLARE v_venda_id INT;
DECLARE v_usuario_id INT;
DECLARE v_status VARCHAR (20);
DECLARE v_quantidade INT;

START TRANSACTION;
SELECT id
INTO v_venda_id
FROM vendas
WHERE id = p_venda_id;

SELECT status
INTO v_status
FROM Vendas
WHERE id = p_venda_id;
IF v_status = 'Ativa' THEN
UPDATE vendas SET status = 'Cancelada' WHERE id = p_venda_id;
UPDATE Produtos JOIN Vendas_Itens ON Produtos.id = Vendas_Itens.produto_id SET estoque = estoque + Vendas_Itens.quantidade WHERE Vendas_Itens.venda_id = p_venda_id;
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (p_usuario_id,'Vendas',p_venda_id,'UPDATE', NULL, NULL);
COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel realizar o cancelamento.';
END IF;
END$$

DELIMITER $$

CREATE PROCEDURE CRIAR_PRODUTO (
p_usuario_id INT,
p_fornecedor_id INT,
p_nome_produto VARCHAR(20),
p_categoria_id VARCHAR(20),
p_preco DECIMAL (10,2),
p_quantidade_produto INT,
p_quantidade_minima INT
)
BEGIN
-- verificar se usuario existe

DECLARE v_usuario_id INT;
DECLARE v_fornecedor_id INT;

START TRANSACTION;

SELECT COUNT(*) INTO v_usuario_id
FROM Usuarios
WHERE id = p_usuario_id;

-- Verificar se fornecedor existe

SELECT COUNT(*) INTO v_fornecedor_id
FROM Fornecedores
WHERE id = p_fornecedor_id;

IF v_usuario_id > 0 AND v_fornecedor_id > 0 THEN
INSERT INTO Produtos (nome,preco,categoria_id,fornecedor_id,estoque,estoque_minimo) 
VALUES (p_nome_produto,p_preco,p_categoria_id,p_fornecedor_id,p_quantidade_produto,p_quantidade_minima);

INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo)
VALUES (p_usuario_id,'Produtos',LAST_INSERT_ID(),'INSERT',NULL,p_quantidade_produto);

COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel criar o produto. O Usuario ou fornecedor não existe.';
END IF;
END$$

DELIMITER ;

-- Criar Fornecedor

DELIMITER $$

CREATE PROCEDURE Aprovar_Fornecedor (
p_cliente_id INT,
p_usuario_id INT,
p_nome_fornecedor VARCHAR(30),
p_email_fornecedor VARCHAR(50),
p_telefone_fornecedor VARCHAR (11)
)
BEGIN
DECLARE v_cliente_existe INT;
DECLARE v_usuario_existe INT;
DECLARE v_tipo_usuario VARCHAR (20);

START TRANSACTION;


SELECT COUNT(*) INTO v_cliente_existe
FROM clientes
WHERE id = p_cliente_id;

SELECT COUNT(*) INTO v_usuario_existe
FROM Usuarios
WHERE id = p_usuario_id;


SELECT tipo
INTO v_tipo_usuario
FROM usuarios
WHERE id = p_usuario_id;


IF v_cliente_existe > 0 AND v_usuario_existe > 0 AND v_tipo_usuario = 'admin' THEN
INSERT INTO  Fornecedores (nome,email,telefone)
VALUES (p_nome_fornecedor,p_email_fornecedor,p_telefone_fornecedor);
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo)
VALUES (p_usuario_id,'Fornecedores',LAST_INSERT_ID(), 'INSERT',NULL,NULL);
COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel aprovar o fornecedor. O cliente não existe e/ou usuario não existe ou usuario não é admin.';
END IF;
END$$

delimiter ;

-- CRIAR CATEGORIAS DE PRODUTOS

DELIMITER $$

CREATE PROCEDURE CRIAR_CATEGORIA (
p_usuario_id INT,
p_nome_categoria VARCHAR(20)
)
BEGIN
DECLARE v_usuario_existe INT;
DECLARE v_tipo_usuario VARCHAR(20);
START TRANSACTION;

-- VALIDAR SE O USUARIO É UM ADMIN OU QUAL TIPO DELE

SELECT tipo
INTO v_tipo_usuario
FROM usuarios
WHERE id = p_usuario_id;



SELECT COUNT(*) 
INTO v_usuario_existe
FROM usuarios
WHERE id = p_usuario_id;

IF v_usuario_existe > 0 AND v_tipo_usuario = 'admin' THEN
INSERT INTO Categorias (nome) 
VALUES (p_nome_categoria);
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo)
VALUES (p_usuario_id,'Categorias',LAST_INSERT_ID(),'INSERT',NULL,p_nome_categoria);
COMMIT;
ELSE
ROLLBACK;
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Não foi possivel criar a categoria. Usuario não existe;não é admin.';
END IF;
END$$






