-- =============================================================================
-- SCRIPT DE CRIAÇÃO E CARGA DO BANCO ecommerce_central
-- =============================================================================
-- Disciplina : Infraestrutura para Big Data
-- Objetivo   : Criar o banco centralizado que será usado na atividade de
--              fragmentação de dados em bancos distribuídos.
--
-- INSTRUÇÕES:
--   1. Conecte-se ao cluster MySQL via DBeaver.
--   2. Abra este arquivo (File > Open File) ou cole o conteúdo no editor SQL.
--   3. Execute tudo de uma vez (Ctrl+A → Ctrl+Enter).
--   4. Ao final, o banco ecommerce_central estará pronto com:
--        • 4 tabelas  (clientes, produtos, pedidos, itens_pedido)
--        • 30 clientes, 20 produtos, 60 pedidos e 72 itens
-- =============================================================================

-- -----------------------------------------------------------------------------
-- 1. CRIAÇÃO DO BANCO
-- -----------------------------------------------------------------------------

DROP DATABASE IF EXISTS ecommerce_central;
CREATE DATABASE ecommerce_central
  DEFAULT CHARACTER SET utf8mb4
  DEFAULT COLLATE utf8mb4_unicode_ci;

USE ecommerce_central;

-- -----------------------------------------------------------------------------
-- 2. CRIAÇÃO DAS TABELAS
-- -----------------------------------------------------------------------------

-- Tabela: clientes
CREATE TABLE clientes (
    cliente_id      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(100)  NOT NULL,
    email           VARCHAR(150)  NOT NULL,
    cpf             VARCHAR(14)   NOT NULL,
    telefone        VARCHAR(20),
    data_nascimento DATE,
    genero          ENUM('M','F','Outro'),
    renda_mensal    DECIMAL(10,2),
    score_credito   INT,
    regiao          ENUM('Sul','Sudeste','Nordeste') NOT NULL,
    estado          CHAR(2)       NOT NULL,
    cidade          VARCHAR(100)  NOT NULL,
    cep             VARCHAR(10),
    endereco        VARCHAR(255),
    data_cadastro   DATE          NOT NULL,
    ultima_compra   DATE,
    total_gasto     DECIMAL(12,2) DEFAULT 0.00,
    qtd_pedidos     INT           DEFAULT 0
) ENGINE=InnoDB;

-- Tabela: produtos
CREATE TABLE produtos (
    produto_id      INT AUTO_INCREMENT PRIMARY KEY,
    nome            VARCHAR(200)   NOT NULL,
    categoria       VARCHAR(80)    NOT NULL,
    preco           DECIMAL(10,2)  NOT NULL,
    peso_kg         DECIMAL(6,3),
    estoque         INT            DEFAULT 0,
    descricao       TEXT,
    avaliacao_media DECIMAL(3,2)   DEFAULT 0.00,
    fornecedor      VARCHAR(150)
) ENGINE=InnoDB;

-- Tabela: pedidos
CREATE TABLE pedidos (
    pedido_id       INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id      INT            NOT NULL,
    data_pedido     DATE           NOT NULL,
    valor_total     DECIMAL(12,2)  NOT NULL,
    status          ENUM('Pendente','Processando','Enviado','Entregue','Cancelado') NOT NULL,
    regiao_entrega  ENUM('Sul','Sudeste','Nordeste') NOT NULL,
    estado_entrega  CHAR(2)        NOT NULL,
    frete           DECIMAL(8,2)   DEFAULT 0.00,
    metodo_pagamento ENUM('Pix','Cartão Crédito','Cartão Débito','Boleto') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES clientes(cliente_id)
) ENGINE=InnoDB;

-- Tabela: itens_pedido
CREATE TABLE itens_pedido (
    item_id         INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id       INT            NOT NULL,
    produto_id      INT            NOT NULL,
    quantidade      INT            NOT NULL,
    preco_unitario  DECIMAL(10,2)  NOT NULL,
    subtotal        DECIMAL(12,2)  NOT NULL,
    FOREIGN KEY (pedido_id)  REFERENCES pedidos(pedido_id),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
) ENGINE=InnoDB;

