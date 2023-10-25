create database sistema;
use sistema;
drop database sistema;
create table cliente(
id_cliente int primary key auto_increment,
nome varchar(255) not null,
telefone varchar(20) not null,
endereço varchar(255) not null
);

create table pedido(
id_pedido int primary key auto_increment,
data_criacao date not null,
cliente_id int,
foreign key (cliente_id) references cliente(id_cliente)
);

create table detalhespedido(
id_detalhepedido int primary key auto_increment,
quantidade int not null,
preco double not null,
produto_id int,
pedido_id int,
foreign key (produto_id) references pedido(id_pedido),
foreign key (pedido_id) references produto(id_produto)
);

create table produto(
id_produto int primary key auto_increment,
nome varchar(255) not null,
descricao text not null,
quantidade_estoque int not null
);

create table avaliacoes(
id_avalicao int primary key auto_increment,
quantidade_estrelas int not null,
comentario text,
cliente_id int,
produto_id int,
foreign key (cliente_id) references cliente(id_cliente),
foreign key (produto_id) references produto(id_produto)
);

create table endereco(
id_endereco int primary key auto_increment,
cep varchar(9) not null,
rua varchar(255) not null,
numero int not null,
complemento text,
cliente_id int,
foreign key (cliente_id) references cliente(id_cliente)
);

INSERT INTO cliente (nome, telefone, endereco) VALUES
('Cliente A', '111-111-1111', 'Endereço 1'),
('Cliente B', '222-222-2222', 'Endereço 2'),
('Cliente C', '333-333-3333', 'Endereço 3');


INSERT INTO endereco (cep, rua, numero, complemento, cliente_id) VALUES
('12345-678', 'Rua A', 123, 'Apto 1A', 1),
('54321-876', 'Avenida B', 456, 'Casa 2B', 2),
('98765-432', 'Praça C', 789, NULL, 3);


INSERT INTO produto (nome, descricao, quantidade_estoque) VALUES
('Produto 1', 'Descrição do Produto 1', 100),
('Produto 2', 'Descrição do Produto 2', 50),
('Produto 3', 'Descrição do Produto 3', 75);


INSERT INTO pedido (data_criacao, cliente_id) VALUES
('2023-01-15', 1),
('2023-01-16', 2),
('2023-01-17', 1);


INSERT INTO detalhespedido (quantidade, preco, produto_id, pedido_id) VALUES
(2, 10.99, 1, 1),
(3, 25.50, 2, 1),
(1, 5.99, 3, 2),
(4, 12.99, 1, 2);


INSERT INTO avaliacoes (quantidade_estrelas, comentario, cliente_id, produto_id) VALUES
(5, 'Bom produto!', 1, 1),
(4, 'Produto ok.', 2, 2),
(3, 'Poderia ser melhor.', 1, 3);

select * from detalhespedido;

alter table cliente add foreign key (endereco_id) references endereco(id_endereco);
desc cliente;
desc endereco;
select * from endereco;


alter table cliente drop column endereco_id;
alter table cliente add column endereco_id int; 
alter table cliente add foreign key (endereco_id) references endereco(id_endereco);

create view pedidodetalhado as
select 
p.id_pedido,
p.data_criacao,
c.nome as nome_cliente,
e.cep,
e.numero,
dp.quantidade,
dp.preco,
pr.nome as nome_produto,
pr.descricao as descricao_produto
from pedido p
inner join cliente c on p.cliente_id = c.id_cliente
inner join endereco e on c.id_cliente = e.cliente_id
inner join detalhespedido dp on p.id_pedido = dp.pedido_id
inner join produto pr on dp.produto_id = pr.id_produto;

select * from pedidodetalhado;

create view infomacoes_endereco as
select 
	c.nome as NomeCliente,
	e.cep,
	e.numero as Número,
	p.nome as NomeProduto,
	dp.quantidade as Quantidade
from endereco e 
inner join cliente c on e.cliente_id = c.id_cliente 
inner join detalhespedido dp on dp.pedido_id = e.id_endereco
inner join produto p on dp.produto_id = p.id_produto
;
select * from infomacoes_endereco;


CREATE VIEW ViewInfoCliente AS
SELECT
    c.nome AS NomeCliente,
    e.cep,
    e.numero AS NumeroCasa,
    p.nome AS NomeProduto,
    dp.quantidade AS Quantidade
FROM detalhespedido dp
INNER JOIN pedido ped ON dp.pedido_id = ped.id_pedido
INNER JOIN cliente c ON ped.cliente_id = c.id_cliente
INNER JOIN endereco e ON c.id_cliente = e.cliente_id
INNER JOIN produto p ON dp.produto_id = p.id_produto;

select * from ViewInfoCliente;
select * from endereco;
delete from cliente where endereco_id = 'a';

use sistema;

-- codigo trigger
-- CREATE DEFINER=`root`@`localhost` TRIGGER `sistema`.`detalhespedido_BEFORE_INSERT` BEFORE INSERT ON `detalhespedido` 
-- FOR EACH ROW
-- BEGIN
-- 	DECLARE produto_quantidade INT;
--      SELECT quantidade_estoque INTO produto_quantidade
--      FROM produto
-- 	 WHERE id_produto = NEW.produto_id;
--      UPDATE produto
-- 	 SET quantidade_estoque = produto_quantidade - NEW.quantidade
-- 	 WHERE id_produto = NEW.produto_id;
-- END
insert into detalhespedido(quantidade,preco,produto_id)values (10,100.00,3);



drop index indexpreco on detalhespedido;
desc detalhespedido;
select * from produto;
select * from avaliacoes;
create unique index indexpreco on detalhespedido(id_detalhepedido);

select * from detalhespedido where preco > 25.00 order by preco desc;

select * from detalhespedido;