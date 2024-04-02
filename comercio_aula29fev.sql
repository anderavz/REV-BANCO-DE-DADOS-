---------------------------------------------
--criação do banco de dados 
--------------------------------------------
create database ADMBD_VendasM
go

--------------------------------------------
--acessar o banco de dados
--------------------------------------------
use ADMBD_VendasM
go

------------------------------------------
--criação das tabelas
------------------------------------------

-----------------------------------------
--tabela pessoas
----------------------------------------
 create table Pessoas
(
	idPessoa int 		not null primary key identity,
	nome varchar(50) 	not null,
	cpf varchar(14) 	not null unique, ---- unico 
	status int 			null  check(status in(1,2)) ----- checar o status que é 1 ou 2 
)
go 

-----------------------------------------
--tabela clientes
-----------------------------------------
create table Clientes
(
	pessoaId int 			not null primary key, -- vai puxar da tabela pessoas
	renda decimal(10,2) 	not null check (renda >= 700.00), --uso isso para checar a restrição 
	credito decimal(10,2) 	not null check (credito >= 100.00),
	foreign key (pessoaId)	references Pessoas(idPessoa)
)
go

-----------------------------------------
--tabela vendedores
-----------------------------------------
create table Vendedores
(
	pessoaId int 			not null primary key, -- vai puxar da tabela pessoas
	salario decimal(10,2) 	not null check (salario >= 1000.00),
	foreign key (pessoaId)	references Pessoas(idPessoa)
)
go

-----------------------------------------
--tabela pedidos
-----------------------------------------
create table Pedidos
(
	idPedido int	not null primary key identity,
	data datetime 	not null, --DIA, MES E ANO, HORA, MINUTO E SEGUNDO
	valor money		null, --mesma função no decimal  para dinheiro
	status int 		null check (status in (1,2,3)), --tem que ser NULL para ser preenchido depois na finalização do pedido 
	--chaves estrangeiras na tabela
	vendedorId int 	not null, --criar primeiro as colunas e depois as foreign keys EX: abaixo
	clienteId int	not null,
	foreign key(vendedorId) references Vendedores(pessoaId), --vai usar o mesmo id que pessoa
	foreign key(clienteId) references Clientes(pessoaId) --vai usar o mesmo id que pessoa
)
go

-----------------------------------------
--tabela produtos
-----------------------------------------
create table Produtos
(
	idProduto int			not null primary key identity,
	descricao varchar (100) not null,
	quantidade int			null check(quantidade >= 0),
	valor decimal(10,2)		null check(valor > 0),
	status int				null check (status in (1,2))
)
go

-----------------------------------------
--tabela itens_pedidos
-----------------------------------------
create table Itens_Pedidos
(
	pedidoId int not null,
	produtoId int not null,
	quantidade int null check(quantidade >= 0),
	valor money null check(valor > 0.0),
	--primary key composta (PK) ----------------------- resultado da relação NXN(n para n) no modelo relacional
	primary key(pedidoId, produtoId),
	--chaves estrangeiras(FK) ------------------------- estou puxando os dados das outras tabelas
	foreign key(pedidoId)	references Pedidos(idPedido),
	foreign key(produtoId)	references Produtos(idProduto),
)
go

-----------------------------------------
--INSERIR DADOS NAS TABELAS------------------------INSERTS
-----------------------------------------


-----------------------------------------
--INSERIR NA TABELA PESSOAS
-----------------------------------------
insert into Pessoas(nome, cpf, status) --insert especificando as colunas
values
	('Valeria',	'111.111.111-11', 1)
go

insert into Pessoas --insert nao especificando as colunas tenho que preencher na ordem da tabela
values
	('Mario',	'222.222.222-22', 1)
go


insert into Pessoas (nome, cpf, status) --insert em maior quantidade
values
	('José Carlos',	'111.111.111-12', 2),
	('Maria Rita',	'111.111.111-13', 1),
	('Antonio',		'111.111.111-14', 2),
	('Henrique',	'111.111.111-15', 2),
	('Sergio',		'111.111.111-16', 2)
go

