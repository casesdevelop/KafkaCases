CREATE TABLE IF NOT EXISTS Products (
    Id SERIAL PRIMARY KEY,
    Sku VARCHAR(50) UNIQUE NOT NULL,
    Name VARCHAR(255) NOT NULL,
    Quantity INT NOT NULL DEFAULT 0,
    Price DECIMAL(10, 2) NOT NULL
);

-- Dados de teste
INSERT INTO Products (Sku, Name, Quantity, Price) 
VALUES ('NB-DELL-M15', 'Notebook Dell Alienware', 10, 8500.00);

INSERT INTO Products (Sku, Name, Quantity, Price) 
VALUES ('MOUSE-LOGI', 'Mouse Logitech MX', 50, 350.00);