-- -----------------------------------------------------------------------------
-- 3. CARGA DE DADOS
-- -----------------------------------------------------------------------------

-- Produtos (20 registros)
INSERT INTO produtos (nome, categoria, preco, peso_kg, estoque, descricao, avaliacao_media, fornecedor) VALUES
('Notebook Gamer 15"',        'Eletrônicos',    5499.90, 2.300, 120, 'Notebook com GPU dedicada, 16GB RAM, SSD 512GB',  4.50, 'TechBR Distribuidora'),
('Smartphone 128GB',          'Eletrônicos',    2899.00, 0.195, 300, 'Tela AMOLED 6.5", câmera 108MP',                  4.70, 'TechBR Distribuidora'),
('Fone Bluetooth ANC',        'Eletrônicos',     349.90, 0.250, 500, 'Cancelamento ativo de ruído, 30h bateria',         4.30, 'AudioMax'),
('Smart TV 55" 4K',           'Eletrônicos',    3199.00, 14.50, 80,  'Smart TV LED, HDR10, Wi-Fi integrado',             4.60, 'TechBR Distribuidora'),
('Câmera DSLR 24MP',          'Eletrônicos',    4250.00, 0.680, 45,  'Sensor APS-C, vídeo 4K, lente 18-55mm',           4.80, 'FotoImport'),
('Cadeira Ergonômica',        'Móveis',          899.90, 12.00, 150, 'Ajuste lombar, apoio de braço 3D, mesh',           4.40, 'ConfortOffice'),
('Mesa Standing Desk',        'Móveis',         1599.00, 25.00, 60,  'Regulagem elétrica de altura, 140x70cm',           4.20, 'ConfortOffice'),
('Monitor Ultrawide 34"',     'Eletrônicos',    2799.00, 6.800, 90,  'WQHD 3440x1440, 144Hz, USB-C',                    4.50, 'TechBR Distribuidora'),
('Teclado Mecânico RGB',      'Periféricos',     299.90, 0.850, 400, 'Switch blue, ABNT2, iluminação por tecla',         4.10, 'AudioMax'),
('Mouse Sem Fio Ergonômico',  'Periféricos',     189.90, 0.120, 600, 'Sensor 16000 DPI, 6 botões programáveis',          4.30, 'AudioMax'),
('SSD NVMe 1TB',              'Componentes',     459.90, 0.050, 350, 'Leitura 3500MB/s, escrita 3000MB/s',               4.70, 'StorageTech'),
('HD Externo 2TB',            'Componentes',     399.90, 0.170, 250, 'USB 3.0, compacto, backup automático',             4.00, 'StorageTech'),
('Webcam Full HD',            'Periféricos',     279.90, 0.150, 200, '1080p 60fps, microfone duplo, autofoco',           4.20, 'FotoImport'),
('Roteador Wi-Fi 6',          'Redes',           549.90, 0.450, 180, 'Dual-band AX1800, 4 antenas, MU-MIMO',            4.40, 'NetConnect'),
('Switch Gigabit 8 Portas',   'Redes',           199.90, 0.300, 220, 'Não-gerenciável, plug and play, metal',            4.10, 'NetConnect'),
('Mochila Notebook 17"',      'Acessórios',      189.90, 0.900, 300, 'Impermeável, compartimento acolchoado, USB',       4.30, 'BagStore'),
('Hub USB-C 7 em 1',          'Acessórios',      159.90, 0.085, 400, 'HDMI 4K, USB 3.0, SD/MicroSD, PD 100W',           4.50, 'TechBR Distribuidora'),
('Caixa de Som Portátil',     'Áudio',           249.90, 0.540, 280, 'Bluetooth 5.3, 20W, à prova d\'água IPX7',        4.60, 'AudioMax'),
('Tablet 10" 64GB',           'Eletrônicos',    1899.00, 0.460, 110, 'Tela IPS, caneta stylus, Wi-Fi + 4G',             4.40, 'TechBR Distribuidora'),
('Impressora Multifuncional', 'Periféricos',      799.90, 5.200, 75, 'Jato de tinta, Wi-Fi, duplex automático',          3.90, 'PrintBR');