-----------------------------------------
--INSERIR NA TABELA CLIENTES -----------------------lembre-se que cliente é uma pessoa tmb
-----------------------------------------
insert into Clientes (pessoaId, renda, credito)
values
	(1,5000.00,1500.00)
go

insert into Clientes --inserindo em maior quantidade e de uma vez só
values
	(3,2500.00,750.00),--os clientes estao cadastrados com o id impar para melhor entendimento 
	(5,7500.00,2500.00),
	(7,3000.00,900.00)
go

-----------------------------------------
--INSERIR NA TABELA VENDEDORES -----------------------lembre-se que vendedor é uma pessoa tmb
-----------------------------------------
insert into Vendedores (pessoaId, salario)
values
	(2,2500.00)
go

insert into Vendedores 
values
	(4,3500.00),--os vendedores estao cadastrados com o id par para melhor entendimento
	(6,1200.00)
go

---------------------------------------------------------------------------
--CONSULTAR AS TABELAS PESSOAS E CLIENTES PARA SABER OS NOMES DOS CLIENTES
---------------------------------------------------------------------------
select	Pessoas.idPessoa codigo, Pessoas.nome Cliente, Pessoas.cpf CPF, Pessoas.status Situação, Clientes.renda Renda, Clientes.credito Credito
from	Pessoas, Clientes --JUNÇÃO DAS DUAS TABELAS
where	Pessoas.idPessoa = Clientes.pessoaId
go

--USANDO INNER JOIN 
select	Pessoas.idPessoa codigo, Pessoas.nome Cliente, Pessoas.cpf CPF, Pessoas.status Situação, Clientes.renda Renda, Clientes.credito Credito
from Pessoas inner join Clientes on Pessoas.idPessoa = Clientes.pessoaId
go

---------------------------------------------------------------------------
--CONSULTAR AS TABELAS PESSOAS E CLIENTES PARA SABER OS NOMES DOS CLIENTES
--TODOS OS PEDIDOS DE CADA CLIENTE
---------------------------------------------------------------------------
select	P.idPessoa Cod_CLiente, P.nome Cliente, P.cpf CPF, P.status Situacao,
		C.renda Renda, C.credito Credito, Pe.status Situacao_Cliente,
		Pe.idPedido No_Pedido,
		Pe.data Data_Pedido, Pe.status Situacao_Pedido
from	Pessoas P, Clientes C, Pedidos Pe
where	P.idPessoa = C.pessoaId and C.pessoaId = Pe.clienteId
order by P.nome
go

--USANDO INNER JOIN 


---------------------------------------------------------------------------
--CONSULTAR AS TABELAS PESSOAS E VENDEDORES PARA SABER OS NOMES DOS VENDEDORES
---------------------------------------------------------------------------
select	Pessoas.idPessoa codigo, Pessoas.nome Vendedor, Pessoas.cpf CPF, Pessoas.status Situação, Vendedores.salario Salario
from	Pessoas, Vendedores --JUNÇÃO DAS DUAS TABELAS
where	Pessoas.idPessoa = Vendedores.pessoaId
go

--USANDO INNER JOIN 
select	Pessoas.idPessoa codigo, Pessoas.nome Vendedor, Pessoas.cpf CPF, Pessoas.status Situação, Vendedores.salario Salario
from Pessoas inner join Vendedores on Pessoas.idPessoa = Vendedores.pessoaId
go


select * from Pessoas
go

select * from Clientes
go

select * from Vendedores
go

-----------------------------------------
--INSERIR NA TABELA PRODUTOS
-----------------------------------------

insert into Produtos (descricao, quantidade, valor, status)
values
	('Coca cola', 150, 5.00, 1)
go
 
insert into Produtos (descricao, quantidade, valor)
values
	('Chocolate ao leite', 200,10.00)
go

insert into Produtos
values
	('cocada',25, 4.50, 1),
	('BIscoito', 35, 7.60, 1),
	('Chocolate Branco', 200, 12.59, 2),
	('Cotuba', 550, 5.50, 1),
	('Coxinha de Frango', 60, 7.80, 1),
	('ESfirra de Carne', 45, 8.50, 2),
	('Sorvete de Creme', 70, 11.35, 1),
	('Bala Baiana', 40, 4.00, 1),
	('Bolo de coco', 10, 17.50, 2)
