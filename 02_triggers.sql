create trigger baixa_estoque
after insert on Vendas_Itens
for each row
begin
UPDATE Produtos
SET estoque = estoque - NEW.quantidade
WHERE id = NEW.produto_id;
end;

