USE orders_db;

CREATE TABLE IF NOT EXISTS Orders (
    Id CHAR(36) NOT NULL PRIMARY KEY,
    CustomerId VARCHAR(255) NOT NULL,
    Status VARCHAR(50) NOT NULL,
    TotalAmount DECIMAL(10, 2) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Dados de teste (Opcional)
INSERT INTO Orders (Id, CustomerId, Status, TotalAmount) 
VALUES ('uuid-teste-123', 'cliente-01', 'PENDING', 150.00);