go

select * from Produtos --mostra todos os produtos cadastrados 
go

-----------------------------------------
--INSERIR NA TABELA PEDIDOS
-----------------------------------------

insert into Pedidos (data, status, vendedorId, clienteId)
values 
	('2023-11-12', 3, 2, 5)
go

insert into Pedidos (data, status, vendedorId, clienteId)
values
	('2024-23-01', 2, 4, 7)
go

insert into Pedidos (data, status, vendedorId, clienteId)
values
	('2024-15-01', 2, 4, 3),
	('2024-10-02', 1, 6, 7),
	('2024-15-01', 2, 6, 5),
	('2024-29-02', 1, 2, 3),
	(GETDATE(), 1, 2, 7),--getdate pega a data do dia 
	(GETDATE(), 2, 4, 3)
go

select * from Pedidos
go

-----------------------------------------
--INSERIR NA TABELA ITENS_PEDIDOS
-----------------------------------------
--estou cadastrando os dados do pedido 1

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(1, 1, 3, 4.50),
	(1, 5, 6, 12.59),
	(1, 9, 2, 11.35)
go

--estou cadastrando dados do pedido 2

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(2, 3, 1, 4.50),
	(2, 8, 30, 8.25),
	(2, 2, 50, 9.50),
	(2, 10, 4, 4.00)
go

--estou cadastrando dados do pedido 3

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(3, 5, 5, 12.59)
go

--estou cadastrando dados do pedido 4

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(4, 7, 3, 7.80),
	(4, 6, 1, 5.50),
	(4, 8, 2, 8.50),
	(4, 1, 1, 5.50)
go

--estou cadastrando dados do pedido 5

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(5, 4, 2, 7.60),
	(5, 2, 5, 10.00)
go

--estou cadastrando dados do pedido 6

insert into Itens_Pedidos (pedidoId, produtoId, quantidade, valor)
values 
	(6, 10, 5, 4.00),
	(6, 3, 10, 4.50)
go

------------------------------------------------------------------------
--CONSULTAR OS PRODUTOS DE CADA PEDIDO 
------------------------------------------------------------------------
select	Pe.idPedido No_Pedido, Pe.data Data_Pedido, Pe.status Sit_Pedido,
		Pe.clienteId Cod_cliente, Pe.vendedorId Cod_Vendedor,
		Pe.valor Total_Pedido, IP.quantidade Qtd_Prod, IP.valor Valor_Venda,
		(IP.quantidade * IP.valor) Total_Item, Pr.idProduto Cod_produto, Pr.descricao Produto
from Pedidos Pe, Itens_Pedidos IP, Produtos Pr -- junção das tabelas
where Pe.idPedido = IP.pedidoId and IP.produtoId = Pr.idProduto
order by pe.idPedido
go

--USANDO INNER JOIN
select	Pe.idPedido No_Pedido, Pe.data Data_Pedido, Pe.status Sit_Pedido,
		Pe.clienteId Cod_cliente, Pe.vendedorId Cod_Vendedor,
		Pe.valor Total_Pedido, IP.quantidade Qtd_Prod, IP.valor Valor_Venda,
		(IP.quantidade * IP.valor) Total_Item, Pr.idProduto Cod_produto, Pr.descricao Produto
from Pedidos Pe inner join Itens_Pedidos IP on Pe.idPedido = IP.pedidoId
				inner join Produtos Pr		on IP.produtoId = Pr.idProduto
order by Pe.idPedido
go


----------------------------------------------------------------------------------
--CONSULTAR  A QUANTIDADE DE INTENS NA TABELA DE PRODUTOS, CONSULTAR A QUANTIDADE
-- DE PRODUTOS EM ESTOQUE, O PREÇO MEDIO DOS PRODUTOS, O PREÇO DO PRODUTO MAIS CARO
-- E O PREÇO DO PRODUTO MAIS BARATO-
-----------------------------------------------------------------------------------
select  count(idProduto) quantidade, sum(quantidade) estoque, avg(valor)Preco_Medio,
		max(valor) Produto_Mais_Caro, min(valor) Produto_Mais_Barato
