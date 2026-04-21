<div align="center">

# 🧾 Gestão Comercial MySQL

**Sistema completo de gestão comercial com regras de negócio no banco de dados** — v1.0

[![MySQL](https://img.shields.io/badge/MySQL-Advanced-blue?style=for-the-badge&logo=mysql&logoColor=white)]()
[![Status](https://img.shields.io/badge/Project-Completed-success?style=for-the-badge)]()
[![License](https://img.shields.io/badge/Academic-Project-lightgrey?style=for-the-badge)]()

Sistema completo de banco de dados para gestão comercial com controle de clientes, fornecedores, produtos, vendas, pagamentos, estoque e devoluções — totalmente estruturado com **procedures, triggers, functions, views e transações SQL**.

---

[📊 Estrutura](#estrutura) • [⚙️ Funcionalidades](#funcionalidades) • [🧠 Regras de Negócio](#regras-de-negócio) • [🗄️ Arquitetura](#arquitetura)

</div>

---

## 📊 Estrutura

O sistema possui modelagem relacional completa com:

- Clientes
- Usuários (admin/vendedor)
- Fornecedores
- Categorias de produtos
- Produtos
- Vendas
- Itens da venda
- Pagamentos
- Estoque
- Devoluções
- Auditoria de operações

---

## ⚙️ Funcionalidades

- ✔ Registro completo de vendas com múltiplos itens  
- ✔ Controle automático de estoque  
- ✔ Sistema de carrinho (venda pendente → ativa)  
- ✔ Cancelamento com estorno de estoque  
- ✔ Sistema de devolução com reentrada de produtos  
- ✔ Auditoria completa de ações do sistema  
- ✔ Classificação automática de clientes (Bronze / Prata / Ouro)  
- ✔ Relatórios com Views SQL avançadas  

---

## 🧠 Regras de Negócio

- Não é permitido vender sem estoque disponível  
- Toda venda altera automaticamente o estoque  
- Cancelamentos reconstroem o estoque anterior  
- Toda alteração importante é registrada na auditoria  
- Apenas usuários admin podem criar categorias e fornecedores  
- Clientes são classificados por volume de compras  

---

## 🗄️ Arquitetura do Banco

O sistema foi desenvolvido utilizando recursos avançados do MySQL:

### 🔹 Procedures
- Execução de vendas completas
- Finalização de vendas
- Criação de produtos e categorias
- Aprovação de fornecedores
- Processamento de devoluções

### 🔹 Functions
- Cálculo de total de vendas
- Classificação de clientes
- Relatórios de produtos vendidos

### 🔹 Triggers
- Atualização automática de estoque
- Registro de movimentações
- Auditoria de alterações

### 🔹 Views
- Ranking de clientes
- Ranking de produtos
- Faturamento mensal
- Relatórios de reposição
- Quantidade de produtos vendidos

### 🔹 Transações
- Uso de `START TRANSACTION`, `COMMIT` e `ROLLBACK` para garantir integridade dos dados

---

## 📈 Relatórios Disponíveis

- Faturamento por mês  
- Produtos mais vendidos  
- Clientes com maior gasto  
- Produtos com estoque baixo  
- Histórico de vendas  

---

## 🔐 Auditoria

Todas as operações críticas são registradas com:

- Usuário responsável  
- Tipo de operação (INSERT / UPDATE / DELETE)  
- Tabela afetada  
- Valores antigos e novos  
- Data e hora  

---

## 🚀 Objetivo do Projeto

Simular um sistema real de gestão comercial, garantindo:

- Integridade dos dados  
- Automação de processos  
- Segurança nas operações  
- Rastreabilidade total  
- Uso avançado de recursos do MySQL  

---

## 👨‍💻 Autor

Projeto acadêmico desenvolvido para estudo avançado de banco de dados relacional.
Autores : Italo / Débora
---

<div align="center">

Release 100%...

</div>
