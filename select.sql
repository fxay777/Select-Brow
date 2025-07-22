-- 1. Consulta SEM índice para medir performance inicial
EXPLAIN ANALYZE
SELECT id, nome, email, cidade, estado
FROM clientes
WHERE estado = 'SP'
ORDER BY data_cadastro DESC;

-- 2. Criar índice composto em estado e data_cadastro (ideal para filtro e ordenação)
CREATE INDEX idx_clientes_estado_data ON clientes(estado, data_cadastro DESC);

-- 3. Consulta COM índice para comparar ganho de performance
EXPLAIN ANALYZE
SELECT id, nome, email, cidade, estado
FROM clientes
WHERE estado = 'SP'
ORDER BY data_cadastro DESC;

-- 4. (Opcional) Outra consulta usando apenas o campo 'email'
EXPLAIN ANALYZE
SELECT id, nome, cpf
FROM clientes
WHERE email = 'usuario123@exemplo.com';

-- 5. Criar índice adicional (se quiser comparar com índice específico para email)
CREATE INDEX idx_clientes_email ON clientes(email);

-- 6. Repetir a consulta de e-mail para comparar
EXPLAIN ANALYZE
SELECT id, nome, cpf
FROM clientes
WHERE email = 'usuario123@exemplo.com';