from Produtos
go

select * from Produtos
go

----------------------------------------------------------------------------------
--CONSULTAR O TOTAL DE CADA PEDIDO 
-----------------------------------------------------------------------------------
select	Pe.idPedido Cod_Pedido, Pe.data Data_Pedido,
		sum(IP.quantidade * IP.valor) Total_Pedido
from pedidos Pe, Itens_Pedidos IP
where Pe.idPedido = IP.pedidoId
group by Pe.idPedido, Pe.data --tenho que usar as tabelas que eu chamei la no select OBS: o sum eu criei agr e nao existe em tabela nenhuma,. por isso nao devo colocar p nao dar erro
go

-- CONSULTAR TODOS OS CLIENTES QUE O NOME COMEÇA COM A LETRA V

select P.idPessoa, Cod_Cliente, P.nome Cliente, P.cpf CPF, P.status Situacao, C.renda Renda, C.credito Credito
from Pessoas P, Clientes C
where P.nome Like 'V%' and P.idPessoa = C.pessoaId
go

select * from Pessoas
insert into Pessoas (cpf, nome, status) values ('110.110.110.11', 'Viana', 2);
go
insert into Clientes (pessoaId, renda, credito) values
(10, 5000.0, 1500.00)
go

---------------------------------------------------------------------------------------------
-- Consultar todos os produtos que tem a sílada BA na descrição
---------------------------------------------------------------------------------------------
select idProduto Cod_Produto, descricao Produto, quantidade Estoque, valor Preco,
status Situacao
from Produtos
where descricao Like '%BA%'
go

---------------------------------------------------------------------------------------------
--Consultar todos os produtos com valor entre 1.00 e 7.50
---------------------------------------------------------------------------------------------

select idProduto Cod_Produto, descricao Produto, quantidade Estoque, 
valor Preco, status Situacao
from Produtos
where valor between 1.00 and 7.50
go

-- operador de comparação
select idProduto Cod_Produto, descricao Produto, quantidade Estoque, 
valor Preco, status Situacao
from Produtos
where valor >= 1.00 and valor <= 7.50
go

select C.pessoaId Cod_Cliente, P.nome Cliente, P.cpf CPF, P.status Situacao, C.credito Credito, C.renda Renda
from Pessoas P, Clientes C
where P.idPessoa = C.pessoaId
go

select idProduto Cod_Produto, descricao Produto, quantidade Estoque, 
valor Preco, status Situacao
from Produtos
where valor not between 5.00 and 7.50
go

select idProduto Cod_Produto, descricao Produto, quantidade Estoque, 
valor Preco, status Situacao
from Produtos
where valor < 5.00 or valor > 7.50
go


---------------------------------------------------------------------------------------------
-- Consultar todos os produtos que NÃO tem a sílada BA na descrição
---------------------------------------------------------------------------------------------
select idProduto Cod_Produto, descricao Produto, quantidade Estoque, valor Preco,
status Situacao
from Produtos
where descricao not Like '%BA%'
go

---------------------------------------------------------------------------------------------
-- Consultar todas as pessoas com status 1 ou 2
---------------------------------------------------------------------------------------------

select idPessoa Cod_Pessoa, nome Nome, cpf CPF, status Status
from Pessoas
where status in (1,2)
go

---------------------------------------------------------------------------------------------
-- Consultar todas as pessoas com status diferente de 1 ou 2
---------------------------------------------------------------------------------------------
select idPessoa Cod_Pessoa, nome Nome, cpf CPF, status Status
from Pessoas
where status not in (1,2) or status is null
go

---------------------------------------------------------------------------------------------
-- Consultar todos os pedidos com o status 1 ou 2
---------------------------------------------------------------------------------------------

select idPedido No_Pedido, data Data_Pedido, valor 'Total Pedido',
status Sit_Pedido
from Pedidos
where status in (1,2)
go

