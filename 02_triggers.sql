DELIMITER $$
create trigger atualizar_preco
after UPDATE on Produtos
for each row
begin
IF old.preco <> new.preco
THEN
INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (@usuario_id,'Produtos',NEW.id,'UPDATE',old.preco,new.preco);
END IF;
end$$

DELIMITER ;

DELIMITER $$
CREATE TRIGGER Movimentos_Estoque
after UPDATE ON Produtos
for each row
begin
DECLARE v_produto_id INT;
SELECT id
INTO v_produto_id
FROM Produtos
WHERE id = new.id
LIMIT 1;
IF v_produto_id IS NOT NULL THEN
    IF new.estoque > old.estoque 
    THEN
    INSERT INTO Estoque_Movimentacoes (produto_id,quantidade,tipo) VALUES (v_produto_id,new.estoque - old.estoque,'entrada');
    INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (@usuario_id,'Produtos/Estoque',v_produto_id,'INSERT',old.estoque,new.estoque);
ELSEIF new.estoque < old.estoque THEN
    INSERT INTO Estoque_Movimentacoes (produto_id,quantidade,tipo) VALUES (v_produto_id,old.estoque - new.estoque,'saida');
    INSERT INTO Auditoria (usuario_id,tabela_afetada,id_registro,tipo_operacao,valor_antigo,valor_novo) VALUES (@usuario_id,'Produtos/Estoque',v_produto_id,'INSERT',old.estoque,new.estoque);
 END IF;
END IF;
END$$

DELIMITER ;
