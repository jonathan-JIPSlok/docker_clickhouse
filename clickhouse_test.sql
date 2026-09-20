use testdb;

create table teste (
    id UInt32,
    nome String,
    valor Float32
) ENGINE = MergeTree()
ORDER BY id;

-- Inserção de dados
INSERT INTO teste SELECT
    number AS id,
    concat('Nome ', toString(number)) AS nome,
    rand() % 100 AS valor
FROM numbers(1000000);