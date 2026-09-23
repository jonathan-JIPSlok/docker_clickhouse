CREATE TABLE Inventario_Produtos (
    sku_id INT PRIMARY KEY,
    produto_nome VARCHAR(50),
    categoria VARCHAR(50),
    quantidade_estoque INT,
    preco_unitario DECIMAL,
    data_entrada DATE,
    localizacao VARCHAR(50)
);

INSERT INTO Inventario_Produtos (sku_id, produto_nome, categoria, quantidade_estoque, preco_unitario, data_entrada, localizacao) VALUES
    (1, 'Arroz', 'Alimento', 10, 12.00, 2026-06-20, 'São Paulo'),
    (2, 'Feijão', 'Alimento', 12, 23.00, 2026-06-22, 'Rio de Janeiro'),
    (3, 'Macarrão', 'Alimento', 30, 10.00, 2026-06-11, 'São Paulo');

-- Quantidade total de produtos por categoria
CREATE VIEW quantidade_por_categoria AS
SELECT categoria, SUM(quantidade_estoque) AS total_quantidade
FROM Inventario_Produtos
GROUP BY categoria;

-- valor total do estoque por localização
CREATE VIEW valor_estoque_por_localizacao AS
SELECT localizacao, SUM(quantidade_estoque * preco_unitario) AS valor_total_estoque
FROM Inventario_Produtos
GROUP BY localizacao;

-- produtos em baixo estoque
CREATE VIEW produtos_baixo_estoque AS
SELECT sku_id, produto_nome, quantidade_estoque
FROM Inventario_Produtos
WHERE quantidade_estoque < 10;