DELIMITER $$

create trigger baixa_estoque
after insert on Vendas_Itens
for each row
begin
UPDATE Produtos
SET estoque = estoque - NEW.quantidade
WHERE id = NEW.produto_id;
end$$

DELIMITER ;

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