-- Clientes (30 registros — 10 por região)
INSERT INTO clientes (nome, email, cpf, telefone, data_nascimento, genero, renda_mensal, score_credito, regiao, estado, cidade, cep, endereco, data_cadastro, ultima_compra, total_gasto, qtd_pedidos) VALUES
-- REGIÃO SUDESTE (10 clientes)
('Ana Silva',          'ana.silva@email.com',       '123.456.789-01', '(11)99001-1001', '1992-03-15', 'F', 6500.00,  780, 'Sudeste',  'SP', 'São Paulo',         '01001-000', 'Rua Augusta, 100',           '2023-01-10', '2025-04-20', 12580.50, 8),
('Bruno Oliveira',     'bruno.oliv@email.com',      '234.567.890-12', '(21)99002-2002', '1988-07-22', 'M', 8200.00,  820, 'Sudeste',  'RJ', 'Rio de Janeiro',    '20040-020', 'Av. Rio Branco, 50',         '2023-02-05', '2025-05-10', 18920.00, 12),
('Carla Mendes',       'carla.mendes@email.com',    '345.678.901-23', '(11)99003-3003', '1995-11-30', 'F', 4800.00,  650, 'Sudeste',  'SP', 'Campinas',          '13015-100', 'Rua Barão de Jaguara, 200',  '2023-03-18', '2025-03-05', 5430.80,  4),
('Daniel Santos',      'daniel.santos@email.com',   '456.789.012-34', '(31)99004-4004', '1990-01-08', 'M', 7100.00,  710, 'Sudeste',  'MG', 'Belo Horizonte',    '30130-000', 'Rua da Bahia, 300',          '2023-04-22', '2025-04-28', 9875.20,  6),
('Elena Costa',        'elena.costa@email.com',     '567.890.123-45', '(27)99005-5005', '1998-06-14', 'F', 3500.00,  580, 'Sudeste',  'ES', 'Vitória',           '29010-000', 'Av. Jerônimo Monteiro, 80',  '2023-06-01', '2025-02-18', 3210.40,  3),
('Felipe Rocha',       'felipe.rocha@email.com',    '678.901.234-56', '(11)99006-6006', '1985-09-03', 'M', 12000.00, 900, 'Sudeste',  'SP', 'São Paulo',         '04543-011', 'Av. Faria Lima, 1500',       '2023-01-15', '2025-05-15', 32450.90, 18),
('Gabriela Lima',      'gabi.lima@email.com',       '789.012.345-67', '(21)99007-7007', '1993-12-25', 'F', 5500.00,  700, 'Sudeste',  'RJ', 'Niterói',           '24020-100', 'Rua Visconde de Uruguai, 40','2023-07-10', '2025-01-22', 6780.00,  5),
('Henrique Almeida',   'henrique.alm@email.com',    '890.123.456-78', '(31)99008-8008', '1987-04-17', 'M', 9500.00,  830, 'Sudeste',  'MG', 'Belo Horizonte',    '30140-100', 'Rua Espírito Santo, 600',    '2023-05-20', '2025-04-01', 15600.30, 10),
('Isabela Ferreira',   'isa.ferreira@email.com',    '901.234.567-89', '(11)99009-9009', '1996-08-09', 'F', 4200.00,  620, 'Sudeste',  'SP', 'Santos',            '11010-100', 'Av. Ana Costa, 250',         '2023-08-14', '2025-03-30', 4120.60,  3),
('João Pedro Martins', 'jp.martins@email.com',      '012.345.678-90', '(21)99010-0010', '1991-02-28', 'M', 6800.00,  750, 'Sudeste',  'RJ', 'Rio de Janeiro',    '22041-080', 'Rua Barata Ribeiro, 100',    '2023-09-01', '2025-05-08', 8940.70,  7),
-- REGIÃO SUL (10 clientes)
('Karen Schneider',    'karen.sch@email.com',       '111.222.333-44', '(51)99011-1011', '1994-05-20', 'F', 5800.00,  730, 'Sul',      'RS', 'Porto Alegre',      '90010-000', 'Rua dos Andradas, 500',      '2023-02-20', '2025-04-12', 7650.30,  5),
('Lucas Becker',       'lucas.becker@email.com',    '222.333.444-55', '(41)99012-2012', '1989-10-11', 'M', 7800.00,  800, 'Sul',      'PR', 'Curitiba',          '80010-000', 'Rua XV de Novembro, 300',    '2023-03-05', '2025-05-02', 14230.80, 9),
('Marina Kowalski',    'marina.kow@email.com',      '333.444.555-66', '(48)99013-3013', '1997-01-16', 'F', 4100.00,  640, 'Sul',      'SC', 'Florianópolis',     '88010-000', 'Rua Felipe Schmidt, 150',    '2023-04-10', '2025-02-25', 3890.50,  3),
('Nicolas Wagner',     'nicolas.wag@email.com',     '444.555.666-77', '(51)99014-4014', '1986-08-05', 'M', 10500.00, 870, 'Sul',      'RS', 'Porto Alegre',      '90050-100', 'Av. Ipiranga, 800',          '2023-01-25', '2025-05-18', 22100.40, 14),
('Olívia Krüger',     'olivia.kru@email.com',      '555.666.777-88', '(41)99015-5015', '1993-03-29', 'F', 5200.00,  690, 'Sul',      'PR', 'Londrina',          '86010-000', 'Rua Sergipe, 200',           '2023-06-15', '2025-03-10', 5670.90,  4),
('Pedro Hoffmann',     'pedro.hoff@email.com',      '666.777.888-99', '(47)99016-6016', '1990-12-01', 'M', 6300.00,  720, 'Sul',      'SC', 'Joinville',         '89201-000', 'Rua do Príncipe, 100',       '2023-07-20', '2025-04-05', 8430.20,  6),
('Rafaela Müller',     'rafa.muller@email.com',     '777.888.999-00', '(51)99017-7017', '1999-07-18', 'F', 3200.00,  560, 'Sul',      'RS', 'Caxias do Sul',     '95010-000', 'Rua Sinimbu, 400',           '2023-09-10', '2025-01-15', 2340.80,  2),
('Samuel Fontana',     'samuel.font@email.com',     '888.999.000-11', '(42)99018-8018', '1988-04-25', 'M', 8900.00,  840, 'Sul',      'PR', 'Curitiba',          '80020-100', 'Rua Marechal Deodoro, 500',  '2023-05-08', '2025-05-20', 19870.60, 11),
('Tatiana Pereira',    'tati.pereira@email.com',    '999.000.111-22', '(48)99019-9019', '1995-09-07', 'F', 4600.00,  670, 'Sul',      'SC', 'Blumenau',          '89010-000', 'Rua XV de Novembro, 800',    '2023-08-25', '2025-02-28', 4560.30,  4),
('Vinicius Zanella',   'vini.zanella@email.com',    '000.111.222-33', '(54)99020-0020', '1992-11-13', 'M', 5900.00,  710, 'Sul',      'RS', 'Porto Alegre',      '90110-000', 'Av. Osvaldo Aranha, 300',    '2023-10-01', '2025-04-22', 6890.10,  5),
-- REGIÃO NORDESTE (10 clientes)
('Wanderley Souza',    'wander.souza@email.com',    '112.233.445-56', '(71)99021-1021', '1991-06-10', 'M', 5000.00,  680, 'Nordeste', 'BA', 'Salvador',          '40020-000', 'Rua Chile, 100',             '2023-02-14', '2025-03-18', 6230.40,  5),
('Ximena Barbosa',     'ximena.barb@email.com',     '223.344.556-67', '(81)99022-2022', '1996-02-03', 'F', 4300.00,  630, 'Nordeste', 'PE', 'Recife',            '50030-000', 'Av. Guararapes, 200',        '2023-03-22', '2025-04-08', 4780.90,  4),
('Yuri Cavalcanti',    'yuri.caval@email.com',      '334.455.667-78', '(85)99023-3023', '1987-10-27', 'M', 9200.00,  850, 'Nordeste', 'CE', 'Fortaleza',         '60060-000', 'Rua Guilherme Rocha, 300',   '2023-01-30', '2025-05-12', 16540.70, 10),
('Zélia Nascimento',   'zelia.nasc@email.com',      '445.566.778-89', '(71)99024-4024', '1994-04-12', 'F', 3800.00,  590, 'Nordeste', 'BA', 'Salvador',          '40060-100', 'Rua Carlos Gomes, 50',       '2023-05-05', '2025-01-20', 2890.30,  2),
('André Figueiredo',   'andre.fig@email.com',       '556.677.889-90', '(84)99025-5025', '1989-08-19', 'M', 6700.00,  740, 'Nordeste', 'RN', 'Natal',             '59010-000', 'Av. Rio Branco, 400',        '2023-06-28', '2025-03-25', 8120.60,  6),
('Beatriz Moura',      'bia.moura@email.com',       '667.788.990-01', '(98)99026-6026', '1997-12-06', 'F', 3400.00,  570, 'Nordeste', 'MA', 'São Luís',          '65010-000', 'Rua Grande, 150',            '2023-07-15', '2025-02-10', 2450.80,  2),
('Caio Rodrigues',     'caio.rod@email.com',        '778.899.001-12', '(79)99027-7027', '1993-03-01', 'M', 5500.00,  700, 'Nordeste', 'SE', 'Aracaju',           '49010-000', 'Rua Laranjeiras, 200',       '2023-08-20', '2025-04-15', 5980.40,  4),
('Débora Pinto',       'debora.pinto@email.com',    '889.900.112-23', '(82)99028-8028', '1990-07-24', 'F', 4900.00,  660, 'Nordeste', 'AL', 'Maceió',            '57020-000', 'Rua do Comércio, 80',        '2023-04-12', '2025-05-01', 7340.20,  5),
('Eduardo Lima',       'edu.lima@email.com',        '990.011.223-34', '(86)99029-9029', '1986-11-15', 'M', 7600.00,  790, 'Nordeste', 'PI', 'Teresina',          '64000-000', 'Av. Frei Serafim, 500',      '2023-09-05', '2025-04-28', 11230.90, 8),
('Fernanda Araújo',    'fer.araujo@email.com',      '001.122.334-45', '(83)99030-0030', '1998-05-08', 'F', 3600.00,  600, 'Nordeste', 'PB', 'João Pessoa',       '58010-000', 'Rua Duque de Caxias, 300',   '2023-10-18', '2025-02-22', 3150.50,  3);

