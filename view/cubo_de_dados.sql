CREATE TABLE Dim_Tempo (
    id_tempo INT PRIMARY KEY,
    ano INT,
    trimestre VARCHAR(2),
    mes VARCHAR(2),
    dia INT
);

INSERT INTO Dim_Tempo (id_tempo, ano, trimestre, mes, dia) VALUES
    (1, 2024, 'Q1', '01', 1),
    (2, 2024, 'Q1', '02', 1),
    (3, 2024, 'Q1', '03', 1),
    (4, 2024, 'Q2', '04', 1);

SELECT * FROM Dim_Tempo

CREATE TABLE Dim_Produto (
    id_produto INT PRIMARY KEY,
    nome_produto VARCHAR(50),
    categoria_produto VARCHAR(50)
);

INSERT INTO Dim_Produto (id_produto, nome_produto, categoria_produto) VALUES
    (1, 'Produto A', 'Categoria 1' ),
    (2, 'Produto B', 'Categoria 2' ),
    (3, 'Produto C', 'Categoria 1' );

SELECT * FROM Dim_Produto

CREATE TABLE Dim_Localizacao (
    id_localizacao INT PRIMARY KEY,
    pais VARCHAR(50),
    cidade VARCHAR(50)
);

INSERT INTO Dim_Localizacao (id_localizacao, pais, cidade) VALUES
    (1, 'Brasil', 'São Paulo'),
    (2, 'Brasil', 'Rio de Janeiro'),
    (3, 'Argentina', 'Buenos Aires');

SELECT * FROM Dim_Localizacao

CREATE TABLE Fato_Vendas (
    id_venda INT PRIMARY KEY,
    id_tempo INT,
    id_produto INT,
    id_localizacao INT,
    quantidade INT,
    valor_venda DECIMAL(10, 2),
    FOREIGN KEY (id_tempo) REFERENCES Dim_Tempo(id_tempo),
    FOREIGN KEY (id_produto) REFERENCES Dim_Produto(id_produto),
    FOREIGN KEY (id_localizacao) REFERENCES Dim_Localizacao(id_localizacao)
);

INSERT INTO Fato_Vendas (id_venda, id_tempo, id_produto, id_localizacao, quantidade, valor_venda) VALUES 
    (1, 1, 1, 1, 10, 100.00),
    (2, 2, 2, 2, 5, 50.00),
    (3, 3, 3, 3, 20, 200.00),
    (4, 4, 1, 1, 15, 150.00);

SELECT * FROM Fato_Vendas

-- CRIANDO VIEWS => RELATÓRIOS

CREATE VIEW Vendas_Produto_Tempo AS -- vendas por produto por tempo
SELECT p.nome_produto, t.ano, t.mes, SUM(f.quantidade) AS total_quantidade, SUM(f.valor_venda) AS total_valor
FROM Fato_Vendas f
JOIN Dim_Produto p ON f.id_produto = p.id_produto
JOIN Dim_Tempo t ON f.id_tempo = t.id_tempo
GROUP BY p.nome_produto, t.ano, t.mes;

SELECT * FROM Vendas_Produto_Tempo

CREATE VIEW Vendas_Localizacao_Produto AS -- vendas por localização por produto
SELECT l.pais, l.cidade, p.nome_produto, SUM(f.quantidade) AS total_quantidade, SUM(f.valor_venda) AS total_valor
FROM Fato_Vendas f
JOIN Dim_Localizacao l ON f.id_localizacao = l.id_localizacao
JOIN Dim_Produto p ON f.id_produto = p.id_produto
GROUP BY l.pais, l.cidade, p.nome_produto;

SELECT * FROM Vendas_Localizacao_Produto

-- DataMart -> parte dos dados que são processados
CREATE VIEW DataMart_Vendas_Local_Tempo AS
SELECT l.pais, l.cidade, t.ano, t.mes, SUM(f.quantidade) AS total_quantidade, SUM(f.valor_venda) AS total_valor
FROM Fato_Vendas f
JOIN Dim_Localizacao l ON f.id_localizacao = l.id_localizacao
JOIN Dim_Tempo t ON f.id_tempo = t.id_tempo
GROUP BY l.pais, l.cidade, t.ano, t.mes;

SELECT * FROM DataMart_Vendas_Local_Tempo