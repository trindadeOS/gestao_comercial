CREATE DATABASE gestao_comercial;
USE gestao_comercial;
CREATE TABLE clientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(30) NOT NULL,
    senha VARCHAR(30) NOT NULL,
    email VARCHAR(60) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    cpf VARCHAR(14) NOT NULL UNIQUE
);
CREATE TABLE Fornecedores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    telefone VARCHAR(20)
);
CREATE TABLE Categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE
);
CREATE TABLE Produtos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    categoria_id INT,
    fornecedor_id INT,
    estoque INT NOT NULL,
    estoque_minimo INT DEFAULT 5,
    FOREIGN KEY (categoria_id) REFERENCES Categorias(id),
    FOREIGN KEY (fornecedor_id) REFERENCES Fornecedores(id)
);
CREATE TABLE Estoque_Movimentacoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    quantidade INT NOT NULL,
    tipo ENUM('entrada', 'saida') NOT NULL,
    data_movimento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
CREATE TABLE Vendas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    status ENUM('Ativa','Cancelada', 'Pendente') default 'Pendente',
    data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10, 2) default 0,
    FOREIGN KEY (cliente_id) REFERENCES clientes(id)
);
CREATE TABLE Vendas_Itens (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venda_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (venda_id) REFERENCES Vendas(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
CREATE TABLE Pagamentos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venda_id INT,
    valor DECIMAL(10, 2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (venda_id) REFERENCES Vendas(id)
);
CREATE TABLE Usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    tipo ENUM('admin', 'vendedor') NOT NULL
);
CREATE TABLE Auditoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT NOT NULL,
    tabela_afetada VARCHAR(255) NOT NULL,
    id_registro INT,
    tipo_operacao ENUM ('INSERT', 'UPDATE', 'DELETE') NOT NULL,
    valor_antigo text,
    valor_novo text,
    data_acao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES Usuarios(id)
    
);
CREATE TABLE Devolucoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    venda_id INT,
    produto_id INT,
    quantidade INT NOT NULL,
    data_devolucao DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (venda_id) REFERENCES Vendas(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
CREATE TABLE Descontos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT,
    percentual DECIMAL(5, 2) NOT NULL,
    data_inicio DATETIME,
    data_fim DATETIME,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);
CREATE TABLE Promocoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    data_inicio DATETIME,
    data_fim DATETIME
);

-- views RELATORIOS

CREATE VIEW relatorio_reposicao AS
SELECT 
    id,
    nome,
    estoque,
    estoque_minimo,
    (estoque_minimo - estoque) AS Faltam
FROM Produtos
WHERE estoque < estoque_minimo;

CREATE VIEW clientes_total AS
SELECT clientes.id, clientes.nome, SUM(vendas.total) AS total_gasto
FROM clientes
JOIN vendas ON  vendas.cliente_id = clientes.id
WHERE vendas.status = 'Ativa'
GROUP BY clientes.id

CREATE VIEW Ranking_Clientes AS
SELECT clientes.id, clientes.nome, SUM(vendas.total) AS total_gasto
FROM clientes
JOIN Vendas ON vendas.cliente_id = clientes.id
WHERE vendas.status = 'Ativa'
GROUP BY clientes.id
ORDER BY total_gasto DESC;

CREATE VIEW Quantidade_Produtos_Vendidos AS
SELECT
produtos.id,
produtos.nome,
TOTAL_VENDIDO_PRODUTO(produtos.id) AS resumo_vendas
FROM produtos;

CREATE VIEW Ranking_Produtos AS
SELECT produtos.id, produtos.nome, SUM(Vendas_Itens.quantidade) AS Total_Vendido
FROM produtos
JOIN Vendas_Itens ON Vendas_Itens.produto_id = produtos.id
JOIN vendas ON vendas.id = Vendas_Itens.venda_id
WHERE vendas.status = 'Ativa'
GROUP BY produtos.id, produtos.nome
ORDER BY Total_Vendido DESC;

CREATE VIEW Faturamento_Mensal AS
SELECT
 DATE_FORMAT(data_venda, '%Y-%m') AS mes,
 SUM(total) AS total_mes
FROM vendas
WHERE status = 'Ativa'
GROUP BY mes;