---------------------------------------------------------------------------------------------
-- Consultar todos os pedidos diferente de 1 ou 2
---------------------------------------------------------------------------------------------

select idPedido No_Pedido, data Data_Pedido, valor 'Total Pedido',
status Sit_Pedido
from Pedidos
where status not in (1,2)
go



-----------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS COM STATUS NULL 
-----------------------------------------------------------------------------

select idPessoa, nome, cpf, status
from Pessoas
where status IS NULL
go

-----------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS COM STATUS DIFERENTE DE NULL 
-----------------------------------------------------------------------------

select idPessoa, nome, cpf, status
from Pessoas
where status IS NOT NULL
go

-----------------------------------------------------------------------------
-- CONSULTAR TODOS OS PRODUTOS COM VALOR ACIMA DA MEDIA DE PREÇO
-----------------------------------------------------------------------------
select idProduto, descricao, quantidade, valor, status
from Produtos
where valor	>	(
					select avg(valor)
					from Produtos
				)
go

---------------------------------------------------------------------------------------------
--Update
---------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------
--Alterar a quantidade do produto com id = 2 para 90 unidades
---------------------------------------------------------------------------------------------

update Produtos set quantidade = 90 where Produtos.idProduto = 2
go


select * from Produtos
go

---------------------------------------------------------------------------------------------
--Consultar a tabela Itens_Pedidos para verificar a quantidade vendida
--de alguns produtos e atualizar a tabela de Produtos
---------------------------------------------------------------------------------------------

select * from Itens_Pedidos
go

select sum(quantidade) from Itens_Pedidos
where produtoID = 5
go

update Produtos set quantidade = quantidade - 6
where idProduto = 5
go

select * from Produtos
go

---------------------------------------------------------------------------------------------
--Consultar a tabela Itens_Pedidos e calcular o valor do Pedido 1
--Atualizar o valor do Pedido 1 
---------------------------------------------------------------------------------------------

select sum(quantidade * valor) 'Valor total do pedido' from Itens_Pedidos
where pedidoId = 1
go
--62,95
select * from Itens_Pedidos
where pedidoId = 1
go

select * from Pedidos
go

-- Atualização do valor do pedido 1
update Pedidos set valor = 62.95
where idPedido = 1
go

select sum(quantidade * valor) from Itens_Pedidos
where pedidoId = 2
go

select * from Itens_Pedidos where pedidoId = 2
go

update Pedidos set valor = (
								select sum(quantidade * valor) from Itens_Pedidos
								where pedidoId = 4
							)
where idPedido = 4
go

select * from Pedidos where idPedido = 2
go



--------------------------------------------------------------------------------------
--ATUALIZAR O STATUS DE TODOS OS PEDIDOS ATRIBUINDO O VALOR 1
------------------------------------------------------------------------------------

update Pedidos set status = 1
go

select * from Pedidos
go

--------------------------------------------------------------------------------------
-- CONSIDERAR QUE PEDIDOS COM O VALOR CALCULADO É PEDIDO FINALIZADO. 
-- ENTAO O STATUS DESSES PEDIDOS DEVE SER 3
------------------------------------------------------------------------------------

update Pedidos set status = 3
where valor is not  NULL -- != É SINAL DE DIFERENTE MAS NAO USO NO NULL, E SIM 'is not' PARA BUSCAR OS CADASTROS DIFERENTES DE NULL 
go

-----------------------------------------------------------------------------------
-- CALCULAR O TOTAL D EPEDIDO 4 USANDO A TABELA ITENS_PEDIDOS
-- ATUALIZAR O VALOR DO PEDIDO 4 NA TABELA PEDIDOS E ALTERAR O STATUS PARA
-- 3 INDICANDO QUE O PEIDDO FOI FINALIZADO 
-- OBJETIVO ----- ALTERAR DUAS COLUNAS EM UM UPDATE
-----------------------------------------------------------------------------------

update Pedidos set status = 3,
					valor = (
								select sum (quantidade * valor) from Itens_Pedidos
								where pedidoId = 4
							)
where idPedido = 4
go 

