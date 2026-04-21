<div align="center">

# 🧾 Gestão Comercial ERP

**Sistema completo de gestão comercial com banco de dados relacional avançado em MySQL**

[![MySQL](https://img.shields.io/badge/MySQL-8.0-blue?style=for-the-badge&logo=mysql&logoColor=white)]
[![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow?style=for-the-badge)]
[![License](https://img.shields.io/badge/license-MIT-green?style=for-the-badge)]

Sistema de ERP backend para controle de vendas, estoque, clientes, fornecedores e relatórios inteligentes.

</div>

---

## 🚀 Sobre o projeto

O **Gestão Comercial ERP** é um sistema de banco de dados completo desenvolvido em MySQL, com foco em:

- Controle de vendas e fluxo de pedidos
- Gestão automática de estoque
- Relatórios gerenciais em tempo real
- Auditoria de operações críticas
- Regras de negócio encapsuladas em procedures e triggers

---

## 🧠 Funcionalidades principais

### 📦 Produtos & Estoque
- Cadastro de produtos com categoria e fornecedor
- Controle automático de estoque
- Movimentações de entrada e saída

### 💰 Vendas
- Criação de vendas com status (Pendente, Ativa, Cancelada)
- Adição de itens por venda
- Cálculo automático de total

### 🔁 Processos automáticos
- Finalização de vendas
- Cancelamento com reversão de estoque
- Devoluções com validação de quantidade

### 👥 Clientes & Fornecedores
- Cadastro de clientes com classificação automática
- Aprovação de fornecedores via permissão de admin

### 📊 Relatórios (Views)
- Ranking de clientes
- Ranking de produtos
- Faturamento mensal
- Relatório de reposição de estoque
- Total gasto por cliente

### 🛡️ Auditoria
- Registro de INSERT, UPDATE e DELETE
- Rastreamento de alterações em produtos, vendas e estoque

---

## 🗂️ Estrutura do banco

### Principais tabelas:

- clientes
- produtos
- vendas
- vendas_itens
- fornecedores
- categorias
- usuarios
- pagamentos
- auditoria
- devolucoes
- estoque_movimentacoes

---

## ⚙️ Lógica implementada

### 🔧 Procedures
- `EXEC_VENDA` → cria vendas e adiciona itens
- `FINALIZAR_VENDA` → finaliza venda e baixa estoque
- `CANCELAR_VENDA` → cancela venda e restaura estoque
- `EXEC_DEVOLUCAO` → devoluções de produtos
- `CRIAR_PRODUTO` → validação de usuário e fornecedor
- `CRIAR_CATEGORIA` → controle de acesso admin
- `APROVAR_FORNECEDOR` → criação controlada

---

### 🧮 Functions
- `Calcular_Total` → soma total de uma venda
- `Classificar_Cliente` → Bronze / Prata / Ouro
- `Total_Vendido_Produto` → total vendido por produto
- `Total_Gasto_Cliente` → total gasto por cliente

---

### 📈 Views (Relatórios)
- `Ranking_Clientes`
- `Ranking_Produtos`
- `Faturamento_Mensal`
- `Clientes_Total`
- `Relatorio_Reposicao`
- `Quantidade_Produtos_Vendidos`

---

## 🔄 Fluxo do sistema
