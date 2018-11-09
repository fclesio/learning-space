use loja;
create table produtos (id integer auto_increment primary key, nome varchar(255), preco decimal(10,2));
alter table produtos add column usado boolean default false;
alter table produtos add column descricao varchar(255);
create table categorias (id integer auto_increment primary key, nome varchar(255));
insert into categorias (nome) values ("Futebol"), ("Volei"), ("Tenis");
alter table produtos add column categoria_id integer;
update produtos set categoria_id = 1;