select * from Pedidos

----------------------------------------------------------------------------------
-- DAR AUMENTO DE 10% DE TODOS OS PRODUTOS CADASTRADOS
-----------------------------------------------------------------------------------

update Produtos set valor = valor + (valor * 0.10) --0.10 = 10%
go 

select * from Produtos
go

----------------------------------------------------------------------------------
-- DAR DESCONTO DE 5% PARA TODODS OS PRODUTOS CADASTRADOS COM QUANTIDADE MAIOR QUE 100 UNIDS
-----------------------------------------------------------------------------------

update Produtos set valor = valor - (valor * 0.05)
where quantidade > 100
go

select * from Produtos
where quantidade > 100
go

----------------------------------------------------------------------------------------
-- INNER JOIN
----------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------
-- CONSULTAR TODO OS CLIENTES E SEUS PEDIDOS 
----------------------------------------------------------------------------------------

select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente,
		c.renda Renda, Pe.idPedido No_Pedidos, Pe.data Data_Pedido,
		Pe.valor Total_Pedido, Pe.status Situação
from Pessoas P	inner join Clientes C	on P.idPessoa = C.pessoaId
				inner join Pedidos Pe	on C.pessoaId = Pe.clienteId
go


-----------------------------------------------------------------------------------------
-- CONSULTAR TODO OS CLIENTE, SEUS PRODUTOS E OS PRODUTOS DE CADA PEDIDO
----------------------------------------------------------------------------------------

select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente,
		c.renda Renda, Pe.idPedido No_Pedidos, Pe.data Data_Pedido,
		Pe.valor Total_Pedido, Pe.status Situação,
		Pr.idProduto No_Produto, Pr.descricao Produto, IP.quantidade QTD_Vendida,
		IP.valor Valor_Pago, (IP.quantidade * IP.valor) Total_Item
from Pessoas P	inner join Clientes C			on P.idPessoa = C.pessoaId
				inner join Pedidos Pe			on C.pessoaId = Pe.clienteId
				inner join Itens_Pedidos IP		on Pe.idPedido = IP.pedidoId
				inner join Produtos Pr			on IP.produtoId = Pr.idProduto
go


-----------------------------------------------------------------------------------------
-- CONSULTAR TODO OS CLIENTE QUE COMPRARAM ALGUM TIPO DE CHOCOLATE
----------------------------------------------------------------------------------------

select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente,
		c.renda Renda, Pe.idPedido No_Pedidos, Pe.data Data_Pedido,
		Pe.valor Total_Pedido, Pe.status Situação,
		Pr.idProduto No_Produto, Pr.descricao Produto, IP.quantidade QTD_Vendida,
		IP.valor Valor_Pago, (IP.quantidade * IP.valor) Total_Item
from Pessoas P	inner join Clientes C			on P.idPessoa = C.pessoaId
				inner join Pedidos Pe			on C.pessoaId = Pe.clienteId
				inner join Itens_Pedidos IP		on Pe.idPedido = IP.pedidoId
				inner join Produtos Pr			on IP.produtoId = Pr.idProduto
				and Pr.descricao like 'choco%'
go

-----------------------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS QUE SAO OU NAO CLIENTES
----------------------------------------------------------------------------------------

select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Cliente,
		C.renda Renda, C.credito Credito
from Pessoas P		left join Clientes C  on P.idPessoa = C.pessoaId
go
---------------------------------------------------------------------------OBS: A RENDA E O CREDITO VAI SER PREENCHIDO SE A PESSOA FOR CLIENTE 

-----------------------------------------------------------------------------------------
-- CONSULTAR TODAS AS PESSOAS QUE SAO OU NAO VENDEDORES
----------------------------------------------------------------------------------------
select	P.idPessoa Cod_Cliente, P.nome Cliente, P.cpf CPF_Vendedor,
		V.salario Salario
from Pessoas P		left join Vendedores V  on P.idPessoa = V.pessoaId
go
---------------------------------------------------------------------------OBS: O SALARIO VAI SER PREECHIDO SE A PESSOA FOR VENDEDOR 