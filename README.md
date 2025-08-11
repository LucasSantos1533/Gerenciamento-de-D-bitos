# 💰 SGDEJC – Sistema de Gerenciamento de Débitos EJC

Este é um projeto desenvolvido como **Trabalho de Conclusão de Curso (TCC)** no curso de **Sistemas de Informação**.  
O objetivo é **automatizar o gerenciamento de débitos e vendas** durante os encontros do **Encontro de Jovens com Cristo (EJC)**, substituindo o controle manual por uma solução digital integrada.

---

## ✨ Funcionalidades
- 📦 **Cadastro de Produtos**
- 🛒 **Registro de Vendas**
- 💵 **Registro de Pagamentos**
- 🔍 **Consulta de Débitos**
- 📜 **Listagem de Pagamentos**
- 📊 **Relatório de Produto Mais Vendido**
- ☁️ **Integração com Firebase Firestore** para armazenamento em nuvem

---

## 🗂 Estrutura de Coleções – Firestore

### 📂 **Participantes**
- **id**: `string`
- **nome**: `string`
- **tipo**: `string` (círculo ou equipe)

#### 📄 Subcoleção: **Vendas**
- **data**: `timestamp`
- **funcionario**: `string`
- **produtos**: `array` de objetos
  - **nome**: `string`
  - **preco**: `number`
  - **quantidade**: `number`
  - **status**: `string`

---

### 📂 **Funcionários**
- **id**: `string`
- **nome**: `string`
- **telefone**: `string`

---

### 📂 **Débitos**
- **data**: `timestamp`
- **funcionario**: `string`
- **identificador**: `string`
- **nomeParticipante**: `string`
- **participanteID**: `string`
- **produtos**: `array` de objetos
  - **nome**: `string`
  - **preco**: `number`
  - **quantidade**: `number`
  - **status**: `string`
- **vendaID**: `string`

---

### 📂 **Pagamentos**
- **dataPagamento**: `timestamp`
- **debitoID**: `string`
- **descricao**: `string`
- **identificador**: `string`
- **nomeFuncionario**: `string`
- **nomeParticipante**: `string`
- **nomeProduto**: `string`
- **status**: `string`
- **valor**: `number`

---

### 📂 **Produtos**
- **nome**: `string`
- **preco**: `number`
- **dataCompra**: `timestamp`
- **descricao**: `string`

---

## 🛠 Tecnologias Utilizadas
- **Flutter** → Framework para desenvolvimento multiplataforma
- **Firebase Firestore** → Banco de dados NoSQL para armazenamento
- **Dart** → Linguagem de programação principal

---

## 📌 Observações
> Este repositório contém **apenas a estrutura das coleções** para demonstração e fins acadêmicos.  
> Nenhum dado real ou sensível foi incluído.

---
