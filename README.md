# 🛒 Ecommerce Microservices Platform
> Uma plataforma de ecommerce em microsserviços orientada a eventos — dois times, dois mundos, **um fluxo**: mensagens no **Apache Kafka**.

---

## 📌 Visão Geral

Este projeto demonstra uma arquitetura **Event-Driven** (assíncrona) onde serviços desacoplados se comunicam através de tópicos.

* **Arquitetura:** Microsserviços & Event-Driven
* **Comunicação:** Apache Kafka (Pub/Sub)
* **Monorepo Lógico:** Estrutura unificada, mas com ciclos de vida e bancos de dados isolados por Squad.

---

## 🏗 Arquitetura & Squads

### 🔧 Infraestrutura Compartilhada
* **Kafka + Zookeeper:** Responsáveis pelo transporte de eventos e orquestração do cluster.

### 📦 Squad 1 — Pedidos (Producer)
* **Stack:** .NET 10 + MySQL
* **Responsabilidade:** Gerenciamento e criação de pedidos.
* **Papel no Kafka:** **Producer** (Publica o evento `OrderCreated` quando um pedido é salvo).

### 🏭 Squad 2 — Estoque (Consumer)
* **Stack:** Node.js (LTS) + PostgreSQL
* **Responsabilidade:** Controle de inventário e fulfillment.
* **Papel no Kafka:** **Consumer** (Escuta o evento `OrderCreated` para dar baixa no estoque automaticamente).

---

## 📂 Estrutura do Projeto

```text
ecommerce-platform/
├── infra-shared/              # Kafka e Zookeeper (Barramento de Eventos)
│   └── docker-compose.yml
│
├── squad-1-orders/            # [Squad 1] API de Pedidos (Producer)
│   ├── init/                  # Scripts SQL (CREATE TABLE, SEED)
│   ├── src/                   # Código Fonte (.NET 10)
│   └── docker-compose.yml     # Container do MySQL
│
└── squad-2-inventory/         # [Squad 2] Worker de Estoque (Consumer)
    ├── init/                  # Scripts SQL (CREATE TABLE, SEED)
    ├── src/                   # Código Fonte (Node.js LTS)
    └── docker-compose.yml     # Container do PostgreSQL

```

## 🚀 Como Rodar (Ambiente Completo)

### Pré-requisitos
* **Docker + Docker Compose**
* **.NET SDK 10** (Para rodar a API do Squad 1 localmente)
* **Node.js LTS** (Para rodar o Worker do Squad 2 localmente)

> **Nota:** Se você utiliza versões antigas do Docker, substitua `docker compose` por `docker-compose` nos comandos abaixo.

### 0. Criar Rede Docker (Passo Obrigatório)
Como os serviços estão em pastas separadas, precisamos de uma rede externa para que os containers (Banco, Kafka e Apps) se enxerguem.

```bash
docker network create ecommerce-network
```

### 1. Subir Infraestrutura (Kafka)
Primeiro, subimos o barramento de eventos.

```bash
cd infra-shared
docker compose up -d
```
* **Acesso Host:** localhost:9092
* **Acesso Interno (Docker):** kafka:29092

### 2. Squad 1 — Pedidos (.NET + MySQL)

**A) Subir o Banco de Dados**
O script na pasta init/ será executado automaticamente na primeira vez.

```bash
cd squad-1-orders
docker compose up -d
```

**B) Rodar a API (.NET)**

```bash
cd src
dotnet restore
dotnet run
```
A API estará rodando e pronta para gerar pedidos.

### 3. Squad 2 — Estoque (Node + Postgres)

**A) Subir o Banco de Dados**

```bash
cd squad-2-inventory
docker compose up -d
```

**B) Rodar o Worker (Node.js)**

```bash
cd src
npm install
npm run dev
```
O worker ficará aguardando eventos do Kafka.

## 🔌 Credenciais e Portas

| Serviço | Tipo | Host:Porta | Usuário | Senha | Banco de Dados |
|---------|------|------------|---------|-------|----------------|
| Kafka | Msg | localhost:9092 | - | - | - |
| MySQL | DB | localhost:3306 | orders_user | orders_password | orders_db |
| Postgres | DB | localhost:5432 | inventory_user | inventory_password | inventory_db |

### Acesso Administrativo (Root):
* **MySQL Root:** root
* **Postgres Superuser:** inventory_user (Configurado como admin no Docker)

## 🛠 Comandos Úteis

### Resetar Bancos de Dados
Caso precise limpar tudo e rodar os scripts de init/ novamente:

**Squad 1 (MySQL):**
```bash
cd squad-1-orders
docker compose down -v
docker compose up -d
```

**Squad 2 (Postgres):**
```bash
cd squad-2-inventory
docker compose down -v
docker compose up -d
```

### Logs e Monitoramento
Ver logs do Kafka:
```bash
cd infra-shared
docker compose logs -f kafka
```

Ver todos os containers rodando:
```bash
docker ps
```

## 🍎 Nota para Apple Silicon (M1/M2/M3)
Este projeto está configurado para rodar nativamente em arquitetura ARM64.
As imagens utilizadas (mysql:8.0 e postgres:alpine) já possuem suporte multi-arch.
Não é necessária emulação (Rosetta), garantindo performance máxima no seu Mac.