-- Pedidos (60 registros — ~20 por região)
INSERT INTO pedidos (cliente_id, data_pedido, valor_total, status, regiao_entrega, estado_entrega, frete, metodo_pagamento) VALUES
-- SUDESTE
(1,  '2024-08-15', 5849.80, 'Entregue',    'Sudeste',  'SP', 0.00,   'Pix'),
(1,  '2025-01-20', 649.80,  'Entregue',    'Sudeste',  'SP', 15.90,  'Cartão Crédito'),
(2,  '2024-06-10', 8298.00, 'Entregue',    'Sudeste',  'RJ', 0.00,   'Cartão Crédito'),
(2,  '2024-11-05', 3098.90, 'Entregue',    'Sudeste',  'RJ', 22.50,  'Pix'),
(2,  '2025-03-22', 549.90,  'Enviado',     'Sudeste',  'RJ', 18.90,  'Boleto'),
(3,  '2024-09-18', 2899.00, 'Entregue',    'Sudeste',  'SP', 25.00,  'Cartão Crédito'),
(3,  '2025-02-10', 489.80,  'Entregue',    'Sudeste',  'SP', 15.90,  'Pix'),
(4,  '2024-07-25', 5499.90, 'Entregue',    'Sudeste',  'MG', 35.00,  'Cartão Crédito'),
(4,  '2024-12-15', 1099.80, 'Entregue',    'Sudeste',  'MG', 28.00,  'Boleto'),
(5,  '2024-10-08', 1899.00, 'Entregue',    'Sudeste',  'ES', 30.00,  'Pix'),
(6,  '2024-05-12', 10498.90,'Entregue',    'Sudeste',  'SP', 0.00,   'Cartão Crédito'),
(6,  '2024-09-30', 5598.00, 'Entregue',    'Sudeste',  'SP', 0.00,   'Cartão Crédito'),
(6,  '2025-02-28', 2799.00, 'Enviado',     'Sudeste',  'SP', 0.00,   'Pix'),
(7,  '2024-08-20', 3199.00, 'Entregue',    'Sudeste',  'RJ', 28.00,  'Cartão Débito'),
(7,  '2025-01-10', 899.90,  'Entregue',    'Sudeste',  'RJ', 22.00,  'Pix'),
(8,  '2024-06-05', 6299.90, 'Entregue',    'Sudeste',  'MG', 32.00,  'Cartão Crédito'),
(8,  '2024-11-20', 4250.00, 'Entregue',    'Sudeste',  'MG', 35.00,  'Cartão Crédito'),
(9,  '2025-01-05', 2399.00, 'Entregue',    'Sudeste',  'SP', 18.00,  'Boleto'),
(10, '2024-10-15', 3349.80, 'Entregue',    'Sudeste',  'RJ', 20.00,  'Cartão Crédito'),
(10, '2025-04-01', 1259.70, 'Processando', 'Sudeste',  'RJ', 22.00,  'Pix'),
-- SUL
(11, '2024-07-10', 3548.90, 'Entregue',    'Sul',      'RS', 30.00,  'Cartão Crédito'),
(11, '2025-02-15', 489.80,  'Entregue',    'Sul',      'RS', 20.00,  'Pix'),
(12, '2024-05-20', 5499.90, 'Entregue',    'Sul',      'PR', 25.00,  'Cartão Crédito'),
(12, '2024-09-08', 3098.90, 'Entregue',    'Sul',      'PR', 22.00,  'Pix'),
(12, '2025-03-18', 1599.00, 'Enviado',     'Sul',      'PR', 28.00,  'Boleto'),
(13, '2024-10-22', 2899.00, 'Entregue',    'Sul',      'SC', 32.00,  'Cartão Crédito'),
(14, '2024-06-15', 8298.90, 'Entregue',    'Sul',      'RS', 0.00,   'Cartão Crédito'),
(14, '2024-10-01', 5598.00, 'Entregue',    'Sul',      'RS', 0.00,   'Cartão Crédito'),
(14, '2025-01-28', 2799.00, 'Entregue',    'Sul',      'RS', 0.00,   'Pix'),
(14, '2025-04-10', 549.90,  'Processando', 'Sul',      'RS', 18.00,  'Cartão Débito'),
(15, '2024-08-05', 3199.00, 'Entregue',    'Sul',      'PR', 28.00,  'Cartão Crédito'),
(15, '2025-02-20', 899.90,  'Entregue',    'Sul',      'PR', 22.00,  'Pix'),
(16, '2024-09-12', 5499.90, 'Entregue',    'Sul',      'SC', 30.00,  'Cartão Crédito'),
(16, '2025-03-30', 799.90,  'Enviado',     'Sul',      'SC', 25.00,  'Boleto'),
(17, '2024-11-10', 1899.00, 'Entregue',    'Sul',      'RS', 20.00,  'Pix'),
(18, '2024-06-25', 6299.90, 'Entregue',    'Sul',      'PR', 0.00,   'Cartão Crédito'),
(18, '2024-10-18', 5598.00, 'Entregue',    'Sul',      'PR', 0.00,   'Cartão Crédito'),
(18, '2025-04-05', 3199.00, 'Enviado',     'Sul',      'PR', 0.00,   'Pix'),
(19, '2024-08-28', 2899.00, 'Entregue',    'Sul',      'SC', 28.00,  'Cartão Débito'),
(20, '2025-01-15', 3548.90, 'Entregue',    'Sul',      'RS', 25.00,  'Cartão Crédito'),
-- NORDESTE
(21, '2024-07-20', 3199.00, 'Entregue',    'Nordeste', 'BA', 45.00,  'Pix'),
(21, '2025-01-08', 899.90,  'Entregue',    'Nordeste', 'BA', 35.00,  'Cartão Débito'),
(22, '2024-09-05', 2899.00, 'Entregue',    'Nordeste', 'PE', 42.00,  'Cartão Crédito'),
(22, '2025-03-12', 349.90,  'Enviado',     'Nordeste', 'PE', 28.00,  'Pix'),
(23, '2024-05-18', 5499.90, 'Entregue',    'Nordeste', 'CE', 40.00,  'Cartão Crédito'),
(23, '2024-08-30', 3199.00, 'Entregue',    'Nordeste', 'CE', 38.00,  'Pix'),
(23, '2024-12-20', 2899.00, 'Entregue',    'Nordeste', 'CE', 35.00,  'Cartão Crédito'),
(23, '2025-04-15', 1599.00, 'Processando', 'Nordeste', 'CE', 32.00,  'Boleto'),
(24, '2024-10-10', 1899.00, 'Entregue',    'Nordeste', 'BA', 40.00,  'Pix'),
(25, '2024-08-08', 4250.00, 'Entregue',    'Nordeste', 'RN', 48.00,  'Cartão Crédito'),
(25, '2025-02-05', 1599.00, 'Entregue',    'Nordeste', 'RN', 38.00,  'Boleto'),
(26, '2024-11-15', 1899.00, 'Entregue',    'Nordeste', 'MA', 50.00,  'Pix'),
(27, '2024-09-22', 2799.00, 'Entregue',    'Nordeste', 'SE', 44.00,  'Cartão Crédito'),
(27, '2025-03-08', 899.90,  'Enviado',     'Nordeste', 'SE', 35.00,  'Pix'),
(28, '2024-07-05', 3199.00, 'Entregue',    'Nordeste', 'AL', 46.00,  'Cartão Crédito'),
(28, '2024-12-01', 1899.00, 'Entregue',    'Nordeste', 'AL', 40.00,  'Pix'),
(28, '2025-04-20', 549.90,  'Pendente',    'Nordeste', 'AL', 30.00,  'Boleto'),
(29, '2024-06-12', 5499.90, 'Entregue',    'Nordeste', 'PI', 42.00,  'Cartão Crédito'),
(29, '2024-11-28', 2899.00, 'Entregue',    'Nordeste', 'PI', 38.00,  'Cartão Crédito'),
(30, '2024-10-25', 1899.00, 'Entregue',    'Nordeste', 'PB', 40.00,  'Pix');

