-- Criação da tabela clientes
DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes (
    id SERIAL PRIMARY KEY,
    nome VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    cpf VARCHAR(14),
    cidade VARCHAR(100),
    estado CHAR(2),
    data_cadastro TIMESTAMP
);

-- Inserção de dados fictícios (gerar registros aleatórios)
-- Inserindo 10.000 clientes fictícios (ajuste conforme necessário)
INSERT INTO clientes (nome, email, cpf, cidade, estado, data_cadastro)
SELECT
    'Cliente ' || i,
    'usuario' || i || '@exemplo.com',
    LPAD(i::text, 11, '0'),
    'Cidade ' || (i % 100),
    CASE WHEN i % 5 = 0 THEN 'SP' ELSE 'RJ' END,
    NOW() - (i || ' days')::INTERVAL
FROM generate_series(1, 10000) AS s(i);

-- Consulta SEM índice para medir performance
EXPLAIN ANALYZE
SELECT id, nome, email, cidade, estado
FROM clientes
WHERE estado = 'SP'
ORDER BY data_cadastro DESC;

-- Criar índice composto (estado + data_cadastro)
CREATE INDEX IF NOT EXISTS idx_clientes_estado_data
ON clientes(estado, data_cadastro DESC);

-- Consulta COM índice para medir melhoria
EXPLAIN ANALYZE
SELECT id, nome, email, cidade, estado
FROM clientes
WHERE estado = 'SP'
ORDER BY data_cadastro DESC;

-- Consulta por e-mail (antes do índice)
EXPLAIN ANALYZE
SELECT id, nome, cpf
FROM clientes
WHERE email = 'usuario123@exemplo.com';

-- Criar índice em email
CREATE INDEX IF NOT EXISTS idx_clientes_email
ON clientes(email);

-- Consulta por e-mail (após índice)
EXPLAIN ANALYZE
SELECT id, nome, cpf
FROM clientes
WHERE email = 'usuario123@exemplo.com';