-- Itens dos pedidos (72 registros)
INSERT INTO itens_pedido (pedido_id, produto_id, quantidade, preco_unitario, subtotal) VALUES
-- Pedidos Sudeste
(1,  1,  1, 5499.90, 5499.90),  (1,  3,  1, 349.90,  349.90),
(2,  9,  1, 299.90,  299.90),   (2,  3,  1, 349.90,  349.90),
(3,  1,  1, 5499.90, 5499.90),  (3,  8,  1, 2799.00, 2799.00),
(4,  4,  1, 3199.00, 3199.00),
(5,  14, 1, 549.90,  549.90),
(6,  2,  1, 2899.00, 2899.00),
(7,  9,  1, 299.90,  299.90),   (7,  10, 1, 189.90,  189.90),
(8,  1,  1, 5499.90, 5499.90),
(9,  6,  1, 899.90,  899.90),   (9,  10, 1, 189.90,  189.90),
(10, 19, 1, 1899.00, 1899.00),
(11, 1,  1, 5499.90, 5499.90),  (11, 8,  1, 2799.00, 2799.00),  (11, 17, 1, 159.90, 159.90),
(12, 4,  1, 3199.00, 3199.00),  (12, 7,  1, 1599.00, 1599.00),  (12, 12, 1, 399.90, 399.90),
(13, 8,  1, 2799.00, 2799.00),
(14, 4,  1, 3199.00, 3199.00),
(15, 6,  1, 899.90,  899.90),
(16, 1,  1, 5499.90, 5499.90),  (16, 20, 1, 799.90,  799.90),
(17, 5,  1, 4250.00, 4250.00),
(18, 7,  1, 1599.00, 1599.00),  (18, 20, 1, 799.90,  799.90),
(19, 8,  1, 2799.00, 2799.00),  (19, 14, 1, 549.90,  549.90),
(20, 11, 1, 459.90,  459.90),   (20, 20, 1, 799.90,  799.90),
-- Pedidos Sul
(21, 2,  1, 2899.00, 2899.00),  (21, 3,  1, 349.90,  349.90),   (21, 9,  1, 299.90,  299.90),
(22, 9,  1, 299.90,  299.90),   (22, 10, 1, 189.90,  189.90),
(23, 1,  1, 5499.90, 5499.90),
(24, 2,  1, 2899.00, 2899.00),  (24, 10, 1, 189.90,  189.90),
(25, 7,  1, 1599.00, 1599.00),
(26, 2,  1, 2899.00, 2899.00),
(27, 1,  1, 5499.90, 5499.90),  (27, 8,  1, 2799.00, 2799.00),
(28, 4,  1, 3199.00, 3199.00),  (28, 7,  1, 1599.00, 1599.00),  (28, 12, 1, 399.90, 399.90),
(29, 8,  1, 2799.00, 2799.00),
(30, 14, 1, 549.90,  549.90),
(31, 4,  1, 3199.00, 3199.00),
(32, 6,  1, 899.90,  899.90),
(33, 1,  1, 5499.90, 5499.90),
(34, 20, 1, 799.90,  799.90),
(35, 19, 1, 1899.00, 1899.00),
(36, 1,  1, 5499.90, 5499.90),  (36, 20, 1, 799.90,  799.90),
(37, 4,  1, 3199.00, 3199.00),  (37, 7,  1, 1599.00, 1599.00),  (37, 12, 1, 399.90, 399.90),
(38, 4,  1, 3199.00, 3199.00),
(39, 2,  1, 2899.00, 2899.00),
(40, 2,  1, 2899.00, 2899.00),  (40, 3,  1, 349.90,  349.90),   (40, 9,  1, 299.90,  299.90),
-- Pedidos Nordeste
(41, 4,  1, 3199.00, 3199.00),
(42, 6,  1, 899.90,  899.90),
(43, 2,  1, 2899.00, 2899.00),
(44, 3,  1, 349.90,  349.90),
(45, 1,  1, 5499.90, 5499.90),
(46, 4,  1, 3199.00, 3199.00),
(47, 2,  1, 2899.00, 2899.00),
(48, 7,  1, 1599.00, 1599.00),
(49, 19, 1, 1899.00, 1899.00),
(50, 5,  1, 4250.00, 4250.00),
(51, 7,  1, 1599.00, 1599.00),
(52, 19, 1, 1899.00, 1899.00),
(53, 8,  1, 2799.00, 2799.00),
(54, 6,  1, 899.90,  899.90),
(55, 4,  1, 3199.00, 3199.00),
(56, 19, 1, 1899.00, 1899.00),
(57, 14, 1, 549.90,  549.90),
(58, 1,  1, 5499.90, 5499.90),
(59, 2,  1, 2899.00, 2899.00),
(60, 19, 1, 1899.00, 1899.00);

-- -----------------------------------------------------------------------------
-- 4. VERIFICAÇÃO RÁPIDA
-- -----------------------------------------------------------------------------

SELECT 'clientes'     AS tabela, COUNT(*) AS registros FROM clientes
UNION ALL
SELECT 'produtos',     COUNT(*) FROM produtos
UNION ALL
SELECT 'pedidos',      COUNT(*) FROM pedidos
UNION ALL
SELECT 'itens_pedido', COUNT(*) FROM itens_pedido;

-- Resultado esperado: 30 clientes, 20 produtos, 60 pedidos, 72 itens
