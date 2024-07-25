create database livraria;

use livraria;

CREATE TABLE USUARIO (
    ID_USUARIO SERIAL PRIMARY KEY,
    NOME VARCHAR(30) NOT NULL,
    SEXO CHAR(1) NOT NULL CHECK (SEXO IN ('M', 'F')),
    EMAIL VARCHAR(50) UNIQUE,
    CPF VARCHAR(15) UNIQUE
);

CREATE TABLE ENDERECO (
    ID_ENDERECO SERIAL PRIMARY KEY,
    ID_USUARIO INT,
    RUA VARCHAR(30) NOT NULL,
    BAIRRO VARCHAR(30) NOT NULL,
    CIDADE VARCHAR(30) NOT NULL,
    ESTADO CHAR(2) NOT NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO)
);

ALTER TABLE ENDERECO
ALTER COLUMN rua TYPE VARCHAR(50);

ALTER TABLE ENDERECO
ALTER COLUMN bairro TYPE VARCHAR(50);

ALTER TABLE ENDERECO
ALTER COLUMN cidade TYPE VARCHAR(50);

CREATE TABLE TELEFONE (
    ID_TELEFONE SERIAL PRIMARY KEY,
    ID_USUARIO INT,
    TIPO CHAR(3) NOT NULL CHECK (TIPO IN ('RES', 'COM', 'CEL')),
    DDD CHAR(2) NOT NULL,
    NUMERO VARCHAR(10) unique NOT NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO)
);

drop table telefone;

CREATE TABLE LIVRO (
    ID_LIVRO SERIAL PRIMARY KEY,
    TITULO VARCHAR(100) NOT NULL,
    AUTOR VARCHAR(50) NOT NULL,
    ANO_PUBLICACAO INT NOT NULL,
    GENERO VARCHAR(50) NOT NULL
);

CREATE TABLE EMPRESTIMO (
    ID_EMPRESTIMO SERIAL PRIMARY KEY,
    ID_USUARIO INT,
    ID_LIVRO INT,
    DATA_EMPRESTIMO DATE,
    DATA_DEVOLUCAO DATE NULL,
    FOREIGN KEY (ID_USUARIO) REFERENCES USUARIO(ID_USUARIO),
    FOREIGN KEY (ID_LIVRO) REFERENCES LIVRO(ID_LIVRO)
);


insert into livraria.public.usuario (nome, sexo, email, cpf) values
('John Doe', 'M', 'john.doe@example.com', '12345678900');

select *
from livraria.public.usuario u;

insert into livraria.public.endereco (id_usuario, rua, bairro, cidade, estado) values
(1, 'Rua A', 'Bairro A', 'Cidade A', 'AA');

select *
from livraria.public.endereco e;

insert into livraria.public.telefone (id_usuario, tipo, ddd, numero) values
(1, 'RES', '11', '123456789');

select *
from livraria.public.telefone t;

insert into livraria.public.livro (TITULO, AUTOR, ANO_PUBLICACAO, GENERO) VALUES
('Livro B', 'Autor B', 2005, 'Não-Ficção');

select *
from livraria.public.livro l;

INSERT INTO EMPRESTIMO (ID_USUARIO, ID_LIVRO, DATA_EMPRESTIMO, DATA_DEVOLUCAO) VALUES
(1, 1, '2023-01-01', '2023-01-15');

select *
from livraria.public.emprestimo e;

drop table livraria.public.emprestimo ;


CREATE OR REPLACE FUNCTION check_user_loan_status()
RETURNS TRIGGER AS $$
BEGIN

    IF EXISTS (
        SELECT 1
        FROM EMPRESTIMO
        WHERE ID_USUARIO = NEW.ID_USUARIO
        AND DATA_DEVOLUCAO IS NULL
    ) THEN
        RAISE EXCEPTION 'O usuário % já possui um empréstimo não devolvido', NEW.ID_USUARIO;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER before_loan_insert
BEFORE INSERT ON EMPRESTIMO
FOR EACH ROW
EXECUTE FUNCTION check_user_loan_status();

delete from livraria.public.emprestimo 
where id_emprestimo = 1;

INSERT INTO EMPRESTIMO (ID_USUARIO, ID_LIVRO, DATA_EMPRESTIMO, DATA_DEVOLUCAO) VALUES
(1, 2, '2023-01-01', null);

update emprestimo 
set data_devolucao = '2023-01-02'
where id_emprestimo = 2;

INSERT INTO livraria.public.usuario (nome, sexo, email, cpf) values
('Victor Longui Pereira', 'M', 'vic.longui@example.com', '15648977737'),
('Ana Costa Lima', 'F', 'ana.lima@example.com', '13456987732'),
('Pedro Silva Santos', 'M', 'pedro.santos@example.com', '12345678901'),
('Mariana Alves Souza', 'F', 'mariana.souza@example.com', '98765432109'),
('Lucas Pereira Gomes', 'M', 'lucas.gomes@example.com', '23456789012'),
('Fernanda Rocha Lima', 'F', 'fernanda.lima@example.com', '34567890123'),
('João Almeida Martins', 'M', 'joao.martins@example.com', '45678901234'),
('Carla Rodrigues Costa', 'F', 'carla.costa@example.com', '56789012345'),
('Paulo Oliveira Silva', 'M', 'paulo.silva@example.com', '67890123456'),
('Gabriel Ferreira Santos', 'M', 'gabriel.santos@example.com', '78901234567'),
('Rafael Souza Lima', 'M', 'rafael.lima@example.com', '89012345678'),
('Camila Pereira Almeida', 'F', 'camila.almeida@example.com', '90123456789'),
('Renato Santos Gomes', 'M', 'renato.gomes@example.com', '12312312312'),
('Juliana Oliveira Costa', 'F', 'juliana.costa@example.com', '23423423423'),
('Bruno Lima Ferreira', 'M', 'bruno.ferreira@example.com', '34534534534'),
('Larissa Martins Silva', 'F', 'larissa.silva@example.com', '45645645645'),
('Mateus Almeida Souza', 'M', 'mateus.souza@example.com', '56756756756'),
('Isabela Pereira Lima', 'F', 'isabela.lima@example.com', '67867867867'),
('Leonardo Silva Costa', 'M', 'leonardo.costa@example.com', '78978978978'),
('Patrícia Santos Gomes', 'F', 'patricia.gomes@example.com', '89089089089'),
('Ricardo Oliveira Lima', 'M', 'ricardo.lima@example.com', '90190190190'),
('Mariana Silva Costa', 'F', 'mariana.costa@example.com', '12332112332'),
('Felipe Pereira Souza', 'M', 'felipe.souza@example.com', '23443223443'),
('Sofia Santos Lima', 'F', 'sofia.lima@example.com', '34554334554'),
('Roberto Almeida Silva', 'M', 'roberto.silva@example.com', '45665445665'),
('Aline Pereira Gomes', 'F', 'aline.gomes@example.com', '56776556776'),
('Daniela Lima Ferreira', 'F', 'daniela.ferreira@example.com', '67887667887'),
('Fernando Oliveira Costa', 'M', 'fernando.costa@example.com', '78998778998'),
('Marcelo Silva Santos', 'M', 'marcelo.santos@example.com', '89019801980'),
('Cátia Santos Lima', 'F', 'catia.lima@example.com', '90130901230'),
('Alexandre Almeida Silva', 'M', 'alexandre.silva@example.com', '12341234123'),
('Tatiana Pereira Costa', 'F', 'tatiana.costa@example.com', '23452345234'),
('Thiago Lima Gomes', 'M', 'thiago.gomes@example.com', '34563456345'),
('Beatriz Oliveira Souza', 'F', 'beatriz.souza@example.com', '45674567456'),
('Eduardo Silva Ferreira', 'M', 'eduardo.ferreira@example.com', '56785678567'),
('Caroline Pereira Lima', 'F', 'caroline.lima@example.com', '67896789678'),
('Lucas Santos Costa', 'M', 'lucas.costa@example.com', '78907890789'),
('Julio Almeida Silva', 'M', 'julio.silva@example.com', '89018901890'),
('Marta Lima Gomes', 'F', 'marta.gomes@example.com', '90129012901'),
('Bruna Oliveira Souza', 'F', 'bruna.souza@example.com', '12340123401'),
('André Silva Ferreira', 'M', 'andre.ferreira@example.com', '23451234512');

select * from usuario u;

INSERT INTO livraria.public.usuario (nome, sexo, email, cpf) values
('Vinícius Almeida Silva', 'M', 'vinicius.silva_23@example.com', '78901234513'),
('Fernanda Oliveira Martins', 'F', 'fer.oliveira_vibes@example.com', '89011234524'),
('Felipe Costa Lima', 'M', 'felipe.lima_adventure@example.com', '90121234535'),
('Amanda Martins Alves', 'F', 'amanda.alves_glam@example.com', '01231234546'),
('Lucas Pereira Costa', 'M', 'lucas_costa_89@example.com', '12341234557'),
('Larissa Almeida Silva', 'F', 'larissa.silva_star@example.com', '78901234502'),
('Rafaela Santos Lima', 'F', 'rafaela.lima_butterfly@example.com', '89011234513'),
('Guilherme Costa Alves', 'M', 'guilherme.alves_wild@example.com', '90121234524');

INSERT INTO livraria.public.endereco (id_usuario, rua, bairro, cidade, estado) VALUES
(150, 'Rua das Flores', 'Centro', 'São Paulo', 'SP'),
(151, 'Avenida dos Sonhos', 'Jardins', 'Rio de Janeiro', 'RJ'),
(152, 'Rua das Palmeiras', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(153, 'Avenida das Águias', 'Morumbi', 'São Paulo', 'SP'),
(154, 'Rua das Estrelas', 'Botafogo', 'Rio de Janeiro', 'RJ'),
(155, 'Avenida das Rosas', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(156, 'Rua dos Ipês', 'Vila Mariana', 'São Paulo', 'SP'),
(157, 'Avenida dos Girassóis', 'Leblon', 'Rio de Janeiro', 'RJ'),
(158, 'Rua das Violetas', 'Moema', 'São Paulo', 'SP'),
(159, 'Avenida das Orquídeas', 'Barra da Tijuca', 'Rio de Janeiro', 'RJ'),
(452, 'Rua dos Lírios', 'Tijuca', 'Rio de Janeiro', 'RJ'),
(453, 'Avenida das Tulipas', 'Brooklin', 'São Paulo', 'SP'),
(454, 'Rua das Dálias', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(455, 'Avenida das Acácias', 'Lapa', 'São Paulo', 'SP'),
(456, 'Rua das Hortênsias', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(457, 'Avenida das Magnólias', 'Santana', 'São Paulo', 'SP'),
(458, 'Rua dos Cravos', 'Centro', 'São Paulo', 'SP'),
(459, 'Avenida das Violetas', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(460, 'Rua dos Antúrios', 'Leblon', 'Rio de Janeiro', 'RJ'),
(461, 'Avenida das Begônias', 'Itaim Bibi', 'São Paulo', 'SP'),
(462, 'Rua das Azaleias', 'Botafogo', 'Rio de Janeiro', 'RJ'),
(463, 'Avenida das Camélias', 'Gávea', 'Rio de Janeiro', 'RJ'),
(464, 'Rua das Margaridas', 'Moema', 'São Paulo', 'SP'),
(240, 'Avenida das Rosas', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(241, 'Rua dos Ipês', 'Vila Mariana', 'São Paulo', 'SP'),
(242, 'Avenida dos Girassóis', 'Leblon', 'Rio de Janeiro', 'RJ'),
(243, 'Rua das Violetas', 'Moema', 'São Paulo', 'SP'),
(244, 'Avenida das Orquídeas', 'Barra da Tijuca', 'Rio de Janeiro', 'RJ'),
(245, 'Rua dos Lírios', 'Tijuca', 'Rio de Janeiro', 'RJ'),
(246, 'Avenida das Tulipas', 'Brooklin', 'São Paulo', 'SP'),
(247, 'Rua das Dálias', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(248, 'Avenida das Acácias', 'Lapa', 'São Paulo', 'SP'),
(249, 'Rua das Hortênsias', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(250, 'Avenida das Magnólias', 'Santana', 'São Paulo', 'SP'),
(251, 'Rua dos Cravos', 'Centro', 'São Paulo', 'SP'),
(252, 'Avenida das Violetas', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(253, 'Rua dos Antúrios', 'Leblon', 'Rio de Janeiro', 'RJ'),
(254, 'Avenida das Begônias', 'Itaim Bibi', 'São Paulo', 'SP'),
(255, 'Rua das Azaleias', 'Botafogo', 'Rio de Janeiro', 'RJ'),
(256, 'Avenida das Camélias', 'Gávea', 'Rio de Janeiro', 'RJ'),
(257, 'Rua das Margaridas', 'Moema', 'São Paulo', 'SP'),
(258, 'Avenida das Rosas', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(259, 'Rua dos Ipês', 'Vila Mariana', 'São Paulo', 'SP'),
(260, 'Avenida dos Girassóis', 'Leblon', 'Rio de Janeiro', 'RJ'),
(261, 'Rua das Violetas', 'Moema', 'São Paulo', 'SP'),
(262, 'Avenida das Orquídeas', 'Barra da Tijuca', 'Rio de Janeiro', 'RJ'),
(263, 'Rua dos Lírios', 'Tijuca', 'Rio de Janeiro', 'RJ'),
(264, 'Avenida das Tulipas', 'Brooklin', 'São Paulo', 'SP'),
(265, 'Rua das Dálias', 'Copacabana', 'Rio de Janeiro', 'RJ'),
(266, 'Avenida das Acácias', 'Lapa', 'São Paulo', 'SP'),
(267, 'Rua das Hortênsias', 'Ipanema', 'Rio de Janeiro', 'RJ'),
(268, 'Avenida das Magnólias', 'Santana', 'São Paulo', 'SP'),
(269, 'Rua dos Cravos', 'Centro', 'São Paulo', 'SP'),
(270, 'Avenida das Violetas', 'Copacabana', 'Rio de Janeiro', 'RJ');

INSERT INTO livraria.public.telefone (id_usuario, tipo, ddd, numero) VALUES
(150, 'CEL', '11', '999977745'),
(151, 'RES', '21', '226233445'),
(152, 'COM', '11', '333356987'),
(153, 'CEL', '11', '555588666'),
(154, 'RES', '21', '711177911'),
(155, 'COM', '11', '880000223'),
(156, 'CEL', '11', '114777334'),
(157, 'RES', '21', '334588667'),
(158, 'COM', '11', '514727886'),
(159, 'CEL', '11', '770101290'),
(452, 'RES', '21', '999020223'),
(453, 'COM', '11', '222030335'),
(454, 'CEL', '11', '304045566'),
(455, 'RES', '21', '555050889'),
(456, 'COM', '11', '777060611'),
(457, 'CEL', '11', '807077011'),
(458, 'RES', '21', '112080885'),
(459, 'COM', '11', '330990667'),
(460, 'CEL', '11', '556677777'),
(461, 'RES', '21', '855899001'),
(462, 'COM', '11', '889999912'),
(463, 'CEL', '11', '118989934'),
(464, 'RES', '21', '334414157'),
(240, 'COM', '11', '556768689'),
(241, 'CEL', '11', '733544990'),
(242, 'RES', '21', '836840012'),
(243, 'COM', '11', '112000045'),
(244, 'CEL', '11', '505050667'),
(245, 'RES', '21', '554040409'),
(246, 'COM', '11', '760609001'),
(247, 'CEL', '11', '887878812'),
(248, 'RES', '21', '110000334'),
(249, 'COM', '11', '336966667'),
(250, 'CEL', '11', '556671212'),
(251, 'RES', '21', '000119001'),
(252, 'COM', '11', '882224712'),
(253, 'CEL', '11', '111258334'),
(254, 'RES', '21', '330001467'),
(255, 'COM', '11', '556060989'),
(256, 'CEL', '11', '770443501'),
(257, 'RES', '21', '889758112'),
(258, 'COM', '11', '111668304'),
(259, 'CEL', '11', '336956067'),
(260, 'RES', '21', '556625809'),
(261, 'COM', '11', '700000001'),
(262, 'CEL', '11', '881477112'),
(263, 'RES', '21', '111226664'),
(264, 'COM', '11', '334487577'),
(265, 'CEL', '11', '555265889'),
(266, 'RES', '21', '770000001'),
(267, 'COM', '11', '889366612'),
(268, 'CEL', '11', '111888884'),
(269, 'RES', '21', '333698667'),
(270, 'COM', '11', '500110189');



INSERT INTO livraria.public.livro (TITULO, AUTOR, ANO_PUBLICACAO, GENERO) VALUES
('Aventuras no Espaço', 'Lucas Silva', 2010, 'Ficção Científica'),
('O Mistério do Lago', 'Ana Costa', 2005, 'Suspense'),
('Caminhos da Vida', 'Pedro Alves', 2018, 'Drama'),
('O Segredo da Floresta', 'Mariana Lima', 2015, 'Aventura'),
('Poesias da Alma', 'João Martins', 2003, 'Poesia'),
('O Despertar das Sombras', 'Carla Santos', 2012, 'Fantasia'),
('Noites de Insônia', 'Ricardo Oliveira', 2008, 'Suspense'),
('Viagem ao Desconhecido', 'Luiza Fernandes', 2019, 'Ficção Científica'),
('Amores Perdidos', 'Gustavo Costa', 2013, 'Romance'),
('O Último Herói', 'Maria Almeida', 2011, 'Aventura'),
('Destinos Cruzados', 'Felipe Lima', 2016, 'Drama'),
('Memórias do Passado', 'Juliana Santos', 2007, 'História'),
('Segredos da Meia-Noite', 'Paulo Silva', 2014, 'Suspense'),
('A Dança dos Ventos', 'Camila Vieira', 2009, 'Fantasia'),
('Corações Partidos', 'Daniel Martins', 2004, 'Romance'),
('A Revolta dos Gigantes', 'Mariana Oliveira', 2020, 'Aventura'),
('Estações da Vida', 'Lucas Fernandes', 2017, 'Drama'),
('Versos do Coração', 'Aline Costa', 2006, 'Poesia'),
('A Cidade Esquecida', 'Rafaela Santos', 2011, 'Fantasia'),
('Entre o Amor e o Ódio', 'Matheus Almeida', 2013, 'Romance'),
('O Mistério do Templo', 'Isabela Lima', 2008, 'Aventura'),
('Flores da Primavera', 'Tiago Oliveira', 2015, 'Drama'),
('Páginas da História', 'Carolina Vieira', 2002, 'História'),
('No Limiar da Escuridão', 'Giovanna Costa', 2016, 'Suspense'),
('O Reino Encantado', 'Bruno Martins', 2010, 'Fantasia'),
('Segredos do Passado', 'Laura Almeida', 2007, 'Romance'),
('O Tesouro Perdido', 'Gabriel Santos', 2014, 'Aventura'),
('Sombras do Destino', 'Ana Beatriz Lima', 2019, 'Drama'),
('Caminhos da Liberdade', 'Rodrigo Vieira', 2005, 'História'),
('Almas Perdidas', 'Amanda Costa', 2012, 'Suspense'),
('Voos da Imaginação', 'Guilherme Oliveira', 2003, 'Fantasia'),
('Despertar da Paixão', 'Beatriz Almeida', 2017, 'Romance'),
('O Mistério do Abismo', 'Felipe Vieira', 2009, 'Aventura'),
('Entre o Sonho e a Realidade', 'Carolina Alves', 2018, 'Drama'),
('Versos da Alma', 'Rafael Martins', 2006, 'Poesia'),
('As Ruínas Antigas', 'Juliana Oliveira', 2011, 'História'),
('Noite de Terror', 'Lucas Costa', 2015, 'Suspense'),
('O Guardião do Portal', 'Isabela Martins', 2008, 'Fantasia'),
('Destinos Cruzados', 'Thiago Almeida', 2013, 'Romance'),
('O Enigma do Passado', 'Mariana Costa', 2004, 'Aventura'),
('Além das Estrelas', 'Vinícius Vieira', 2020, 'Drama'),
('Memórias Esquecidas', 'Fernanda Alves', 2007, 'História'),
('Na Sombra da Noite', 'Ricardo Oliveira', 2016, 'Suspense'),
('O Reino Encantado', 'Luiza Martins', 2010, 'Fantasia'),
('Segredos do Coração', 'Bruno Santos', 2012, 'Romance'),
('A Busca pelo Tesouro', 'Camila Lima', 2005, 'Aventura'),
('Corações Partidos', 'Gustavo Almeida', 2018, 'Drama'),
('Versos de Amor', 'Laura Costa', 2003, 'Poesia'),
('O Mistério das Pirâmides', 'Rafaela Vieira', 2009, 'História'),
('Noite Sombria', 'Guilherme Alves', 2014, 'Suspense'),
('O Jardim dos Sonhos', 'Carolina Oliveira', 2011, 'Fantasia'),
('Entre o Céu e a Terra', 'Mateus Lima', 2017, 'Romance'),
('O Segredo das Montanhas', 'Isabela Costa', 2006, 'Aventura'),
('O Último Adeus', 'Lucas Almeida', 2019, 'Drama');


INSERT INTO EMPRESTIMO (ID_USUARIO, ID_LIVRO, DATA_EMPRESTIMO, DATA_DEVOLUCAO) VALUES
(150, 2, '2024-06-30', '2024-07-15'),
(151, 3, '2024-07-01', NULL),
(152, 4, '2024-07-01', '2024-07-10'),
(153, 5, '2024-07-02', NULL),
(154, 6, '2024-07-02', NULL),
(155, 7, '2024-07-03', NULL),
(156, 8, '2024-07-03', '2024-07-12'),
(157, 9, '2024-07-04', NULL),
(158, 10, '2024-07-04', NULL),
(159, 11, '2024-07-05', '2024-07-20'),
(452, 12, '2024-07-05', NULL),
(453, 13, '2024-07-06', NULL),
(454, 14, '2024-07-06', NULL),
(455, 15, '2024-07-07', '2024-07-18'),
(456, 16, '2024-07-07', NULL),
(457, 17, '2024-07-08', NULL),
(458, 18, '2024-07-08', NULL),
(459, 19, '2024-07-09', '2024-07-14'),
(460, 20, '2024-07-09', NULL),
(461, 21, '2024-07-10', NULL),
(462, 22, '2024-07-10', NULL),
(463, 23, '2024-07-11', '2024-07-17'),
(464, 24, '2024-07-11', NULL),
(240, 25, '2024-07-12', NULL),
(241, 26, '2024-07-12', NULL),
(242, 27, '2024-07-13', NULL),
(243, 28, '2024-07-13', '2024-07-19'),
(244, 29, '2024-07-14', NULL),
(245, 30, '2024-07-14', NULL),
(246, 31, '2024-07-15', NULL),
(247, 32, '2024-07-15', '2024-07-16'),
(248, 33, '2024-07-16', NULL),
(249, 34, '2024-07-16', NULL),
(250, 35, '2024-07-17', NULL),
(251, 36, '2024-07-17', '2024-07-21'),
(252, 37, '2024-07-18', NULL),
(253, 38, '2024-07-18', NULL),
(254, 39, '2024-07-19', NULL),
(255, 40, '2024-07-19', NULL),
(256, 41, '2024-07-20', NULL),
(257, 42, '2024-07-20', NULL),
(258, 43, '2024-07-21', NULL),
(259, 44, '2024-07-21', NULL),
(260, 45, '2024-07-22', NULL),
(261, 46, '2024-07-22', '2024-07-23'),
(262, 47, '2024-07-23', NULL),
(263, 48, '2024-07-23', NULL),
(264, 49, '2024-07-24', NULL),
(265, 50, '2024-07-24', NULL),
(266, 51, '2024-07-25', NULL),
(267, 52, '2024-07-25', '2024-07-24'),
(268, 53, '2024-07-26', NULL),
(269, 54, '2024-07-26', NULL),
(270, 55, '2024-07-27', NULL);

select * from livraria.public.usuario u;
select * from endereco e;
select * from telefone t;
select * from livro l;
select * from emprestimo e;

select * from livraria.dbt_dev_livraria.stg_livraria_usuario slu;
select * from livraria.dbt_dev_livraria.stg_livraria_endereco sle;
select * from livraria.dbt_dev_livraria.stg_livraria_telefone slt;
select * from livraria.dbt_dev_livraria.stg_livraria_livro sll;
select * from livraria.dbt_dev_livraria.stg_livraria_emprestimo slem;

SELECT
    SLU.ID_USUARIO,
    SLU.NOME,
    COUNT(SLEM.ID_EMPRESTIMO) AS Total_de_emprestimos
FROM livraria.dbt_dev_livraria.stg_livraria_usuario AS SLU
JOIN livraria.dbt_dev_livraria.stg_livraria_emprestimo AS SLEM 
    ON SLU.ID_USUARIO = SLEM.ID_USUARIO
GROUP BY SLU.ID_USUARIO, SLU.NOME;


SELECT
    SLU.ID_USUARIO,
    SLU.NOME,
    SLEM.ID_EMPRESTIMO,
    SLL.ID_LIVRO,
    SLL.TITULO,
    SLL.AUTOR,
    SLL.ANO_PUBLICACAO,
    SLL.GENERO,
    (SLEM.DATA_DEVOLUCAO - SLEM.DATA_EMPRESTIMO) AS "Tempo de duração de empréstimo (DIAS)"
FROM livraria.dbt_dev_livraria.stg_livraria_usuario AS SLU
JOIN livraria.dbt_dev_livraria.stg_livraria_emprestimo AS SLEM 
    ON SLU.ID_USUARIO = SLEM.ID_USUARIO
JOIN livraria.dbt_dev_livraria.stg_livraria_livro AS SLL 
    ON SLEM.ID_LIVRO = SLL.ID_LIVRO;
   
   SELECT
    SLU.ID_USUARIO,
    SLU.NOME,
    SLEM.ID_EMPRESTIMO,
    SLL.ID_LIVRO,
    SLL.TITULO,
    SLL.AUTOR,
    SLL.ANO_PUBLICACAO,
    SLL.GENERO,
    CASE
        WHEN SLEM.DATA_DEVOLUCAO IS NOT NULL AND SLEM.DATA_EMPRESTIMO IS NOT NULL THEN
            (SLEM.DATA_DEVOLUCAO - SLEM.DATA_EMPRESTIMO)::text
        ELSE 'sem data de devolucao'
    END AS "Tempo de duração de empréstimo (DIAS)"
FROM livraria.dbt_dev_livraria.stg_livraria_usuario AS SLU
JOIN livraria.dbt_dev_livraria.stg_livraria_emprestimo AS SLEM 
    ON SLU.ID_USUARIO = SLEM.ID_USUARIO
JOIN livraria.dbt_dev_livraria.stg_livraria_livro AS SLL 
    ON SLEM.ID_LIVRO = SLL.ID_LIVRO;
   
   select * from livraria.dbt_dev_livraria.dim_tempo_de_emp dtde;
  
  select *
  from emprestimo e;
 
update emprestimo 
set data_devolucao = '2024-07-26'
where id_emprestimo = 165;


select
    SLU.NOME,
    SLU.SEXO,
    SLU.EMAIL,
    SLU.CPF,
    SLE.RUA,
    SLE.BAIRRO,
    SLE.CIDADE,
    SLE.ESTADO,
    SLT.TIPO,
    SLT.DDD,
    SLT.NUMERO,
    SLL.TITULO,
    SLL.AUTOR,
    SLL.ANO_PUBLICACAO,
    SLL.GENERO,
    SLEM.DATA_EMPRESTIMO,
    SLEM.DATA_DEVOLUCAO
from livraria.dbt_dev_livraria.stg_livraria_usuario AS SLU
join livraria.dbt_dev_livraria.stg_livraria_endereco sle 
	on slu.id_usuario = sle.id_usuario 
JOIN livraria.dbt_dev_livraria.stg_livraria_emprestimo AS SLEM 
    ON SLU.ID_USUARIO = SLEM.ID_USUARIO
join livraria.dbt_dev_livraria.stg_livraria_telefone slt
	on slu.id_usuario  = slt.id_usuario 
JOIN livraria.dbt_dev_livraria.stg_livraria_livro AS SLL 
    ON SLEM.ID_LIVRO = SLL.ID_LIVRO;


DROP VIEW IF EXISTS dbt_dev_livraria.stg_livraria_emprestimo;

DROP TABLE IF EXISTS emprestimo;

CREATE TABLE emprestimo (
    id_emprestimo SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_livro INT NOT NULL,
    data_emprestimo DATE NOT NULL,
    data_devolucao DATE,
    status VARCHAR(20) NOT NULL DEFAULT 'emprestado'
);


CREATE OR REPLACE FUNCTION verificar_disponibilidade_livro()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM emprestimo
        WHERE id_livro = NEW.id_livro
        AND status = 'emprestado'
    ) THEN
        RAISE EXCEPTION 'O livro já está emprestado';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_verificar_disponibilidade_livro
BEFORE INSERT ON emprestimo
FOR EACH ROW
EXECUTE FUNCTION verificar_disponibilidade_livro();

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES
(1, 1, '2024-01-01', '2024-01-15', 'devolvido'),
(150, 2, '2024-01-02', '2024-01-16', 'devolvido'),
(151, 3, '2024-01-03', '2024-01-17', 'devolvido'),
(152, 4, '2024-01-04', '2024-01-18', 'devolvido'),
(153, 5, '2024-01-05', '2024-01-19', 'devolvido'),
(154, 6, '2024-01-06', '2024-01-20', 'devolvido'),
(155, 7, '2024-01-07', '2024-01-21', 'devolvido'),
(156, 8, '2024-01-08', '2024-01-22', 'devolvido'),
(157, 9, '2024-01-09', '2024-01-23', 'devolvido'),
(158, 10, '2024-01-10', '2024-01-24', 'devolvido'),
(159, 11, '2024-01-11', '2024-01-25', 'devolvido'),
(452, 12, '2024-01-12', '2024-01-26', 'devolvido'),
(453, 13, '2024-01-13', '2024-01-27', 'devolvido'),
(454, 14, '2024-01-14', '2024-01-28', 'devolvido'),
(455, 15, '2024-01-15', '2024-01-29', 'devolvido'),
(456, 16, '2024-01-16', '2024-01-30', 'devolvido'),
(457, 17, '2024-01-17', '2024-01-31', 'devolvido'),
(458, 18, '2024-01-18', '2024-02-01', 'devolvido'),
(459, 19, '2024-01-19', '2024-02-02', 'devolvido'),
(460, 20, '2024-01-20', '2024-02-03', 'devolvido'),
(461, 21, '2024-01-21', '2024-02-04', 'devolvido'),
(462, 22, '2024-01-22', '2024-02-05', 'devolvido'),
(463, 23, '2024-01-23', '2024-02-06', 'devolvido'),
(464, 24, '2024-01-24', '2024-02-07', 'devolvido'),
(240, 25, '2024-01-25', '2024-02-08', 'devolvido'),
(241, 26, '2024-01-26', '2024-02-09', 'devolvido'),
(242, 27, '2024-01-27', '2024-02-10', 'devolvido'),
(243, 28, '2024-01-28', '2024-02-11', 'devolvido'),
(244, 29, '2024-01-29', '2024-02-12', 'devolvido'),
(245, 30, '2024-01-30', '2024-02-13', 'devolvido'),
(246, 31, '2024-01-31', '2024-02-14', 'devolvido'),
(247, 32, '2024-02-01', '2024-02-15', 'devolvido'),
(248, 33, '2024-02-02', '2024-02-16', 'devolvido'),
(249, 34, '2024-02-03', '2024-02-17', 'devolvido'),
(250, 35, '2024-02-04', '2024-02-18', 'devolvido'),
(251, 36, '2024-02-05', NULL, 'em andamento'),
(252, 37, '2024-02-06', NULL, 'em andamento'),
(253, 38, '2024-02-07', NULL, 'em andamento'),
(254, 39, '2024-02-08', NULL, 'em andamento'),
(255, 40, '2024-02-09', NULL, 'em andamento'),
(256, 41, '2024-02-10', NULL, 'em andamento'),
(257, 42, '2024-02-11', NULL, 'em andamento'),
(258, 43, '2024-02-12', NULL, 'em andamento'),
(259, 44, '2024-02-13', NULL, 'em andamento'),
(260, 45, '2024-02-14', NULL, 'em andamento'),
(261, 46, '2024-02-15', NULL, 'em andamento'),
(262, 47, '2024-02-16', NULL, 'em andamento'),
(263, 48, '2024-02-17', NULL, 'em andamento'),
(264, 49, '2024-02-18', NULL, 'em andamento'),
(265, 50, '2024-02-19', NULL, 'em andamento'),
(266, 51, '2024-02-20', NULL, 'em andamento'),
(267, 52, '2024-02-21', NULL, 'em andamento'),
(268, 53, '2024-02-22', NULL, 'em andamento'),
(269, 54, '2024-02-23', NULL, 'em andamento'),
(270, 55, '2024-02-24', NULL, 'em andamento');

select * from emprestimo e ;

select * from livro l;

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES
(150, 3, '2024-02-25', null, 'em andamento');

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES
(1, 3, '2024-02-25', null, 'em andamento');

delete from emprestimo 
where id_emprestimo = 58;

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo)
VALUES (1, 1, '2024-07-04');

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo)
VALUES (250, 1, '2024-07-04');

--Erro SQL [P0001]: ERROR: O livro já está emprestado
--  Onde: PL/pgSQL function verificar_disponibilidade_livro() line 9 at RAISE

select * from livraria.dbt_dev_livraria.stg_livraria_emprestimo sle ;

select * from livraria.dbt_dev_livraria.dim_tempo_de_emp dtde;

select * from livraria.dbt_dev_livraria.dim_emp_por_pessoa depp;

select * from livraria.dbt_dev_livraria.dim_livraria_geral dlg;

select * from emprestimo e;

select * from usuario u ;

select * from endereco e ;

INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Souza', 'M', 'marcelo.lima.souza@webmail.com', '71364160217');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Silva', 'F', 'fernanda.lima.silva@email.com', '94261096342');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Oliveira', 'M', 'marcelo.lima.oliveira@mail.com', '09237231363');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Costa Silva', 'M', 'mateus.costa.silva@webmail.com', '10265542944');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Gomes Oliveira', 'F', 'amanda.gomes.oliveira@example.com', '94025610700');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Lima', 'M', 'felipe.rocha.lima@webmail.com', '60036106273');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Rocha', 'M', 'pedro.silva.rocha@example.com', '96634979772');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Costa Gomes', 'F', 'ana.costa.gomes@myemail.com', '75750362254');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Lima Oliveira', 'M', 'lucas.lima.oliveira@mail.com', '28457927867');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Pereira', 'F', 'giovanna.lima.pereira@email.com', '63890956805');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Pereira', 'F', 'paula.costa.pereira@mail.com', '75303671528');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Rocha', 'M', 'leonardo.souza.rocha@email.com', '28083088409');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Rocha', 'F', 'carla.lima.rocha@example.com', '65195845111');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Oliveira Almeida', 'M', 'leonardo.oliveira.almeida@example.com', '09662807991');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Lima Costa', 'F', 'luiza.lima.costa@email.com', '24995668316');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Almeida Martins', 'F', 'giovanna.almeida.martins@webmail.com', '24226925095');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Silva Silva', 'M', 'lucas.silva.silva@webmail.com', '62936408492');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Martins', 'M', 'bruno.almeida.martins@email.com', '85968376895');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Almeida Souza', 'M', 'felipe.almeida.souza@example.com', '92037297203');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Silva', 'M', 'jo�o.pereira.silva@myemail.com', '20975030490');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Rocha', 'M', 'bruno.almeida.rocha@example.com', '62476400298');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Martins Gomes', 'F', 'luiza.martins.gomes@mail.com', '49990379389');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Oliveira Pereira', 'F', 'mariana.oliveira.pereira@webmail.com', '16834245281');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Almeida Lima', 'M', 'rafael.almeida.lima@example.com', '82540313467');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Pereira', 'M', 'lucas.oliveira.pereira@email.com', '55268628848');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Martins', 'M', 'jo�o.souza.martins@example.com', '93395624461');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Oliveira', 'M', 'bruno.gomes.oliveira@example.com', '46945031715');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Oliveira', 'M', 'leonardo.almeida.oliveira@mail.com', '51439588233');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Gomes', 'F', 'giovanna.martins.gomes@webmail.com', '77195459322');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Pereira', 'F', 'marcela.lima.pereira@example.com', '38949693919');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Silva Rocha', 'F', 'amanda.silva.rocha@example.com', '81242732125');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Almeida', 'F', 'giovanna.martins.almeida@email.com', '22105284540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Costa Almeida', 'M', 'leonardo.costa.almeida@mail.com', '51591835172');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Rocha', 'M', 'gabriel.souza.rocha@example.com', '00200554116');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Almeida Martins', 'F', 'mariana.almeida.martins@mail.com', '50815922821');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Silva', 'M', 'leonardo.souza.silva@mail.com', '94022344607');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Gomes Lima', 'M', 'lucas.gomes.lima@email.com', '28613794894');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Rocha', 'M', 'bruno.gomes.rocha@email.com', '86683259716');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Martins', 'F', 'giovanna.rocha.martins@webmail.com', '14860058658');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Pereira', 'F', 'luiza.silva.pereira@mail.com', '86686129981');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Lima', 'M', 'bruno.rocha.lima@webmail.com', '20859146089');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Oliveira Lima', 'F', 'marcela.oliveira.lima@example.com', '72210299949');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Gomes', 'M', 'bruno.silva.gomes@email.com', '32073771814');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Costa Lima', 'M', 'jo�o.costa.lima@myemail.com', '90289039312');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Lima', 'M', 'mateus.silva.lima@example.com', '42462394543');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Gomes', 'F', 'paula.costa.gomes@webmail.com', '65850068202');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Silva Costa', 'F', 'ana.silva.costa@mail.com', '10120412279');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Pereira', 'M', 'mateus.silva.pereira@myemail.com', '37144181677');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Lima Pereira', 'F', 'ana.lima.pereira@email.com', '92391595283');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Souza Almeida', 'M', 'lucas.souza.almeida@webmail.com', '82433807297');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Souza Martins', 'F', 'luiza.souza.martins@webmail.com', '75388691234');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Gomes', 'F', 'ana.oliveira.gomes@mail.com', '03122799384');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Almeida', 'M', 'jo�o.souza.almeida@myemail.com', '98084642838');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Pereira Gomes', 'F', 'carla.pereira.gomes@myemail.com', '72499140272');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Rocha', 'M', 'lucas.almeida.rocha@mail.com', '72587916449');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Martins Silva', 'M', 'pedro.martins.silva@mail.com', '81806929691');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Gomes', 'M', 'jo�o.souza.gomes@example.com', '79586958796');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Silva Oliveira', 'M', 'marcelo.silva.oliveira@example.com', '11021073088');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Costa Gomes', 'M', 'marcelo.costa.gomes@mail.com', '81432703432');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Pereira', 'M', 'pedro.pereira.pereira@mail.com', '69513453328');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Almeida', 'F', 'mariana.pereira.almeida@mail.com', '47545440752');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Silva', 'F', 'ana.gomes.silva@myemail.com', '41550455167');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Pereira', 'M', 'leonardo.almeida.pereira@myemail.com', '41009120529');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Almeida', 'F', 'larissa.oliveira.almeida@myemail.com', '03607899078');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Gomes Oliveira', 'M', 'rafael.gomes.oliveira@myemail.com', '81083883326');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Lima', 'F', 'luiza.costa.lima@webmail.com', '69794272587');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Souza', 'M', 'pedro.almeida.souza@mail.com', '37465587765');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Pereira Costa', 'M', 'bruno.pereira.costa@myemail.com', '49640419996');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Lima', 'F', 'mariana.gomes.lima@myemail.com', '46482433343');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Lima Rocha', 'F', 'luiza.lima.rocha@myemail.com', '49677425842');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Costa Pereira', 'M', 'jo�o.costa.pereira@email.com', '97135186598');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Silva', 'F', 'larissa.pereira.silva@webmail.com', '45144491984');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Souza', 'F', 'luiza.gomes.souza@example.com', '40126189276');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Costa', 'F', 'larissa.lima.costa@webmail.com', '47593856519');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Gomes Oliveira', 'F', 'giovanna.gomes.oliveira@myemail.com', '47224550527');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Souza', 'M', 'lucas.almeida.souza@webmail.com', '27209688506');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Lima', 'M', 'lucas.oliveira.lima@email.com', '99494376758');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Pereira', 'F', 'fernanda.lima.pereira@webmail.com', '77654837602');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Pereira', 'F', 'fernanda.lima.pereira@example.com', '28305546801');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Oliveira Souza', 'M', 'bruno.oliveira.souza@email.com', '45722775291');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Costa Oliveira', 'M', 'marcelo.costa.oliveira@webmail.com', '63141696133');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Martins', 'F', 'larissa.lima.martins@email.com', '98027992670');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Almeida Silva', 'F', 'larissa.almeida.silva@example.com', '09718208470');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Silva Gomes', 'M', 'lucas.silva.gomes@email.com', '67497590800');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Almeida', 'M', 'rafael.rocha.almeida@mail.com', '52182960629');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Lima', 'M', 'pedro.pereira.lima@example.com', '78420311678');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Oliveira', 'M', 'pedro.almeida.oliveira@myemail.com', '29435411366');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Pereira', 'M', 'leonardo.almeida.pereira@email.com', '39153338426');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Costa Martins', 'F', 'marcela.costa.martins@mail.com', '04923400110');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Oliveira Martins', 'F', 'amanda.oliveira.martins@mail.com', '35557312234');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Martins', 'M', 'leonardo.silva.martins@example.com', '51950362229');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Pereira', 'F', 'luiza.pereira.pereira@webmail.com', '12434744360');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Gomes', 'F', 'larissa.pereira.gomes@myemail.com', '37841299593');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Lima Oliveira', 'M', 'rafael.lima.oliveira@mail.com', '30123149064');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Souza Pereira', 'F', 'mariana.souza.pereira@email.com', '28015867993');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Gomes Silva', 'F', 'fernanda.gomes.silva@example.com', '20440169706');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Oliveira', 'M', 'marcelo.souza.oliveira@mail.com', '21928000435');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Silva Pereira', 'M', 'gabriel.silva.pereira@mail.com', '85665469268');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Almeida Oliveira', 'M', 'rafael.almeida.oliveira@webmail.com', '19865537608');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Martins', 'M', 'bruno.rocha.martins@myemail.com', '85625071826');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Pereira Oliveira', 'F', 'fernanda.pereira.oliveira@example.com', '56570587251');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Almeida', 'M', 'gabriel.oliveira.almeida@example.com', '76661440374');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Almeida', 'F', 'carla.lima.almeida@webmail.com', '14731878542');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Costa', 'M', 'gabriel.gomes.costa@myemail.com', '36373235776');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Pereira Silva', 'M', 'bruno.pereira.silva@email.com', '99662401549');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Almeida Souza', 'M', 'rafael.almeida.souza@myemail.com', '29366390855');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Martins', 'M', 'jo�o.souza.martins@email.com', '36794779883');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Gomes Rocha', 'F', 'marcela.gomes.rocha@example.com', '88910706228');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Oliveira Pereira', 'M', 'rafael.oliveira.pereira@email.com', '71804006840');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Oliveira Martins', 'F', 'carla.oliveira.martins@email.com', '04376248518');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Pereira', 'M', 'felipe.martins.pereira@webmail.com', '65724596854');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Silva Gomes', 'M', 'rafael.silva.gomes@myemail.com', '35773832092');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Pereira Almeida', 'F', 'ana.pereira.almeida@example.com', '61039066458');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Gomes', 'F', 'marcela.rocha.gomes@mail.com', '44903732874');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Rocha Souza', 'F', 'fernanda.rocha.souza@email.com', '96146104957');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Pereira', 'M', 'pedro.pereira.pereira@myemail.com', '12068518326');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Souza', 'M', 'mateus.pereira.souza@mail.com', '95839262546');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Rocha Pereira', 'F', 'ana.rocha.pereira@myemail.com', '82967720730');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Gomes', 'F', 'paula.souza.gomes@myemail.com', '81121426208');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Costa Martins', 'F', 'fernanda.costa.martins@example.com', '02832945390');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Costa Silva', 'M', 'rafael.costa.silva@mail.com', '33904483115');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Silva', 'M', 'marcelo.oliveira.silva@webmail.com', '89232884464');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Rocha Silva', 'M', 'gabriel.rocha.silva@email.com', '08036012825');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Martins', 'M', 'lucas.martins.martins@mail.com', '89613548042');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Pereira', 'F', 'larissa.lima.pereira@mail.com', '52471774315');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Costa', 'M', 'marcelo.oliveira.costa@webmail.com', '22385265517');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Souza Martins', 'F', 'luiza.souza.martins@myemail.com', '55803108614');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Silva Gomes', 'M', 'jo�o.silva.gomes@mail.com', '23774389814');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Costa', 'M', 'marcelo.rocha.costa@myemail.com', '92178914560');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Lima', 'M', 'bruno.souza.lima@mail.com', '57588788894');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Oliveira', 'M', 'leonardo.silva.oliveira@myemail.com', '24306324052');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Pereira', 'F', 'larissa.lima.pereira@email.com', '30731902114');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Gomes', 'F', 'ana.souza.gomes@webmail.com', '62699979922');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Costa', 'M', 'marcelo.rocha.costa@mail.com', '96336451198');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Souza Almeida', 'M', 'mateus.souza.almeida@mail.com', '77757607691');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Rocha Martins', 'M', 'leonardo.rocha.martins@example.com', '12931104264');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Lima', 'F', 'giovanna.souza.lima@myemail.com', '19609503270');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Martins Lima', 'F', 'ana.martins.lima@mail.com', '91564749409');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Souza Gomes', 'F', 'marcela.souza.gomes@example.com', '85842701627');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Gomes', 'F', 'marcela.rocha.gomes@email.com', '84590477313');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Rocha Silva', 'F', 'larissa.rocha.silva@mail.com', '17337912035');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Pereira', 'M', 'jo�o.gomes.pereira@mail.com', '33531854668');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Almeida Rocha', 'M', 'mateus.almeida.rocha@webmail.com', '59843716813');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Martins', 'F', 'amanda.lima.martins@mail.com', '81179553335');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Rocha', 'M', 'lucas.costa.rocha@example.com', '48355947531');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Lima', 'F', 'paula.martins.lima@email.com', '19658250054');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Gomes', 'F', 'carla.costa.gomes@myemail.com', '06915431121');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Pereira Pereira', 'F', 'giovanna.pereira.pereira@webmail.com', '61449724123');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Lima Martins', 'M', 'felipe.lima.martins@email.com', '99285287394');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Pereira Souza', 'M', 'rafael.pereira.souza@example.com', '85048096625');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Gomes', 'M', 'lucas.pereira.gomes@email.com', '45512180082');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Souza Martins', 'M', 'mateus.souza.martins@email.com', '72013414639');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Martins', 'F', 'amanda.lima.martins@email.com', '54990094965');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Rocha Lima', 'F', 'amanda.rocha.lima@email.com', '43200307986');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Costa Souza', 'M', 'bruno.costa.souza@example.com', '91050313773');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Souza Costa', 'F', 'carla.souza.costa@email.com', '31899698285');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Silva', 'M', 'gabriel.lima.silva@myemail.com', '43990884466');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Rocha', 'F', 'marcela.rocha.rocha@myemail.com', '40268593414');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Souza', 'F', 'fernanda.lima.souza@webmail.com', '69354906887');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Silva', 'F', 'carla.lima.silva@mail.com', '46256241777');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Silva Oliveira', 'F', 'larissa.silva.oliveira@webmail.com', '47348126862');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Almeida Rocha', 'F', 'amanda.almeida.rocha@mail.com', '08674381862');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Oliveira Pereira', 'M', 'mateus.oliveira.pereira@myemail.com', '70230382792');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Gomes Gomes', 'M', 'marcelo.gomes.gomes@webmail.com', '21154716734');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Gomes Gomes', 'F', 'paula.gomes.gomes@webmail.com', '20659048959');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Rocha Rocha', 'F', 'fernanda.rocha.rocha@mail.com', '57889938836');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Oliveira', 'F', 'fernanda.almeida.oliveira@mail.com', '24781162587');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Gomes', 'M', 'bruno.gomes.gomes@email.com', '65652091539');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Almeida', 'F', 'fernanda.almeida.almeida@webmail.com', '76185411387');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Rocha Rocha', 'F', 'carla.rocha.rocha@example.com', '47808665295');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Souza', 'F', 'larissa.souza.souza@mail.com', '11911999682');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Pereira', 'M', 'leonardo.silva.pereira@mail.com', '88537427584');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Almeida', 'F', 'larissa.oliveira.almeida@webmail.com', '19276922656');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Rocha', 'F', 'luiza.pereira.rocha@myemail.com', '47348504209');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Almeida', 'M', 'leonardo.pereira.almeida@webmail.com', '97020848876');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Silva Oliveira', 'F', 'marcela.silva.oliveira@example.com', '43302382943');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Costa', 'M', 'mateus.lima.costa@example.com', '13902222990');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Rocha Almeida', 'F', 'luiza.rocha.almeida@mail.com', '28478308994');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Lima', 'F', 'larissa.lima.lima@myemail.com', '53535442944');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Oliveira', 'F', 'fernanda.almeida.oliveira@webmail.com', '15030100728');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Pereira', 'F', 'amanda.lima.pereira@webmail.com', '15526977206');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Silva', 'F', 'mariana.pereira.silva@email.com', '18015949918');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Oliveira Costa', 'M', 'bruno.oliveira.costa@mail.com', '46768830000');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Almeida Pereira', 'F', 'luiza.almeida.pereira@webmail.com', '38546887453');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Oliveira', 'M', 'pedro.almeida.oliveira@mail.com', '05273642605');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Lima', 'M', 'gabriel.almeida.lima@email.com', '58811086180');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Almeida', 'F', 'paula.lima.almeida@example.com', '93076415779');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Oliveira Silva', 'M', 'pedro.oliveira.silva@myemail.com', '50357494348');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Rocha Gomes', 'F', 'ana.rocha.gomes@example.com', '80243751495');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Costa', 'F', 'fernanda.lima.costa@mail.com', '48114529254');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Lima', 'M', 'gabriel.almeida.lima@mail.com', '16380395875');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Gomes', 'F', 'marcela.martins.gomes@mail.com', '11995220496');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Martins Almeida', 'M', 'leonardo.martins.almeida@email.com', '92244518411');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Silva Pereira', 'F', 'amanda.silva.pereira@mail.com', '56653139583');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Rocha Rocha', 'M', 'mateus.rocha.rocha@webmail.com', '27182005018');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Martins Lima', 'M', 'leonardo.martins.lima@myemail.com', '00048358582');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Pereira', 'F', 'giovanna.lima.pereira@webmail.com', '10310865726');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Costa Pereira', 'F', 'fernanda.costa.pereira@example.com', '09515759064');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Pereira Almeida', 'F', 'carla.pereira.almeida@myemail.com', '25078918112');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Oliveira', 'M', 'bruno.almeida.oliveira@example.com', '24774642827');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Almeida', 'F', 'amanda.martins.almeida@example.com', '84145879377');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Costa Rocha', 'M', 'marcelo.costa.rocha@mail.com', '64128418886');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Silva', 'F', 'marcela.pereira.silva@example.com', '46505055903');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Oliveira', 'F', 'mariana.gomes.oliveira@mail.com', '43130398846');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Costa', 'F', 'marcela.pereira.costa@example.com', '87325875637');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Martins Almeida', 'M', 'mateus.martins.almeida@webmail.com', '47503476086');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Gomes', 'M', 'mateus.lima.gomes@myemail.com', '13792096048');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Oliveira Silva', 'M', 'pedro.oliveira.silva@email.com', '03091946409');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Gomes', 'M', 'jo�o.lima.gomes@webmail.com', '83821240346');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Souza', 'M', 'lucas.pereira.souza@mail.com', '81090908245');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Martins', 'F', 'luiza.pereira.martins@email.com', '46234522931');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Oliveira', 'M', 'gabriel.oliveira.oliveira@myemail.com', '55029209717');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Almeida', 'M', 'pedro.gomes.almeida@email.com', '69543768266');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Rocha', 'M', 'marcelo.oliveira.rocha@webmail.com', '03749211651');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Lima', 'F', 'fernanda.silva.lima@webmail.com', '99020177033');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Pereira Lima', 'F', 'giovanna.pereira.lima@myemail.com', '61091499546');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Costa Pereira', 'M', 'jo�o.costa.pereira@myemail.com', '39455550187');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Gomes Oliveira', 'M', 'mateus.gomes.oliveira@email.com', '89343765236');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Gomes', 'M', 'lucas.oliveira.gomes@email.com', '03051243122');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Souza Martins', 'F', 'carla.souza.martins@myemail.com', '03893653780');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Almeida', 'M', 'marcelo.oliveira.almeida@email.com', '06486548305');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Rocha Martins', 'M', 'pedro.rocha.martins@webmail.com', '55112196431');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Lima Oliveira', 'M', 'pedro.lima.oliveira@email.com', '47779713596');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Costa', 'M', 'bruno.rocha.costa@example.com', '23014081975');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Oliveira Rocha', 'F', 'marcela.oliveira.rocha@example.com', '55750142761');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Almeida Rocha', 'F', 'giovanna.almeida.rocha@myemail.com', '16474574828');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Pereira', 'F', 'fernanda.souza.pereira@email.com', '97773040868');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Souza', 'F', 'marcela.lima.souza@mail.com', '55132863677');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Martins', 'F', 'fernanda.martins.martins@webmail.com', '63921939999');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Silva', 'F', 'larissa.souza.silva@mail.com', '14508615066');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Souza', 'M', 'jo�o.gomes.souza@webmail.com', '88545031970');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Silva Souza', 'M', 'gabriel.silva.souza@myemail.com', '61046632980');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Rocha', 'F', 'paula.martins.rocha@example.com', '31551309528');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Lima', 'M', 'marcelo.lima.lima@webmail.com', '63872284006');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Souza', 'M', 'bruno.lima.souza@example.com', '43861707024');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Martins', 'M', 'pedro.souza.martins@email.com', '74073594131');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Almeida', 'M', 'jo�o.pereira.almeida@myemail.com', '16912175411');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Oliveira', 'M', 'marcelo.rocha.oliveira@webmail.com', '45587610564');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Martins Almeida', 'F', 'larissa.martins.almeida@myemail.com', '81831051035');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Rocha', 'M', 'gabriel.gomes.rocha@myemail.com', '04588166108');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Oliveira Gomes', 'F', 'giovanna.oliveira.gomes@myemail.com', '93440780786');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Costa Lima', 'M', 'mateus.costa.lima@example.com', '56023166468');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Gomes Gomes', 'F', 'amanda.gomes.gomes@example.com', '25587002147');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Gomes Souza', 'M', 'rafael.gomes.souza@myemail.com', '06009560626');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Gomes', 'F', 'marcela.lima.gomes@myemail.com', '27051694157');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Pereira', 'M', 'rafael.martins.pereira@mail.com', '83503078670');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Rocha Gomes', 'M', 'pedro.rocha.gomes@webmail.com', '18121895135');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Oliveira Rocha', 'M', 'leonardo.oliveira.rocha@email.com', '51100737345');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Martins', 'F', 'giovanna.souza.martins@mail.com', '77169363182');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Costa', 'F', 'carla.lima.costa@myemail.com', '02350873134');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Gomes Oliveira', 'M', 'marcelo.gomes.oliveira@myemail.com', '30037898394');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Almeida Rocha', 'F', 'paula.almeida.rocha@myemail.com', '61831623230');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Martins Gomes', 'M', 'bruno.martins.gomes@example.com', '36317353207');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Souza Rocha', 'F', 'mariana.souza.rocha@email.com', '13289763226');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Almeida Costa', 'M', 'jo�o.almeida.costa@email.com', '23930386676');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Gomes Almeida', 'M', 'leonardo.gomes.almeida@myemail.com', '69088562529');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Pereira', 'F', 'giovanna.lima.pereira@example.com', '94290392355');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Lima', 'F', 'paula.lima.lima@example.com', '34950970811');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Silva Rocha', 'M', 'lucas.silva.rocha@example.com', '57464562429');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Silva Martins', 'M', 'lucas.silva.martins@mail.com', '95694390967');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Martins Lima', 'M', 'pedro.martins.lima@webmail.com', '05745236182');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Martins Silva', 'F', 'luiza.martins.silva@webmail.com', '66798705290');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Rocha', 'F', 'giovanna.rocha.rocha@webmail.com', '05575248425');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Rocha Costa', 'F', 'luiza.rocha.costa@myemail.com', '73163007671');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Costa', 'F', 'fernanda.souza.costa@mail.com', '07166042213');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Martins Pereira', 'F', 'larissa.martins.pereira@example.com', '52716995663');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Rocha Almeida', 'F', 'fernanda.rocha.almeida@mail.com', '29017892730');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Almeida Lima', 'F', 'larissa.almeida.lima@myemail.com', '59978977863');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Almeida', 'M', 'felipe.rocha.almeida@email.com', '37829482640');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Almeida', 'M', 'felipe.rocha.almeida@webmail.com', '66023509032');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Pereira', 'M', 'gabriel.oliveira.pereira@webmail.com', '50003458728');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Costa Rocha', 'F', 'mariana.costa.rocha@myemail.com', '19869407332');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Gomes Costa', 'M', 'leonardo.gomes.costa@example.com', '95843189021');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Oliveira', 'M', 'marcelo.souza.oliveira@myemail.com', '53469957473');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Martins', 'F', 'mariana.martins.martins@mail.com', '79642681962');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Souza Costa', 'M', 'mateus.souza.costa@mail.com', '33929946314');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Gomes', 'M', 'marcelo.oliveira.gomes@example.com', '16472510944');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Silva Silva', 'F', 'marcela.silva.silva@mail.com', '25402645520');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Lima', 'M', 'bruno.gomes.lima@myemail.com', '15827678378');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Costa', 'M', 'lucas.pereira.costa@webmail.com', '14063821646');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Gomes', 'M', 'gabriel.lima.gomes@myemail.com', '65130011777');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Silva', 'M', 'felipe.martins.silva@webmail.com', '83813897792');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Silva', 'M', 'pedro.gomes.silva@email.com', '40400526784');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Pereira', 'M', 'lucas.oliveira.pereira@example.com', '52249251103');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Silva', 'M', 'bruno.lima.silva@myemail.com', '57924664834');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Martins Lima', 'M', 'pedro.martins.lima@email.com', '31075992806');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Costa Lima', 'F', 'marcela.costa.lima@example.com', '60799198529');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Lima', 'F', 'fernanda.silva.lima@myemail.com', '31639725345');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Almeida Almeida', 'F', 'luiza.almeida.almeida@myemail.com', '04083968142');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Oliveira Gomes', 'M', 'mateus.oliveira.gomes@email.com', '56709639971');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Costa', 'F', 'amanda.lima.costa@myemail.com', '40925595174');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Silva', 'M', 'leonardo.silva.silva@email.com', '00716092434');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Lima', 'M', 'felipe.pereira.lima@example.com', '36899446686');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Rocha Pereira', 'M', 'gabriel.rocha.pereira@myemail.com', '40543951005');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Pereira', 'M', 'lucas.pereira.pereira@example.com', '08899793641');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Rocha', 'M', 'gabriel.lima.rocha@email.com', '86037935663');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Souza', 'F', 'larissa.lima.souza@email.com', '27596902703');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Lima', 'M', 'leonardo.pereira.lima@email.com', '84955478755');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Pereira Lima', 'F', 'amanda.pereira.lima@webmail.com', '98048157110');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Oliveira', 'M', 'lucas.rocha.oliveira@webmail.com', '55631345731');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Rocha Rocha', 'M', 'pedro.rocha.rocha@example.com', '25722359007');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Pereira Silva', 'F', 'giovanna.pereira.silva@email.com', '19576844482');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Souza', 'M', 'gabriel.almeida.souza@webmail.com', '45428918600');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Costa Gomes', 'F', 'marcela.costa.gomes@mail.com', '78875522532');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Souza', 'M', 'bruno.lima.souza@webmail.com', '65987958147');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Almeida', 'F', 'marcela.martins.almeida@example.com', '06607623883');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Silva Silva', 'F', 'mariana.silva.silva@myemail.com', '54787738435');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Rocha Silva', 'M', 'jo�o.rocha.silva@email.com', '73415494454');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Rocha', 'M', 'jo�o.pereira.rocha@email.com', '63667365405');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Gomes', 'M', 'marcelo.lima.gomes@myemail.com', '54673663754');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Rocha Pereira', 'M', 'mateus.rocha.pereira@example.com', '20485671738');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Almeida Martins', 'F', 'marcela.almeida.martins@webmail.com', '74799264724');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Rocha', 'F', 'larissa.souza.rocha@email.com', '05961553336');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Oliveira Pereira', 'F', 'carla.oliveira.pereira@email.com', '94240832540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Souza Costa', 'F', 'amanda.souza.costa@myemail.com', '83245051457');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Oliveira Gomes', 'M', 'bruno.oliveira.gomes@webmail.com', '08638967341');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Martins Lima', 'F', 'carla.martins.lima@email.com', '16844723172');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Almeida Silva', 'F', 'larissa.almeida.silva@myemail.com', '24103573179');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Souza', 'M', 'rafael.rocha.souza@mail.com', '85204435626');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Oliveira', 'F', 'fernanda.almeida.oliveira@myemail.com', '88921800180');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Oliveira Souza', 'F', 'giovanna.oliveira.souza@email.com', '65800296199');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Costa', 'M', 'pedro.pereira.costa@webmail.com', '07411370639');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Rocha Oliveira', 'M', 'gabriel.rocha.oliveira@mail.com', '43532546012');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Gomes Pereira', 'M', 'felipe.gomes.pereira@myemail.com', '36204017692');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Martins Lima', 'M', 'mateus.martins.lima@mail.com', '26018991731');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Costa Lima', 'M', 'leonardo.costa.lima@webmail.com', '33894359009');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Oliveira', 'M', 'jo�o.souza.oliveira@email.com', '68463636650');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Pereira', 'M', 'gabriel.souza.pereira@webmail.com', '64636585401');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Gomes Oliveira', 'M', 'marcelo.gomes.oliveira@mail.com', '61561460087');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Lima Pereira', 'M', 'pedro.lima.pereira@myemail.com', '62443298657');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Lima', 'M', 'gabriel.souza.lima@mail.com', '87404160267');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Oliveira', 'F', 'amanda.martins.oliveira@email.com', '29286547540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Gomes', 'F', 'luiza.costa.gomes@myemail.com', '53818802288');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Rocha Almeida', 'F', 'luiza.rocha.almeida@email.com', '33372614859');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Almeida Oliveira', 'F', 'paula.almeida.oliveira@webmail.com', '84177748021');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Souza', 'M', 'pedro.souza.souza@webmail.com', '43416547904');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Martins', 'M', 'mateus.pereira.martins@webmail.com', '03561394179');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Almeida Gomes', 'F', 'larissa.almeida.gomes@email.com', '48451623663');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Martins', 'M', 'jo�o.gomes.martins@myemail.com', '17935993858');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Martins', 'F', 'fernanda.martins.martins@email.com', '78564787607');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Pereira Souza', 'M', 'bruno.pereira.souza@email.com', '07642239063');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Gomes', 'M', 'lucas.rocha.gomes@mail.com', '30141349176');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Rocha Lima', 'M', 'mateus.rocha.lima@mail.com', '31145385107');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Silva Souza', 'M', 'jo�o.silva.souza@myemail.com', '55425016013');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Rocha', 'M', 'jo�o.lima.rocha@email.com', '21152157746');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Oliveira Almeida', 'M', 'rafael.oliveira.almeida@webmail.com', '47150680444');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Martins Oliveira', 'F', 'luiza.martins.oliveira@example.com', '98839995949');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Oliveira Gomes', 'F', 'luiza.oliveira.gomes@mail.com', '82823142604');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Oliveira', 'M', 'felipe.pereira.oliveira@mail.com', '01523185772');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Souza', 'M', 'pedro.gomes.souza@mail.com', '78506795194');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Lima', 'M', 'pedro.almeida.lima@mail.com', '05628669577');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Costa Almeida', 'M', 'marcelo.costa.almeida@email.com', '19992449633');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Costa Martins', 'M', 'felipe.costa.martins@example.com', '67095897019');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Almeida', 'M', 'lucas.almeida.almeida@mail.com', '46792140305');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Lima', 'M', 'felipe.rocha.lima@email.com', '23998470436');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Costa Silva', 'M', 'rafael.costa.silva@example.com', '87077830474');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Rocha', 'M', 'gabriel.lima.rocha@example.com', '21895460081');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Souza Costa', 'F', 'amanda.souza.costa@mail.com', '27451629006');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Souza Lima', 'F', 'marcela.souza.lima@webmail.com', '96719257512');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Martins', 'M', 'marcelo.martins.martins@webmail.com', '79517172022');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Almeida Souza', 'M', 'jo�o.almeida.souza@mail.com', '13504370123');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Souza', 'F', 'marcela.lima.souza@email.com', '69053354000');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Costa', 'F', 'ana.souza.costa@myemail.com', '82173728343');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Costa', 'F', 'giovanna.martins.costa@mail.com', '17221624430');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Almeida Gomes', 'F', 'paula.almeida.gomes@email.com', '77565525693');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Gomes', 'F', 'ana.oliveira.gomes@webmail.com', '02693728768');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Costa Rocha', 'M', 'jo�o.costa.rocha@mail.com', '00608781841');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Almeida', 'F', 'mariana.martins.almeida@email.com', '47371856133');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Almeida', 'F', 'mariana.martins.almeida@example.com', '84802357806');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Almeida', 'M', 'leonardo.pereira.almeida@example.com', '40553691809');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Oliveira', 'M', 'mateus.pereira.oliveira@email.com', '50296250103');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Silva', 'M', 'marcelo.rocha.silva@mail.com', '80338843820');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Martins Almeida', 'M', 'bruno.martins.almeida@webmail.com', '85515811820');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Lima', 'M', 'jo�o.gomes.lima@email.com', '83336692264');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Costa', 'F', 'luiza.pereira.costa@myemail.com', '09851395415');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Souza Almeida', 'M', 'felipe.souza.almeida@webmail.com', '97668715010');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Costa Costa', 'M', 'leonardo.costa.costa@myemail.com', '79027742949');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Pereira', 'F', 'paula.costa.pereira@myemail.com', '50202979752');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Costa', 'F', 'mariana.gomes.costa@webmail.com', '20264260411');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Gomes Pereira', 'F', 'larissa.gomes.pereira@email.com', '43271235999');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Rocha Souza', 'F', 'mariana.rocha.souza@myemail.com', '55232028031');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Almeida Oliveira', 'F', 'carla.almeida.oliveira@example.com', '56921565018');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Costa Almeida', 'F', 'mariana.costa.almeida@example.com', '50119713924');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Gomes Lima', 'M', 'felipe.gomes.lima@email.com', '59497173696');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Gomes Oliveira', 'F', 'marcela.gomes.oliveira@myemail.com', '47644098085');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Gomes Gomes', 'F', 'carla.gomes.gomes@mail.com', '28358034789');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Costa', 'M', 'jo�o.pereira.costa@webmail.com', '44864821505');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Martins', 'F', 'marcela.martins.martins@myemail.com', '67773582177');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Almeida', 'M', 'mateus.silva.almeida@myemail.com', '40187233533');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Souza', 'M', 'mateus.silva.souza@email.com', '97129782059');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Oliveira', 'M', 'lucas.martins.oliveira@myemail.com', '49280818406');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Silva Rocha', 'F', 'marcela.silva.rocha@myemail.com', '76316662273');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Pereira', 'M', 'rafael.martins.pereira@webmail.com', '15247659227');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Costa Lima', 'F', 'fernanda.costa.lima@email.com', '39384458349');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Oliveira Almeida', 'M', 'felipe.oliveira.almeida@email.com', '15691654711');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Almeida Martins', 'F', 'carla.almeida.martins@myemail.com', '58402095311');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Gomes', 'M', 'jo�o.pereira.gomes@email.com', '86304167377');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Souza', 'F', 'larissa.lima.souza@example.com', '34940425913');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Lima Lima', 'M', 'lucas.lima.lima@myemail.com', '86561668167');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Almeida', 'M', 'lucas.pereira.almeida@myemail.com', '72256339895');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Almeida', 'M', 'pedro.silva.almeida@mail.com', '11363420625');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Rocha', 'F', 'marcela.martins.rocha@mail.com', '63027130313');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Almeida Rocha', 'M', 'jo�o.almeida.rocha@mail.com', '20303672903');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Silva Souza', 'F', 'giovanna.silva.souza@mail.com', '83203699012');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Gomes', 'F', 'larissa.oliveira.gomes@example.com', '80289169223');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Gomes Silva', 'M', 'mateus.gomes.silva@mail.com', '08606097890');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Pereira Silva', 'M', 'rafael.pereira.silva@email.com', '07894412213');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Gomes', 'M', 'gabriel.souza.gomes@webmail.com', '46225555754');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Oliveira', 'M', 'jo�o.pereira.oliveira@mail.com', '64008971191');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Pereira', 'M', 'pedro.souza.pereira@myemail.com', '35826151423');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Silva Lima', 'M', 'gabriel.silva.lima@myemail.com', '73870180573');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Martins', 'M', 'leonardo.pereira.martins@webmail.com', '91276168238');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Gomes Almeida', 'F', 'fernanda.gomes.almeida@email.com', '20209593337');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Martins', 'F', 'mariana.martins.martins@myemail.com', '81665400687');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Oliveira', 'F', 'marcela.lima.oliveira@myemail.com', '13789945312');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Costa Rocha', 'M', 'mateus.costa.rocha@example.com', '02940808806');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Costa Souza', 'F', 'ana.costa.souza@webmail.com', '40198910380');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Oliveira Oliveira', 'F', 'mariana.oliveira.oliveira@myemail.com', '96007337814');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Gomes Silva', 'F', 'paula.gomes.silva@email.com', '86530034606');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Pereira', 'F', 'fernanda.lima.pereira@email.com', '14519378270');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Costa Pereira', 'M', 'felipe.costa.pereira@email.com', '92289977093');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Oliveira', 'M', 'jo�o.pereira.oliveira@webmail.com', '77861182954');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Gomes', 'F', 'ana.souza.gomes@mail.com', '56148555840');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Martins Souza', 'M', 'jo�o.martins.souza@webmail.com', '18138516552');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Lima', 'M', 'lucas.rocha.lima@mail.com', '08917372195');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Souza', 'F', 'fernanda.silva.souza@example.com', '09352535279');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Rocha Martins', 'M', 'pedro.rocha.martins@email.com', '23099727768');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Costa Martins', 'F', 'amanda.costa.martins@myemail.com', '86602876031');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Lima', 'F', 'fernanda.lima.lima@myemail.com', '16626303904');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Rocha', 'M', 'bruno.rocha.rocha@example.com', '95613746520');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Gomes Costa', 'M', 'rafael.gomes.costa@webmail.com', '06907381251');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Martins', 'F', 'paula.souza.martins@webmail.com', '13690926871');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Gomes Almeida', 'M', 'felipe.gomes.almeida@email.com', '73796186814');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Silva Silva', 'M', 'rafael.silva.silva@example.com', '44797278087');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Silva', 'F', 'marcela.martins.silva@example.com', '96300753639');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Martins', 'M', 'marcelo.souza.martins@myemail.com', '74825287610');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Rocha Rocha', 'M', 'leonardo.rocha.rocha@mail.com', '99388949929');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Martins', 'F', 'luiza.silva.martins@webmail.com', '58524068767');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Gomes', 'F', 'giovanna.martins.gomes@myemail.com', '16923004151');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Almeida', 'F', 'giovanna.lima.almeida@mail.com', '39009252903');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Gomes Pereira', 'M', 'mateus.gomes.pereira@mail.com', '55087421423');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Oliveira', 'M', 'mateus.silva.oliveira@webmail.com', '15546372933');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Costa Lima', 'M', 'mateus.costa.lima@mail.com', '63373453893');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Costa Martins', 'M', 'pedro.costa.martins@example.com', '76745346426');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Almeida', 'M', 'gabriel.pereira.almeida@email.com', '46874526292');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Costa Souza', 'M', 'gabriel.costa.souza@mail.com', '37638105659');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Costa', 'M', 'lucas.martins.costa@mail.com', '51640228880');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Almeida', 'M', 'pedro.almeida.almeida@webmail.com', '16049274236');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Almeida Lima', 'M', 'felipe.almeida.lima@webmail.com', '04182540540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Rocha Rocha', 'F', 'fernanda.rocha.rocha@myemail.com', '80106778062');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Oliveira Lima', 'F', 'mariana.oliveira.lima@webmail.com', '39014935138');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Oliveira', 'F', 'ana.gomes.oliveira@webmail.com', '63160781667');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Silva', 'M', 'leonardo.lima.silva@example.com', '62702467943');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Silva', 'M', 'pedro.silva.silva@myemail.com', '18335132936');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Lima Lima', 'M', 'pedro.lima.lima@mail.com', '71548029222');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Lima', 'M', 'gabriel.lima.lima@mail.com', '79798291546');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Souza Rocha', 'M', 'lucas.souza.rocha@webmail.com', '39143625742');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Oliveira Rocha', 'F', 'fernanda.oliveira.rocha@webmail.com', '19915111080');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Oliveira', 'M', 'felipe.martins.oliveira@email.com', '36826478253');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Lima Almeida', 'M', 'rafael.lima.almeida@example.com', '76254675453');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Silva Gomes', 'F', 'giovanna.silva.gomes@webmail.com', '89808041096');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Souza Martins', 'M', 'rafael.souza.martins@email.com', '32221952513');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Martins', 'M', 'lucas.pereira.martins@mail.com', '52524880153');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Costa Martins', 'F', 'ana.costa.martins@example.com', '39457826534');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Lima Silva', 'F', 'marcela.lima.silva@webmail.com', '63451750665');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Martins', 'M', 'pedro.souza.martins@mail.com', '42217151540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Oliveira', 'M', 'lucas.almeida.oliveira@mail.com', '65588836139');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Gomes Pereira', 'M', 'lucas.gomes.pereira@myemail.com', '63709564094');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Pereira', 'M', 'felipe.martins.pereira@myemail.com', '65383082322');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Oliveira', 'F', 'giovanna.lima.oliveira@mail.com', '94716060121');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Almeida Rocha', 'F', 'marcela.almeida.rocha@myemail.com', '65545499724');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Gomes Rocha', 'F', 'larissa.gomes.rocha@example.com', '89914805323');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Rocha Silva', 'F', 'ana.rocha.silva@myemail.com', '70061703027');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Gomes Souza', 'M', 'mateus.gomes.souza@email.com', '05225025503');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Gomes', 'F', 'larissa.pereira.gomes@webmail.com', '33944762991');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Oliveira', 'M', 'jo�o.lima.oliveira@email.com', '09716293912');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Lima Silva', 'F', 'ana.lima.silva@myemail.com', '02551265997');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Oliveira Oliveira', 'F', 'paula.oliveira.oliveira@mail.com', '69475265540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Lima', 'F', 'amanda.martins.lima@email.com', '74785416758');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Costa', 'F', 'fernanda.lima.costa@email.com', '27209399594');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Silva', 'M', 'lucas.pereira.silva@mail.com', '06811810740');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Almeida', 'F', 'luiza.silva.almeida@mail.com', '40270557699');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Oliveira Almeida', 'M', 'jo�o.oliveira.almeida@webmail.com', '76619156268');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Souza Rocha', 'F', 'luiza.souza.rocha@email.com', '16669719027');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Gomes', 'F', 'fernanda.silva.gomes@email.com', '38238450472');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Gomes', 'M', 'leonardo.silva.gomes@myemail.com', '07799423300');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Costa', 'F', 'larissa.oliveira.costa@mail.com', '14544008547');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Lima', 'M', 'lucas.oliveira.lima@webmail.com', '55495643998');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Martins', 'M', 'marcelo.rocha.martins@example.com', '33231599162');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Oliveira Pereira', 'M', 'leonardo.oliveira.pereira@webmail.com', '42809056053');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Costa Almeida', 'M', 'leonardo.costa.almeida@example.com', '44794947245');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Rocha Oliveira', 'F', 'luiza.rocha.oliveira@email.com', '60943522169');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Rocha Silva', 'M', 'jo�o.rocha.silva@myemail.com', '33182034877');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Gomes', 'F', 'paula.martins.gomes@example.com', '61554635750');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Rocha', 'F', 'carla.costa.rocha@email.com', '96741504679');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Souza Oliveira', 'M', 'mateus.souza.oliveira@myemail.com', '98125571700');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Rocha', 'M', 'lucas.martins.rocha@example.com', '73180349642');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Rocha Martins', 'F', 'mariana.rocha.martins@mail.com', '23580261753');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Rocha', 'F', 'paula.costa.rocha@email.com', '13389915452');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Almeida', 'M', 'mateus.lima.almeida@webmail.com', '84870261576');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Oliveira', 'F', 'giovanna.rocha.oliveira@webmail.com', '17048659538');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Silva', 'M', 'felipe.pereira.silva@webmail.com', '42732172273');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Martins Martins', 'F', 'larissa.martins.martins@myemail.com', '92128304205');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Lima Rocha', 'F', 'luiza.lima.rocha@mail.com', '70274373535');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Costa', 'M', 'gabriel.souza.costa@mail.com', '48947549641');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Gomes Souza', 'F', 'giovanna.gomes.souza@example.com', '29275962746');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Gomes', 'M', 'leonardo.pereira.gomes@myemail.com', '27543245604');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Rocha', 'F', 'amanda.lima.rocha@myemail.com', '33613356003');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Rocha Gomes', 'F', 'larissa.rocha.gomes@myemail.com', '52121993947');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Costa Gomes', 'F', 'giovanna.costa.gomes@example.com', '06337016131');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Gomes Rocha', 'F', 'fernanda.gomes.rocha@webmail.com', '35576621324');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Costa Silva', 'F', 'larissa.costa.silva@myemail.com', '55676033509');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Rocha', 'F', 'fernanda.lima.rocha@email.com', '41044748326');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Martins Oliveira', 'F', 'larissa.martins.oliveira@webmail.com', '59543258732');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Lima Gomes', 'F', 'mariana.lima.gomes@myemail.com', '17044920892');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Silva', 'M', 'marcelo.lima.silva@webmail.com', '71458453871');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Silva', 'F', 'carla.lima.silva@webmail.com', '00306071265');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Oliveira Oliveira', 'M', 'mateus.oliveira.oliveira@webmail.com', '64781182933');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Silva', 'M', 'pedro.almeida.silva@webmail.com', '56525847323');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Lima', 'F', 'fernanda.silva.lima@example.com', '33539163914');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Silva Pereira', 'M', 'rafael.silva.pereira@webmail.com', '78358286865');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Oliveira', 'M', 'gabriel.almeida.oliveira@mail.com', '29368926225');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Pereira', 'F', 'giovanna.martins.pereira@mail.com', '37027915472');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Souza Souza', 'F', 'marcela.souza.souza@myemail.com', '79283354578');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Lima', 'F', 'luiza.silva.lima@email.com', '59204475363');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Costa Lima', 'M', 'jo�o.costa.lima@example.com', '35745418460');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Oliveira Almeida', 'F', 'carla.oliveira.almeida@webmail.com', '70540959262');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Gomes', 'F', 'carla.costa.gomes@email.com', '36826455611');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Oliveira Lima', 'F', 'marcela.oliveira.lima@webmail.com', '35411403732');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Pereira', 'M', 'jo�o.souza.pereira@myemail.com', '80245450917');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Costa', 'M', 'bruno.souza.costa@email.com', '38913268654');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Oliveira', 'M', 'pedro.souza.oliveira@email.com', '96089346050');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Oliveira Almeida', 'M', 'felipe.oliveira.almeida@mail.com', '55902150491');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Silva Lima', 'F', 'ana.silva.lima@mail.com', '20318112010');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Silva', 'F', 'fernanda.martins.silva@example.com', '57702956547');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Rocha Souza', 'F', 'mariana.rocha.souza@email.com', '20534231590');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Martins', 'M', 'pedro.souza.martins@example.com', '95836343167');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Almeida', 'M', 'lucas.almeida.almeida@email.com', '50938658796');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Costa Pereira', 'M', 'gabriel.costa.pereira@email.com', '43003765378');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Oliveira Almeida', 'M', 'jo�o.oliveira.almeida@email.com', '58823247797');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Martins', 'M', 'bruno.almeida.martins@webmail.com', '51631444450');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Martins', 'M', 'mateus.pereira.martins@mail.com', '30389872772');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Souza', 'M', 'lucas.pereira.souza@example.com', '44403062079');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Costa', 'F', 'carla.lima.costa@mail.com', '01618041226');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Almeida Gomes', 'F', 'carla.almeida.gomes@example.com', '03601335441');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Oliveira', 'M', 'gabriel.oliveira.oliveira@mail.com', '11905741134');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Costa', 'M', 'leonardo.lima.costa@webmail.com', '94247479288');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Almeida', 'M', 'lucas.costa.almeida@mail.com', '22978037638');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Gomes Pereira', 'F', 'paula.gomes.pereira@myemail.com', '02005135977');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Almeida', 'F', 'paula.lima.almeida@mail.com', '74975173654');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Silva', 'F', 'luiza.silva.silva@myemail.com', '84326525186');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Silva Rocha', 'M', 'jo�o.silva.rocha@myemail.com', '68012932718');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Almeida', 'F', 'carla.costa.almeida@example.com', '30386520639');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Pereira Souza', 'M', 'lucas.pereira.souza@email.com', '09931072907');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Martins', 'F', 'marcela.pereira.martins@mail.com', '14145942871');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Rocha Costa', 'F', 'larissa.rocha.costa@mail.com', '51315819731');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Oliveira', 'F', 'luiza.gomes.oliveira@webmail.com', '88887130312');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Pereira', 'M', 'bruno.rocha.pereira@webmail.com', '57307417041');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Souza', 'F', 'ana.oliveira.souza@example.com', '32601420314');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Costa', 'F', 'paula.souza.costa@mail.com', '42837315029');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Almeida Pereira', 'M', 'rafael.almeida.pereira@example.com', '21615850896');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Rocha Gomes', 'F', 'ana.rocha.gomes@mail.com', '94306339366');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Almeida', 'F', 'luiza.pereira.almeida@example.com', '41609424496');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Almeida Pereira', 'F', 'giovanna.almeida.pereira@webmail.com', '40948439062');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Almeida Souza', 'F', 'carla.almeida.souza@email.com', '83332749172');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Rocha', 'F', 'giovanna.rocha.rocha@example.com', '08617582389');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Oliveira Silva', 'F', 'amanda.oliveira.silva@example.com', '84671260256');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Costa', 'F', 'luiza.costa.costa@email.com', '59864139342');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Pereira Martins', 'F', 'ana.pereira.martins@myemail.com', '12760009459');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Lima Almeida', 'M', 'rafael.lima.almeida@myemail.com', '14688453072');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Rocha', 'F', 'mariana.martins.rocha@webmail.com', '76412965395');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Oliveira', 'F', 'larissa.lima.oliveira@webmail.com', '15660244259');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Oliveira', 'M', 'marcelo.oliveira.oliveira@myemail.com', '10711703738');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Silva Pereira', 'M', 'marcelo.silva.pereira@webmail.com', '88266481492');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Rocha', 'F', 'fernanda.almeida.rocha@example.com', '67661484617');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Gomes Martins', 'F', 'paula.gomes.martins@webmail.com', '91717695356');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Almeida', 'F', 'mariana.gomes.almeida@email.com', '05014485667');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Almeida Almeida', 'F', 'carla.almeida.almeida@mail.com', '37808843410');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Pereira', 'M', 'mateus.silva.pereira@example.com', '15248650491');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Costa', 'F', 'fernanda.martins.costa@mail.com', '71446322585');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Lima', 'M', 'leonardo.souza.lima@mail.com', '47883489785');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Martins', 'M', 'lucas.almeida.martins@webmail.com', '48285955257');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Lima Costa', 'M', 'pedro.lima.costa@email.com', '01590334773');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Pereira Gomes', 'M', 'jo�o.pereira.gomes@mail.com', '00812728921');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Lima Rocha', 'M', 'rafael.lima.rocha@webmail.com', '60636397206');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Souza Souza', 'F', 'mariana.souza.souza@myemail.com', '18341175535');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Almeida', 'F', 'giovanna.rocha.almeida@email.com', '38672733741');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Martins', 'M', 'felipe.pereira.martins@example.com', '43771143870');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Almeida Almeida', 'F', 'ana.almeida.almeida@webmail.com', '88575643915');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Gomes Martins', 'M', 'felipe.gomes.martins@myemail.com', '85356957869');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Gomes', 'F', 'luiza.costa.gomes@email.com', '36240408431');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Souza', 'F', 'ana.gomes.souza@mail.com', '87794827546');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Costa Lima', 'F', 'fernanda.costa.lima@mail.com', '76037231789');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Souza', 'M', 'bruno.silva.souza@mail.com', '76609992903');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Silva', 'M', 'jo�o.souza.silva@example.com', '07249198092');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Oliveira Almeida', 'F', 'luiza.oliveira.almeida@myemail.com', '39945367184');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Costa', 'F', 'giovanna.rocha.costa@example.com', '81768049937');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Rocha Rocha', 'F', 'amanda.rocha.rocha@myemail.com', '95835947355');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Almeida Gomes', 'F', 'larissa.almeida.gomes@example.com', '42333378214');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Lima', 'M', 'bruno.silva.lima@email.com', '73737678847');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Rocha Lima', 'M', 'jo�o.rocha.lima@myemail.com', '99232445997');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Silva', 'F', 'amanda.martins.silva@mail.com', '66710603847');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Lima', 'F', 'ana.oliveira.lima@email.com', '22878164991');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Rocha Oliveira', 'F', 'larissa.rocha.oliveira@example.com', '84742766995');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Souza', 'M', 'leonardo.almeida.souza@mail.com', '54051449352');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Rocha', 'M', 'leonardo.pereira.rocha@webmail.com', '70682755284');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Martins', 'M', 'felipe.martins.martins@example.com', '41399826946');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Lima', 'F', 'paula.souza.lima@mail.com', '04606346156');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Lima Oliveira', 'M', 'lucas.lima.oliveira@myemail.com', '29432647589');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Pereira', 'F', 'marcela.pereira.pereira@webmail.com', '28127367351');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Almeida', 'F', 'larissa.pereira.almeida@webmail.com', '45160916495');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Costa', 'F', 'luiza.pereira.costa@webmail.com', '06143361795');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Martins', 'M', 'marcelo.lima.martins@example.com', '27197194872');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Oliveira Silva', 'M', 'jo�o.oliveira.silva@mail.com', '83243920900');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Martins Silva', 'M', 'jo�o.martins.silva@myemail.com', '18563408282');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Oliveira Souza', 'F', 'giovanna.oliveira.souza@mail.com', '35570997689');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Costa', 'M', 'gabriel.gomes.costa@example.com', '24187910375');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Rocha Almeida', 'F', 'carla.rocha.almeida@myemail.com', '50754914542');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Costa Gomes', 'F', 'giovanna.costa.gomes@myemail.com', '28641264986');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Lima Silva', 'F', 'mariana.lima.silva@myemail.com', '95310618683');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Lima Almeida', 'F', 'luiza.lima.almeida@webmail.com', '58174862632');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Gomes Silva', 'F', 'carla.gomes.silva@example.com', '10121213153');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Souza', 'F', 'amanda.lima.souza@mail.com', '59790948933');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Costa Pereira', 'F', 'marcela.costa.pereira@example.com', '28281439149');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Souza', 'M', 'marcelo.souza.souza@mail.com', '04507811154');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Silva Almeida', 'M', 'felipe.silva.almeida@example.com', '96487677012');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Pereira', 'F', 'larissa.lima.pereira@example.com', '14419236335');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Souza Gomes', 'M', 'pedro.souza.gomes@example.com', '73723172514');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Oliveira', 'F', 'mariana.pereira.oliveira@webmail.com', '49447350259');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Rocha Souza', 'F', 'ana.rocha.souza@email.com', '67336229440');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Martins', 'F', 'carla.lima.martins@mail.com', '24276065172');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Lima', 'M', 'leonardo.almeida.lima@myemail.com', '66193921170');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Silva Oliveira', 'M', 'gabriel.silva.oliveira@webmail.com', '45744071835');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Oliveira', 'M', 'pedro.gomes.oliveira@myemail.com', '56260452104');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Rocha Almeida', 'F', 'paula.rocha.almeida@webmail.com', '08401969204');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Oliveira Pereira', 'M', 'pedro.oliveira.pereira@example.com', '55020088836');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Pereira', 'M', 'lucas.rocha.pereira@mail.com', '70198077475');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Souza', 'M', 'rafael.martins.souza@webmail.com', '87496720690');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Martins', 'M', 'gabriel.pereira.martins@myemail.com', '26183814037');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Almeida Costa', 'M', 'mateus.almeida.costa@example.com', '18088615263');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Pereira', 'F', 'paula.martins.pereira@myemail.com', '86956609402');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Souza Rocha', 'F', 'carla.souza.rocha@email.com', '90498737716');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Gomes', 'F', 'luiza.costa.gomes@mail.com', '50382531534');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Gomes', 'M', 'marcelo.martins.gomes@myemail.com', '05890799582');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Costa Lima', 'F', 'ana.costa.lima@example.com', '57171507038');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Silva Souza', 'F', 'fernanda.silva.souza@webmail.com', '21120414401');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Rocha', 'F', 'fernanda.souza.rocha@myemail.com', '28943104534');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Souza Gomes', 'F', 'luiza.souza.gomes@mail.com', '12127184764');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Silva Martins', 'F', 'amanda.silva.martins@myemail.com', '78035063459');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Martins Almeida', 'F', 'luiza.martins.almeida@example.com', '50782759292');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Rocha', 'M', 'gabriel.pereira.rocha@mail.com', '10324696663');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Costa', 'M', 'gabriel.souza.costa@webmail.com', '35908886712');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Souza Rocha', 'M', 'mateus.souza.rocha@webmail.com', '76519998933');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Pereira Rocha', 'F', 'paula.pereira.rocha@myemail.com', '52749368736');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Martins', 'F', 'carla.lima.martins@webmail.com', '94495145115');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Silva', 'F', 'mariana.pereira.silva@myemail.com', '80664417429');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Silva Souza', 'F', 'ana.silva.souza@myemail.com', '94122054003');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Pereira Souza', 'F', 'amanda.pereira.souza@mail.com', '30194697505');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Lima Silva', 'F', 'amanda.lima.silva@webmail.com', '69050912756');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Pereira Souza', 'M', 'rafael.pereira.souza@myemail.com', '88754920972');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Rocha', 'F', 'fernanda.souza.rocha@email.com', '42429971091');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Costa', 'F', 'mariana.pereira.costa@email.com', '81365154192');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Lima', 'F', 'paula.martins.lima@mail.com', '19593024232');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Lima', 'M', 'marcelo.martins.lima@webmail.com', '44593557476');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Almeida Pereira', 'M', 'mateus.almeida.pereira@email.com', '81034229661');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Souza Silva', 'M', 'rafael.souza.silva@example.com', '23603527595');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Costa Gomes', 'M', 'rafael.costa.gomes@example.com', '74138582215');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Silva', 'F', 'luiza.silva.silva@mail.com', '62885065408');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Silva', 'F', 'ana.souza.silva@myemail.com', '96814214245');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Oliveira Martins', 'M', 'marcelo.oliveira.martins@mail.com', '78215317047');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Silva Costa', 'M', 'felipe.silva.costa@example.com', '06905022189');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Oliveira', 'M', 'bruno.silva.oliveira@myemail.com', '88067386219');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Martins', 'M', 'bruno.souza.martins@email.com', '51708755479');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Gomes Pereira', 'M', 'mateus.gomes.pereira@example.com', '66987050594');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Souza', 'M', 'felipe.martins.souza@example.com', '05601973982');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Rocha', 'F', 'carla.costa.rocha@myemail.com', '28751279499');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Rocha', 'M', 'gabriel.almeida.rocha@email.com', '45845097755');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Silva', 'F', 'ana.gomes.silva@email.com', '70857852572');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Almeida', 'F', 'fernanda.almeida.almeida@example.com', '05601614596');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Martins Silva', 'M', 'pedro.martins.silva@email.com', '47661796872');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Souza Oliveira', 'F', 'amanda.souza.oliveira@webmail.com', '06569699702');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Gomes', 'M', 'jo�o.gomes.gomes@mail.com', '79265693381');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Almeida Rocha', 'F', 'ana.almeida.rocha@webmail.com', '78601064163');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Souza Martins', 'M', 'lucas.souza.martins@example.com', '53319375302');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Rocha Silva', 'M', 'leonardo.rocha.silva@webmail.com', '07451411404');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Oliveira Martins', 'M', 'pedro.oliveira.martins@mail.com', '07415799659');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Souza', 'M', 'marcelo.souza.souza@myemail.com', '89015447603');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Gomes Almeida', 'F', 'amanda.gomes.almeida@mail.com', '39094647147');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Costa', 'F', 'fernanda.lima.costa@example.com', '03781089025');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Almeida', 'M', 'bruno.lima.almeida@webmail.com', '10112711512');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Souza', 'M', 'felipe.rocha.souza@email.com', '20628676997');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Souza', 'M', 'bruno.souza.souza@myemail.com', '99995324621');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Costa', 'M', 'pedro.silva.costa@myemail.com', '39626543235');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Almeida Martins', 'M', 'felipe.almeida.martins@mail.com', '96824127959');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Almeida Oliveira', 'F', 'ana.almeida.oliveira@myemail.com', '65284330486');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Souza Pereira', 'F', 'mariana.souza.pereira@webmail.com', '05041714808');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Martins', 'F', 'larissa.oliveira.martins@mail.com', '64538447818');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Lima', 'F', 'marcela.rocha.lima@email.com', '62847242370');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Oliveira Gomes', 'M', 'bruno.oliveira.gomes@example.com', '89126000357');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Lima Silva', 'M', 'rafael.lima.silva@example.com', '42450799939');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Souza', 'F', 'mariana.martins.souza@webmail.com', '17246182958');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Pereira', 'M', 'bruno.almeida.pereira@myemail.com', '32558333433');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Silva Martins', 'M', 'felipe.silva.martins@mail.com', '80843954374');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Lima Costa', 'F', 'mariana.lima.costa@mail.com', '17762775517');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Silva Almeida', 'F', 'carla.silva.almeida@myemail.com', '84377515308');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Silva', 'F', 'giovanna.martins.silva@myemail.com', '49730142969');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Lima', 'F', 'paula.martins.lima@myemail.com', '69084354733');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Gomes Silva', 'M', 'marcelo.gomes.silva@mail.com', '79144988601');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Almeida', 'F', 'ana.oliveira.almeida@email.com', '41964469353');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Silva', 'F', 'luiza.pereira.silva@webmail.com', '75536570734');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Silva', 'F', 'larissa.oliveira.silva@example.com', '79058058670');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Lima', 'F', 'paula.lima.lima@myemail.com', '80052608483');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Costa', 'M', 'lucas.almeida.costa@mail.com', '73640287219');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Pereira', 'M', 'pedro.almeida.pereira@webmail.com', '47883552462');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Souza', 'M', 'marcelo.rocha.souza@email.com', '32740825441');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Rocha', 'M', 'lucas.almeida.rocha@example.com', '15473667694');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Martins Souza', 'M', 'gabriel.martins.souza@email.com', '96473235744');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Lima', 'F', 'fernanda.martins.lima@mail.com', '38544372354');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Lima', 'F', 'luiza.silva.lima@webmail.com', '44403761769');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Souza', 'M', 'bruno.rocha.souza@example.com', '72042962340');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Gomes', 'M', 'lucas.costa.gomes@webmail.com', '60879240249');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Oliveira', 'F', 'giovanna.souza.oliveira@email.com', '93577591335');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Oliveira Silva', 'F', 'luiza.oliveira.silva@example.com', '29047037283');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Martins', 'M', 'gabriel.oliveira.martins@mail.com', '67651157821');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Gomes Rocha', 'M', 'lucas.gomes.rocha@example.com', '47635662482');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Gomes Costa', 'M', 'felipe.gomes.costa@example.com', '12214211255');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Lima', 'F', 'larissa.souza.lima@email.com', '16934889069');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Rocha Souza', 'F', 'fernanda.rocha.souza@myemail.com', '88111197145');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Rocha Souza', 'M', 'leonardo.rocha.souza@webmail.com', '89759637143');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Almeida Costa', 'M', 'mateus.almeida.costa@webmail.com', '91912650812');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Costa Souza', 'M', 'marcelo.costa.souza@email.com', '76020513006');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Souza', 'M', 'marcelo.rocha.souza@mail.com', '54733013760');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Rocha Martins', 'M', 'mateus.rocha.martins@email.com', '40363950475');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Rocha', 'F', 'larissa.lima.rocha@mail.com', '03043634334');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Silva', 'F', 'larissa.lima.silva@mail.com', '53553790571');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Souza Souza', 'M', 'rafael.souza.souza@example.com', '62701274046');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Oliveira', 'M', 'rafael.martins.oliveira@example.com', '92109957519');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Oliveira Gomes', 'M', 'mateus.oliveira.gomes@mail.com', '96884553908');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Martins', 'M', 'jo�o.gomes.martins@webmail.com', '12171625871');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Rocha', 'M', 'pedro.silva.rocha@email.com', '79602821240');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Lima', 'M', 'pedro.pereira.lima@myemail.com', '20537721981');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Silva Martins', 'F', 'giovanna.silva.martins@mail.com', '98379370651');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Rocha', 'M', 'jo�o.lima.rocha@example.com', '22054204973');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Silva Oliveira', 'M', 'lucas.silva.oliveira@myemail.com', '05250143366');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Silva Pereira', 'F', 'luiza.silva.pereira@myemail.com', '30016500172');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Silva', 'M', 'gabriel.pereira.silva@myemail.com', '29546332859');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Almeida', 'M', 'pedro.almeida.almeida@email.com', '04558271807');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Silva Rocha', 'F', 'carla.silva.rocha@myemail.com', '30813679512');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Martins Lima', 'F', 'ana.martins.lima@example.com', '24006708752');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Gomes Martins', 'F', 'carla.gomes.martins@mail.com', '89111047967');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Martins Lima', 'M', 'gabriel.martins.lima@email.com', '22401203798');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Pereira', 'M', 'pedro.almeida.pereira@myemail.com', '13071395456');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Almeida', 'M', 'pedro.gomes.almeida@mail.com', '41040406275');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Martins Silva', 'F', 'giovanna.martins.silva@example.com', '77680807802');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Oliveira', 'M', 'leonardo.lima.oliveira@myemail.com', '58894046605');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Martins', 'F', 'luiza.pereira.martins@myemail.com', '83884221571');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Lima', 'M', 'pedro.gomes.lima@mail.com', '84761505973');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Lima', 'M', 'leonardo.lima.lima@email.com', '70290371920');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Souza', 'F', 'ana.gomes.souza@myemail.com', '79699194661');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Souza', 'F', 'luiza.gomes.souza@email.com', '57261726960');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Almeida Oliveira', 'F', 'amanda.almeida.oliveira@email.com', '75650225318');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Souza', 'F', 'amanda.martins.souza@myemail.com', '97599664258');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Pereira', 'F', 'fernanda.martins.pereira@email.com', '79963997313');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Martins', 'M', 'lucas.costa.martins@example.com', '82994207556');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Rocha Martins', 'F', 'larissa.rocha.martins@example.com', '95222496083');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Silva Silva', 'F', 'paula.silva.silva@webmail.com', '83400426080');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Rocha', 'F', 'paula.costa.rocha@example.com', '79078149753');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Costa Silva', 'F', 'larissa.costa.silva@webmail.com', '92410737345');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Gomes', 'M', 'marcelo.rocha.gomes@mail.com', '23739018471');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Lima', 'F', 'larissa.oliveira.lima@myemail.com', '08267966521');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Oliveira Almeida', 'F', 'amanda.oliveira.almeida@mail.com', '15126779667');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Almeida Costa', 'F', 'paula.almeida.costa@mail.com', '26803245318');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Lima Silva', 'M', 'lucas.lima.silva@webmail.com', '15439089751');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Pereira Pereira', 'F', 'fernanda.pereira.pereira@webmail.com', '29233389781');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Souza Costa', 'M', 'gabriel.souza.costa@email.com', '22321450002');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Martins Souza', 'F', 'ana.martins.souza@myemail.com', '45871222870');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Almeida Rocha', 'M', 'jo�o.almeida.rocha@example.com', '02705917445');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Oliveira Souza', 'F', 'marcela.oliveira.souza@example.com', '85419820716');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Oliveira Costa', 'F', 'luiza.oliveira.costa@webmail.com', '33349179753');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Oliveira Rocha', 'M', 'lucas.oliveira.rocha@example.com', '94485666795');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Almeida Silva', 'M', 'rafael.almeida.silva@mail.com', '46026720071');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Gomes', 'F', 'fernanda.souza.gomes@example.com', '39250697694');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Almeida Almeida', 'F', 'luiza.almeida.almeida@webmail.com', '60661201407');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Oliveira', 'F', 'luiza.costa.oliveira@example.com', '49951952148');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Almeida', 'M', 'gabriel.gomes.almeida@example.com', '21372220742');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Gomes Pereira', 'F', 'giovanna.gomes.pereira@myemail.com', '86630411530');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Martins', 'F', 'giovanna.souza.martins@myemail.com', '16978815775');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Almeida', 'M', 'lucas.costa.almeida@email.com', '27731967174');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Martins', 'M', 'rafael.martins.martins@email.com', '99095527738');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Gomes', 'F', 'mariana.pereira.gomes@email.com', '56193493525');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Rocha', 'F', 'fernanda.souza.rocha@mail.com', '35053875439');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Gomes Almeida', 'M', 'pedro.gomes.almeida@webmail.com', '09584993188');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Gomes Souza', 'F', 'fernanda.gomes.souza@email.com', '84786085134');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Martins', 'M', 'lucas.rocha.martins@myemail.com', '89041221697');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Souza Pereira', 'F', 'amanda.souza.pereira@myemail.com', '23484026115');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Almeida Gomes', 'M', 'lucas.almeida.gomes@mail.com', '70343941820');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Costa Gomes', 'M', 'rafael.costa.gomes@mail.com', '90899687242');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Pereira', 'M', 'jo�o.souza.pereira@example.com', '05337930030');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Pereira', 'M', 'rafael.rocha.pereira@webmail.com', '94789433270');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Silva Costa', 'F', 'paula.silva.costa@email.com', '53673678649');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Oliveira Lima', 'M', 'bruno.oliveira.lima@webmail.com', '41769786948');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Souza', 'F', 'giovanna.souza.souza@email.com', '03004096163');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Martins Lima', 'F', 'amanda.martins.lima@mail.com', '59144289037');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Silva', 'F', 'carla.costa.silva@myemail.com', '33961525690');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Souza Lima', 'F', 'luiza.souza.lima@mail.com', '84544925423');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Lima', 'M', 'mateus.lima.lima@email.com', '29175765487');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Almeida', 'M', 'bruno.lima.almeida@myemail.com', '89815315400');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Costa', 'M', 'felipe.pereira.costa@mail.com', '51921393720');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Pereira', 'M', 'lucas.martins.pereira@example.com', '53245923708');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Almeida', 'F', 'giovanna.rocha.almeida@mail.com', '55153963001');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Oliveira', 'F', 'fernanda.lima.oliveira@mail.com', '78435682422');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Gomes Silva', 'F', 'carla.gomes.silva@myemail.com', '48337017038');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Oliveira Oliveira', 'M', 'felipe.oliveira.oliveira@mail.com', '92856757393');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Silva Almeida', 'F', 'amanda.silva.almeida@myemail.com', '04665157780');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Oliveira Gomes', 'F', 'paula.oliveira.gomes@myemail.com', '85181383083');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Rocha', 'M', 'bruno.souza.rocha@email.com', '03405645801');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Martins Rocha', 'F', 'paula.martins.rocha@email.com', '56309248316');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Almeida Almeida', 'F', 'giovanna.almeida.almeida@webmail.com', '74445014206');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Costa', 'F', 'fernanda.souza.costa@webmail.com', '57397419776');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Lima Souza', 'F', 'luiza.lima.souza@webmail.com', '02219613140');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Gomes', 'M', 'lucas.martins.gomes@myemail.com', '90542257628');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Costa', 'M', 'mateus.lima.costa@myemail.com', '10614942945');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Almeida', 'M', 'pedro.silva.almeida@example.com', '48944247132');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Martins', 'F', 'marcela.pereira.martins@webmail.com', '52080864681');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Gomes Pereira', 'F', 'ana.gomes.pereira@example.com', '44370751337');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Costa Souza', 'F', 'giovanna.costa.souza@example.com', '58369790940');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Oliveira Lima', 'F', 'paula.oliveira.lima@email.com', '30229483313');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Souza Costa', 'F', 'carla.souza.costa@myemail.com', '75043386669');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Gomes', 'M', 'rafael.rocha.gomes@mail.com', '73240411684');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Gomes Rocha', 'M', 'lucas.gomes.rocha@webmail.com', '38839434492');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Souza Costa', 'M', 'bruno.souza.costa@example.com', '97697176159');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Martins Oliveira', 'M', 'lucas.martins.oliveira@email.com', '24263502851');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Souza Oliveira', 'M', 'felipe.souza.oliveira@example.com', '09106030923');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Costa Oliveira', 'M', 'lucas.costa.oliveira@myemail.com', '54016333201');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Silva Rocha', 'F', 'ana.silva.rocha@email.com', '40533852746');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Silva Gomes', 'M', 'rafael.silva.gomes@mail.com', '02313630942');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Silva Pereira', 'M', 'gabriel.silva.pereira@example.com', '43107760974');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Martins Silva', 'M', 'gabriel.martins.silva@myemail.com', '85226193491');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Costa Gomes', 'M', 'leonardo.costa.gomes@myemail.com', '28257373865');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Rocha', 'M', 'lucas.rocha.rocha@mail.com', '54341702817');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Martins Rocha', 'F', 'fernanda.martins.rocha@email.com', '14970653472');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Martins', 'F', 'giovanna.souza.martins@webmail.com', '29960268177');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Almeida', 'M', 'leonardo.souza.almeida@myemail.com', '95068401424');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Silva', 'F', 'luiza.costa.silva@email.com', '05499055562');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Oliveira', 'M', 'jo�o.lima.oliveira@webmail.com', '57494763799');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Souza', 'M', 'gabriel.gomes.souza@myemail.com', '31051560973');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Costa Gomes', 'M', 'felipe.costa.gomes@webmail.com', '43369642702');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Pereira Silva', 'M', 'marcelo.pereira.silva@example.com', '55655583002');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Souza', 'M', 'marcelo.lima.souza@example.com', '27858578758');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Rocha', 'F', 'luiza.gomes.rocha@email.com', '64677988753');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Silva Martins', 'M', 'leonardo.silva.martins@mail.com', '60767266106');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Gomes Pereira', 'F', 'giovanna.gomes.pereira@mail.com', '92541070146');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Silva', 'F', 'larissa.souza.silva@webmail.com', '33261273296');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Oliveira', 'M', 'gabriel.gomes.oliveira@mail.com', '52021400226');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Pereira Costa', 'F', 'carla.pereira.costa@mail.com', '15801496819');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Souza Souza', 'M', 'felipe.souza.souza@myemail.com', '29767346734');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Pereira Silva', 'F', 'amanda.pereira.silva@example.com', '21319709151');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Rocha', 'M', 'bruno.gomes.rocha@webmail.com', '24926896375');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Souza', 'F', 'marcela.rocha.souza@email.com', '27248296767');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Pereira Gomes', 'F', 'carla.pereira.gomes@webmail.com', '26412314324');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Costa', 'M', 'gabriel.pereira.costa@example.com', '23645271636');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Oliveira', 'M', 'lucas.rocha.oliveira@example.com', '39355835223');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Gomes', 'F', 'giovanna.rocha.gomes@webmail.com', '20936509922');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Costa Rocha', 'F', 'carla.costa.rocha@mail.com', '01550660929');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Lima Oliveira', 'M', 'gabriel.lima.oliveira@myemail.com', '75743392128');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Gomes', 'F', 'giovanna.lima.gomes@mail.com', '85578246728');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Souza Silva', 'M', 'rafael.souza.silva@myemail.com', '49049739834');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Lima Rocha', 'F', 'larissa.lima.rocha@myemail.com', '52883917669');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Almeida', 'F', 'paula.lima.almeida@email.com', '17291671227');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Rocha Martins', 'M', 'bruno.rocha.martins@email.com', '57155084812');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Silva Rocha', 'F', 'larissa.silva.rocha@mail.com', '28454468721');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Almeida Souza', 'M', 'jo�o.almeida.souza@email.com', '24456834346');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Souza Souza', 'F', 'larissa.souza.souza@email.com', '23609712904');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Oliveira Pereira', 'F', 'giovanna.oliveira.pereira@myemail.com', '46469129679');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Costa', 'F', 'paula.souza.costa@myemail.com', '27578050114');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Pereira Souza', 'F', 'mariana.pereira.souza@example.com', '42129573838');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Lima Gomes', 'F', 'giovanna.lima.gomes@myemail.com', '88260425871');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Almeida', 'M', 'leonardo.pereira.almeida@myemail.com', '91174491319');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Almeida', 'F', 'marcela.martins.almeida@email.com', '68044798477');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Pereira Costa', 'M', 'leonardo.pereira.costa@webmail.com', '65063887818');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Gomes Oliveira', 'M', 'rafael.gomes.oliveira@webmail.com', '54011165431');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Souza Gomes', 'F', 'giovanna.souza.gomes@webmail.com', '96635732959');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Lima Almeida', 'M', 'jo�o.lima.almeida@email.com', '12599493575');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Oliveira Almeida', 'M', 'gabriel.oliveira.almeida@myemail.com', '60183819051');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Lima', 'M', 'gabriel.gomes.lima@email.com', '37081701199');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Pereira Costa', 'M', 'felipe.pereira.costa@example.com', '33058045603');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Souza Almeida', 'M', 'marcelo.souza.almeida@myemail.com', '20491319864');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Costa Rocha', 'M', 'pedro.costa.rocha@webmail.com', '01019440913');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Gomes', 'F', 'fernanda.souza.gomes@mail.com', '96450040050');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Costa Costa', 'M', 'rafael.costa.costa@example.com', '10165359432');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Rocha Rocha', 'M', 'pedro.rocha.rocha@mail.com', '86580339937');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Gomes Rocha', 'M', 'bruno.gomes.rocha@example.com', '16304868677');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Almeida Souza', 'F', 'fernanda.almeida.souza@example.com', '52002995926');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Silva Silva', 'F', 'giovanna.silva.silva@mail.com', '03784831479');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Rocha Gomes', 'M', 'gabriel.rocha.gomes@myemail.com', '23246065430');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Silva Rocha', 'M', 'pedro.silva.rocha@webmail.com', '94744450965');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Silva', 'M', 'marcelo.martins.silva@mail.com', '77193454040');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Pereira Souza', 'F', 'amanda.pereira.souza@myemail.com', '97770480076');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Martins Oliveira', 'M', 'gabriel.martins.oliveira@webmail.com', '41551954101');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Pereira', 'F', 'luiza.gomes.pereira@email.com', '63344526487');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Rocha Gomes', 'M', 'jo�o.rocha.gomes@example.com', '57163967735');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Rocha Lima', 'M', 'mateus.rocha.lima@example.com', '20026944104');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Costa Pereira', 'F', 'mariana.costa.pereira@myemail.com', '52886276065');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Souza', 'F', 'ana.souza.souza@example.com', '46568001812');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Costa', 'M', 'lucas.rocha.costa@myemail.com', '81645334942');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Rocha', 'F', 'mariana.gomes.rocha@example.com', '82349302733');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Silva Pereira', 'F', 'carla.silva.pereira@mail.com', '82723535573');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Lima Pereira', 'M', 'marcelo.lima.pereira@myemail.com', '00505905703');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Almeida Martins', 'M', 'felipe.almeida.martins@myemail.com', '62133655902');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Souza Lima', 'M', 'jo�o.souza.lima@email.com', '95678748776');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Rocha', 'F', 'giovanna.rocha.rocha@mail.com', '94384450857');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Souza', 'M', 'marcelo.martins.souza@example.com', '30200379362');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Almeida Gomes', 'M', 'felipe.almeida.gomes@example.com', '36251723657');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Silva Souza', 'M', 'mateus.silva.souza@webmail.com', '97644142888');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Lima Almeida', 'M', 'pedro.lima.almeida@example.com', '86910230022');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Lima Pereira', 'F', 'mariana.lima.pereira@example.com', '24594131948');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Souza', 'M', 'gabriel.gomes.souza@example.com', '28624764279');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Jo�o Gomes Oliveira', 'M', 'jo�o.gomes.oliveira@email.com', '34901198826');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Souza Oliveira', 'M', 'rafael.souza.oliveira@webmail.com', '72543463586');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Pereira', 'M', 'gabriel.almeida.pereira@myemail.com', '41893714324');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Costa', 'M', 'gabriel.almeida.costa@myemail.com', '17676303540');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Souza', 'M', 'mateus.pereira.souza@webmail.com', '98914190627');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Rocha Almeida', 'F', 'carla.rocha.almeida@mail.com', '79447434352');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Pereira Almeida', 'M', 'gabriel.pereira.almeida@example.com', '22569663767');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Silva Lima', 'M', 'rafael.silva.lima@email.com', '24494464409');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Costa', 'F', 'mariana.gomes.costa@email.com', '68400762029');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Martins Martins', 'M', 'mateus.martins.martins@example.com', '28213350063');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Martins Oliveira', 'M', 'rafael.martins.oliveira@mail.com', '97223889080');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Souza', 'M', 'felipe.rocha.souza@myemail.com', '89586543403');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Gomes', 'M', 'bruno.lima.gomes@webmail.com', '60216905585');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Gomes', 'F', 'luiza.costa.gomes@example.com', '90678738814');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Souza', 'M', 'leonardo.lima.souza@webmail.com', '58440990625');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Amanda Silva Pereira', 'F', 'amanda.silva.pereira@webmail.com', '86535190434');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Martins Souza', 'M', 'pedro.martins.souza@example.com', '80094849447');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Costa Silva', 'F', 'fernanda.costa.silva@myemail.com', '73603779951');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Costa', 'M', 'pedro.pereira.costa@mail.com', '92213362094');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Silva', 'M', 'bruno.silva.silva@myemail.com', '87182700471');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Oliveira Oliveira', 'F', 'larissa.oliveira.oliveira@webmail.com', '19903378830');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Almeida', 'M', 'leonardo.souza.almeida@webmail.com', '33216824119');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Martins Gomes', 'M', 'felipe.martins.gomes@myemail.com', '31239377235');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Lima Pereira', 'F', 'paula.lima.pereira@mail.com', '68874303982');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Lima Costa', 'M', 'leonardo.lima.costa@example.com', '54883644068');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Gomes Silva', 'F', 'mariana.gomes.silva@myemail.com', '08882811544');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Gomes', 'M', 'mateus.lima.gomes@mail.com', '71133920773');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Silva Oliveira', 'F', 'larissa.silva.oliveira@mail.com', '80179828938');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mariana Martins Martins', 'F', 'mariana.martins.martins@example.com', '82172419018');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Silva Lima', 'F', 'giovanna.silva.lima@email.com', '75687597563');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Silva', 'F', 'larissa.pereira.silva@mail.com', '98121215738');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Pereira Lima', 'F', 'carla.pereira.lima@example.com', '24699130992');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Giovanna Rocha Lima', 'F', 'giovanna.rocha.lima@myemail.com', '09810111699');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Costa Lima', 'F', 'marcela.costa.lima@mail.com', '34429381329');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Oliveira', 'M', 'rafael.rocha.oliveira@email.com', '52870799725');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Silva Lima', 'M', 'bruno.silva.lima@webmail.com', '37108680979');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Rocha Lima', 'M', 'felipe.rocha.lima@myemail.com', '58368549723');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Souza Gomes', 'F', 'ana.souza.gomes@example.com', '40167330323');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Almeida Souza', 'M', 'pedro.almeida.souza@example.com', '70340879042');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Costa', 'F', 'marcela.martins.costa@example.com', '06117738805');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Larissa Pereira Lima', 'F', 'larissa.pereira.lima@email.com', '21801466200');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Gomes Souza', 'F', 'carla.gomes.souza@email.com', '49872193209');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Rocha Souza', 'F', 'carla.rocha.souza@email.com', '23476377317');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Carla Lima Martins', 'F', 'carla.lima.martins@email.com', '01595526983');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Costa Gomes', 'F', 'paula.costa.gomes@myemail.com', '09718602520');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Rocha Souza', 'F', 'paula.rocha.souza@webmail.com', '25649356221');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Lima Lima', 'M', 'mateus.lima.lima@mail.com', '41763567287');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Oliveira', 'M', 'mateus.pereira.oliveira@webmail.com', '05670286285');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Souza Silva', 'M', 'leonardo.souza.silva@example.com', '54992617468');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Pedro Pereira Pereira', 'M', 'pedro.pereira.pereira@email.com', '86676465517');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Oliveira Souza', 'F', 'luiza.oliveira.souza@myemail.com', '14256797102');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Lima Gomes', 'F', 'fernanda.lima.gomes@example.com', '09041183262');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Martins Silva', 'M', 'marcelo.martins.silva@example.com', '69886352557');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Almeida Rocha', 'M', 'gabriel.almeida.rocha@mail.com', '20813118668');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Lima Costa', 'M', 'bruno.lima.costa@example.com', '66740969405');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Oliveira Gomes', 'F', 'ana.oliveira.gomes@myemail.com', '25967916062');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Oliveira Pereira', 'M', 'rafael.oliveira.pereira@mail.com', '15277047114');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Rocha Almeida', 'M', 'marcelo.rocha.almeida@email.com', '55248715380');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Martins', 'M', 'bruno.almeida.martins@example.com', '12008931617');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Gabriel Gomes Souza', 'M', 'gabriel.gomes.souza@email.com', '35824120461');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Souza Gomes', 'F', 'marcela.souza.gomes@email.com', '71559907564');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Silva Pereira', 'M', 'marcelo.silva.pereira@email.com', '60092056189');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Pereira Rocha', 'F', 'marcela.pereira.rocha@webmail.com', '13165842906');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Gomes Pereira', 'F', 'luiza.gomes.pereira@webmail.com', '43985656101');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Rocha Costa', 'F', 'marcela.rocha.costa@example.com', '57118493793');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Ana Lima Lima', 'F', 'ana.lima.lima@webmail.com', '19865132633');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcela Martins Almeida', 'F', 'marcela.martins.almeida@webmail.com', '15946532014');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Lucas Rocha Lima', 'M', 'lucas.rocha.lima@myemail.com', '40989889401');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Souza Oliveira', 'M', 'felipe.souza.oliveira@webmail.com', '23319262310');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Almeida Souza', 'M', 'bruno.almeida.souza@webmail.com', '04484668449');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Lima', 'F', 'luiza.pereira.lima@mail.com', '32811294141');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Leonardo Almeida Costa', 'M', 'leonardo.almeida.costa@example.com', '78766997176');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Souza Oliveira', 'F', 'paula.souza.oliveira@email.com', '64762782164');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Almeida', 'M', 'mateus.pereira.almeida@email.com', '67080391456');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Costa Almeida', 'F', 'luiza.costa.almeida@mail.com', '54836752950');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Paula Almeida Martins', 'F', 'paula.almeida.martins@email.com', '31748051469');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Mateus Pereira Pereira', 'M', 'mateus.pereira.pereira@example.com', '35219667055');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Fernanda Souza Gomes', 'F', 'fernanda.souza.gomes@email.com', '82182892020');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Rafael Rocha Oliveira', 'M', 'rafael.rocha.oliveira@example.com', '51396394466');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Marcelo Silva Costa', 'M', 'marcelo.silva.costa@webmail.com', '99766137774');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Bruno Pereira Silva', 'M', 'bruno.pereira.silva@webmail.com', '51527969420');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Luiza Pereira Martins', 'F', 'luiza.pereira.martins@example.com', '22970422555');
INSERT INTO usuario (nome, sexo, email, cpf) VALUES ('Felipe Souza Souza', 'M', 'felipe.souza.souza@webmail.com', '96562414097');

INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (771, 'Av. Brigadeiro Faria Lima, 6234', 'Vila Madalena', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1045, 'Av. Brigadeiro Faria Lima, 6715', 'Vila Madalena', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1095, 'Rua da Consola��o, 8985', 'Lapa', 'Curitiba', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1054, 'Rua Augusta, 217', 'Centro', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1290, 'Rua Oscar Freire, 4847', 'Centro', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (978, 'Av. 9 de Julho, 2243', 'Bela Vista', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1324, 'Av. Ipiranga, 3177', 'Centro', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (744, 'Av. Brigadeiro Faria Lima, 9351', 'Vila Madalena', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (981, 'Rua da Consola��o, 451', 'Santana', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1004, 'Rua 25 de Mar�o, 3781', 'Lapa', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (807, 'Av. Brigadeiro Faria Lima, 7326', 'Lapa', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1260, 'Rua Augusta, 4969', 'Itaim Bibi', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1313, 'Rua Oscar Freire, 8150', 'Moema', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1216, 'Av. Ipiranga, 1001', 'Santana', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1398, 'Av. 9 de Julho, 5638', 'Santana', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1030, 'Av. Ipiranga, 8022', 'Tatuap�', 'Curitiba', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1304, 'Av. Brasil, 3663', 'Pinheiros', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (931, 'Av. Brasil, 5397', 'Jardins', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1198, 'Av. Brasil, 4971', 'Bela Vista', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1350, 'Rua 25 de Mar�o, 6637', 'Bela Vista', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1652, 'Av. 9 de Julho, 1783', 'Jardins', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1273, 'Rua 25 de Mar�o, 4762', 'Vila Madalena', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (824, 'Av. 9 de Julho, 65', 'Centro', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1469, 'Rua Oscar Freire, 7913', 'Santana', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1047, 'Rua 25 de Mar�o, 7737', 'Vila Madalena', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1609, 'Rua Oscar Freire, 8144', 'Lapa', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (889, 'Av. 9 de Julho, 1884', 'Tatuap�', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (759, 'Rua Haddock Lobo, 5191', 'Moema', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1474, 'Rua Oscar Freire, 8380', 'Jardins', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (740, 'Av. Brigadeiro Faria Lima, 6117', 'Centro', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1005, 'Rua Haddock Lobo, 1172', 'Lapa', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1662, 'Rua 25 de Mar�o, 9572', 'Itaim Bibi', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (757, 'Rua Augusta, 5401', 'Santana', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1430, 'Av. Ipiranga, 4387', 'Santana', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1659, 'Av. Brasil, 8296', 'Pinheiros', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1055, 'Rua da Consola��o, 7682', 'Itaim Bibi', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (809, 'Rua Oscar Freire, 6714', 'Santana', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1402, 'Av. Ipiranga, 7670', 'Centro', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1566, 'Rua Augusta, 8896', 'Tatuap�', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1305, 'Rua da Consola��o, 9445', 'Jardins', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1243, 'Av. Brigadeiro Faria Lima, 3303', 'Santana', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1592, 'Rua da Consola��o, 2103', 'Centro', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (899, 'Av. Brigadeiro Faria Lima, 8327', 'Lapa', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (882, 'Av. Brigadeiro Faria Lima, 4537', 'Tatuap�', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1308, 'Rua 25 de Mar�o, 8085', 'Pinheiros', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (866, 'Rua 25 de Mar�o, 3364', 'Tatuap�', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1420, 'Av. 9 de Julho, 3227', 'Lapa', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1588, 'Rua da Consola��o, 6152', 'Tatuap�', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (929, 'Rua 25 de Mar�o, 4584', 'Moema', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1264, 'Av. Paulista, 3107', 'Pinheiros', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1522, 'Av. Brigadeiro Faria Lima, 2920', 'Itaim Bibi', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1323, 'Av. Brasil, 9682', 'Lapa', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (845, 'Rua Haddock Lobo, 7286', 'Vila Madalena', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1255, 'Rua Augusta, 2906', 'Vila Madalena', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1460, 'Av. Brigadeiro Faria Lima, 524', 'Pinheiros', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (846, 'Av. Ipiranga, 5889', 'Lapa', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1679, 'Av. Paulista, 9393', 'Bela Vista', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (790, 'Rua da Consola��o, 9708', 'Jardins', 'Fortaleza', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1521, 'Av. Paulista, 5862', 'Moema', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1002, 'Av. Paulista, 434', 'Lapa', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (920, 'Rua Oscar Freire, 6899', 'Moema', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1439, 'Av. Ipiranga, 4222', 'Santana', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1168, 'Av. Brasil, 4681', 'Tatuap�', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (883, 'Av. Brasil, 4931', 'Centro', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (735, 'Av. Paulista, 9669', 'Santana', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1563, 'Av. Ipiranga, 7818', 'Vila Madalena', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1348, 'Av. Brasil, 3172', 'Pinheiros', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1062, 'Av. Brasil, 4378', 'Centro', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (901, 'Av. 9 de Julho, 4266', 'Jardins', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (749, 'Av. Brasil, 974', 'Bela Vista', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1380, 'Rua 25 de Mar�o, 2624', 'Bela Vista', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1525, 'Av. Brasil, 8302', 'Pinheiros', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1197, 'Rua da Consola��o, 5371', 'Lapa', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1497, 'Av. Ipiranga, 4338', 'Jardins', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (892, 'Av. Brasil, 3210', 'Jardins', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1484, 'Av. 9 de Julho, 6320', 'Itaim Bibi', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (847, 'Av. Brigadeiro Faria Lima, 9965', 'Itaim Bibi', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1485, 'Rua 25 de Mar�o, 5088', 'Itaim Bibi', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1089, 'Av. 9 de Julho, 8384', 'Vila Madalena', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1532, 'Av. Brasil, 8832', 'Tatuap�', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1053, 'Av. 9 de Julho, 4764', 'Moema', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1337, 'Rua Oscar Freire, 4174', 'Vila Madalena', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1069, 'Rua da Consola��o, 2943', 'Pinheiros', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (958, 'Rua Haddock Lobo, 9853', 'Jardins', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (731, 'Rua Oscar Freire, 5708', 'Lapa', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1555, 'Rua 25 de Mar�o, 2390', 'Jardins', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (922, 'Av. Brasil, 7877', 'Vila Madalena', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1546, 'Av. Paulista, 946', 'Santana', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1628, 'Av. Brigadeiro Faria Lima, 9653', 'Lapa', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1272, 'Rua Haddock Lobo, 3234', 'Vila Madalena', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1520, 'Rua Augusta, 4068', 'Lapa', 'Salvador', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (767, 'Av. Paulista, 3740', 'Vila Madalena', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1031, 'Rua 25 de Mar�o, 6845', 'Jardins', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1226, 'Av. Brasil, 1024', 'Moema', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1374, 'Rua Haddock Lobo, 462', 'Vila Madalena', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (844, 'Rua Augusta, 3550', 'Vila Madalena', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1358, 'Av. Ipiranga, 9997', 'Pinheiros', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1289, 'Av. 9 de Julho, 9387', 'Bela Vista', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1636, 'Av. Brasil, 4348', 'Tatuap�', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1526, 'Rua da Consola��o, 8299', 'Tatuap�', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (741, 'Av. Brigadeiro Faria Lima, 5222', 'Moema', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1033, 'Av. Ipiranga, 5196', 'Lapa', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1574, 'Rua 25 de Mar�o, 3801', 'Santana', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1240, 'Rua Augusta, 846', 'Itaim Bibi', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1124, 'Rua Haddock Lobo, 5443', 'Itaim Bibi', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1351, 'Rua Haddock Lobo, 9347', 'Moema', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (906, 'Rua 25 de Mar�o, 2524', 'Santana', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1338, 'Rua Augusta, 3111', 'Vila Madalena', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1675, 'Rua Augusta, 2241', 'Itaim Bibi', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (976, 'Av. Paulista, 4830', 'Vila Madalena', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1714, 'Av. Brasil, 2818', 'Vila Madalena', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1012, 'Rua Augusta, 2201', 'Bela Vista', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1426, 'Av. Brigadeiro Faria Lima, 9437', 'Centro', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (933, 'Rua Augusta, 4312', 'Moema', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1349, 'Rua Augusta, 5079', 'Itaim Bibi', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1091, 'Av. Brasil, 3831', 'Lapa', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1196, 'Rua 25 de Mar�o, 1714', 'Pinheiros', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1194, 'Rua Haddock Lobo, 7980', 'Bela Vista', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1300, 'Rua Haddock Lobo, 9505', 'Pinheiros', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (925, 'Rua Oscar Freire, 2503', 'Lapa', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1558, 'Rua 25 de Mar�o, 3441', 'Pinheiros', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1246, 'Av. Brigadeiro Faria Lima, 8865', 'Jardins', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1001, 'Av. 9 de Julho, 6320', 'Lapa', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1247, 'Av. 9 de Julho, 4540', 'Bela Vista', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1712, 'Av. Paulista, 3686', 'Jardins', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (754, 'Rua da Consola��o, 5633', 'Moema', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1011, 'Rua Augusta, 9865', 'Pinheiros', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1413, 'Av. Brigadeiro Faria Lima, 3520', 'Lapa', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1412, 'Av. 9 de Julho, 4509', 'Itaim Bibi', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1043, 'Av. Brasil, 1646', 'Moema', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1333, 'Rua da Consola��o, 7610', 'Tatuap�', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1622, 'Av. 9 de Julho, 8965', 'Tatuap�', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (941, 'Rua Haddock Lobo, 4872', 'Jardins', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1498, 'Rua Augusta, 2013', 'Tatuap�', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1320, 'Av. Paulista, 674', 'Moema', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1537, 'Rua da Consola��o, 6694', 'Itaim Bibi', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (841, 'Rua Haddock Lobo, 1037', 'Vila Madalena', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1376, 'Rua da Consola��o, 4519', 'Tatuap�', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (776, 'Av. 9 de Julho, 378', 'Centro', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1481, 'Av. 9 de Julho, 8084', 'Moema', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1254, 'Rua da Consola��o, 6709', 'Pinheiros', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (902, 'Av. Brigadeiro Faria Lima, 2674', 'Centro', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1390, 'Rua Haddock Lobo, 7356', 'Tatuap�', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1396, 'Rua Haddock Lobo, 5070', 'Tatuap�', 'Salvador', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1709, 'Rua Haddock Lobo, 570', 'Itaim Bibi', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (808, 'Rua 25 de Mar�o, 6003', 'Jardins', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1590, 'Av. 9 de Julho, 47', 'Vila Madalena', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1421, 'Rua Haddock Lobo, 3137', 'Pinheiros', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1705, 'Rua 25 de Mar�o, 4000', 'Santana', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1539, 'Av. Ipiranga, 6805', 'Tatuap�', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1540, 'Av. 9 de Julho, 9337', 'Vila Madalena', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (955, 'Av. Ipiranga, 2265', 'Centro', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1575, 'Av. Brasil, 1479', 'Itaim Bibi', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1617, 'Rua Haddock Lobo, 4174', 'Tatuap�', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1710, 'Av. Brigadeiro Faria Lima, 8173', 'Pinheiros', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1249, 'Rua da Consola��o, 2081', 'Lapa', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1239, 'Rua 25 de Mar�o, 41', 'Pinheiros', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (825, 'Rua Augusta, 7118', 'Jardins', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (970, 'Rua Haddock Lobo, 6719', 'Bela Vista', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1202, 'Av. Paulista, 885', 'Moema', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1137, 'Av. Brasil, 9385', 'Centro', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1680, 'Av. Brasil, 7905', 'Jardins', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1175, 'Av. Brigadeiro Faria Lima, 9606', 'Centro', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1516, 'Rua Augusta, 3664', 'Bela Vista', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1642, 'Av. Brigadeiro Faria Lima, 2364', 'Santana', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1080, 'Av. Ipiranga, 9643', 'Itaim Bibi', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (753, 'Av. 9 de Julho, 5453', 'Bela Vista', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1068, 'Rua Oscar Freire, 5899', 'Centro', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (991, 'Av. Brigadeiro Faria Lima, 2418', 'Jardins', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1115, 'Rua 25 de Mar�o, 186', 'Vila Madalena', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1492, 'Av. Paulista, 3257', 'Jardins', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (742, 'Av. Brigadeiro Faria Lima, 6779', 'Lapa', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (782, 'Rua Augusta, 1539', 'Pinheiros', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1665, 'Av. 9 de Julho, 5596', 'Bela Vista', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (939, 'Rua Oscar Freire, 8819', 'Moema', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1721, 'Av. Paulista, 7863', 'Jardins', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1633, 'Rua da Consola��o, 3429', 'Vila Madalena', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1452, 'Rua Augusta, 4474', 'Jardins', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (896, 'Rua Haddock Lobo, 2209', 'Vila Madalena', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1637, 'Av. Ipiranga, 9089', 'Centro', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1125, 'Av. Brigadeiro Faria Lima, 9571', 'Moema', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1506, 'Rua 25 de Mar�o, 4125', 'Lapa', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1250, 'Rua Haddock Lobo, 292', 'Moema', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (935, 'Rua Haddock Lobo, 5626', 'Itaim Bibi', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1096, 'Av. Paulista, 796', 'Lapa', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (804, 'Rua Oscar Freire, 8806', 'Jardins', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (732, 'Rua 25 de Mar�o, 6453', 'Itaim Bibi', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1035, 'Rua da Consola��o, 9067', 'Centro', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1535, 'Av. Paulista, 3016', 'Moema', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1650, 'Rua Augusta, 3069', 'Pinheiros', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1056, 'Rua Augusta, 9374', 'Vila Madalena', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (885, 'Av. Ipiranga, 635', 'Tatuap�', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1301, 'Av. Brigadeiro Faria Lima, 8103', 'Santana', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1700, 'Rua Augusta, 6953', 'Pinheiros', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (861, 'Av. Brasil, 860', 'Pinheiros', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1619, 'Rua Haddock Lobo, 3341', 'Santana', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1625, 'Av. Ipiranga, 8835', 'Centro', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1403, 'Av. Paulista, 5975', 'Tatuap�', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1330, 'Av. 9 de Julho, 6630', 'Itaim Bibi', 'Bras�lia', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1549, 'Rua Haddock Lobo, 6908', 'Tatuap�', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1463, 'Rua 25 de Mar�o, 6203', 'Itaim Bibi', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1564, 'Av. Paulista, 4768', 'Bela Vista', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1037, 'Rua da Consola��o, 8735', 'Moema', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (982, 'Rua Oscar Freire, 6137', 'Itaim Bibi', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1212, 'Av. Brigadeiro Faria Lima, 6516', 'Vila Madalena', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1605, 'Av. Brigadeiro Faria Lima, 6107', 'Bela Vista', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1149, 'Rua da Consola��o, 7032', 'Bela Vista', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1616, 'Av. Paulista, 6538', 'Itaim Bibi', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1634, 'Av. Paulista, 2370', 'Centro', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1543, 'Rua Haddock Lobo, 8600', 'Santana', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1490, 'Av. Ipiranga, 7928', 'Itaim Bibi', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1123, 'Rua Oscar Freire, 1586', 'Itaim Bibi', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (878, 'Av. 9 de Julho, 1358', 'Tatuap�', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1550, 'Av. 9 de Julho, 5491', 'Bela Vista', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (853, 'Rua Augusta, 8713', 'Lapa', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1210, 'Rua da Consola��o, 7914', 'Lapa', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1049, 'Rua Oscar Freire, 2089', 'Tatuap�', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1119, 'Rua 25 de Mar�o, 2332', 'Tatuap�', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1292, 'Av. 9 de Julho, 5592', 'Pinheiros', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1359, 'Rua da Consola��o, 2407', 'Bela Vista', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (746, 'Rua da Consola��o, 4503', 'Pinheiros', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1468, 'Av. Paulista, 7846', 'Vila Madalena', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1159, 'Av. Paulista, 9018', 'Jardins', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1027, 'Rua da Consola��o, 2833', 'Bela Vista', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (909, 'Av. Ipiranga, 6594', 'Pinheiros', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1007, 'Rua Haddock Lobo, 7260', 'Pinheiros', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (891, 'Rua 25 de Mar�o, 1102', 'Pinheiros', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1209, 'Rua Haddock Lobo, 9960', 'Vila Madalena', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1548, 'Rua Haddock Lobo, 787', 'Tatuap�', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1621, 'Rua Haddock Lobo, 2712', 'Pinheiros', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (964, 'Rua da Consola��o, 3622', 'Vila Madalena', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1077, 'Rua da Consola��o, 4731', 'Moema', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1018, 'Rua Augusta, 7351', 'Jardins', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1596, 'Rua Haddock Lobo, 753', 'Jardins', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (801, 'Av. Brasil, 8483', 'Pinheiros', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (796, 'Rua 25 de Mar�o, 1576', 'Tatuap�', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1227, 'Av. Brasil, 3003', 'Vila Madalena', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (910, 'Rua Augusta, 7299', 'Jardins', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1716, 'Rua Haddock Lobo, 5365', 'Jardins', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1269, 'Av. Ipiranga, 7098', 'Itaim Bibi', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (875, 'Rua Oscar Freire, 4534', 'Moema', 'Salvador', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1583, 'Rua Augusta, 2278', 'Itaim Bibi', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (736, 'Rua Oscar Freire, 8464', 'Vila Madalena', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1146, 'Rua Oscar Freire, 8092', 'Santana', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1440, 'Rua Oscar Freire, 1910', 'Centro', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1248, 'Rua Haddock Lobo, 3203', 'Lapa', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1601, 'Rua Augusta, 1305', 'Vila Madalena', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (738, 'Av. 9 de Julho, 2827', 'Lapa', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1126, 'Rua Augusta, 8343', 'Bela Vista', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1174, 'Rua Augusta, 5438', 'Pinheiros', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1363, 'Av. 9 de Julho, 9255', 'Lapa', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1419, 'Av. Brasil, 4300', 'Jardins', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1384, 'Av. Ipiranga, 1230', 'Moema', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1366, 'Av. Brasil, 1581', 'Itaim Bibi', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1626, 'Av. 9 de Julho, 8956', 'Jardins', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1688, 'Rua 25 de Mar�o, 653', 'Santana', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1166, 'Av. Brigadeiro Faria Lima, 8245', 'Bela Vista', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (930, 'Av. Brigadeiro Faria Lima, 2233', 'Itaim Bibi', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (830, 'Av. Brigadeiro Faria Lima, 4426', 'Vila Madalena', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1425, 'Rua Oscar Freire, 8758', 'Bela Vista', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (793, 'Av. Brigadeiro Faria Lima, 964', 'Bela Vista', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (756, 'Rua Haddock Lobo, 9640', 'Pinheiros', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1211, 'Av. Brigadeiro Faria Lima, 6344', 'Vila Madalena', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1177, 'Av. 9 de Julho, 8095', 'Tatuap�', 'Bras�lia', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1698, 'Rua da Consola��o, 7569', 'Itaim Bibi', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1336, 'Rua Oscar Freire, 2959', 'Tatuap�', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (777, 'Av. Brasil, 5543', 'Bela Vista', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (877, 'Av. Brasil, 45', 'Tatuap�', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1090, 'Av. Ipiranga, 5983', 'Lapa', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (842, 'Av. Brasil, 7781', 'Tatuap�', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (959, 'Av. 9 de Julho, 9882', 'Tatuap�', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (837, 'Av. Paulista, 819', 'Tatuap�', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1310, 'Av. Brigadeiro Faria Lima, 782', 'Centro', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1016, 'Av. Ipiranga, 3623', 'Lapa', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1395, 'Rua 25 de Mar�o, 5367', 'Centro', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (814, 'Rua Oscar Freire, 5876', 'Pinheiros', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1355, 'Av. Paulista, 9983', 'Tatuap�', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1142, 'Rua Haddock Lobo, 4991', 'Pinheiros', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1294, 'Rua Oscar Freire, 6295', 'Jardins', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1611, 'Av. Brigadeiro Faria Lima, 1628', 'Moema', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1058, 'Av. Brasil, 2324', 'Pinheiros', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (750, 'Av. Brigadeiro Faria Lima, 3235', 'Jardins', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1404, 'Av. Brasil, 9167', 'Tatuap�', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1394, 'Rua 25 de Mar�o, 3463', 'Jardins', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1133, 'Av. 9 de Julho, 8939', 'Itaim Bibi', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1677, 'Av. Brigadeiro Faria Lima, 8265', 'Pinheiros', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1589, 'Rua Haddock Lobo, 1634', 'Santana', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1696, 'Rua Haddock Lobo, 7543', 'Itaim Bibi', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1325, 'Rua 25 de Mar�o, 6369', 'Vila Madalena', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1111, 'Rua da Consola��o, 5988', 'Pinheiros', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1341, 'Rua Haddock Lobo, 2729', 'Itaim Bibi', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1585, 'Rua Haddock Lobo, 3667', 'Bela Vista', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1422, 'Rua Oscar Freire, 3884', 'Jardins', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (758, 'Rua Augusta, 9606', 'Pinheiros', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (950, 'Av. Ipiranga, 1706', 'Itaim Bibi', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1488, 'Rua da Consola��o, 9030', 'Pinheiros', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1340, 'Av. Ipiranga, 3134', 'Centro', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1446, 'Av. Ipiranga, 8302', 'Bela Vista', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1728, 'Av. Brigadeiro Faria Lima, 5399', 'Bela Vista', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1297, 'Rua 25 de Mar�o, 9891', 'Lapa', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1279, 'Rua da Consola��o, 6992', 'Itaim Bibi', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1311, 'Rua Haddock Lobo, 5349', 'Moema', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1179, 'Rua 25 de Mar�o, 1774', 'Vila Madalena', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1517, 'Rua da Consola��o, 9690', 'Jardins', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1199, 'Rua 25 de Mar�o, 6211', 'Centro', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (871, 'Av. Brasil, 5731', 'Vila Madalena', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (894, 'Av. Paulista, 3476', 'Jardins', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (786, 'Rua da Consola��o, 5937', 'Moema', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (774, 'Av. Paulista, 4510', 'Itaim Bibi', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1534, 'Av. Paulista, 8651', 'Jardins', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (990, 'Rua Oscar Freire, 1835', 'Pinheiros', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1448, 'Rua da Consola��o, 5439', 'Itaim Bibi', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (855, 'Av. Ipiranga, 4530', 'Tatuap�', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1378, 'Rua da Consola��o, 2680', 'Itaim Bibi', 'Fortaleza', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1285, 'Rua da Consola��o, 1186', 'Vila Madalena', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1170, 'Rua Haddock Lobo, 8639', 'Centro', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1602, 'Av. Ipiranga, 8824', 'Pinheiros', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1321, 'Rua 25 de Mar�o, 2434', 'Santana', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1122, 'Rua Augusta, 7964', 'Moema', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1715, 'Av. Brasil, 6673', 'Centro', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (799, 'Rua Oscar Freire, 5020', 'Santana', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (816, 'Rua da Consola��o, 8227', 'Tatuap�', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1382, 'Rua Oscar Freire, 4155', 'Pinheiros', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1052, 'Av. Brasil, 1754', 'Lapa', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1038, 'Rua 25 de Mar�o, 8508', 'Tatuap�', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1641, 'Rua Augusta, 894', 'Pinheiros', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1262, 'Av. Brasil, 8260', 'Vila Madalena', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1162, 'Rua Haddock Lobo, 1084', 'Jardins', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1259, 'Av. Paulista, 3154', 'Pinheiros', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1042, 'Av. Brigadeiro Faria Lima, 8130', 'Santana', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (821, 'Av. Brigadeiro Faria Lima, 1262', 'Jardins', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (755, 'Av. Ipiranga, 2771', 'Moema', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1303, 'Rua 25 de Mar�o, 3008', 'Centro', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1631, 'Rua Haddock Lobo, 1965', 'Lapa', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1281, 'Av. Ipiranga, 7471', 'Moema', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (903, 'Av. Brasil, 1735', 'Itaim Bibi', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (969, 'Rua da Consola��o, 7160', 'Centro', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1544, 'Av. Ipiranga, 4056', 'Centro', 'Curitiba', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1669, 'Rua da Consola��o, 9785', 'Jardins', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1161, 'Av. Brigadeiro Faria Lima, 5954', 'Moema', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1075, 'Av. 9 de Julho, 5639', 'Itaim Bibi', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1253, 'Av. Brasil, 7182', 'Lapa', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1134, 'Av. Paulista, 2280', 'Itaim Bibi', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1432, 'Av. Brigadeiro Faria Lima, 5738', 'Bela Vista', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (795, 'Av. Brigadeiro Faria Lima, 110', 'Moema', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1606, 'Rua Oscar Freire, 8075', 'Vila Madalena', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1277, 'Av. Brigadeiro Faria Lima, 2309', 'Tatuap�', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1156, 'Av. 9 de Julho, 458', 'Itaim Bibi', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1453, 'Av. Brigadeiro Faria Lima, 8660', 'Lapa', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1580, 'Av. Ipiranga, 9094', 'Tatuap�', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1231, 'Av. Paulista, 5100', 'Lapa', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (794, 'Rua da Consola��o, 311', 'Santana', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (905, 'Rua Haddock Lobo, 5715', 'Bela Vista', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1501, 'Av. 9 de Julho, 4469', 'Vila Madalena', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1639, 'Av. Brigadeiro Faria Lima, 4522', 'Vila Madalena', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (839, 'Av. 9 de Julho, 9543', 'Jardins', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1416, 'Av. Ipiranga, 8665', 'Lapa', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1693, 'Rua Haddock Lobo, 5305', 'Lapa', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1593, 'Av. Paulista, 2897', 'Jardins', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1085, 'Av. Brasil, 8798', 'Itaim Bibi', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1530, 'Av. Brigadeiro Faria Lima, 8066', 'Pinheiros', 'Salvador', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (998, 'Av. Ipiranga, 5244', 'Centro', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1613, 'Av. Ipiranga, 8133', 'Lapa', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1595, 'Rua Oscar Freire, 932', 'Bela Vista', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1233, 'Rua da Consola��o, 4411', 'Tatuap�', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1570, 'Rua Haddock Lobo, 1237', 'Moema', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1653, 'Av. Paulista, 1123', 'Pinheiros', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (963, 'Av. Brigadeiro Faria Lima, 3598', 'Vila Madalena', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1573, 'Rua 25 de Mar�o, 7849', 'Bela Vista', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1275, 'Rua da Consola��o, 4240', 'Centro', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1346, 'Av. Ipiranga, 6476', 'Moema', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (769, 'Rua Augusta, 9044', 'Moema', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1599, 'Rua da Consola��o, 7343', 'Jardins', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1547, 'Av. 9 de Julho, 162', 'Tatuap�', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (876, 'Av. 9 de Julho, 756', 'Tatuap�', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1410, 'Rua Haddock Lobo, 1778', 'Tatuap�', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1496, 'Av. Ipiranga, 6717', 'Tatuap�', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1008, 'Av. Paulista, 2969', 'Pinheiros', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1464, 'Av. Brasil, 5069', 'Lapa', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1345, 'Av. Brasil, 5621', 'Itaim Bibi', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1258, 'Av. Brasil, 944', 'Bela Vista', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1173, 'Av. Ipiranga, 646', 'Pinheiros', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1603, 'Av. 9 de Julho, 2011', 'Lapa', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1048, 'Rua 25 de Mar�o, 6512', 'Tatuap�', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1512, 'Av. Brigadeiro Faria Lima, 6354', 'Santana', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1689, 'Rua da Consola��o, 6852', 'Moema', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (874, 'Rua Augusta, 5930', 'Jardins', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1725, 'Av. 9 de Julho, 2872', 'Centro', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1065, 'Rua da Consola��o, 2182', 'Santana', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (996, 'Av. Brasil, 5511', 'Bela Vista', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1671, 'Rua Oscar Freire, 1342', 'Centro', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1144, 'Rua Oscar Freire, 8706', 'Santana', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (912, 'Av. Ipiranga, 6043', 'Pinheiros', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1365, 'Av. 9 de Julho, 8982', 'Vila Madalena', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1061, 'Av. Paulista, 9683', 'Moema', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1562, 'Rua Augusta, 4277', 'Tatuap�', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1706, 'Av. Ipiranga, 6935', 'Centro', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (927, 'Rua Oscar Freire, 1627', 'Santana', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1034, 'Av. 9 de Julho, 5041', 'Lapa', 'S�o Paulo', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1479, 'Av. Brasil, 7794', 'Itaim Bibi', 'Bras�lia', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1101, 'Av. Paulista, 95', 'Santana', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1515, 'Rua Oscar Freire, 8633', 'Pinheiros', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1020, 'Rua 25 de Mar�o, 6807', 'Centro', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1169, 'Av. 9 de Julho, 9393', 'Santana', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1529, 'Rua Haddock Lobo, 3147', 'Jardins', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1319, 'Rua 25 de Mar�o, 9879', 'Lapa', 'Recife', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (890, 'Rua 25 de Mar�o, 6167', 'Santana', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (819, 'Av. Brigadeiro Faria Lima, 982', 'Bela Vista', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1620, 'Rua Oscar Freire, 4083', 'Centro', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1044, 'Rua Augusta, 4581', 'Bela Vista', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1632, 'Rua da Consola��o, 8603', 'Santana', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1692, 'Av. Brigadeiro Faria Lima, 9432', 'Jardins', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1699, 'Av. Brigadeiro Faria Lima, 377', 'Bela Vista', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (960, 'Av. Brigadeiro Faria Lima, 600', 'Jardins', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (737, 'Av. Ipiranga, 5666', 'Santana', 'Salvador', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1342, 'Av. Brasil, 4044', 'Vila Madalena', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1541, 'Av. Brigadeiro Faria Lima, 8064', 'Vila Madalena', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1367, 'Rua Augusta, 9595', 'Jardins', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1465, 'Rua da Consola��o, 4448', 'Itaim Bibi', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1687, 'Av. Brigadeiro Faria Lima, 58', 'Moema', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (766, 'Rua Haddock Lobo, 7320', 'Santana', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1117, 'Av. Paulista, 7413', 'Tatuap�', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (798, 'Rua da Consola��o, 681', 'Pinheiros', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1207, 'Av. Brasil, 3883', 'Lapa', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1263, 'Rua 25 de Mar�o, 5393', 'Moema', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1691, 'Rua 25 de Mar�o, 8217', 'Vila Madalena', 'Fortaleza', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1478, 'Rua 25 de Mar�o, 610', 'Jardins', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (953, 'Rua Haddock Lobo, 516', 'Centro', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1219, 'Rua Haddock Lobo, 2400', 'Tatuap�', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1458, 'Rua 25 de Mar�o, 5735', 'Centro', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1381, 'Rua Augusta, 4195', 'Pinheiros', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1010, 'Rua 25 de Mar�o, 1402', 'Tatuap�', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (954, 'Rua Oscar Freire, 5161', 'Jardins', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1518, 'Rua da Consola��o, 8819', 'Santana', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (918, 'Rua Haddock Lobo, 1565', 'Tatuap�', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1401, 'Rua Oscar Freire, 6669', 'Itaim Bibi', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1268, 'Rua 25 de Mar�o, 6862', 'Itaim Bibi', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1444, 'Av. Ipiranga, 4071', 'Centro', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1635, 'Rua Haddock Lobo, 6832', 'Itaim Bibi', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1242, 'Av. 9 de Julho, 2054', 'Centro', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (911, 'Rua Augusta, 4654', 'Itaim Bibi', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (895, 'Rua 25 de Mar�o, 8659', 'Santana', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1371, 'Av. Brigadeiro Faria Lima, 2639', 'Lapa', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1514, 'Rua Oscar Freire, 5171', 'Centro', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1295, 'Rua da Consola��o, 4880', 'Itaim Bibi', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1032, 'Av. 9 de Julho, 218', 'Pinheiros', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1658, 'Rua Haddock Lobo, 3077', 'Vila Madalena', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (764, 'Rua Augusta, 9886', 'Itaim Bibi', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1193, 'Rua Haddock Lobo, 3072', 'Moema', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1571, 'Av. Brigadeiro Faria Lima, 887', 'Itaim Bibi', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1717, 'Rua 25 de Mar�o, 5755', 'Centro', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1718, 'Av. Brigadeiro Faria Lima, 2628', 'Jardins', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (817, 'Rua Haddock Lobo, 9579', 'Itaim Bibi', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1107, 'Av. Ipiranga, 8991', 'Tatuap�', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1241, 'Av. Brigadeiro Faria Lima, 9200', 'Tatuap�', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1454, 'Rua Haddock Lobo, 5406', 'Jardins', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (838, 'Av. Brigadeiro Faria Lima, 6365', 'Moema', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1369, 'Av. Brasil, 2011', 'Tatuap�', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (914, 'Av. Brigadeiro Faria Lima, 3162', 'Moema', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (924, 'Rua 25 de Mar�o, 9201', 'Centro', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1379, 'Av. Brigadeiro Faria Lima, 8722', 'Tatuap�', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1192, 'Av. Brasil, 89', 'Bela Vista', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (993, 'Av. Brasil, 5758', 'Itaim Bibi', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1391, 'Av. Paulista, 3948', 'Moema', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (999, 'Av. Brigadeiro Faria Lima, 643', 'Lapa', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (762, 'Av. Ipiranga, 5590', 'Tatuap�', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1586, 'Rua da Consola��o, 1', 'Centro', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1495, 'Rua Augusta, 8284', 'Pinheiros', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1678, 'Av. Paulista, 5348', 'Tatuap�', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1025, 'Av. Ipiranga, 3581', 'Pinheiros', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1618, 'Av. 9 de Julho, 61', 'Lapa', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1352, 'Av. Ipiranga, 4943', 'Jardins', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (886, 'Rua Augusta, 4288', 'Itaim Bibi', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1041, 'Rua Haddock Lobo, 6604', 'Pinheiros', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1147, 'Av. Brigadeiro Faria Lima, 9211', 'Vila Madalena', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1473, 'Rua 25 de Mar�o, 8298', 'Tatuap�', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1648, 'Rua da Consola��o, 2900', 'Pinheiros', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1066, 'Av. Paulista, 2423', 'Itaim Bibi', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (957, 'Rua Oscar Freire, 4353', 'Santana', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1545, 'Av. 9 de Julho, 254', 'Vila Madalena', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1105, 'Rua 25 de Mar�o, 5044', 'Moema', 'Curitiba', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1415, 'Rua Augusta, 1565', 'Vila Madalena', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (936, 'Av. Ipiranga, 1540', 'Vila Madalena', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (988, 'Av. Brasil, 7885', 'Pinheiros', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1278, 'Av. Ipiranga, 6310', 'Tatuap�', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1487, 'Av. 9 de Julho, 6433', 'Santana', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1067, 'Av. Brigadeiro Faria Lima, 2383', 'Jardins', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1185, 'Rua Augusta, 5422', 'Santana', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1557, 'Av. Brasil, 7710', 'Moema', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1567, 'Av. Brigadeiro Faria Lima, 4783', 'Centro', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (907, 'Rua da Consola��o, 9651', 'Pinheiros', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (802, 'Rua Oscar Freire, 6268', 'Pinheiros', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (884, 'Rua Haddock Lobo, 9575', 'Itaim Bibi', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (967, 'Rua Haddock Lobo, 2126', 'Moema', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1660, 'Av. Ipiranga, 9046', 'Tatuap�', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (859, 'Av. Brigadeiro Faria Lima, 8501', 'Bela Vista', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1649, 'Av. 9 de Julho, 9328', 'Jardins', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1493, 'Av. Paulista, 4773', 'Pinheiros', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (897, 'Av. 9 de Julho, 693', 'Lapa', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (949, 'Rua Augusta, 1010', 'Bela Vista', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (966, 'Rua Oscar Freire, 5875', 'Tatuap�', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1181, 'Rua Haddock Lobo, 8112', 'Moema', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1645, 'Av. Brasil, 1939', 'Bela Vista', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (827, 'Av. Ipiranga, 8906', 'Bela Vista', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (904, 'Av. Brigadeiro Faria Lima, 8952', 'Moema', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1427, 'Av. Brasil, 8765', 'Santana', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1097, 'Av. Paulista, 1866', 'Centro', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1083, 'Rua Haddock Lobo, 3851', 'Tatuap�', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1392, 'Rua Haddock Lobo, 4558', 'Bela Vista', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1017, 'Av. 9 de Julho, 5038', 'Lapa', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1121, 'Rua da Consola��o, 7479', 'Santana', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1163, 'Av. Brigadeiro Faria Lima, 226', 'Pinheiros', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (826, 'Av. Ipiranga, 2123', 'Jardins', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (947, 'Av. Brigadeiro Faria Lima, 6901', 'Centro', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1360, 'Av. Paulista, 5560', 'Vila Madalena', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1387, 'Av. Brigadeiro Faria Lima, 4515', 'Moema', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1647, 'Rua Oscar Freire, 1192', 'Centro', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1624, 'Rua Augusta, 5195', 'Lapa', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1113, 'Av. Paulista, 2537', 'Bela Vista', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1094, 'Av. Ipiranga, 5144', 'Itaim Bibi', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (763, 'Av. Ipiranga, 2553', 'Bela Vista', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (860, 'Av. Paulista, 8673', 'Itaim Bibi', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1433, 'Av. 9 de Julho, 9495', 'Itaim Bibi', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1511, 'Av. Paulista, 8746', 'Lapa', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1466, 'Rua Oscar Freire, 7639', 'Tatuap�', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1612, 'Av. Paulista, 5335', 'Vila Madalena', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (932, 'Rua da Consola��o, 7992', 'Tatuap�', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1435, 'Av. Brasil, 755', 'Tatuap�', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1538, 'Av. Ipiranga, 5934', 'Santana', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1151, 'Rua da Consola��o, 6833', 'Vila Madalena', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (797, 'Rua Augusta, 9578', 'Santana', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1579, 'Rua Augusta, 481', 'Itaim Bibi', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1686, 'Av. Brigadeiro Faria Lima, 6417', 'Centro', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1683, 'Rua Haddock Lobo, 2882', 'Jardins', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1270, 'Av. Brigadeiro Faria Lima, 2541', 'Centro', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1480, 'Rua Augusta, 7800', 'Centro', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (835, 'Av. Brigadeiro Faria Lima, 8240', 'Pinheiros', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1317, 'Rua 25 de Mar�o, 3538', 'Tatuap�', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (872, 'Rua Augusta, 1112', 'Lapa', 'Salvador', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1347, 'Av. Brasil, 773', 'Jardins', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (822, 'Av. Brigadeiro Faria Lima, 5444', 'Vila Madalena', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1531, 'Av. Ipiranga, 3262', 'Tatuap�', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1598, 'Av. Brasil, 8406', 'Lapa', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (916, 'Av. Ipiranga, 6917', 'Tatuap�', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1074, 'Av. Ipiranga, 6086', 'Jardins', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1150, 'Av. 9 de Julho, 4016', 'Pinheiros', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1299, 'Av. Brasil, 6367', 'Tatuap�', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1443, 'Av. Ipiranga, 7539', 'Pinheiros', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1646, 'Rua da Consola��o, 2967', 'Santana', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1411, 'Rua Augusta, 1429', 'Moema', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1523, 'Av. 9 de Julho, 4982', 'Pinheiros', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1154, 'Rua da Consola��o, 6384', 'Centro', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1554, 'Av. Brasil, 1132', 'Pinheiros', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1388, 'Rua Oscar Freire, 3189', 'Itaim Bibi', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1087, 'Rua Haddock Lobo, 5729', 'Itaim Bibi', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (893, 'Av. Brasil, 562', 'Moema', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1597, 'Av. 9 de Julho, 7660', 'Santana', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1245, 'Rua Oscar Freire, 3039', 'Jardins', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (772, 'Rua Augusta, 5239', 'Pinheiros', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (870, 'Rua Haddock Lobo, 3158', 'Itaim Bibi', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1489, 'Rua Haddock Lobo, 6023', 'Santana', 'Curitiba', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1505, 'Rua Oscar Freire, 8841', 'Pinheiros', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (962, 'Rua da Consola��o, 9294', 'Itaim Bibi', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (840, 'Av. Paulista, 8913', 'Centro', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1594, 'Rua Haddock Lobo, 5255', 'Lapa', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1200, 'Av. Brigadeiro Faria Lima, 5431', 'Moema', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1228, 'Rua Oscar Freire, 2260', 'Bela Vista', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1190, 'Av. Ipiranga, 4268', 'Bela Vista', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1036, 'Rua Augusta, 7431', 'Tatuap�', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (951, 'Rua 25 de Mar�o, 9297', 'Bela Vista', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1112, 'Av. 9 de Julho, 3923', 'Lapa', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1607, 'Av. Brasil, 6311', 'Lapa', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1315, 'Rua da Consola��o, 8753', 'Moema', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1309, 'Rua 25 de Mar�o, 5412', 'Vila Madalena', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (974, 'Rua Augusta, 3637', 'Bela Vista', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1063, 'Av. Brasil, 6658', 'Jardins', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1668, 'Rua Haddock Lobo, 8315', 'Bela Vista', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1092, 'Av. Brasil, 7630', 'Bela Vista', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (985, 'Av. 9 de Julho, 9258', 'Pinheiros', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1524, 'Rua Haddock Lobo, 964', 'Bela Vista', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1568, 'Rua Oscar Freire, 1115', 'Itaim Bibi', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1127, 'Av. Ipiranga, 7795', 'Itaim Bibi', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1298, 'Rua da Consola��o, 7981', 'Vila Madalena', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1106, 'Av. Brasil, 4817', 'Centro', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (788, 'Rua Oscar Freire, 5803', 'Pinheiros', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1280, 'Av. Brigadeiro Faria Lima, 1014', 'Tatuap�', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (977, 'Av. Brasil, 1019', 'Pinheiros', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1704, 'Av. 9 de Julho, 9045', 'Lapa', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1252, 'Av. Brasil, 6723', 'Vila Madalena', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1494, 'Rua 25 de Mar�o, 1910', 'Jardins', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1623, 'Rua 25 de Mar�o, 2207', 'Centro', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (994, 'Rua Augusta, 6810', 'Bela Vista', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1657, 'Rua Oscar Freire, 1017', 'Pinheiros', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (898, 'Av. 9 de Julho, 913', 'Moema', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1009, 'Rua da Consola��o, 9741', 'Jardins', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (733, 'Av. Paulista, 4090', 'Lapa', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1021, 'Av. 9 de Julho, 3072', 'Bela Vista', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1504, 'Av. Brasil, 8843', 'Pinheiros', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1145, 'Rua da Consola��o, 8652', 'Itaim Bibi', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1682, 'Av. 9 de Julho, 3481', 'Bela Vista', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1707, 'Av. Ipiranga, 6082', 'Jardins', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1644, 'Av. Ipiranga, 4231', 'Centro', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (818, 'Av. Brasil, 3964', 'Vila Madalena', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (868, 'Av. Ipiranga, 7447', 'Itaim Bibi', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (934, 'Av. Brigadeiro Faria Lima, 1896', 'Centro', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1661, 'Rua 25 de Mar�o, 2571', 'Itaim Bibi', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1218, 'Rua 25 de Mar�o, 5692', 'Lapa', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1445, 'Av. Ipiranga, 2526', 'Vila Madalena', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1102, 'Rua 25 de Mar�o, 9875', 'Jardins', 'Salvador', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (867, 'Av. Paulista, 6614', 'Tatuap�', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1296, 'Rua Haddock Lobo, 606', 'Santana', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1099, 'Rua Augusta, 6307', 'Pinheiros', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1206, 'Av. Paulista, 8241', 'Jardins', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (836, 'Rua Augusta, 8915', 'Tatuap�', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1152, 'Rua Augusta, 9841', 'Moema', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (948, 'Rua 25 de Mar�o, 5636', 'Moema', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1354, 'Av. Paulista, 1721', 'Centro', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (900, 'Rua Augusta, 764', 'Jardins', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1276, 'Av. 9 de Julho, 9793', 'Santana', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1203, 'Rua Augusta, 4750', 'Vila Madalena', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1014, 'Rua da Consola��o, 8593', 'Santana', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (854, 'Rua Haddock Lobo, 7242', 'Santana', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (783, 'Av. Brasil, 6835', 'Lapa', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1364, 'Rua 25 de Mar�o, 8193', 'Moema', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (812, 'Av. 9 de Julho, 3404', 'Tatuap�', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1215, 'Av. Paulista, 9339', 'Moema', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (915, 'Av. Brasil, 3261', 'Jardins', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1655, 'Av. Brigadeiro Faria Lima, 3085', 'Santana', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1438, 'Rua Haddock Lobo, 3889', 'Jardins', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1414, 'Av. Paulista, 2220', 'Lapa', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1039, 'Rua Augusta, 8529', 'Itaim Bibi', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1553, 'Rua 25 de Mar�o, 6769', 'Centro', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1235, 'Rua Oscar Freire, 164', 'Bela Vista', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1236, 'Rua Haddock Lobo, 8', 'Vila Madalena', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1476, 'Rua da Consola��o, 7437', 'Vila Madalena', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1399, 'Av. Paulista, 4699', 'Vila Madalena', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1148, 'Rua Haddock Lobo, 1558', 'Bela Vista', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1064, 'Rua 25 de Mar�o, 3098', 'Tatuap�', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1157, 'Av. Ipiranga, 3357', 'Tatuap�', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1361, 'Rua Augusta, 5924', 'Jardins', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1423, 'Av. Ipiranga, 9347', 'Vila Madalena', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1690, 'Av. Paulista, 9663', 'Moema', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1708, 'Rua Haddock Lobo, 2727', 'Centro', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (751, 'Rua Oscar Freire, 9634', 'Lapa', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1383, 'Av. Brasil, 6974', 'Pinheiros', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (775, 'Av. 9 de Julho, 726', 'Moema', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1357, 'Rua da Consola��o, 3018', 'Jardins', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1475, 'Av. 9 de Julho, 2103', 'Jardins', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1569, 'Av. 9 de Julho, 321', 'Tatuap�', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1214, 'Av. Brigadeiro Faria Lima, 5555', 'Vila Madalena', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1114, 'Av. 9 de Julho, 2260', 'Vila Madalena', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1527, 'Rua Augusta, 2658', 'Bela Vista', 'Salvador', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1685, 'Rua Augusta, 5240', 'Lapa', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1079, 'Rua Oscar Freire, 6984', 'Lapa', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1405, 'Av. Paulista, 3265', 'Jardins', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1719, 'Av. Brigadeiro Faria Lima, 4321', 'Pinheiros', 'Curitiba', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1604, 'Av. Brasil, 3669', 'Itaim Bibi', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (863, 'Av. Brigadeiro Faria Lima, 5211', 'Tatuap�', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1344, 'Av. Paulista, 1024', 'Jardins', 'Bras�lia', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1329, 'Av. Ipiranga, 8414', 'Itaim Bibi', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (942, 'Rua da Consola��o, 2560', 'Itaim Bibi', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1471, 'Rua Augusta, 3531', 'Lapa', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1654, 'Rua Oscar Freire, 310', 'Lapa', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (805, 'Av. 9 de Julho, 3078', 'Tatuap�', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (743, 'Av. Paulista, 9537', 'Jardins', 'S�o Paulo', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1663, 'Av. 9 de Julho, 2280', 'Tatuap�', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1477, 'Av. Ipiranga, 2355', 'Moema', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (813, 'Av. Brasil, 8336', 'Itaim Bibi', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1713, 'Rua Augusta, 4745', 'Bela Vista', 'Recife', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1165, 'Rua da Consola��o, 7574', 'Bela Vista', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1695, 'Rua da Consola��o, 4026', 'Itaim Bibi', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (979, 'Av. 9 de Julho, 3538', 'Tatuap�', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1224, 'Rua Haddock Lobo, 2997', 'Vila Madalena', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1393, 'Av. 9 de Julho, 7153', 'Bela Vista', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1400, 'Av. Brigadeiro Faria Lima, 5985', 'Tatuap�', 'Rio de Janeiro', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1282, 'Rua 25 de Mar�o, 4437', 'Centro', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1417, 'Rua Oscar Freire, 4610', 'Tatuap�', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1086, 'Rua Oscar Freire, 1298', 'Lapa', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (888, 'Rua 25 de Mar�o, 5415', 'Vila Madalena', 'Salvador', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1257, 'Rua da Consola��o, 1384', 'Pinheiros', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1424, 'Av. Brigadeiro Faria Lima, 6002', 'Vila Madalena', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (787, 'Rua Oscar Freire, 7916', 'Centro', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1274, 'Rua 25 de Mar�o, 1406', 'Pinheiros', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1353, 'Av. Brasil, 4338', 'Tatuap�', 'Bras�lia', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1084, 'Av. Ipiranga, 6027', 'Pinheiros', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1073, 'Rua Oscar Freire, 4540', 'Vila Madalena', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1587, 'Av. 9 de Julho, 8952', 'Bela Vista', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1723, 'Rua Oscar Freire, 1313', 'Moema', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1703, 'Rua Oscar Freire, 542', 'Jardins', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1153, 'Rua Oscar Freire, 614', 'Itaim Bibi', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (739, 'Rua Haddock Lobo, 501', 'Itaim Bibi', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1429, 'Av. Brasil, 1789', 'Lapa', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1326, 'Av. Paulista, 4899', 'Tatuap�', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1141, 'Rua 25 de Mar�o, 8773', 'Tatuap�', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1467, 'Rua 25 de Mar�o, 4672', 'Vila Madalena', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (833, 'Av. Brasil, 2424', 'Centro', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1026, 'Rua 25 de Mar�o, 7989', 'Moema', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1356, 'Rua 25 de Mar�o, 7602', 'Centro', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1234, 'Av. Ipiranga, 1465', 'Centro', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1409, 'Av. Ipiranga, 7532', 'Moema', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1722, 'Av. Brigadeiro Faria Lima, 4006', 'Bela Vista', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1040, 'Av. Ipiranga, 3128', 'Bela Vista', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (995, 'Av. 9 de Julho, 3877', 'Pinheiros', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1584, 'Av. Brigadeiro Faria Lima, 5777', 'Santana', 'Fortaleza', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1729, 'Rua da Consola��o, 1490', 'Tatuap�', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1442, 'Rua 25 de Mar�o, 6930', 'Moema', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1322, 'Rua Augusta, 8258', 'Vila Madalena', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1221, 'Rua 25 de Mar�o, 1163', 'Centro', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1561, 'Rua Haddock Lobo, 9894', 'Tatuap�', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (791, 'Av. Paulista, 5086', 'Jardins', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1076, 'Av. Brasil, 564', 'Itaim Bibi', 'Fortaleza', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1138, 'Av. Paulista, 6821', 'Bela Vista', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1140, 'Av. 9 de Julho, 8532', 'Vila Madalena', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (956, 'Rua 25 de Mar�o, 145', 'Tatuap�', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1711, 'Rua Augusta, 6768', 'Jardins', 'Fortaleza', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1019, 'Av. Brigadeiro Faria Lima, 8575', 'Bela Vista', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1205, 'Av. Brasil, 5', 'Bela Vista', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (829, 'Rua da Consola��o, 9031', 'Itaim Bibi', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (831, 'Av. Ipiranga, 3828', 'Centro', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (800, 'Rua Oscar Freire, 2007', 'Tatuap�', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1502, 'Av. Ipiranga, 8418', 'Jardins', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (823, 'Av. Brasil, 1111', 'Centro', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1377, 'Rua Oscar Freire, 345', 'Bela Vista', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1451, 'Rua Augusta, 7027', 'Lapa', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1265, 'Rua 25 de Mar�o, 1995', 'Lapa', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (792, 'Rua Haddock Lobo, 7390', 'Santana', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (856, 'Rua Augusta, 5351', 'Jardins', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1503, 'Av. Brasil, 984', 'Pinheiros', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1139, 'Av. Ipiranga, 4458', 'Moema', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1312, 'Rua Haddock Lobo, 6177', 'Lapa', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (862, 'Av. Paulista, 5810', 'Tatuap�', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1491, 'Rua Oscar Freire, 5573', 'Lapa', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1630, 'Rua 25 de Mar�o, 5887', 'Centro', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1182, 'Av. Brigadeiro Faria Lima, 5901', 'Lapa', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1189, 'Av. Brasil, 8948', 'Centro', 'Rio de Janeiro', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1100, 'Av. Brasil, 3575', 'Centro', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1608, 'Av. Brasil, 6580', 'Vila Madalena', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1335, 'Av. Paulista, 554', 'Pinheiros', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1651, 'Rua da Consola��o, 3360', 'Jardins', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (843, 'Av. 9 de Julho, 9542', 'Pinheiros', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1441, 'Av. Ipiranga, 8755', 'Tatuap�', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1082, 'Rua da Consola��o, 8778', 'Bela Vista', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1136, 'Rua Oscar Freire, 4137', 'Bela Vista', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1307, 'Rua Oscar Freire, 1103', 'Santana', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1015, 'Rua Oscar Freire, 2083', 'Vila Madalena', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (944, 'Av. 9 de Julho, 6524', 'Vila Madalena', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (752, 'Av. Paulista, 7134', 'Itaim Bibi', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1051, 'Av. Ipiranga, 8543', 'Bela Vista', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1640, 'Av. Paulista, 1584', 'Itaim Bibi', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1024, 'Av. Ipiranga, 5976', 'Santana', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (784, 'Rua Haddock Lobo, 7425', 'Pinheiros', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (928, 'Rua Augusta, 9946', 'Bela Vista', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1327, 'Rua Oscar Freire, 7746', 'Santana', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1029, 'Av. Paulista, 9056', 'Bela Vista', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1286, 'Rua 25 de Mar�o, 6859', 'Pinheiros', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (850, 'Rua da Consola��o, 7008', 'Bela Vista', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (917, 'Av. Paulista, 1848', 'Itaim Bibi', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1724, 'Av. Paulista, 5329', 'Vila Madalena', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1110, 'Av. Ipiranga, 9764', 'Bela Vista', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (789, 'Av. Brasil, 5213', 'Centro', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1070, 'Av. Brasil, 4778', 'Tatuap�', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1470, 'Av. Brigadeiro Faria Lima, 4139', 'Lapa', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1314, 'Rua Haddock Lobo, 3240', 'Centro', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1510, 'Av. Paulista, 8117', 'Santana', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1591, 'Rua Haddock Lobo, 1787', 'Pinheiros', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (943, 'Rua 25 de Mar�o, 1778', 'Moema', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1098, 'Av. Ipiranga, 7211', 'Lapa', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (848, 'Av. Brasil, 226', 'Centro', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1486, 'Rua Oscar Freire, 8342', 'Itaim Bibi', 'S�o Paulo', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (923, 'Av. 9 de Julho, 1617', 'Santana', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1656, 'Rua da Consola��o, 565', 'Vila Madalena', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (765, 'Rua Augusta, 4351', 'Vila Madalena', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1528, 'Rua Haddock Lobo, 7321', 'Centro', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1542, 'Rua 25 de Mar�o, 8420', 'Bela Vista', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1375, 'Av. Ipiranga, 3616', 'Itaim Bibi', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (965, 'Av. Ipiranga, 448', 'Tatuap�', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1288, 'Av. Ipiranga, 7512', 'Itaim Bibi', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (803, 'Av. 9 de Julho, 3607', 'Santana', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1180, 'Av. Brigadeiro Faria Lima, 7260', 'Moema', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (992, 'Av. Brigadeiro Faria Lima, 3081', 'Jardins', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1726, 'Av. Brigadeiro Faria Lima, 455', 'Santana', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1694, 'Av. Brasil, 3298', 'Moema', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1195, 'Rua Haddock Lobo, 5774', 'Jardins', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1284, 'Av. 9 de Julho, 3473', 'Pinheiros', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1022, 'Av. 9 de Julho, 168', 'Jardins', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (880, 'Rua Haddock Lobo, 5408', 'Jardins', 'Curitiba', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1450, 'Rua Oscar Freire, 4999', 'Moema', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (865, 'Av. 9 de Julho, 6636', 'Lapa', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1293, 'Rua da Consola��o, 2192', 'Pinheiros', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1386, 'Rua Oscar Freire, 1840', 'Bela Vista', 'Belo Horizonte', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1582, 'Rua Oscar Freire, 7832', 'Santana', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1266, 'Rua Oscar Freire, 5283', 'Centro', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (946, 'Av. Ipiranga, 4755', 'Santana', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (938, 'Av. Brigadeiro Faria Lima, 2503', 'Lapa', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (770, 'Rua Augusta, 1706', 'Lapa', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1556, 'Rua da Consola��o, 4656', 'Santana', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (984, 'Rua Augusta, 8027', 'Tatuap�', 'Rio de Janeiro', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (747, 'Rua Haddock Lobo, 5451', 'Santana', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1217, 'Rua Augusta, 2930', 'Centro', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1129, 'Rua Augusta, 5660', 'Jardins', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1158, 'Rua Oscar Freire, 975', 'Vila Madalena', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1229, 'Rua 25 de Mar�o, 6817', 'Vila Madalena', 'Fortaleza', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1108, 'Rua 25 de Mar�o, 4323', 'Bela Vista', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1368, 'Av. 9 de Julho, 5529', 'Tatuap�', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1670, 'Av. 9 de Julho, 2125', 'Jardins', 'Recife', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1428, 'Rua Augusta, 5196', 'Centro', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1078, 'Rua da Consola��o, 3419', 'Itaim Bibi', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1576, 'Rua Haddock Lobo, 7610', 'Pinheiros', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1472, 'Rua Augusta, 7022', 'Tatuap�', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1610, 'Rua Haddock Lobo, 445', 'Centro', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (851, 'Rua Haddock Lobo, 9424', 'Moema', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (832, 'Av. Ipiranga, 3824', 'Vila Madalena', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1187, 'Av. Paulista, 4163', 'Lapa', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (926, 'Av. Brigadeiro Faria Lima, 1267', 'Bela Vista', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1183, 'Av. Brigadeiro Faria Lima, 4258', 'Moema', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1536, 'Av. Brasil, 3675', 'Jardins', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1251, 'Av. Brasil, 8641', 'Santana', 'Curitiba', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (940, 'Av. Brasil, 8516', 'Centro', 'S�o Paulo', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (761, 'Av. Paulista, 205', 'Pinheiros', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (864, 'Av. 9 de Julho, 8477', 'Bela Vista', 'Salvador', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1000, 'Av. Paulista, 8008', 'Centro', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1050, 'Rua 25 de Mar�o, 1609', 'Tatuap�', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1208, 'Av. Ipiranga, 882', 'Bela Vista', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1023, 'Av. Paulista, 5790', 'Centro', 'Porto Alegre', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1237, 'Av. 9 de Julho, 8621', 'Santana', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1088, 'Av. Ipiranga, 5151', 'Centro', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1130, 'Rua Haddock Lobo, 4964', 'Moema', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1436, 'Rua da Consola��o, 7113', 'Centro', 'Curitiba', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1028, 'Av. 9 de Julho, 6201', 'Jardins', 'S�o Paulo', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1407, 'Av. 9 de Julho, 1057', 'Jardins', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1418, 'Rua da Consola��o, 6272', 'Vila Madalena', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (980, 'Av. 9 de Julho, 1168', 'Centro', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (908, 'Av. 9 de Julho, 5515', 'Moema', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (760, 'Av. Ipiranga, 3038', 'Bela Vista', 'S�o Paulo', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (913, 'Av. Brigadeiro Faria Lima, 641', 'Pinheiros', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (773, 'Av. Paulista, 1072', 'Santana', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (815, 'Rua da Consola��o, 3311', 'Vila Madalena', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1627, 'Rua da Consola��o, 1914', 'Santana', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1230, 'Rua Augusta, 6576', 'Bela Vista', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1071, 'Rua da Consola��o, 4981', 'Santana', 'Rio de Janeiro', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (968, 'Av. 9 de Julho, 606', 'Vila Madalena', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1578, 'Rua Augusta, 5130', 'Jardins', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1461, 'Av. Ipiranga, 7787', 'Moema', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (945, 'Rua Augusta, 9747', 'Bela Vista', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (987, 'Rua Oscar Freire, 1994', 'Tatuap�', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1449, 'Rua da Consola��o, 2060', 'Centro', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1684, 'Rua Augusta, 9155', 'Vila Madalena', 'Curitiba', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (820, 'Rua da Consola��o, 200', 'Lapa', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1132, 'Av. Brigadeiro Faria Lima, 5646', 'Centro', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1060, 'Rua da Consola��o, 8828', 'Centro', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1172, 'Rua Augusta, 7671', 'Tatuap�', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1244, 'Av. Brasil, 1800', 'Moema', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (779, 'Rua 25 de Mar�o, 5051', 'Moema', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1615, 'Av. Brasil, 4125', 'Vila Madalena', 'Curitiba', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1681, 'Rua da Consola��o, 8828', 'Bela Vista', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1135, 'Av. Paulista, 1519', 'Itaim Bibi', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1057, 'Rua da Consola��o, 6092', 'Centro', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1447, 'Av. Brasil, 3987', 'Vila Madalena', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1343, 'Av. Brigadeiro Faria Lima, 6641', 'Santana', 'Florian�polis', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1552, 'Av. Paulista, 4572', 'Vila Madalena', 'Fortaleza', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1720, 'Av. Ipiranga, 2282', 'Centro', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1673, 'Rua Haddock Lobo, 7816', 'Bela Vista', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1507, 'Rua da Consola��o, 7846', 'Santana', 'Bras�lia', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1093, 'Rua 25 de Mar�o, 3238', 'Jardins', 'Rio de Janeiro', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (887, 'Av. Brasil, 7655', 'Pinheiros', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (857, 'Av. Brigadeiro Faria Lima, 150', 'Moema', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (881, 'Rua Augusta, 2799', 'Itaim Bibi', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1238, 'Rua 25 de Mar�o, 1994', 'Lapa', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (748, 'Av. 9 de Julho, 1055', 'Pinheiros', 'Florian�polis', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1533, 'Rua da Consola��o, 9488', 'Bela Vista', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1155, 'Rua Haddock Lobo, 1688', 'Jardins', 'Belo Horizonte', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (849, 'Av. Ipiranga, 9541', 'Tatuap�', 'Fortaleza', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (986, 'Av. Paulista, 9143', 'Lapa', 'Porto Alegre', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1373, 'Rua Oscar Freire, 2222', 'Moema', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1672, 'Av. 9 de Julho, 3984', 'Centro', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1223, 'Av. Ipiranga, 3900', 'Itaim Bibi', 'Porto Alegre', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1167, 'Rua da Consola��o, 7581', 'Itaim Bibi', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (989, 'Av. 9 de Julho, 143', 'Tatuap�', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1261, 'Rua Augusta, 2527', 'Jardins', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1565, 'Av. Brasil, 6597', 'Bela Vista', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1727, 'Av. 9 de Julho, 5164', 'Santana', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1176, 'Av. Brasil, 4110', 'Bela Vista', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1519, 'Rua da Consola��o, 5438', 'Itaim Bibi', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1600, 'Av. Ipiranga, 21', 'Lapa', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (768, 'Rua Augusta, 3508', 'Bela Vista', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1316, 'Rua da Consola��o, 6685', 'Jardins', 'Porto Alegre', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1143, 'Rua Oscar Freire, 4212', 'Pinheiros', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (781, 'Av. Brigadeiro Faria Lima, 1124', 'Tatuap�', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1186, 'Av. 9 de Julho, 261', 'Tatuap�', 'Recife', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (971, 'Av. 9 de Julho, 8436', 'Tatuap�', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1171, 'Rua Haddock Lobo, 4374', 'Tatuap�', 'Porto Alegre', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1701, 'Rua Oscar Freire, 2108', 'Moema', 'Belo Horizonte', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (858, 'Av. Brasil, 8776', 'Tatuap�', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (961, 'Rua Augusta, 6693', 'Bela Vista', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (937, 'Rua Oscar Freire, 9665', 'Lapa', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1118, 'Rua Augusta, 4663', 'Jardins', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1222, 'Rua Haddock Lobo, 1246', 'Bela Vista', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1372, 'Rua Oscar Freire, 8715', 'Vila Madalena', 'Recife', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1109, 'Av. Paulista, 9138', 'Lapa', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1006, 'Rua 25 de Mar�o, 5405', 'Moema', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1103, 'Av. 9 de Julho, 6397', 'Vila Madalena', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (806, 'Av. Ipiranga, 9789', 'Santana', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (952, 'Rua 25 de Mar�o, 4187', 'Bela Vista', 'S�o Paulo', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1664, 'Rua Augusta, 9454', 'Tatuap�', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1046, 'Rua Augusta, 2662', 'Tatuap�', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (745, 'Av. Ipiranga, 9970', 'Tatuap�', 'Curitiba', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1178, 'Av. 9 de Julho, 9291', 'Moema', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (873, 'Rua Augusta, 4423', 'Itaim Bibi', 'Salvador', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1059, 'Av. Brigadeiro Faria Lima, 6949', 'Itaim Bibi', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1370, 'Rua Haddock Lobo, 404', 'Moema', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1397, 'Rua Haddock Lobo, 4851', 'Centro', 'Belo Horizonte', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (811, 'Rua Oscar Freire, 7834', 'Itaim Bibi', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1271, 'Rua Haddock Lobo, 6120', 'Pinheiros', 'Belo Horizonte', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1462, 'Rua da Consola��o, 8389', 'Bela Vista', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1667, 'Rua Augusta, 4101', 'Jardins', 'S�o Paulo', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1559, 'Rua Oscar Freire, 1327', 'Tatuap�', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (919, 'Av. 9 de Julho, 6451', 'Vila Madalena', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1331, 'Av. Ipiranga, 9333', 'Jardins', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (780, 'Rua Haddock Lobo, 6010', 'Pinheiros', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1389, 'Rua Haddock Lobo, 6522', 'Santana', 'Florian�polis', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1362, 'Rua 25 de Mar�o, 695', 'Jardins', 'Salvador', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (973, 'Rua Haddock Lobo, 2603', 'Itaim Bibi', 'Belo Horizonte', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1256, 'Av. Brasil, 4730', 'Tatuap�', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1081, 'Rua Oscar Freire, 4782', 'Centro', 'Bras�lia', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1302, 'Rua Oscar Freire, 7349', 'Bela Vista', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1164, 'Rua Augusta, 9496', 'Itaim Bibi', 'Rio de Janeiro', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1232, 'Av. Brigadeiro Faria Lima, 9503', 'Tatuap�', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (997, 'Rua 25 de Mar�o, 5296', 'Pinheiros', 'Porto Alegre', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (734, 'Rua da Consola��o, 4382', 'Pinheiros', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1220, 'Av. Brasil, 788', 'Moema', 'Salvador', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1509, 'Rua da Consola��o, 5031', 'Vila Madalena', 'Florian�polis', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1730, 'Av. 9 de Julho, 100', 'Lapa', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1482, 'Av. Brigadeiro Faria Lima, 1184', 'Jardins', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1104, 'Rua Oscar Freire, 3377', 'Santana', 'Florian�polis', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1013, 'Rua 25 de Mar�o, 3767', 'Moema', 'Recife', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1201, 'Av. Brigadeiro Faria Lima, 5633', 'Lapa', 'Salvador', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1499, 'Rua da Consola��o, 7819', 'Lapa', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1638, 'Rua Oscar Freire, 3626', 'Itaim Bibi', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1339, 'Rua 25 de Mar�o, 5348', 'Santana', 'Florian�polis', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1455, 'Av. Ipiranga, 528', 'Tatuap�', 'Porto Alegre', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1213, 'Rua da Consola��o, 5054', 'Pinheiros', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1408, 'Rua Augusta, 6846', 'Lapa', 'Fortaleza', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1191, 'Av. Paulista, 4431', 'Jardins', 'S�o Paulo', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1483, 'Rua 25 de Mar�o, 3941', 'Jardins', 'Curitiba', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1291, 'Av. Ipiranga, 2963', 'Jardins', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1437, 'Rua Augusta, 4218', 'Santana', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1643, 'Av. Brasil, 1852', 'Vila Madalena', 'S�o Paulo', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1614, 'Rua Haddock Lobo, 5727', 'Tatuap�', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1577, 'Av. Brasil, 6275', 'Pinheiros', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1131, 'Rua 25 de Mar�o, 2630', 'Bela Vista', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (852, 'Rua 25 de Mar�o, 6247', 'Pinheiros', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1431, 'Rua 25 de Mar�o, 4092', 'Centro', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1572, 'Rua Augusta, 6436', 'Pinheiros', 'Recife', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1702, 'Av. Ipiranga, 5159', 'Bela Vista', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1513, 'Av. Brigadeiro Faria Lima, 3607', 'Centro', 'Porto Alegre', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1267, 'Rua Augusta, 9412', 'Santana', 'Recife', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1188, 'Rua 25 de Mar�o, 4860', 'Moema', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1456, 'Av. Paulista, 3078', 'Santana', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (778, 'Rua Augusta, 6064', 'Jardins', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1581, 'Rua Oscar Freire, 3850', 'Lapa', 'Porto Alegre', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1120, 'Rua Augusta, 4661', 'Jardins', 'Bras�lia', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (879, 'Av. Paulista, 3316', 'Moema', 'Florian�polis', 'MG');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1072, 'Rua 25 de Mar�o, 8557', 'Lapa', 'Belo Horizonte', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1225, 'Rua Oscar Freire, 9965', 'Tatuap�', 'Porto Alegre', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1332, 'Av. Brasil, 2309', 'Bela Vista', 'Belo Horizonte', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (975, 'Rua da Consola��o, 4303', 'Lapa', 'Bras�lia', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1287, 'Av. Brigadeiro Faria Lima, 881', 'Tatuap�', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1318, 'Av. 9 de Julho, 6798', 'Santana', 'Recife', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1434, 'Rua da Consola��o, 1740', 'Santana', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1508, 'Av. Brigadeiro Faria Lima, 1378', 'Pinheiros', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1385, 'Rua Oscar Freire, 7519', 'Vila Madalena', 'Recife', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1116, 'Av. Brigadeiro Faria Lima, 1146', 'Tatuap�', 'Belo Horizonte', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (972, 'Rua Oscar Freire, 3313', 'Moema', 'Salvador', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (983, 'Rua Augusta, 5541', 'Centro', 'Curitiba', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1676, 'Rua Oscar Freire, 5690', 'Bela Vista', 'Fortaleza', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1160, 'Av. Brigadeiro Faria Lima, 5122', 'Lapa', 'Rio de Janeiro', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (869, 'Rua 25 de Mar�o, 2156', 'Vila Madalena', 'Belo Horizonte', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1629, 'Av. Paulista, 342', 'Itaim Bibi', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1204, 'Rua Haddock Lobo, 2877', 'Pinheiros', 'Florian�polis', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1406, 'Av. Brasil, 1568', 'Lapa', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1184, 'Av. Brasil, 3222', 'Pinheiros', 'Salvador', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1128, 'Av. Brasil, 1667', 'Bela Vista', 'Fortaleza', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1306, 'Rua Haddock Lobo, 5820', 'Itaim Bibi', 'Recife', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (921, 'Av. Ipiranga, 6042', 'Pinheiros', 'Rio de Janeiro', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1697, 'Rua Oscar Freire, 2704', 'Moema', 'Fortaleza', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (785, 'Rua da Consola��o, 410', 'Pinheiros', 'Florian�polis', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1551, 'Rua Augusta, 4227', 'Vila Madalena', 'Rio de Janeiro', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1500, 'Av. Brasil, 8374', 'Tatuap�', 'Curitiba', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (828, 'Av. Brasil, 318', 'Bela Vista', 'Fortaleza', 'CE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1328, 'Av. Brigadeiro Faria Lima, 8299', 'Vila Madalena', 'S�o Paulo', 'DF');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1666, 'Rua Augusta, 7479', 'Lapa', 'Bras�lia', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1283, 'Av. Paulista, 962', 'Santana', 'Bras�lia', 'SC');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1003, 'Rua Haddock Lobo, 2911', 'Pinheiros', 'Florian�polis', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1457, 'Av. Ipiranga, 1018', 'Lapa', 'Salvador', 'RS');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (810, 'Rua 25 de Mar�o, 5191', 'Santana', 'Bras�lia', 'RJ');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1459, 'Rua Oscar Freire, 8186', 'Santana', 'S�o Paulo', 'SP');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1334, 'Rua 25 de Mar�o, 8659', 'Tatuap�', 'Rio de Janeiro', 'PR');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (834, 'Av. Brigadeiro Faria Lima, 1984', 'Itaim Bibi', 'Recife', 'BA');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1560, 'Av. Brasil, 8047', 'Lapa', 'Curitiba', 'PE');
INSERT INTO endereco (id_usuario, rua, bairro, cidade, estado) VALUES (1674, 'Av. Brasil, 5204', 'Tatuap�', 'Porto Alegre', 'PR');

select * from endereco e ;

select * from telefone t ;

INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (731, 'COM', 31, 939816818);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (732, 'CEL', 51, 913104932);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (733, 'COM', 91, 926223355);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (734, 'COM', 41, 996726929);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (735, 'CEL', 91, 984768719);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (736, 'RES', 11, 960020169);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (737, 'RES', 41, 915707699);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (738, 'CEL', 21, 925354419);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (739, 'RES', 21, 983557010);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (740, 'RES', 71, 942795369);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (741, 'CEL', 11, 985778663);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (742, 'COM', 91, 901819231);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (743, 'COM', 81, 929673772);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (744, 'CEL', 81, 992980239);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (745, 'RES', 31, 948795760);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (746, 'COM', 41, 910586262);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (747, 'CEL', 21, 945699180);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (748, 'RES', 31, 956708013);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (749, 'CEL', 51, 930418014);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (750, 'CEL', 91, 911902138);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (751, 'COM', 41, 917147016);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (752, 'CEL', 31, 951450955);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (753, 'CEL', 81, 964768283);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (754, 'CEL', 91, 933952364);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (755, 'RES', 81, 910075423);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (756, 'COM', 81, 955212540);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (757, 'RES', 11, 968132093);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (758, 'CEL', 91, 908463319);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (759, 'RES', 11, 921383422);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (760, 'COM', 51, 921113378);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (761, 'COM', 71, 990503113);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (762, 'COM', 51, 986980309);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (763, 'COM', 91, 928998548);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (764, 'CEL', 51, 935542446);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (765, 'RES', 81, 904202192);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (766, 'CEL', 91, 977662287);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (767, 'CEL', 41, 976030841);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (768, 'COM', 71, 960179288);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (769, 'CEL', 61, 986110758);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (770, 'RES', 51, 919652797);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (771, 'CEL', 91, 913722921);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (772, 'RES', 61, 931273403);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (773, 'RES', 61, 983354779);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (774, 'RES', 31, 932232992);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (775, 'CEL', 31, 941608214);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (776, 'RES', 51, 973560336);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (777, 'RES', 91, 952762037);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (778, 'COM', 31, 917451157);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (779, 'CEL', 31, 921766771);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (780, 'CEL', 21, 978141740);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (781, 'COM', 81, 956532017);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (782, 'COM', 41, 920724803);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (783, 'CEL', 81, 950180638);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (784, 'CEL', 21, 954113453);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (785, 'COM', 11, 932387108);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (786, 'CEL', 61, 976322575);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (787, 'CEL', 61, 925546737);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (788, 'CEL', 11, 917048136);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (789, 'CEL', 41, 993652354);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (790, 'RES', 61, 950068031);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (791, 'CEL', 41, 987540112);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (792, 'RES', 51, 927334901);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (793, 'COM', 11, 924484989);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (794, 'CEL', 51, 931061809);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (795, 'RES', 31, 929293947);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (796, 'COM', 91, 984750845);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (797, 'COM', 61, 981751344);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (798, 'CEL', 31, 923026041);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (799, 'CEL', 21, 976044725);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (800, 'RES', 31, 943866592);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (801, 'CEL', 91, 915762846);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (802, 'RES', 91, 978519811);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (803, 'COM', 71, 973258519);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (804, 'COM', 61, 956798248);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (805, 'COM', 61, 950933528);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (806, 'RES', 31, 974228710);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (807, 'COM', 81, 947365282);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (808, 'COM', 41, 963396118);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (809, 'RES', 11, 971240735);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (810, 'CEL', 21, 938621350);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (811, 'COM', 31, 946212451);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (812, 'COM', 81, 909300038);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (813, 'RES', 21, 938397222);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (814, 'CEL', 11, 954163880);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (815, 'CEL', 41, 976438025);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (816, 'RES', 41, 923296292);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (817, 'COM', 61, 984599402);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (818, 'COM', 51, 920040930);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (819, 'COM', 61, 959081897);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (820, 'RES', 71, 967591848);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (821, 'RES', 81, 927355573);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (822, 'RES', 61, 926320274);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (823, 'CEL', 71, 910314043);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (824, 'RES', 31, 970445739);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (825, 'RES', 91, 903673136);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (826, 'CEL', 61, 902280493);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (827, 'RES', 41, 978077022);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (828, 'CEL', 21, 996819781);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (829, 'COM', 11, 909391107);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (830, 'COM', 41, 923349799);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (831, 'CEL', 61, 906010885);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (832, 'COM', 71, 952356944);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (833, 'COM', 81, 954143352);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (834, 'COM', 31, 922015504);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (835, 'CEL', 81, 915908430);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (836, 'RES', 41, 902068616);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (837, 'COM', 91, 902978482);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (838, 'CEL', 81, 961795400);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (839, 'CEL', 41, 968887691);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (840, 'COM', 91, 915273857);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (841, 'COM', 61, 955811946);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (842, 'RES', 21, 953712295);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (843, 'RES', 11, 950857418);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (844, 'COM', 51, 933010151);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (845, 'COM', 71, 977801423);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (846, 'RES', 11, 928395263);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (847, 'CEL', 11, 999064155);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (848, 'COM', 41, 929047854);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (849, 'CEL', 71, 903220964);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (850, 'COM', 91, 948250838);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (851, 'COM', 11, 982094565);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (852, 'CEL', 11, 901938233);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (853, 'COM', 91, 941293047);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (854, 'CEL', 21, 963501191);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (855, 'COM', 41, 943685348);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (856, 'RES', 61, 904366998);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (857, 'RES', 81, 912842463);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (858, 'RES', 31, 983046086);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (859, 'RES', 71, 918143200);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (860, 'RES', 11, 902434023);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (861, 'RES', 21, 917366423);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (862, 'CEL', 51, 967339803);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (863, 'COM', 31, 945210546);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (864, 'COM', 71, 988525270);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (865, 'RES', 81, 965387568);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (866, 'COM', 71, 946584341);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (867, 'COM', 11, 955364638);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (868, 'CEL', 61, 997237637);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (869, 'COM', 11, 928827210);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (870, 'RES', 51, 987275344);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (871, 'COM', 41, 920081163);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (872, 'RES', 21, 904660292);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (873, 'RES', 21, 988964955);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (874, 'COM', 91, 994805316);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (875, 'CEL', 11, 908033233);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (876, 'RES', 81, 920559232);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (877, 'CEL', 11, 913919811);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (878, 'CEL', 51, 960623799);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (879, 'RES', 41, 918778246);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (880, 'CEL', 21, 916354194);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (881, 'CEL', 71, 933642342);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (882, 'COM', 51, 988130415);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (883, 'COM', 21, 957400630);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (884, 'CEL', 41, 968274386);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (885, 'CEL', 11, 978674088);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (886, 'COM', 91, 972525150);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (887, 'COM', 21, 973240221);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (888, 'RES', 91, 957447024);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (889, 'RES', 71, 984907718);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (890, 'COM', 11, 957195857);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (891, 'COM', 11, 929120202);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (892, 'COM', 61, 907911313);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (893, 'CEL', 11, 951009664);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (894, 'CEL', 41, 928293426);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (895, 'CEL', 91, 994209537);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (896, 'CEL', 91, 959647152);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (897, 'COM', 31, 938382625);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (898, 'CEL', 41, 965602801);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (899, 'COM', 71, 999262223);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (900, 'COM', 71, 916591158);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (901, 'CEL', 91, 912926580);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (902, 'CEL', 41, 979979578);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (903, 'CEL', 21, 965903802);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (904, 'RES', 71, 922309870);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (905, 'COM', 81, 926241555);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (906, 'COM', 71, 987095708);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (907, 'COM', 21, 979176390);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (908, 'COM', 81, 984684162);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (909, 'COM', 21, 956462839);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (910, 'RES', 11, 988931516);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (911, 'COM', 31, 948043886);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (912, 'CEL', 11, 955100446);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (913, 'RES', 21, 950222622);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (914, 'CEL', 11, 983855288);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (915, 'COM', 61, 917819351);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (916, 'RES', 41, 952238574);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (917, 'CEL', 61, 944003189);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (918, 'COM', 71, 978959585);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (919, 'CEL', 61, 914556077);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (920, 'COM', 81, 962097076);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (921, 'CEL', 61, 985662069);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (922, 'CEL', 81, 953019866);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (923, 'RES', 81, 994704278);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (924, 'RES', 81, 963180562);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (925, 'COM', 21, 984048458);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (926, 'RES', 11, 935170007);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (927, 'CEL', 31, 950760100);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (928, 'COM', 61, 933260218);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (929, 'RES', 21, 924933698);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (930, 'CEL', 51, 996593236);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (931, 'CEL', 71, 912000217);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (932, 'RES', 51, 978023429);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (933, 'CEL', 71, 912986658);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (934, 'CEL', 41, 976055889);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (935, 'COM', 21, 902533408);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (936, 'RES', 81, 973322785);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (937, 'RES', 91, 970829608);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (938, 'CEL', 91, 928739624);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (939, 'RES', 21, 923061032);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (940, 'CEL', 31, 956414927);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (941, 'CEL', 31, 956488161);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (942, 'RES', 81, 963700128);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (943, 'RES', 91, 914133737);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (944, 'COM', 61, 971846922);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (945, 'RES', 71, 983871542);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (946, 'CEL', 81, 971877502);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (947, 'RES', 81, 998491127);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (948, 'COM', 21, 956254017);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (949, 'CEL', 61, 925098243);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (950, 'RES', 61, 902470480);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (951, 'CEL', 81, 954554780);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (952, 'COM', 91, 943216762);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (953, 'RES', 81, 976683834);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (954, 'COM', 61, 939142242);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (955, 'CEL', 91, 961807879);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (956, 'COM', 71, 977435815);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (957, 'CEL', 21, 964297625);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (958, 'RES', 11, 985688888);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (959, 'CEL', 41, 999740409);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (960, 'CEL', 41, 965366319);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (961, 'RES', 11, 934941489);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (962, 'CEL', 81, 979993604);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (963, 'CEL', 91, 923897394);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (964, 'RES', 11, 991045862);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (965, 'CEL', 31, 973080188);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (966, 'COM', 71, 938225122);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (967, 'CEL', 31, 990706888);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (968, 'CEL', 21, 928494440);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (969, 'CEL', 81, 975596983);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (970, 'RES', 31, 978086133);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (971, 'COM', 11, 962629395);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (972, 'COM', 81, 942599914);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (973, 'COM', 81, 964392483);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (974, 'CEL', 41, 900108578);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (975, 'COM', 51, 907809672);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (976, 'COM', 41, 989415792);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (977, 'COM', 81, 950784057);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (978, 'CEL', 61, 939479684);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (979, 'RES', 71, 978887824);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (980, 'CEL', 71, 913243216);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (981, 'CEL', 31, 981932335);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (982, 'COM', 51, 954441490);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (983, 'COM', 51, 940631012);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (984, 'RES', 51, 990384769);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (985, 'COM', 91, 987301774);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (986, 'RES', 51, 915102595);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (987, 'CEL', 91, 905881820);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (988, 'CEL', 71, 941199935);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (989, 'RES', 31, 992714413);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (990, 'COM', 81, 934041944);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (991, 'CEL', 61, 902084807);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (992, 'COM', 71, 919427659);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (993, 'CEL', 11, 960935403);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (994, 'CEL', 61, 986545648);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (995, 'COM', 51, 992572229);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (996, 'RES', 81, 915836229);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (997, 'RES', 91, 911288128);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (998, 'RES', 61, 998801913);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (999, 'RES', 71, 944709820);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1000, 'CEL', 11, 971329582);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1001, 'RES', 71, 907959875);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1002, 'COM', 61, 963106989);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1003, 'CEL', 61, 948873360);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1004, 'CEL', 31, 925356255);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1005, 'RES', 81, 996223719);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1006, 'COM', 51, 900969875);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1007, 'RES', 21, 955279445);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1008, 'COM', 21, 933124983);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1009, 'COM', 51, 929556365);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1010, 'COM', 21, 992920286);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1011, 'RES', 61, 934493931);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1012, 'CEL', 51, 911992658);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1013, 'COM', 41, 905305564);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1014, 'RES', 41, 933087958);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1015, 'CEL', 31, 963541169);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1016, 'COM', 31, 906320720);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1017, 'RES', 31, 957803773);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1018, 'COM', 61, 926140409);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1019, 'COM', 61, 906355890);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1020, 'RES', 31, 977147198);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1021, 'RES', 41, 937218048);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1022, 'CEL', 61, 977908691);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1023, 'RES', 31, 995346374);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1024, 'RES', 71, 987923470);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1025, 'COM', 61, 999490758);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1026, 'CEL', 81, 945854629);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1027, 'RES', 41, 986249183);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1028, 'RES', 81, 972324286);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1029, 'RES', 41, 929557982);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1030, 'COM', 31, 901642292);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1031, 'COM', 21, 967651913);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1032, 'CEL', 71, 915513304);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1033, 'CEL', 61, 901691905);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1034, 'CEL', 21, 916077827);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1035, 'RES', 11, 975262291);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1036, 'COM', 11, 903045424);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1037, 'COM', 81, 975395343);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1038, 'CEL', 71, 947848758);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1039, 'RES', 51, 962247870);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1040, 'COM', 41, 955514333);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1041, 'CEL', 11, 948714080);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1042, 'RES', 51, 969970974);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1043, 'COM', 21, 915955188);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1044, 'COM', 71, 955463218);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1045, 'RES', 71, 922491885);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1046, 'COM', 31, 991074819);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1047, 'CEL', 71, 913362713);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1048, 'CEL', 31, 980387511);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1049, 'RES', 21, 912175671);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1050, 'COM', 21, 979164156);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1051, 'CEL', 31, 927669368);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1052, 'CEL', 81, 978692311);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1053, 'RES', 11, 983405038);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1054, 'RES', 61, 902114106);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1055, 'COM', 51, 945456544);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1056, 'COM', 91, 920172903);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1057, 'CEL', 51, 969078250);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1058, 'COM', 51, 943303603);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1059, 'COM', 21, 969648079);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1060, 'COM', 61, 963002786);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1061, 'RES', 71, 981087316);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1062, 'RES', 91, 920831864);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1063, 'RES', 41, 977291858);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1064, 'RES', 41, 915630826);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1065, 'RES', 81, 931243399);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1066, 'CEL', 61, 919002550);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1067, 'RES', 61, 934330592);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1068, 'COM', 71, 901837647);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1069, 'COM', 81, 964902849);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1070, 'CEL', 91, 995480530);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1071, 'CEL', 81, 963896409);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1072, 'RES', 51, 981176517);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1073, 'COM', 21, 921059454);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1074, 'RES', 91, 987046034);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1075, 'RES', 41, 904477764);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1076, 'RES', 51, 961858170);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1077, 'COM', 11, 996753845);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1078, 'RES', 11, 979907140);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1079, 'RES', 11, 966457920);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1080, 'RES', 71, 962317999);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1081, 'RES', 71, 933358174);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1082, 'COM', 41, 973259394);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1083, 'RES', 81, 980788845);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1084, 'COM', 31, 925532160);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1085, 'RES', 11, 931536777);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1086, 'RES', 11, 968089227);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1087, 'COM', 21, 962466891);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1088, 'RES', 61, 963865072);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1089, 'CEL', 31, 908811528);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1090, 'CEL', 21, 924552468);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1091, 'COM', 21, 941160477);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1092, 'COM', 31, 912682783);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1093, 'CEL', 41, 942410593);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1094, 'COM', 71, 942012170);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1095, 'CEL', 71, 902419040);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1096, 'RES', 51, 923117596);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1097, 'CEL', 41, 971615196);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1098, 'CEL', 41, 925410825);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1099, 'CEL', 41, 922781215);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1100, 'COM', 21, 907603268);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1101, 'CEL', 41, 928727793);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1102, 'CEL', 81, 944933993);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1103, 'COM', 51, 944159551);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1104, 'COM', 31, 948794198);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1105, 'RES', 31, 944242890);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1106, 'RES', 31, 976829026);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1107, 'CEL', 41, 964637890);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1108, 'RES', 71, 982920287);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1109, 'RES', 71, 940973581);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1110, 'RES', 61, 943365727);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1111, 'COM', 11, 906251615);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1112, 'CEL', 81, 907928687);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1113, 'COM', 21, 984592861);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1114, 'CEL', 31, 985306221);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1115, 'CEL', 91, 941405992);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1116, 'CEL', 41, 941410040);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1117, 'RES', 61, 963750183);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1118, 'COM', 21, 962134776);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1119, 'CEL', 91, 920928320);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1120, 'COM', 71, 935306445);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1121, 'COM', 31, 993601988);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1122, 'RES', 61, 914005080);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1123, 'COM', 51, 919010517);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1124, 'RES', 61, 910863628);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1125, 'CEL', 81, 971228035);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1126, 'RES', 71, 918159451);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1127, 'CEL', 41, 921199799);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1128, 'CEL', 41, 968361396);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1129, 'RES', 81, 902404557);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1130, 'CEL', 11, 999680823);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1131, 'RES', 71, 909006272);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1132, 'CEL', 61, 931204688);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1133, 'CEL', 21, 912930282);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1134, 'CEL', 91, 901281695);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1135, 'CEL', 71, 993615811);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1136, 'COM', 91, 974251601);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1137, 'RES', 71, 968384666);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1138, 'COM', 61, 974932475);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1139, 'COM', 71, 913503306);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1140, 'CEL', 61, 950088932);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1141, 'RES', 21, 975309402);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1142, 'COM', 51, 900703430);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1143, 'COM', 11, 977092100);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1144, 'CEL', 61, 938978792);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1145, 'RES', 31, 905971465);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1146, 'COM', 91, 959892583);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1147, 'COM', 51, 956437872);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1148, 'RES', 31, 975937808);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1149, 'CEL', 21, 980718008);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1150, 'RES', 41, 970528007);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1151, 'CEL', 71, 935229383);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1152, 'CEL', 11, 973258248);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1153, 'COM', 51, 947342320);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1154, 'RES', 61, 955751475);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1155, 'COM', 51, 976573461);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1156, 'COM', 71, 955594689);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1157, 'CEL', 91, 964164246);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1158, 'RES', 41, 959439234);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1159, 'CEL', 41, 901725793);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1160, 'RES', 31, 910463490);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1161, 'RES', 61, 927596902);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1162, 'CEL', 81, 951273959);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1163, 'RES', 41, 925280961);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1164, 'RES', 71, 993619919);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1165, 'RES', 81, 966526321);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1166, 'CEL', 91, 905236416);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1167, 'COM', 71, 953760729);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1168, 'COM', 21, 969707153);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1169, 'RES', 71, 988486999);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1170, 'RES', 81, 982747105);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1171, 'COM', 91, 967032963);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1172, 'CEL', 41, 990571816);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1173, 'RES', 41, 929999064);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1174, 'COM', 81, 990291044);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1175, 'COM', 61, 949067843);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1176, 'RES', 81, 911490441);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1177, 'COM', 71, 965350531);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1178, 'CEL', 81, 978078066);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1179, 'RES', 41, 958732062);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1180, 'COM', 71, 909641088);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1181, 'COM', 91, 987001461);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1182, 'COM', 61, 947794605);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1183, 'CEL', 71, 911869952);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1184, 'RES', 11, 939998798);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1185, 'RES', 11, 956409843);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1186, 'RES', 31, 926921976);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1187, 'RES', 91, 950994797);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1188, 'RES', 41, 984373067);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1189, 'COM', 81, 977622739);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1190, 'RES', 71, 913503338);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1191, 'COM', 81, 945108894);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1192, 'CEL', 71, 906430714);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1193, 'COM', 21, 920141277);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1194, 'COM', 11, 979259688);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1195, 'COM', 31, 968062652);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1196, 'COM', 41, 934508111);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1197, 'COM', 51, 925370562);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1198, 'CEL', 81, 921885075);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1199, 'COM', 61, 956572735);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1200, 'CEL', 21, 998334983);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1201, 'CEL', 11, 977446303);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1202, 'COM', 21, 965842600);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1203, 'COM', 51, 912713282);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1204, 'RES', 71, 972859920);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1205, 'COM', 21, 972310321);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1206, 'CEL', 81, 952084140);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1207, 'CEL', 81, 985842251);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1208, 'CEL', 81, 952886777);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1209, 'COM', 71, 946519894);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1210, 'COM', 91, 912086654);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1211, 'COM', 61, 936383832);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1212, 'CEL', 31, 922903377);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1213, 'CEL', 41, 957053091);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1214, 'CEL', 51, 940400173);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1215, 'COM', 11, 974815775);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1216, 'RES', 71, 972697714);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1217, 'COM', 51, 965582363);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1218, 'RES', 11, 911087161);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1219, 'COM', 61, 905124284);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1220, 'RES', 81, 939253455);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1221, 'RES', 11, 997365805);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1222, 'RES', 11, 960384942);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1223, 'COM', 71, 940461640);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1224, 'RES', 71, 905347326);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1225, 'CEL', 71, 963825042);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1226, 'COM', 41, 961385102);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1227, 'CEL', 81, 928236558);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1228, 'COM', 51, 918463774);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1229, 'RES', 11, 908799465);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1230, 'CEL', 71, 934043913);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1231, 'RES', 91, 908004788);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1232, 'COM', 21, 965075247);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1233, 'CEL', 91, 905579464);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1234, 'RES', 31, 952147798);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1235, 'CEL', 21, 939633495);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1236, 'RES', 81, 912834355);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1237, 'RES', 31, 950096696);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1238, 'CEL', 21, 915106359);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1239, 'COM', 71, 980183722);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1240, 'COM', 41, 942157020);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1241, 'CEL', 21, 926780022);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1242, 'COM', 31, 939379809);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1243, 'RES', 81, 907234524);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1244, 'CEL', 11, 955906445);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1245, 'COM', 51, 901912421);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1246, 'COM', 61, 918912824);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1247, 'CEL', 81, 992141577);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1248, 'RES', 71, 951502711);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1249, 'CEL', 31, 904229034);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1250, 'CEL', 41, 991744407);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1251, 'RES', 11, 967216335);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1252, 'RES', 71, 928419632);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1253, 'COM', 51, 983840963);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1254, 'COM', 61, 985092195);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1255, 'COM', 11, 979813544);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1256, 'CEL', 61, 968186267);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1257, 'CEL', 81, 925889601);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1258, 'RES', 81, 980736562);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1259, 'CEL', 71, 911450556);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1260, 'CEL', 31, 908170276);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1261, 'CEL', 81, 988456428);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1262, 'RES', 51, 966082059);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1263, 'COM', 71, 977517078);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1264, 'RES', 21, 982969582);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1265, 'CEL', 51, 953399992);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1266, 'CEL', 51, 940320462);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1267, 'COM', 41, 938732615);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1268, 'COM', 51, 977984412);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1269, 'RES', 31, 933345101);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1270, 'CEL', 31, 902020117);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1271, 'COM', 11, 998030930);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1272, 'RES', 91, 905382040);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1273, 'COM', 91, 927727459);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1274, 'COM', 81, 992974951);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1275, 'COM', 11, 932428126);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1276, 'COM', 21, 964237680);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1277, 'COM', 71, 963525525);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1278, 'RES', 91, 935752490);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1279, 'RES', 41, 992722416);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1280, 'CEL', 51, 900981556);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1281, 'CEL', 31, 961086404);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1282, 'COM', 51, 967240759);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1283, 'RES', 41, 969594658);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1284, 'COM', 11, 982910364);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1285, 'CEL', 51, 926176275);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1286, 'RES', 71, 908508187);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1287, 'RES', 91, 980435269);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1288, 'COM', 41, 998640266);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1289, 'COM', 81, 965542522);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1290, 'RES', 91, 943331992);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1291, 'RES', 71, 998880880);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1292, 'COM', 71, 982742064);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1293, 'COM', 91, 919403378);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1294, 'COM', 91, 932343065);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1295, 'RES', 81, 944838905);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1296, 'COM', 61, 977792565);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1297, 'CEL', 21, 967242477);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1298, 'RES', 31, 964353890);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1299, 'RES', 61, 949840179);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1300, 'CEL', 91, 988990121);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1301, 'CEL', 31, 979445933);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1302, 'CEL', 31, 979886851);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1303, 'COM', 71, 998966443);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1304, 'COM', 31, 929964340);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1305, 'COM', 51, 998194618);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1306, 'CEL', 71, 921042365);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1307, 'RES', 71, 932394754);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1308, 'COM', 31, 953776665);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1309, 'CEL', 21, 932395972);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1310, 'CEL', 71, 999613491);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1311, 'RES', 91, 967093130);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1312, 'COM', 31, 952527095);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1313, 'COM', 81, 993604424);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1314, 'RES', 21, 968376557);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1315, 'COM', 11, 995576912);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1316, 'RES', 21, 903429568);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1317, 'COM', 31, 939371364);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1318, 'COM', 51, 914982209);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1319, 'RES', 71, 932727099);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1320, 'RES', 71, 976493246);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1321, 'RES', 21, 922373923);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1322, 'CEL', 51, 923871345);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1323, 'CEL', 71, 993434255);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1324, 'CEL', 21, 988696746);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1325, 'CEL', 21, 939583757);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1326, 'RES', 81, 904511679);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1327, 'COM', 21, 927372372);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1328, 'CEL', 41, 943482006);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1329, 'RES', 91, 976515962);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1330, 'COM', 31, 904151428);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1331, 'COM', 31, 951068968);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1332, 'RES', 21, 990803326);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1333, 'RES', 51, 963204749);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1334, 'RES', 31, 901269927);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1335, 'CEL', 91, 961396368);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1336, 'CEL', 61, 977174593);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1337, 'RES', 31, 974955014);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1338, 'COM', 71, 963670565);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1339, 'COM', 91, 971345218);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1340, 'RES', 41, 926786993);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1341, 'CEL', 31, 932633893);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1342, 'COM', 31, 915311544);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1343, 'CEL', 41, 952393161);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1344, 'RES', 21, 934294898);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1345, 'COM', 21, 962407980);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1346, 'COM', 91, 936108545);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1347, 'RES', 11, 995788570);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1348, 'COM', 91, 951214499);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1349, 'RES', 11, 987109229);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1350, 'CEL', 41, 934911891);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1351, 'CEL', 91, 941407907);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1352, 'CEL', 31, 930942440);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1353, 'CEL', 21, 993537816);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1354, 'RES', 71, 993037986);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1355, 'CEL', 71, 935184197);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1356, 'COM', 71, 928309967);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1357, 'COM', 41, 989993672);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1358, 'RES', 31, 919088215);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1359, 'RES', 11, 943809304);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1360, 'CEL', 31, 934446389);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1361, 'CEL', 81, 999487774);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1362, 'COM', 71, 940042376);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1363, 'CEL', 41, 917954268);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1364, 'CEL', 31, 948516705);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1365, 'COM', 61, 924289606);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1366, 'COM', 11, 948016727);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1367, 'RES', 61, 974637585);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1368, 'COM', 91, 936629047);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1369, 'RES', 31, 942480661);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1370, 'COM', 61, 938590572);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1371, 'CEL', 81, 986389529);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1372, 'COM', 71, 942504229);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1373, 'COM', 91, 957886161);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1374, 'COM', 21, 985935168);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1375, 'RES', 91, 977819353);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1376, 'RES', 31, 939761062);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1377, 'RES', 91, 974865388);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1378, 'RES', 91, 962555792);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1379, 'COM', 91, 961331969);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1380, 'RES', 11, 948739246);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1381, 'COM', 21, 925339669);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1382, 'CEL', 41, 904317803);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1383, 'COM', 91, 989571540);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1384, 'COM', 11, 965380263);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1385, 'CEL', 71, 922444394);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1386, 'CEL', 41, 953118811);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1387, 'COM', 61, 941439925);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1388, 'CEL', 21, 964613652);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1389, 'RES', 31, 907820311);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1390, 'RES', 31, 967204359);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1391, 'CEL', 41, 938580304);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1392, 'CEL', 81, 931828597);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1393, 'COM', 31, 923964572);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1394, 'RES', 11, 941524433);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1395, 'CEL', 91, 992725923);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1396, 'COM', 11, 965930580);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1397, 'CEL', 21, 979889610);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1398, 'RES', 41, 991748738);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1399, 'COM', 91, 973469743);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1400, 'CEL', 71, 919005211);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1401, 'CEL', 81, 975263356);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1402, 'CEL', 11, 947579459);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1403, 'CEL', 21, 995412217);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1404, 'RES', 61, 911817608);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1405, 'COM', 81, 972236390);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1406, 'COM', 31, 902650598);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1407, 'COM', 11, 992966199);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1408, 'CEL', 61, 924457166);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1409, 'COM', 91, 972395746);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1410, 'RES', 61, 902110952);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1411, 'RES', 11, 979783486);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1412, 'RES', 71, 900375580);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1413, 'RES', 21, 948272908);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1414, 'COM', 51, 940526703);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1415, 'RES', 21, 979545997);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1416, 'COM', 41, 925630103);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1417, 'CEL', 91, 958639264);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1418, 'CEL', 61, 978392895);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1419, 'RES', 71, 935782297);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1420, 'COM', 41, 973911447);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1421, 'RES', 31, 901344108);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1422, 'COM', 71, 996046213);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1423, 'COM', 21, 963621694);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1424, 'CEL', 11, 960376166);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1425, 'COM', 11, 936348879);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1426, 'CEL', 71, 939275453);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1427, 'CEL', 61, 970112966);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1428, 'COM', 51, 975048248);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1429, 'RES', 11, 912150058);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1430, 'RES', 31, 917304919);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1431, 'RES', 81, 954351718);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1432, 'COM', 21, 981039391);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1433, 'COM', 11, 990039664);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1434, 'CEL', 51, 997612289);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1435, 'RES', 61, 965047622);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1436, 'COM', 51, 992964826);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1437, 'COM', 91, 930159295);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1438, 'RES', 91, 923319932);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1439, 'RES', 21, 972748641);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1440, 'RES', 11, 952838191);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1441, 'RES', 41, 974550693);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1442, 'COM', 71, 966052758);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1443, 'COM', 51, 911855841);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1444, 'RES', 21, 977826320);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1445, 'CEL', 61, 976004386);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1446, 'CEL', 81, 926231137);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1447, 'COM', 81, 974099021);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1448, 'COM', 11, 955814162);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1449, 'CEL', 31, 909114960);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1450, 'RES', 91, 952809220);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1451, 'COM', 71, 939443426);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1452, 'CEL', 81, 987156020);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1453, 'CEL', 31, 945061992);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1454, 'COM', 11, 996256901);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1455, 'CEL', 61, 929938987);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1456, 'RES', 51, 963702947);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1457, 'RES', 21, 911106714);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1458, 'COM', 81, 973397963);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1459, 'RES', 71, 941133519);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1460, 'RES', 81, 942443263);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1461, 'RES', 11, 913414356);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1462, 'CEL', 61, 992478962);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1463, 'COM', 81, 997087306);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1464, 'RES', 91, 912755152);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1465, 'COM', 51, 932702477);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1466, 'RES', 61, 923774581);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1467, 'COM', 21, 982264408);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1468, 'COM', 81, 989965488);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1469, 'COM', 41, 940429746);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1470, 'RES', 21, 958886149);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1471, 'RES', 41, 963894478);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1472, 'RES', 21, 957018527);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1473, 'COM', 41, 966279204);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1474, 'RES', 61, 903813975);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1475, 'COM', 71, 915832511);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1476, 'CEL', 21, 982092119);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1477, 'COM', 91, 904247745);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1478, 'RES', 71, 952417731);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1479, 'COM', 11, 922351759);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1480, 'RES', 61, 904309320);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1481, 'CEL', 51, 941521604);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1482, 'COM', 51, 934941241);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1483, 'CEL', 81, 909866091);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1484, 'CEL', 51, 997396500);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1485, 'RES', 51, 935049793);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1486, 'CEL', 61, 957380227);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1487, 'COM', 21, 919245410);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1488, 'CEL', 41, 940031675);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1489, 'CEL', 81, 931843959);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1490, 'RES', 21, 966990849);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1491, 'COM', 11, 938748070);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1492, 'COM', 81, 902029284);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1493, 'CEL', 51, 939796808);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1494, 'CEL', 91, 981678005);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1495, 'RES', 81, 934172797);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1496, 'RES', 51, 926818031);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1497, 'RES', 71, 992763159);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1498, 'RES', 51, 967237996);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1499, 'COM', 81, 950167171);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1500, 'CEL', 31, 921010883);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1501, 'CEL', 81, 948980285);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1502, 'RES', 31, 907218697);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1503, 'CEL', 91, 967995734);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1504, 'CEL', 81, 981854827);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1505, 'RES', 51, 981265030);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1506, 'CEL', 51, 970266198);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1507, 'COM', 11, 978026577);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1508, 'COM', 41, 905707794);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1509, 'RES', 11, 994020723);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1510, 'CEL', 51, 911383409);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1511, 'CEL', 51, 933815790);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1512, 'COM', 71, 910067694);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1513, 'COM', 21, 997869401);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1514, 'COM', 31, 950953126);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1515, 'CEL', 51, 973279560);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1516, 'CEL', 91, 957059641);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1517, 'CEL', 81, 946156330);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1518, 'RES', 31, 903734247);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1519, 'RES', 21, 915156197);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1520, 'CEL', 91, 964790879);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1521, 'COM', 11, 913780539);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1522, 'CEL', 91, 975061301);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1523, 'CEL', 31, 969735214);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1524, 'CEL', 41, 985907464);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1525, 'COM', 11, 992119033);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1526, 'COM', 51, 966425400);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1527, 'CEL', 31, 908384780);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1528, 'COM', 41, 996464795);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1529, 'RES', 61, 912933219);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1530, 'RES', 11, 952846589);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1531, 'CEL', 61, 941967773);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1532, 'COM', 61, 978152865);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1533, 'CEL', 61, 996855352);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1534, 'COM', 51, 941595822);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1535, 'COM', 41, 983278608);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1536, 'COM', 61, 900681107);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1537, 'RES', 81, 921728915);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1538, 'RES', 61, 907724567);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1539, 'CEL', 81, 914762954);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1540, 'CEL', 81, 950397153);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1541, 'CEL', 11, 953849127);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1542, 'RES', 51, 962061935);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1543, 'COM', 21, 991224832);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1544, 'RES', 81, 972138323);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1545, 'CEL', 31, 918052518);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1546, 'COM', 11, 931737073);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1547, 'RES', 81, 928182130);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1548, 'COM', 61, 928369786);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1549, 'COM', 11, 972998157);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1550, 'RES', 21, 919117377);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1551, 'CEL', 11, 978310260);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1552, 'RES', 71, 974483137);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1553, 'CEL', 71, 967463274);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1554, 'CEL', 51, 986198975);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1555, 'RES', 81, 916622160);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1556, 'CEL', 61, 915566181);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1557, 'COM', 71, 918504555);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1558, 'RES', 11, 902055715);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1559, 'COM', 21, 983552750);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1560, 'COM', 11, 945426834);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1561, 'CEL', 81, 995091015);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1562, 'CEL', 41, 978193981);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1563, 'COM', 41, 937692619);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1564, 'RES', 11, 999447671);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1565, 'CEL', 51, 967971408);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1566, 'COM', 11, 901294563);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1567, 'RES', 21, 950946998);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1568, 'COM', 41, 961366856);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1569, 'CEL', 61, 994402300);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1570, 'CEL', 61, 909603087);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1571, 'CEL', 21, 931522398);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1572, 'COM', 21, 914244261);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1573, 'COM', 11, 927497500);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1574, 'CEL', 51, 923988409);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1575, 'RES', 51, 902083915);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1576, 'COM', 41, 909715338);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1577, 'RES', 81, 973577835);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1578, 'COM', 61, 956311679);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1579, 'CEL', 41, 906933932);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1580, 'COM', 81, 954960560);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1581, 'CEL', 71, 947016806);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1582, 'RES', 51, 943367588);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1583, 'COM', 51, 936609150);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1584, 'COM', 91, 989135304);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1585, 'CEL', 41, 990622833);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1586, 'RES', 41, 996236868);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1587, 'RES', 31, 990964002);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1588, 'RES', 51, 915721829);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1589, 'CEL', 11, 916102426);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1590, 'COM', 51, 964848068);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1591, 'COM', 51, 925931869);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1592, 'COM', 51, 901822959);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1593, 'RES', 21, 962189199);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1594, 'CEL', 81, 917269854);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1595, 'COM', 41, 947213412);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1596, 'COM', 61, 981729577);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1597, 'RES', 91, 943634353);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1598, 'CEL', 21, 951895839);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1599, 'COM', 71, 974244394);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1600, 'RES', 41, 938018149);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1601, 'RES', 61, 961863503);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1602, 'COM', 81, 961695407);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1603, 'RES', 31, 943199852);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1604, 'CEL', 31, 938299718);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1605, 'COM', 21, 991862443);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1606, 'CEL', 91, 983388203);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1607, 'COM', 41, 925535340);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1608, 'COM', 71, 957711391);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1609, 'CEL', 31, 929474605);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1610, 'CEL', 91, 918735130);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1611, 'COM', 91, 978193158);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1612, 'COM', 11, 984299510);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1613, 'CEL', 81, 978205303);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1614, 'RES', 41, 944663603);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1615, 'COM', 11, 941923792);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1616, 'COM', 81, 992710431);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1617, 'RES', 41, 910518544);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1618, 'RES', 31, 928627252);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1619, 'COM', 11, 902723881);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1620, 'RES', 51, 980567821);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1621, 'CEL', 61, 991168232);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1622, 'COM', 41, 901158421);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1623, 'COM', 31, 982440677);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1624, 'CEL', 11, 929815171);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1625, 'RES', 11, 959149336);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1626, 'CEL', 81, 988401698);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1627, 'RES', 31, 918977785);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1628, 'RES', 11, 941159519);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1629, 'COM', 51, 959871024);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1630, 'COM', 11, 903419174);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1631, 'RES', 61, 994491666);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1632, 'CEL', 31, 951656054);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1633, 'COM', 11, 939925058);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1634, 'CEL', 61, 929633191);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1635, 'CEL', 81, 932337302);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1636, 'RES', 31, 997358032);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1637, 'COM', 41, 934556346);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1638, 'COM', 61, 938681824);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1639, 'CEL', 31, 925438169);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1640, 'COM', 91, 972746175);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1641, 'CEL', 11, 906164703);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1642, 'COM', 51, 975936098);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1643, 'COM', 61, 939064130);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1644, 'CEL', 81, 990051181);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1645, 'COM', 21, 953373174);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1646, 'COM', 91, 900948655);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1647, 'CEL', 51, 993139165);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1648, 'COM', 71, 906742478);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1649, 'CEL', 41, 941592767);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1650, 'CEL', 61, 906809478);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1651, 'RES', 81, 919508296);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1652, 'CEL', 51, 960711498);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1653, 'RES', 61, 930726110);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1654, 'COM', 81, 910953978);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1655, 'CEL', 51, 988518936);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1656, 'RES', 61, 999464024);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1657, 'COM', 81, 969051306);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1658, 'CEL', 51, 918560491);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1659, 'RES', 21, 963519434);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1660, 'CEL', 81, 968061427);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1661, 'RES', 41, 924472292);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1662, 'COM', 51, 952109590);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1663, 'COM', 81, 997903822);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1664, 'CEL', 81, 929631930);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1665, 'CEL', 61, 942817476);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1666, 'CEL', 21, 936368151);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1667, 'COM', 31, 939405531);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1668, 'CEL', 11, 950128387);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1669, 'RES', 81, 926249182);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1670, 'COM', 51, 979481684);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1671, 'CEL', 81, 908438433);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1672, 'CEL', 31, 999822668);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1673, 'CEL', 61, 909562345);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1674, 'CEL', 71, 931177394);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1675, 'COM', 11, 934348053);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1676, 'CEL', 11, 917377610);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1677, 'RES', 51, 939211634);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1678, 'CEL', 31, 977093837);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1679, 'CEL', 51, 903305808);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1680, 'COM', 41, 972037111);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1681, 'CEL', 81, 943847115);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1682, 'COM', 41, 944824739);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1683, 'CEL', 71, 927977793);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1684, 'RES', 71, 952577947);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1685, 'RES', 31, 978295853);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1686, 'CEL', 71, 913246654);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1687, 'CEL', 31, 964804562);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1688, 'CEL', 51, 962275003);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1689, 'COM', 71, 910808384);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1690, 'COM', 31, 966606742);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1691, 'COM', 31, 919149727);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1692, 'COM', 51, 997855204);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1693, 'RES', 41, 939675868);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1694, 'COM', 91, 968200214);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1695, 'RES', 71, 934720268);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1696, 'COM', 91, 938042075);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1697, 'RES', 91, 958233308);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1698, 'CEL', 61, 901620641);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1699, 'COM', 81, 986515125);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1700, 'CEL', 71, 984887723);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1701, 'RES', 71, 940593489);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1702, 'RES', 11, 971494691);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1703, 'CEL', 51, 992172086);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1704, 'CEL', 51, 996130605);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1705, 'CEL', 21, 971436782);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1706, 'CEL', 41, 907726081);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1707, 'CEL', 21, 920162035);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1708, 'COM', 11, 906579570);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1709, 'CEL', 31, 944651580);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1710, 'RES', 81, 984365991);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1711, 'RES', 41, 904916706);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1712, 'COM', 21, 906337654);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1713, 'COM', 11, 964112721);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1714, 'COM', 11, 966204929);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1715, 'COM', 51, 965423279);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1716, 'CEL', 91, 955011280);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1717, 'CEL', 21, 950486365);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1718, 'RES', 91, 927362450);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1719, 'CEL', 71, 957128211);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1720, 'COM', 31, 901863459);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1721, 'RES', 71, 970896780);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1722, 'COM', 41, 986648697);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1723, 'RES', 61, 921009830);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1724, 'COM', 61, 956564338);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1725, 'RES', 11, 950585739);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1726, 'COM', 51, 997666474);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1727, 'RES', 71, 907889083);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1728, 'COM', 11, 900577176);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1729, 'CEL', 71, 953060320);
INSERT INTO telefone (id_usuario, tipo, ddd, numero) VALUES (1730, 'RES', 81, 916204117);

select * from livro;

INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 1', 'Autor 1', 1988, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 2', 'Autor 2', 2015, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 3', 'Autor 3', 2007, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 4', 'Autor 4', 1945, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 5', 'Autor 5', 1915, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 6', 'Autor 6', 1981, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 7', 'Autor 7', 1945, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 8', 'Autor 8', 1918, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 9', 'Autor 9', 2016, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 10', 'Autor 10', 1979, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 11', 'Autor 11', 1919, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 12', 'Autor 12', 1945, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 13', 'Autor 13', 2005, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 14', 'Autor 14', 2012, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 15', 'Autor 15', 1941, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 16', 'Autor 16', 2013, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 17', 'Autor 17', 1910, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 18', 'Autor 18', 1901, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 19', 'Autor 19', 1920, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 20', 'Autor 20', 1996, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 21', 'Autor 21', 2023, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 22', 'Autor 22', 1942, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 23', 'Autor 23', 1923, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 24', 'Autor 24', 1966, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 25', 'Autor 25', 1940, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 26', 'Autor 26', 1958, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 27', 'Autor 27', 1935, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 28', 'Autor 28', 1953, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 29', 'Autor 29', 1912, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 30', 'Autor 30', 2022, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 31', 'Autor 31', 1984, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 32', 'Autor 32', 1977, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 33', 'Autor 33', 2007, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 34', 'Autor 34', 1986, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 35', 'Autor 35', 1974, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 36', 'Autor 36', 1968, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 37', 'Autor 37', 1975, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 38', 'Autor 38', 1970, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 39', 'Autor 39', 1902, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 40', 'Autor 40', 1921, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 41', 'Autor 41', 1960, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 42', 'Autor 42', 1991, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 43', 'Autor 43', 1999, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 44', 'Autor 44', 1919, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 45', 'Autor 45', 1956, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 46', 'Autor 46', 1974, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 47', 'Autor 47', 1952, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 48', 'Autor 48', 1907, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 49', 'Autor 49', 1926, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 50', 'Autor 50', 1984, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 51', 'Autor 51', 2000, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 52', 'Autor 52', 2021, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 53', 'Autor 53', 2005, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 54', 'Autor 54', 2006, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 55', 'Autor 55', 1949, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 56', 'Autor 56', 2011, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 57', 'Autor 57', 1988, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 58', 'Autor 58', 1956, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 59', 'Autor 59', 1904, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 60', 'Autor 60', 1978, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 61', 'Autor 61', 1923, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 62', 'Autor 62', 2004, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 63', 'Autor 63', 1969, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 64', 'Autor 64', 1942, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 65', 'Autor 65', 1913, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 66', 'Autor 66', 1973, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 67', 'Autor 67', 1932, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 68', 'Autor 68', 1957, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 69', 'Autor 69', 1902, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 70', 'Autor 70', 2007, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 71', 'Autor 71', 2008, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 72', 'Autor 72', 1956, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 73', 'Autor 73', 1918, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 74', 'Autor 74', 1954, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 75', 'Autor 75', 1979, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 76', 'Autor 76', 1990, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 77', 'Autor 77', 1947, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 78', 'Autor 78', 1980, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 79', 'Autor 79', 1909, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 80', 'Autor 80', 1952, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 81', 'Autor 81', 1964, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 82', 'Autor 82', 1992, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 83', 'Autor 83', 2002, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 84', 'Autor 84', 1951, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 85', 'Autor 85', 2018, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 86', 'Autor 86', 1930, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 87', 'Autor 87', 1924, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 88', 'Autor 88', 1982, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 89', 'Autor 89', 1977, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 90', 'Autor 90', 1951, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 91', 'Autor 91', 1907, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 92', 'Autor 92', 1988, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 93', 'Autor 93', 1902, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 94', 'Autor 94', 1973, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 95', 'Autor 95', 1955, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 96', 'Autor 96', 1979, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 97', 'Autor 97', 1965, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 98', 'Autor 98', 1948, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 99', 'Autor 99', 1903, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 100', 'Autor 100', 1936, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 101', 'Autor 101', 1947, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 102', 'Autor 102', 1983, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 103', 'Autor 103', 1915, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 104', 'Autor 104', 1901, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 105', 'Autor 105', 1930, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 106', 'Autor 106', 2001, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 107', 'Autor 107', 1943, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 108', 'Autor 108', 1983, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 109', 'Autor 109', 2017, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 110', 'Autor 110', 1923, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 111', 'Autor 111', 1987, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 112', 'Autor 112', 1981, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 113', 'Autor 113', 1981, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 114', 'Autor 114', 1960, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 115', 'Autor 115', 1962, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 116', 'Autor 116', 2007, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 117', 'Autor 117', 1954, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 118', 'Autor 118', 1929, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 119', 'Autor 119', 1907, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 120', 'Autor 120', 2007, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 121', 'Autor 121', 1992, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 122', 'Autor 122', 1969, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 123', 'Autor 123', 1963, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 124', 'Autor 124', 1903, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 125', 'Autor 125', 1920, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 126', 'Autor 126', 1903, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 127', 'Autor 127', 1964, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 128', 'Autor 128', 1938, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 129', 'Autor 129', 2018, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 130', 'Autor 130', 2004, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 131', 'Autor 131', 1958, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 132', 'Autor 132', 1966, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 133', 'Autor 133', 1974, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 134', 'Autor 134', 1908, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 135', 'Autor 135', 2022, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 136', 'Autor 136', 1909, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 137', 'Autor 137', 1911, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 138', 'Autor 138', 1988, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 139', 'Autor 139', 2020, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 140', 'Autor 140', 1902, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 141', 'Autor 141', 1962, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 142', 'Autor 142', 1949, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 143', 'Autor 143', 2002, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 144', 'Autor 144', 1901, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 145', 'Autor 145', 1925, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 146', 'Autor 146', 2007, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 147', 'Autor 147', 1904, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 148', 'Autor 148', 1962, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 149', 'Autor 149', 1977, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 150', 'Autor 150', 2017, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 151', 'Autor 151', 1956, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 152', 'Autor 152', 1962, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 153', 'Autor 153', 1994, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 154', 'Autor 154', 1942, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 155', 'Autor 155', 1943, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 156', 'Autor 156', 1936, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 157', 'Autor 157', 2017, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 158', 'Autor 158', 1999, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 159', 'Autor 159', 1981, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 160', 'Autor 160', 1978, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 161', 'Autor 161', 1978, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 162', 'Autor 162', 1905, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 163', 'Autor 163', 1952, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 164', 'Autor 164', 1912, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 165', 'Autor 165', 1949, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 166', 'Autor 166', 1914, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 167', 'Autor 167', 2003, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 168', 'Autor 168', 1932, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 169', 'Autor 169', 1980, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 170', 'Autor 170', 1992, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 171', 'Autor 171', 1996, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 172', 'Autor 172', 1955, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 173', 'Autor 173', 1970, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 174', 'Autor 174', 1932, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 175', 'Autor 175', 1992, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 176', 'Autor 176', 1948, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 177', 'Autor 177', 1924, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 178', 'Autor 178', 1978, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 179', 'Autor 179', 1926, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 180', 'Autor 180', 2000, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 181', 'Autor 181', 2017, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 182', 'Autor 182', 1989, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 183', 'Autor 183', 1930, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 184', 'Autor 184', 1966, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 185', 'Autor 185', 2009, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 186', 'Autor 186', 1986, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 187', 'Autor 187', 1966, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 188', 'Autor 188', 1983, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 189', 'Autor 189', 1945, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 190', 'Autor 190', 1977, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 191', 'Autor 191', 2022, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 192', 'Autor 192', 1998, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 193', 'Autor 193', 1997, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 194', 'Autor 194', 2010, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 195', 'Autor 195', 1903, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 196', 'Autor 196', 1919, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 197', 'Autor 197', 1968, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 198', 'Autor 198', 1945, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 199', 'Autor 199', 1901, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 200', 'Autor 200', 1950, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 201', 'Autor 201', 1900, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 202', 'Autor 202', 1969, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 203', 'Autor 203', 1977, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 204', 'Autor 204', 1915, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 205', 'Autor 205', 1916, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 206', 'Autor 206', 1942, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 207', 'Autor 207', 1991, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 208', 'Autor 208', 1909, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 209', 'Autor 209', 1943, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 210', 'Autor 210', 1905, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 211', 'Autor 211', 1970, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 212', 'Autor 212', 1985, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 213', 'Autor 213', 2019, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 214', 'Autor 214', 2001, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 215', 'Autor 215', 1960, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 216', 'Autor 216', 1958, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 217', 'Autor 217', 1964, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 218', 'Autor 218', 1945, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 219', 'Autor 219', 2019, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 220', 'Autor 220', 2013, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 221', 'Autor 221', 1915, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 222', 'Autor 222', 1955, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 223', 'Autor 223', 1916, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 224', 'Autor 224', 1911, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 225', 'Autor 225', 1956, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 226', 'Autor 226', 1901, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 227', 'Autor 227', 1901, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 228', 'Autor 228', 1907, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 229', 'Autor 229', 2011, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 230', 'Autor 230', 1971, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 231', 'Autor 231', 1966, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 232', 'Autor 232', 1967, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 233', 'Autor 233', 1991, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 234', 'Autor 234', 2017, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 235', 'Autor 235', 1982, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 236', 'Autor 236', 2021, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 237', 'Autor 237', 1908, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 238', 'Autor 238', 1937, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 239', 'Autor 239', 2013, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 240', 'Autor 240', 2004, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 241', 'Autor 241', 2013, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 242', 'Autor 242', 1988, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 243', 'Autor 243', 1974, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 244', 'Autor 244', 1900, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 245', 'Autor 245', 1936, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 246', 'Autor 246', 1989, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 247', 'Autor 247', 1986, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 248', 'Autor 248', 1996, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 249', 'Autor 249', 2004, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 250', 'Autor 250', 1926, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 251', 'Autor 251', 1957, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 252', 'Autor 252', 1924, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 253', 'Autor 253', 1927, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 254', 'Autor 254', 1983, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 255', 'Autor 255', 1986, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 256', 'Autor 256', 1991, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 257', 'Autor 257', 1927, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 258', 'Autor 258', 2007, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 259', 'Autor 259', 1916, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 260', 'Autor 260', 1964, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 261', 'Autor 261', 1970, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 262', 'Autor 262', 1976, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 263', 'Autor 263', 1928, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 264', 'Autor 264', 1952, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 265', 'Autor 265', 2021, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 266', 'Autor 266', 1939, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 267', 'Autor 267', 1999, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 268', 'Autor 268', 1906, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 269', 'Autor 269', 1955, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 270', 'Autor 270', 1921, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 271', 'Autor 271', 1947, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 272', 'Autor 272', 1991, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 273', 'Autor 273', 1978, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 274', 'Autor 274', 1904, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 275', 'Autor 275', 1900, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 276', 'Autor 276', 1953, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 277', 'Autor 277', 1972, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 278', 'Autor 278', 1973, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 279', 'Autor 279', 1926, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 280', 'Autor 280', 1937, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 281', 'Autor 281', 1909, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 282', 'Autor 282', 1934, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 283', 'Autor 283', 1925, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 284', 'Autor 284', 1922, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 285', 'Autor 285', 1945, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 286', 'Autor 286', 2016, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 287', 'Autor 287', 2021, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 288', 'Autor 288', 2001, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 289', 'Autor 289', 1991, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 290', 'Autor 290', 2014, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 291', 'Autor 291', 1976, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 292', 'Autor 292', 1934, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 293', 'Autor 293', 1905, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 294', 'Autor 294', 1975, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 295', 'Autor 295', 1938, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 296', 'Autor 296', 2016, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 297', 'Autor 297', 1962, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 298', 'Autor 298', 1928, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 299', 'Autor 299', 1916, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 300', 'Autor 300', 1994, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 301', 'Autor 301', 1909, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 302', 'Autor 302', 1988, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 303', 'Autor 303', 1953, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 304', 'Autor 304', 1920, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 305', 'Autor 305', 1932, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 306', 'Autor 306', 1995, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 307', 'Autor 307', 1925, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 308', 'Autor 308', 1946, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 309', 'Autor 309', 1917, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 310', 'Autor 310', 1909, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 311', 'Autor 311', 2010, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 312', 'Autor 312', 1969, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 313', 'Autor 313', 2012, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 314', 'Autor 314', 1999, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 315', 'Autor 315', 1984, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 316', 'Autor 316', 1952, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 317', 'Autor 317', 1900, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 318', 'Autor 318', 1979, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 319', 'Autor 319', 1919, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 320', 'Autor 320', 2010, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 321', 'Autor 321', 1939, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 322', 'Autor 322', 1961, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 323', 'Autor 323', 1909, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 324', 'Autor 324', 1967, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 325', 'Autor 325', 1973, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 326', 'Autor 326', 1905, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 327', 'Autor 327', 2003, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 328', 'Autor 328', 2019, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 329', 'Autor 329', 1938, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 330', 'Autor 330', 2007, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 331', 'Autor 331', 1910, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 332', 'Autor 332', 1916, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 333', 'Autor 333', 1991, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 334', 'Autor 334', 2018, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 335', 'Autor 335', 1977, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 336', 'Autor 336', 1986, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 337', 'Autor 337', 1976, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 338', 'Autor 338', 1902, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 339', 'Autor 339', 1994, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 340', 'Autor 340', 1940, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 341', 'Autor 341', 1905, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 342', 'Autor 342', 1904, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 343', 'Autor 343', 1995, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 344', 'Autor 344', 1935, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 345', 'Autor 345', 1924, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 346', 'Autor 346', 1942, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 347', 'Autor 347', 2014, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 348', 'Autor 348', 1937, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 349', 'Autor 349', 1920, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 350', 'Autor 350', 2006, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 351', 'Autor 351', 2021, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 352', 'Autor 352', 1986, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 353', 'Autor 353', 1985, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 354', 'Autor 354', 1978, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 355', 'Autor 355', 1932, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 356', 'Autor 356', 1993, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 357', 'Autor 357', 1961, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 358', 'Autor 358', 2011, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 359', 'Autor 359', 1909, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 360', 'Autor 360', 1965, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 361', 'Autor 361', 2011, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 362', 'Autor 362', 2021, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 363', 'Autor 363', 1911, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 364', 'Autor 364', 1915, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 365', 'Autor 365', 1922, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 366', 'Autor 366', 2006, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 367', 'Autor 367', 1910, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 368', 'Autor 368', 1991, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 369', 'Autor 369', 1955, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 370', 'Autor 370', 1930, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 371', 'Autor 371', 1980, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 372', 'Autor 372', 1993, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 373', 'Autor 373', 2008, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 374', 'Autor 374', 1981, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 375', 'Autor 375', 1987, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 376', 'Autor 376', 2018, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 377', 'Autor 377', 1976, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 378', 'Autor 378', 1939, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 379', 'Autor 379', 1930, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 380', 'Autor 380', 2007, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 381', 'Autor 381', 1946, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 382', 'Autor 382', 1965, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 383', 'Autor 383', 1930, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 384', 'Autor 384', 1955, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 385', 'Autor 385', 1978, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 386', 'Autor 386', 1934, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 387', 'Autor 387', 2000, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 388', 'Autor 388', 1981, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 389', 'Autor 389', 1975, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 390', 'Autor 390', 1959, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 391', 'Autor 391', 1935, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 392', 'Autor 392', 2009, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 393', 'Autor 393', 1951, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 394', 'Autor 394', 1942, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 395', 'Autor 395', 2006, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 396', 'Autor 396', 2005, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 397', 'Autor 397', 1982, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 398', 'Autor 398', 1996, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 399', 'Autor 399', 1913, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 400', 'Autor 400', 1938, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 401', 'Autor 401', 1972, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 402', 'Autor 402', 1975, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 403', 'Autor 403', 1963, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 404', 'Autor 404', 1962, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 405', 'Autor 405', 1915, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 406', 'Autor 406', 2023, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 407', 'Autor 407', 1991, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 408', 'Autor 408', 2022, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 409', 'Autor 409', 1935, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 410', 'Autor 410', 1941, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 411', 'Autor 411', 1903, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 412', 'Autor 412', 1940, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 413', 'Autor 413', 2017, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 414', 'Autor 414', 1968, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 415', 'Autor 415', 1910, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 416', 'Autor 416', 1929, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 417', 'Autor 417', 1975, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 418', 'Autor 418', 1976, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 419', 'Autor 419', 1952, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 420', 'Autor 420', 1970, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 421', 'Autor 421', 2020, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 422', 'Autor 422', 1947, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 423', 'Autor 423', 1941, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 424', 'Autor 424', 1910, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 425', 'Autor 425', 1902, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 426', 'Autor 426', 2017, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 427', 'Autor 427', 1971, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 428', 'Autor 428', 1954, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 429', 'Autor 429', 1970, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 430', 'Autor 430', 1993, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 431', 'Autor 431', 2019, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 432', 'Autor 432', 2012, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 433', 'Autor 433', 1904, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 434', 'Autor 434', 1923, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 435', 'Autor 435', 1917, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 436', 'Autor 436', 2002, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 437', 'Autor 437', 1986, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 438', 'Autor 438', 1980, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 439', 'Autor 439', 1912, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 440', 'Autor 440', 2018, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 441', 'Autor 441', 1962, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 442', 'Autor 442', 1976, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 443', 'Autor 443', 2006, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 444', 'Autor 444', 1910, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 445', 'Autor 445', 1927, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 446', 'Autor 446', 1900, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 447', 'Autor 447', 1993, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 448', 'Autor 448', 1968, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 449', 'Autor 449', 1996, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 450', 'Autor 450', 1984, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 451', 'Autor 451', 1915, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 452', 'Autor 452', 1917, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 453', 'Autor 453', 1934, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 454', 'Autor 454', 2013, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 455', 'Autor 455', 1908, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 456', 'Autor 456', 1963, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 457', 'Autor 457', 1944, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 458', 'Autor 458', 1950, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 459', 'Autor 459', 1908, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 460', 'Autor 460', 1943, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 461', 'Autor 461', 1956, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 462', 'Autor 462', 1968, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 463', 'Autor 463', 1938, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 464', 'Autor 464', 1985, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 465', 'Autor 465', 1940, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 466', 'Autor 466', 2004, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 467', 'Autor 467', 2014, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 468', 'Autor 468', 1929, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 469', 'Autor 469', 1945, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 470', 'Autor 470', 1994, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 471', 'Autor 471', 1978, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 472', 'Autor 472', 1989, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 473', 'Autor 473', 2001, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 474', 'Autor 474', 1913, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 475', 'Autor 475', 1940, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 476', 'Autor 476', 1972, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 477', 'Autor 477', 1957, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 478', 'Autor 478', 1917, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 479', 'Autor 479', 1967, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 480', 'Autor 480', 1939, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 481', 'Autor 481', 1906, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 482', 'Autor 482', 1965, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 483', 'Autor 483', 1975, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 484', 'Autor 484', 1940, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 485', 'Autor 485', 2016, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 486', 'Autor 486', 1998, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 487', 'Autor 487', 1967, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 488', 'Autor 488', 1928, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 489', 'Autor 489', 2005, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 490', 'Autor 490', 1993, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 491', 'Autor 491', 1908, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 492', 'Autor 492', 1953, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 493', 'Autor 493', 1973, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 494', 'Autor 494', 2018, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 495', 'Autor 495', 1911, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 496', 'Autor 496', 1964, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 497', 'Autor 497', 2018, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 498', 'Autor 498', 1956, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 499', 'Autor 499', 1900, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 500', 'Autor 500', 1908, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 501', 'Autor 501', 2015, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 502', 'Autor 502', 1947, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 503', 'Autor 503', 1923, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 504', 'Autor 504', 1937, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 505', 'Autor 505', 1911, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 506', 'Autor 506', 2018, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 507', 'Autor 507', 1933, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 508', 'Autor 508', 1947, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 509', 'Autor 509', 1993, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 510', 'Autor 510', 1981, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 511', 'Autor 511', 1940, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 512', 'Autor 512', 2003, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 513', 'Autor 513', 1988, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 514', 'Autor 514', 1940, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 515', 'Autor 515', 1992, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 516', 'Autor 516', 1934, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 517', 'Autor 517', 1997, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 518', 'Autor 518', 1996, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 519', 'Autor 519', 2002, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 520', 'Autor 520', 1977, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 521', 'Autor 521', 1906, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 522', 'Autor 522', 1984, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 523', 'Autor 523', 2005, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 524', 'Autor 524', 2013, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 525', 'Autor 525', 1902, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 526', 'Autor 526', 1948, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 527', 'Autor 527', 1998, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 528', 'Autor 528', 1950, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 529', 'Autor 529', 1942, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 530', 'Autor 530', 1940, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 531', 'Autor 531', 1910, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 532', 'Autor 532', 1929, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 533', 'Autor 533', 1985, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 534', 'Autor 534', 1943, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 535', 'Autor 535', 1986, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 536', 'Autor 536', 1929, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 537', 'Autor 537', 2017, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 538', 'Autor 538', 2008, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 539', 'Autor 539', 2004, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 540', 'Autor 540', 1941, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 541', 'Autor 541', 2011, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 542', 'Autor 542', 1917, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 543', 'Autor 543', 1925, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 544', 'Autor 544', 2017, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 545', 'Autor 545', 1972, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 546', 'Autor 546', 1950, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 547', 'Autor 547', 1989, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 548', 'Autor 548', 1902, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 549', 'Autor 549', 1913, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 550', 'Autor 550', 2020, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 551', 'Autor 551', 1963, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 552', 'Autor 552', 1922, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 553', 'Autor 553', 1916, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 554', 'Autor 554', 1996, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 555', 'Autor 555', 1942, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 556', 'Autor 556', 2020, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 557', 'Autor 557', 1993, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 558', 'Autor 558', 2020, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 559', 'Autor 559', 2004, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 560', 'Autor 560', 1961, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 561', 'Autor 561', 1999, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 562', 'Autor 562', 1906, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 563', 'Autor 563', 1927, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 564', 'Autor 564', 1960, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 565', 'Autor 565', 1949, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 566', 'Autor 566', 1924, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 567', 'Autor 567', 2015, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 568', 'Autor 568', 2016, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 569', 'Autor 569', 2002, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 570', 'Autor 570', 1920, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 571', 'Autor 571', 1988, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 572', 'Autor 572', 1998, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 573', 'Autor 573', 1948, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 574', 'Autor 574', 2013, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 575', 'Autor 575', 2006, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 576', 'Autor 576', 1974, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 577', 'Autor 577', 1980, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 578', 'Autor 578', 1904, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 579', 'Autor 579', 1993, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 580', 'Autor 580', 1983, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 581', 'Autor 581', 2015, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 582', 'Autor 582', 1964, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 583', 'Autor 583', 1947, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 584', 'Autor 584', 1903, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 585', 'Autor 585', 1986, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 586', 'Autor 586', 1996, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 587', 'Autor 587', 1976, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 588', 'Autor 588', 1923, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 589', 'Autor 589', 1965, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 590', 'Autor 590', 2003, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 591', 'Autor 591', 1993, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 592', 'Autor 592', 1911, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 593', 'Autor 593', 2019, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 594', 'Autor 594', 1956, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 595', 'Autor 595', 1944, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 596', 'Autor 596', 1983, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 597', 'Autor 597', 1949, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 598', 'Autor 598', 1945, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 599', 'Autor 599', 1929, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 600', 'Autor 600', 2001, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 601', 'Autor 601', 1989, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 602', 'Autor 602', 1988, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 603', 'Autor 603', 1999, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 604', 'Autor 604', 2000, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 605', 'Autor 605', 1960, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 606', 'Autor 606', 2021, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 607', 'Autor 607', 1984, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 608', 'Autor 608', 1921, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 609', 'Autor 609', 1900, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 610', 'Autor 610', 1918, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 611', 'Autor 611', 1949, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 612', 'Autor 612', 1953, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 613', 'Autor 613', 1936, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 614', 'Autor 614', 2023, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 615', 'Autor 615', 2021, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 616', 'Autor 616', 2009, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 617', 'Autor 617', 1975, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 618', 'Autor 618', 1975, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 619', 'Autor 619', 1946, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 620', 'Autor 620', 1931, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 621', 'Autor 621', 2009, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 622', 'Autor 622', 1999, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 623', 'Autor 623', 2012, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 624', 'Autor 624', 1985, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 625', 'Autor 625', 1930, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 626', 'Autor 626', 1949, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 627', 'Autor 627', 2021, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 628', 'Autor 628', 1902, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 629', 'Autor 629', 2014, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 630', 'Autor 630', 1975, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 631', 'Autor 631', 1918, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 632', 'Autor 632', 1922, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 633', 'Autor 633', 2023, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 634', 'Autor 634', 1939, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 635', 'Autor 635', 1980, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 636', 'Autor 636', 2013, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 637', 'Autor 637', 1995, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 638', 'Autor 638', 2014, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 639', 'Autor 639', 1949, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 640', 'Autor 640', 1919, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 641', 'Autor 641', 1977, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 642', 'Autor 642', 1955, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 643', 'Autor 643', 2001, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 644', 'Autor 644', 1981, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 645', 'Autor 645', 1938, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 646', 'Autor 646', 2000, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 647', 'Autor 647', 1943, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 648', 'Autor 648', 1933, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 649', 'Autor 649', 1969, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 650', 'Autor 650', 2015, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 651', 'Autor 651', 2004, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 652', 'Autor 652', 1919, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 653', 'Autor 653', 1972, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 654', 'Autor 654', 1906, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 655', 'Autor 655', 1978, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 656', 'Autor 656', 1997, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 657', 'Autor 657', 1966, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 658', 'Autor 658', 1996, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 659', 'Autor 659', 1969, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 660', 'Autor 660', 2021, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 661', 'Autor 661', 1928, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 662', 'Autor 662', 1949, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 663', 'Autor 663', 1992, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 664', 'Autor 664', 1993, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 665', 'Autor 665', 1920, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 666', 'Autor 666', 1980, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 667', 'Autor 667', 1983, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 668', 'Autor 668', 1933, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 669', 'Autor 669', 1922, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 670', 'Autor 670', 1989, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 671', 'Autor 671', 2001, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 672', 'Autor 672', 1963, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 673', 'Autor 673', 1995, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 674', 'Autor 674', 1924, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 675', 'Autor 675', 2010, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 676', 'Autor 676', 2022, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 677', 'Autor 677', 1997, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 678', 'Autor 678', 2013, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 679', 'Autor 679', 1924, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 680', 'Autor 680', 1913, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 681', 'Autor 681', 2020, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 682', 'Autor 682', 1960, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 683', 'Autor 683', 1933, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 684', 'Autor 684', 1903, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 685', 'Autor 685', 2022, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 686', 'Autor 686', 1976, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 687', 'Autor 687', 1967, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 688', 'Autor 688', 1941, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 689', 'Autor 689', 1968, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 690', 'Autor 690', 1925, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 691', 'Autor 691', 1912, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 692', 'Autor 692', 1998, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 693', 'Autor 693', 1916, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 694', 'Autor 694', 1901, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 695', 'Autor 695', 1959, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 696', 'Autor 696', 1970, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 697', 'Autor 697', 1980, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 698', 'Autor 698', 1967, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 699', 'Autor 699', 2012, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 700', 'Autor 700', 1990, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 701', 'Autor 701', 1973, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 702', 'Autor 702', 1971, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 703', 'Autor 703', 1992, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 704', 'Autor 704', 1934, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 705', 'Autor 705', 1951, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 706', 'Autor 706', 2015, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 707', 'Autor 707', 1974, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 708', 'Autor 708', 2019, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 709', 'Autor 709', 1994, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 710', 'Autor 710', 1901, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 711', 'Autor 711', 1985, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 712', 'Autor 712', 2005, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 713', 'Autor 713', 2023, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 714', 'Autor 714', 1990, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 715', 'Autor 715', 1927, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 716', 'Autor 716', 1909, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 717', 'Autor 717', 2014, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 718', 'Autor 718', 1942, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 719', 'Autor 719', 2014, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 720', 'Autor 720', 1961, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 721', 'Autor 721', 2018, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 722', 'Autor 722', 2012, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 723', 'Autor 723', 1929, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 724', 'Autor 724', 2012, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 725', 'Autor 725', 1995, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 726', 'Autor 726', 1913, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 727', 'Autor 727', 1983, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 728', 'Autor 728', 1933, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 729', 'Autor 729', 1942, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 730', 'Autor 730', 1992, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 731', 'Autor 731', 1977, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 732', 'Autor 732', 1985, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 733', 'Autor 733', 1929, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 734', 'Autor 734', 1984, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 735', 'Autor 735', 1916, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 736', 'Autor 736', 1936, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 737', 'Autor 737', 1918, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 738', 'Autor 738', 1923, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 739', 'Autor 739', 1996, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 740', 'Autor 740', 1981, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 741', 'Autor 741', 2009, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 742', 'Autor 742', 1968, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 743', 'Autor 743', 2005, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 744', 'Autor 744', 2004, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 745', 'Autor 745', 2019, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 746', 'Autor 746', 2012, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 747', 'Autor 747', 2016, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 748', 'Autor 748', 1926, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 749', 'Autor 749', 1966, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 750', 'Autor 750', 1913, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 751', 'Autor 751', 1982, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 752', 'Autor 752', 1972, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 753', 'Autor 753', 1933, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 754', 'Autor 754', 1981, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 755', 'Autor 755', 1999, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 756', 'Autor 756', 1946, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 757', 'Autor 757', 1928, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 758', 'Autor 758', 2009, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 759', 'Autor 759', 1967, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 760', 'Autor 760', 1992, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 761', 'Autor 761', 1977, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 762', 'Autor 762', 2002, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 763', 'Autor 763', 2014, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 764', 'Autor 764', 1954, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 765', 'Autor 765', 1914, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 766', 'Autor 766', 2003, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 767', 'Autor 767', 1991, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 768', 'Autor 768', 1990, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 769', 'Autor 769', 2012, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 770', 'Autor 770', 1917, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 771', 'Autor 771', 1935, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 772', 'Autor 772', 1903, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 773', 'Autor 773', 2003, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 774', 'Autor 774', 2006, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 775', 'Autor 775', 1927, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 776', 'Autor 776', 1909, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 777', 'Autor 777', 1938, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 778', 'Autor 778', 1988, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 779', 'Autor 779', 1987, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 780', 'Autor 780', 2016, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 781', 'Autor 781', 2000, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 782', 'Autor 782', 1991, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 783', 'Autor 783', 2009, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 784', 'Autor 784', 1956, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 785', 'Autor 785', 1936, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 786', 'Autor 786', 1927, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 787', 'Autor 787', 1901, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 788', 'Autor 788', 1994, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 789', 'Autor 789', 1974, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 790', 'Autor 790', 2005, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 791', 'Autor 791', 1904, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 792', 'Autor 792', 1988, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 793', 'Autor 793', 1951, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 794', 'Autor 794', 1939, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 795', 'Autor 795', 1921, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 796', 'Autor 796', 1922, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 797', 'Autor 797', 1910, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 798', 'Autor 798', 1947, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 799', 'Autor 799', 1972, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 800', 'Autor 800', 1998, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 801', 'Autor 801', 1972, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 802', 'Autor 802', 1956, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 803', 'Autor 803', 1935, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 804', 'Autor 804', 1947, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 805', 'Autor 805', 1929, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 806', 'Autor 806', 1911, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 807', 'Autor 807', 1923, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 808', 'Autor 808', 1977, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 809', 'Autor 809', 2013, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 810', 'Autor 810', 1990, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 811', 'Autor 811', 1959, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 812', 'Autor 812', 1963, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 813', 'Autor 813', 1928, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 814', 'Autor 814', 1913, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 815', 'Autor 815', 1926, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 816', 'Autor 816', 1962, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 817', 'Autor 817', 1957, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 818', 'Autor 818', 1933, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 819', 'Autor 819', 1982, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 820', 'Autor 820', 1913, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 821', 'Autor 821', 1937, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 822', 'Autor 822', 1995, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 823', 'Autor 823', 1973, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 824', 'Autor 824', 1956, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 825', 'Autor 825', 1936, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 826', 'Autor 826', 1971, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 827', 'Autor 827', 1909, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 828', 'Autor 828', 2008, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 829', 'Autor 829', 1938, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 830', 'Autor 830', 1925, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 831', 'Autor 831', 1915, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 832', 'Autor 832', 1921, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 833', 'Autor 833', 1967, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 834', 'Autor 834', 1910, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 835', 'Autor 835', 1916, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 836', 'Autor 836', 1912, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 837', 'Autor 837', 2005, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 838', 'Autor 838', 1985, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 839', 'Autor 839', 1962, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 840', 'Autor 840', 1938, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 841', 'Autor 841', 2003, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 842', 'Autor 842', 1940, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 843', 'Autor 843', 2002, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 844', 'Autor 844', 1911, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 845', 'Autor 845', 2020, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 846', 'Autor 846', 1943, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 847', 'Autor 847', 1985, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 848', 'Autor 848', 1938, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 849', 'Autor 849', 2007, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 850', 'Autor 850', 1938, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 851', 'Autor 851', 2002, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 852', 'Autor 852', 1961, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 853', 'Autor 853', 1956, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 854', 'Autor 854', 1955, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 855', 'Autor 855', 1900, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 856', 'Autor 856', 1928, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 857', 'Autor 857', 1932, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 858', 'Autor 858', 1953, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 859', 'Autor 859', 2009, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 860', 'Autor 860', 1945, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 861', 'Autor 861', 1944, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 862', 'Autor 862', 1944, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 863', 'Autor 863', 1970, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 864', 'Autor 864', 1936, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 865', 'Autor 865', 1918, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 866', 'Autor 866', 2014, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 867', 'Autor 867', 1997, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 868', 'Autor 868', 1911, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 869', 'Autor 869', 1945, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 870', 'Autor 870', 1945, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 871', 'Autor 871', 1994, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 872', 'Autor 872', 1981, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 873', 'Autor 873', 2006, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 874', 'Autor 874', 1963, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 875', 'Autor 875', 1973, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 876', 'Autor 876', 1923, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 877', 'Autor 877', 1915, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 878', 'Autor 878', 1922, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 879', 'Autor 879', 1994, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 880', 'Autor 880', 1908, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 881', 'Autor 881', 1910, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 882', 'Autor 882', 1983, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 883', 'Autor 883', 1996, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 884', 'Autor 884', 1922, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 885', 'Autor 885', 1959, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 886', 'Autor 886', 1946, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 887', 'Autor 887', 2019, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 888', 'Autor 888', 1907, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 889', 'Autor 889', 1987, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 890', 'Autor 890', 2009, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 891', 'Autor 891', 1973, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 892', 'Autor 892', 1973, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 893', 'Autor 893', 1989, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 894', 'Autor 894', 1981, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 895', 'Autor 895', 1988, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 896', 'Autor 896', 1924, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 897', 'Autor 897', 2020, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 898', 'Autor 898', 1954, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 899', 'Autor 899', 1938, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 900', 'Autor 900', 2011, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 901', 'Autor 901', 2022, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 902', 'Autor 902', 1941, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 903', 'Autor 903', 1920, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 904', 'Autor 904', 2020, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 905', 'Autor 905', 1915, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 906', 'Autor 906', 1929, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 907', 'Autor 907', 1956, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 908', 'Autor 908', 1954, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 909', 'Autor 909', 2000, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 910', 'Autor 910', 1925, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 911', 'Autor 911', 1979, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 912', 'Autor 912', 1975, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 913', 'Autor 913', 1985, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 914', 'Autor 914', 1989, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 915', 'Autor 915', 1990, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 916', 'Autor 916', 1980, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 917', 'Autor 917', 1958, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 918', 'Autor 918', 1974, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 919', 'Autor 919', 1956, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 920', 'Autor 920', 1934, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 921', 'Autor 921', 2016, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 922', 'Autor 922', 1923, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 923', 'Autor 923', 1936, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 924', 'Autor 924', 1939, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 925', 'Autor 925', 1937, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 926', 'Autor 926', 1983, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 927', 'Autor 927', 1954, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 928', 'Autor 928', 2015, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 929', 'Autor 929', 1965, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 930', 'Autor 930', 1973, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 931', 'Autor 931', 2011, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 932', 'Autor 932', 1951, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 933', 'Autor 933', 1978, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 934', 'Autor 934', 1956, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 935', 'Autor 935', 1999, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 936', 'Autor 936', 2016, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 937', 'Autor 937', 1908, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 938', 'Autor 938', 1989, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 939', 'Autor 939', 1920, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 940', 'Autor 940', 1927, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 941', 'Autor 941', 2008, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 942', 'Autor 942', 1945, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 943', 'Autor 943', 1901, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 944', 'Autor 944', 1975, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 945', 'Autor 945', 1963, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 946', 'Autor 946', 1953, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 947', 'Autor 947', 1901, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 948', 'Autor 948', 1969, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 949', 'Autor 949', 1936, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 950', 'Autor 950', 1924, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 951', 'Autor 951', 1977, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 952', 'Autor 952', 1923, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 953', 'Autor 953', 1976, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 954', 'Autor 954', 1960, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 955', 'Autor 955', 1990, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 956', 'Autor 956', 1977, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 957', 'Autor 957', 2010, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 958', 'Autor 958', 1914, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 959', 'Autor 959', 1944, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 960', 'Autor 960', 2019, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 961', 'Autor 961', 1951, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 962', 'Autor 962', 1952, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 963', 'Autor 963', 2002, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 964', 'Autor 964', 1995, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 965', 'Autor 965', 1985, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 966', 'Autor 966', 1908, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 967', 'Autor 967', 1909, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 968', 'Autor 968', 1906, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 969', 'Autor 969', 1990, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 970', 'Autor 970', 1925, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 971', 'Autor 971', 2022, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 972', 'Autor 972', 1998, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 973', 'Autor 973', 1955, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 974', 'Autor 974', 2022, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 975', 'Autor 975', 1980, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 976', 'Autor 976', 1942, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 977', 'Autor 977', 1911, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 978', 'Autor 978', 1952, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 979', 'Autor 979', 1914, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 980', 'Autor 980', 1971, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 981', 'Autor 981', 2019, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 982', 'Autor 982', 2010, 'Science Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 983', 'Autor 983', 2008, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 984', 'Autor 984', 2014, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 985', 'Autor 985', 1952, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 986', 'Autor 986', 1977, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 987', 'Autor 987', 1947, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 988', 'Autor 988', 2012, 'Non-fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 989', 'Autor 989', 1917, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 990', 'Autor 990', 2023, 'Romance');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 991', 'Autor 991', 1999, 'Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 992', 'Autor 992', 2014, 'Biography');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 993', 'Autor 993', 1980, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 994', 'Autor 994', 1907, 'Fantasy');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 995', 'Autor 995', 2014, 'Historical Fiction');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 996', 'Autor 996', 1938, 'Mystery');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 997', 'Autor 997', 2015, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 998', 'Autor 998', 1921, 'Thriller');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 999', 'Autor 999', 2023, 'Horror');
INSERT INTO livro (titulo, autor, ano_publicacao, genero) VALUES ('Livro 1000', 'Autor 1000', 1932, 'Horror');

select * from emprestimo e ;

select * from livro l ;

INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1123, 680, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (765, 405, '2024-07-05', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1388, 82, '2024-07-10', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1420, 790, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1232, 256, '2024-06-16', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1521, 983, '2024-07-13', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1632, 79, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1365, 895, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1456, 593, '2024-06-25', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1366, 190, '2024-06-17', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (877, 153, '2024-06-15', '2024-06-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1436, 488, '2024-07-12', '2024-07-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1391, 729, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (881, 790, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (892, 301, '2024-06-21', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1040, 424, '2024-06-29', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1339, 829, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (789, 464, '2024-07-11', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (828, 502, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1538, 308, '2024-07-12', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1673, 170, '2024-06-30', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (971, 81, '2024-06-22', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1383, 808, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1036, 797, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1579, 791, '2024-07-05', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (900, 350, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1469, 422, '2024-07-06', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1625, 844, '2024-06-23', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (814, 601, '2024-06-17', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1728, 283, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1052, 981, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1307, 469, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1275, 960, '2024-06-27', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1520, 976, '2024-06-17', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1106, 86, '2024-07-11', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (749, 76, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (927, 286, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1079, 100, '2024-07-10', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1348, 671, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1029, 254, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1247, 194, '2024-06-21', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1238, 343, '2024-06-16', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (893, 733, '2024-06-20', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (809, 853, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1629, 555, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1544, 956, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1716, 845, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (763, 1042, '2024-07-05', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1555, 522, '2024-07-12', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1558, 621, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1122, 785, '2024-06-22', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (849, 704, '2024-06-21', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (944, 81, '2024-06-24', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (794, 1028, '2024-06-17', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1431, 745, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (961, 1023, '2024-06-16', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (899, 472, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (991, 799, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (809, 394, '2024-06-23', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1469, 745, '2024-06-23', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (736, 74, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1194, 898, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1384, 133, '2024-07-03', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1716, 762, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (921, 469, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (772, 897, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1710, 845, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1265, 1040, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1535, 665, '2024-06-22', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1194, 300, '2024-07-08', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1347, 637, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1224, 808, '2024-07-02', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (828, 478, '2024-06-28', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1479, 744, '2024-07-13', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1061, 189, '2024-07-03', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1228, 957, '2024-07-04', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (953, 316, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1557, 476, '2024-06-21', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1194, 810, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1544, 543, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1386, 892, '2024-07-11', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1492, 590, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1382, 776, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (906, 829, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1451, 183, '2024-07-04', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (819, 172, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1680, 618, '2024-06-23', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1252, 773, '2024-06-30', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1222, 656, '2024-06-15', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (963, 673, '2024-06-28', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1313, 922, '2024-07-05', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1285, 70, '2024-07-06', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (771, 690, '2024-07-13', '2024-07-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1439, 642, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1377, 967, '2024-07-06', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (804, 922, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1570, 1004, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1619, 1043, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (986, 435, '2024-07-12', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (953, 739, '2024-07-12', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1661, 951, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1495, 358, '2024-07-01', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1589, 911, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (947, 123, '2024-06-24', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1194, 533, '2024-06-20', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (910, 470, '2024-07-12', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1000, 388, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1617, 150, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1319, 983, '2024-07-10', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1268, 168, '2024-07-10', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (770, 515, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (735, 306, '2024-07-05', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1633, 944, '2024-07-03', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (764, 559, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (869, 93, '2024-06-15', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1125, 1027, '2024-06-25', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1704, 676, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1249, 629, '2024-07-10', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1292, 256, '2024-07-06', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1295, 134, '2024-06-28', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1567, 366, '2024-06-17', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1478, 699, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (757, 826, '2024-06-27', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1651, 433, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1333, 462, '2024-06-20', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1560, 451, '2024-06-18', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1045, 320, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1063, 65, '2024-06-19', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (846, 766, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1012, 739, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (743, 784, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1461, 581, '2024-06-28', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1185, 759, '2024-07-02', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1356, 78, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (764, 456, '2024-06-28', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1719, 527, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1230, 668, '2024-07-13', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (925, 560, '2024-06-25', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1388, 362, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1385, 96, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1092, 744, '2024-07-03', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1526, 992, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1214, 842, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1446, 768, '2024-06-16', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (831, 498, '2024-07-10', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1690, 693, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1032, 168, '2024-06-21', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1467, 438, '2024-06-18', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1231, 165, '2024-07-06', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1598, 537, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1036, 152, '2024-06-23', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1531, 841, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1194, 968, '2024-06-26', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (977, 495, '2024-06-15', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1459, 433, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1293, 804, '2024-06-26', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1318, 633, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1568, 269, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1507, 817, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1135, 704, '2024-07-10', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1486, 481, '2024-06-23', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1600, 359, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1383, 572, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1360, 715, '2024-07-11', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1378, 329, '2024-07-03', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1275, 1007, '2024-06-25', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1469, 128, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1192, 1045, '2024-06-19', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1564, 499, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1261, 958, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (977, 768, '2024-06-24', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1337, 230, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1061, 866, '2024-07-06', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1440, 357, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1546, 110, '2024-06-26', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1264, 567, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1516, 136, '2024-07-03', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1245, 385, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (937, 493, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (895, 494, '2024-06-19', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1594, 364, '2024-06-18', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1282, 331, '2024-07-12', '2024-07-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (841, 767, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1103, 285, '2024-06-27', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1045, 912, '2024-07-08', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1533, 1054, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1322, 402, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1432, 686, '2024-07-12', '2024-07-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1129, 102, '2024-06-29', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1726, 111, '2024-06-27', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1484, 277, '2024-06-23', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1251, 710, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1668, 477, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1254, 853, '2024-07-05', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (807, 579, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1079, 857, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1682, 1009, '2024-07-02', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1401, 401, '2024-06-28', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1099, 64, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (751, 389, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1299, 463, '2024-06-30', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (871, 924, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1720, 457, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1174, 450, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1556, 599, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (850, 342, '2024-06-17', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1651, 403, '2024-07-07', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1713, 369, '2024-06-27', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1642, 828, '2024-07-01', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1119, 465, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1629, 107, '2024-07-13', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1200, 1004, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (763, 1053, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (939, 315, '2024-07-04', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1001, 643, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1152, 592, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1359, 651, '2024-06-22', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1323, 391, '2024-07-09', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (761, 505, '2024-06-25', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1048, 578, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1677, 256, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1594, 569, '2024-06-27', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1323, 274, '2024-07-01', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (875, 261, '2024-06-19', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1550, 743, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (853, 73, '2024-06-21', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1411, 611, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (783, 160, '2024-06-17', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1677, 1049, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1685, 244, '2024-06-30', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1203, 201, '2024-06-15', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (778, 218, '2024-06-18', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1637, 1018, '2024-07-04', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (950, 207, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1571, 571, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1167, 643, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (952, 914, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (750, 996, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1295, 863, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1668, 944, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (834, 622, '2024-07-01', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1029, 543, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1611, 370, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1539, 598, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (773, 917, '2024-06-20', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (792, 927, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1157, 478, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (743, 903, '2024-07-12', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (832, 74, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1295, 489, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (831, 956, '2024-06-29', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (920, 929, '2024-06-28', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1518, 755, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (771, 837, '2024-06-22', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (847, 224, '2024-06-16', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1529, 285, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1396, 63, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1384, 1055, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (942, 81, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1651, 985, '2024-07-10', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1494, 238, '2024-07-13', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1257, 460, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1217, 831, '2024-06-28', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1063, 772, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1689, 165, '2024-07-11', '2024-07-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1373, 77, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1126, 232, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1045, 751, '2024-06-27', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (814, 979, '2024-07-04', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1247, 219, '2024-07-02', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (879, 727, '2024-07-03', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (986, 947, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1154, 353, '2024-07-01', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (864, 665, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1099, 102, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1475, 236, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1457, 57, '2024-07-09', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1263, 668, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (850, 739, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (976, 864, '2024-07-08', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1627, 916, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1140, 814, '2024-06-17', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1409, 186, '2024-06-25', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (829, 1017, '2024-06-25', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1311, 969, '2024-06-17', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1379, 900, '2024-06-19', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1577, 532, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1344, 809, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1675, 1032, '2024-06-19', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1489, 249, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (845, 454, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (879, 882, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1604, 681, '2024-06-23', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1103, 642, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1709, 877, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1171, 330, '2024-07-04', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1501, 1029, '2024-06-20', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1371, 351, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (941, 453, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1117, 389, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1424, 562, '2024-06-25', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1173, 720, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1338, 607, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1352, 70, '2024-06-21', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1559, 987, '2024-06-25', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1346, 815, '2024-07-10', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (843, 145, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1013, 332, '2024-06-25', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (935, 778, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1424, 499, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1724, 805, '2024-06-21', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1460, 1021, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1201, 290, '2024-07-04', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (796, 67, '2024-06-15', '2024-06-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1597, 869, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1220, 364, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1130, 292, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1175, 779, '2024-06-24', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1193, 300, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1177, 192, '2024-06-29', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (827, 123, '2024-06-23', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1406, 560, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1093, 769, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (957, 156, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (969, 361, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1039, 954, '2024-07-06', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1171, 687, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1435, 361, '2024-06-23', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1234, 1018, '2024-06-15', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1706, 90, '2024-06-28', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1194, 817, '2024-07-02', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (835, 1048, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1635, 297, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1597, 605, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1035, 1021, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1509, 228, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (938, 1009, '2024-06-29', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1413, 463, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1141, 168, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1058, 969, '2024-07-11', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (739, 844, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1624, 1016, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1564, 354, '2024-07-03', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1471, 874, '2024-06-20', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (858, 433, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (883, 823, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1438, 473, '2024-07-10', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1170, 714, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (860, 763, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1093, 100, '2024-07-09', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (972, 90, '2024-06-19', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1395, 372, '2024-07-08', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1375, 978, '2024-07-03', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1091, 740, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (954, 202, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1064, 506, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1288, 535, '2024-07-03', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1535, 127, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (820, 405, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1643, 67, '2024-06-27', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1721, 756, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1070, 644, '2024-07-13', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (795, 368, '2024-06-25', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (978, 537, '2024-07-09', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1610, 772, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (844, 816, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1286, 1005, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (789, 745, '2024-06-29', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (831, 312, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1520, 377, '2024-07-02', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1123, 822, '2024-07-05', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1542, 545, '2024-07-01', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1160, 672, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (890, 643, '2024-07-05', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1386, 835, '2024-06-27', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1538, 553, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1675, 84, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1018, 755, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1347, 965, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (975, 98, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (862, 778, '2024-06-30', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1104, 1012, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1264, 605, '2024-07-01', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1293, 957, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1093, 249, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1040, 819, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1159, 257, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1589, 202, '2024-07-07', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1652, 1010, '2024-07-01', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1209, 888, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (824, 971, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (906, 658, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1686, 430, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1239, 872, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1294, 259, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1124, 1002, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (927, 692, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (950, 558, '2024-07-12', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1215, 372, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (990, 617, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1210, 944, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1641, 515, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1183, 750, '2024-06-30', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1378, 877, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1404, 646, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1621, 749, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1316, 639, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1279, 595, '2024-06-19', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (869, 371, '2024-06-18', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1092, 259, '2024-06-22', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1399, 450, '2024-06-18', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1520, 211, '2024-06-14', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1380, 475, '2024-06-28', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1224, 73, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1686, 67, '2024-07-09', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (757, 725, '2024-06-25', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1225, 463, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1165, 1048, '2024-07-11', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (765, 551, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (818, 120, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1197, 732, '2024-07-01', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1005, 966, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1495, 743, '2024-07-04', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1038, 802, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1162, 555, '2024-07-04', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (950, 757, '2024-07-03', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1187, 865, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1361, 110, '2024-06-20', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (910, 277, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (901, 163, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1292, 60, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1368, 794, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1360, 485, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1103, 135, '2024-06-16', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1001, 255, '2024-07-02', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (919, 1026, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1345, 894, '2024-06-23', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1097, 323, '2024-07-01', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1077, 660, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1159, 851, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (868, 100, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1448, 770, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1450, 812, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1316, 447, '2024-06-28', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1061, 133, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1141, 885, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1544, 692, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1655, 430, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1394, 582, '2024-07-11', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1038, 961, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (985, 288, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1520, 73, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1508, 186, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1076, 132, '2024-06-23', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (938, 509, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1475, 186, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (927, 881, '2024-07-12', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1095, 191, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1493, 572, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (754, 1001, '2024-07-10', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (818, 430, '2024-07-12', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1366, 320, '2024-07-11', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1055, 686, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (820, 469, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1027, 522, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (951, 856, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1030, 970, '2024-07-10', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1621, 396, '2024-06-27', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1213, 330, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1508, 864, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1167, 134, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1479, 209, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (754, 1026, '2024-07-09', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1138, 804, '2024-06-15', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1212, 728, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1724, 79, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1133, 747, '2024-07-12', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (968, 1047, '2024-07-12', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1077, 757, '2024-06-30', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1334, 498, '2024-06-23', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1247, 277, '2024-07-12', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1187, 935, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1234, 1051, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1188, 712, '2024-07-11', '2024-07-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1395, 213, '2024-07-07', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1200, 503, '2024-06-17', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1164, 749, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1481, 826, '2024-06-17', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1651, 1043, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1008, 741, '2024-07-07', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1407, 1023, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1236, 890, '2024-06-23', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1587, 1019, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1612, 121, '2024-06-14', '2024-06-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1267, 845, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (872, 387, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1340, 192, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1004, 725, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1009, 976, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (960, 666, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1045, 708, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1411, 981, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1675, 865, '2024-06-17', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1640, 355, '2024-06-20', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1491, 448, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1295, 682, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1246, 955, '2024-06-18', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1451, 1026, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1041, 800, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1034, 834, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1606, 647, '2024-06-21', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (958, 97, '2024-07-03', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1347, 800, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1264, 922, '2024-07-02', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1024, 282, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1372, 195, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1455, 627, '2024-07-08', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1637, 530, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (805, 718, '2024-07-03', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1504, 377, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1402, 987, '2024-06-16', '2024-06-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1537, 164, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1185, 198, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1135, 385, '2024-07-09', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (941, 787, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (743, 449, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1617, 760, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1084, 706, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1522, 101, '2024-06-30', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1072, 907, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1576, 631, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (986, 723, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1394, 169, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1726, 87, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1557, 734, '2024-07-01', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (938, 129, '2024-06-25', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1351, 157, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (970, 738, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (990, 819, '2024-06-16', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1436, 917, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1701, 668, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1235, 241, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1512, 586, '2024-06-15', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1193, 678, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (925, 847, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1308, 479, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1311, 1034, '2024-06-22', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1126, 762, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1693, 278, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (940, 399, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1166, 279, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1054, 920, '2024-07-05', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1234, 180, '2024-06-20', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1342, 268, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1345, 282, '2024-06-29', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (931, 945, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (862, 1045, '2024-07-12', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (858, 1025, '2024-06-17', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1415, 979, '2024-06-27', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1591, 862, '2024-07-11', '2024-07-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (969, 183, '2024-06-29', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (941, 206, '2024-07-08', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1510, 258, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (987, 819, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (955, 145, '2024-07-13', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1285, 530, '2024-06-18', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1395, 543, '2024-06-25', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1063, 468, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1095, 870, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (856, 638, '2024-07-02', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (829, 1006, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1134, 665, '2024-07-01', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1505, 923, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1491, 924, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (735, 234, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1225, 352, '2024-06-28', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (922, 550, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1728, 418, '2024-06-16', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1518, 135, '2024-06-28', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (804, 447, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1083, 148, '2024-06-21', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1260, 354, '2024-06-19', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1131, 1015, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1300, 237, '2024-07-05', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1194, 434, '2024-07-09', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1384, 565, '2024-06-15', '2024-06-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1384, 661, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1328, 128, '2024-06-17', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1502, 581, '2024-06-16', '2024-06-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1336, 499, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (794, 585, '2024-06-30', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1088, 175, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1381, 549, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1215, 599, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1070, 163, '2024-07-13', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1478, 787, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (983, 323, '2024-07-12', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (830, 1000, '2024-06-24', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1215, 474, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1235, 328, '2024-06-24', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (741, 382, '2024-06-16', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1482, 665, '2024-06-20', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1044, 1008, '2024-07-10', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1017, 839, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1259, 407, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (881, 868, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1463, 553, '2024-07-09', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1224, 249, '2024-07-06', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1416, 557, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (795, 843, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1165, 116, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1684, 529, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1271, 392, '2024-07-01', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1390, 806, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (811, 724, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (766, 428, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1370, 949, '2024-06-14', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (963, 998, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (846, 250, '2024-07-03', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (805, 182, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (990, 366, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1127, 542, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1026, 480, '2024-06-22', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (980, 556, '2024-07-08', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (791, 894, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (844, 551, '2024-06-25', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1430, 131, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (878, 882, '2024-06-25', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1089, 606, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (803, 1051, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1003, 234, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1614, 232, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1437, 900, '2024-07-08', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1044, 211, '2024-07-09', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1068, 449, '2024-07-02', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1154, 336, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1005, 250, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1704, 356, '2024-07-11', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1635, 261, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1430, 387, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1666, 652, '2024-07-09', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1573, 464, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1359, 746, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1309, 1011, '2024-06-23', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1395, 317, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1107, 363, '2024-06-22', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1157, 112, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1014, 372, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (899, 646, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1433, 112, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (877, 852, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1357, 319, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1284, 1004, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1305, 848, '2024-06-16', '2024-06-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (740, 961, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1440, 1044, '2024-06-14', '2024-06-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1544, 378, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1528, 349, '2024-07-08', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1665, 1033, '2024-06-25', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (999, 71, '2024-06-23', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1025, 1000, '2024-06-18', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (735, 522, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1659, 410, '2024-07-05', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (934, 424, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1128, 626, '2024-07-04', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (878, 753, '2024-07-10', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1643, 488, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1021, 954, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1373, 410, '2024-06-24', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1052, 116, '2024-07-02', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1049, 198, '2024-07-06', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1711, 898, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1006, 491, '2024-07-13', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1290, 748, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (766, 741, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (805, 645, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1165, 370, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1672, 504, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1598, 648, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1532, 661, '2024-07-04', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (765, 306, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1693, 644, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (951, 218, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1219, 547, '2024-06-15', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1166, 198, '2024-06-15', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1380, 581, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1518, 893, '2024-06-20', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (955, 575, '2024-06-18', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1171, 769, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (750, 59, '2024-06-18', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1638, 439, '2024-06-18', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1268, 820, '2024-06-25', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1398, 645, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1106, 69, '2024-07-09', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1632, 545, '2024-06-22', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1310, 349, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1494, 411, '2024-07-03', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1311, 199, '2024-07-12', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1616, 87, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1251, 892, '2024-06-23', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1509, 992, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1468, 344, '2024-07-12', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1711, 326, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (891, 267, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1374, 89, '2024-07-12', '2024-07-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (990, 587, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1121, 267, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1423, 938, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1594, 395, '2024-07-12', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1540, 132, '2024-06-20', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1359, 1028, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1442, 171, '2024-06-25', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1223, 364, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1501, 715, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1566, 336, '2024-06-30', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1704, 809, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1290, 324, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (831, 742, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1013, 423, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (738, 587, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1237, 317, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (797, 888, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1213, 237, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1667, 528, '2024-06-26', '2024-06-30', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (847, 279, '2024-06-26', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (736, 244, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1307, 621, '2024-07-02', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (986, 515, '2024-07-05', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1521, 918, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1074, 345, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1654, 450, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1085, 299, '2024-07-06', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (870, 624, '2024-07-08', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1063, 919, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1349, 827, '2024-07-06', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (739, 139, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1003, 643, '2024-06-26', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (959, 419, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (983, 949, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1155, 645, '2024-06-18', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (758, 705, '2024-06-17', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1711, 398, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1505, 817, '2024-06-29', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (980, 689, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1192, 194, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1174, 157, '2024-06-26', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (919, 92, '2024-06-22', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1165, 623, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (830, 866, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1002, 296, '2024-06-15', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1165, 200, '2024-07-04', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (743, 263, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (914, 304, '2024-07-04', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (862, 626, '2024-06-15', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1447, 449, '2024-07-13', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1348, 243, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1292, 709, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (886, 534, '2024-06-22', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1618, 852, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1379, 1020, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1386, 931, '2024-07-03', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1004, 860, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1639, 1049, '2024-07-05', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1586, 883, '2024-07-11', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (806, 559, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1018, 1035, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1081, 414, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1581, 481, '2024-06-26', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1184, 756, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1217, 546, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1552, 97, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (913, 263, '2024-06-21', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1390, 161, '2024-07-01', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (894, 193, '2024-07-03', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (852, 749, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1626, 260, '2024-06-14', '2024-06-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (796, 1006, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (911, 182, '2024-06-21', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1539, 687, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1655, 176, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1100, 77, '2024-07-02', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1248, 673, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1642, 194, '2024-06-19', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1388, 510, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1299, 211, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (956, 91, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1625, 674, '2024-07-11', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1052, 290, '2024-07-01', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1010, 925, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (780, 746, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1574, 756, '2024-07-04', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1388, 596, '2024-07-08', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1213, 994, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1200, 88, '2024-06-15', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1558, 227, '2024-07-02', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (853, 1039, '2024-07-09', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1545, 797, '2024-06-21', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (958, 366, '2024-06-17', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1005, 470, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1281, 572, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1462, 330, '2024-06-26', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1248, 244, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (970, 1027, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1620, 1056, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (803, 596, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1485, 68, '2024-06-30', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1570, 738, '2024-07-05', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1487, 303, '2024-06-27', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1364, 297, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1623, 694, '2024-07-13', '2024-07-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1116, 986, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1424, 153, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1730, 825, '2024-07-10', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1273, 686, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1311, 478, '2024-06-20', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1487, 177, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (755, 888, '2024-07-04', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1238, 125, '2024-07-09', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1406, 573, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1691, 574, '2024-06-16', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1455, 945, '2024-06-26', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1557, 864, '2024-07-11', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1533, 700, '2024-07-04', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1198, 1029, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1471, 972, '2024-06-17', '2024-06-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (741, 174, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1369, 500, '2024-06-17', '2024-06-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (860, 856, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1037, 285, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1224, 687, '2024-07-03', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1250, 575, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1418, 635, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1680, 634, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1147, 877, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1361, 659, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1701, 910, '2024-07-10', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (910, 470, '2024-06-20', '2024-06-28', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (981, 592, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (741, 835, '2024-07-03', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (881, 612, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1419, 565, '2024-07-12', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1543, 391, '2024-06-18', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1595, 83, '2024-06-22', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1447, 962, '2024-06-26', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (837, 610, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (927, 385, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1427, 906, '2024-06-22', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1707, 862, '2024-07-06', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1472, 402, '2024-06-30', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1449, 407, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (782, 87, '2024-07-01', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1594, 1024, '2024-06-18', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (746, 427, '2024-07-05', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (763, 680, '2024-06-30', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1450, 455, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1523, 854, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (960, 938, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1423, 749, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1228, 66, '2024-07-08', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1195, 207, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (978, 236, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1308, 728, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1715, 116, '2024-07-13', '2024-07-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1007, 590, '2024-06-23', '2024-06-29', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1334, 796, '2024-06-20', '2024-06-24', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1371, 588, '2024-07-09', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (870, 314, '2024-07-03', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1322, 425, '2024-06-18', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1399, 796, '2024-06-18', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1719, 238, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1535, 840, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1543, 651, '2024-07-08', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (932, 168, '2024-06-26', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1634, 781, '2024-07-03', '2024-07-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (969, 1055, '2024-07-09', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1021, 194, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1591, 710, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (751, 1025, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1569, 300, '2024-07-03', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1690, 195, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1069, 420, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (751, 503, '2024-07-06', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (886, 549, '2024-06-25', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1042, 142, '2024-06-17', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1725, 596, '2024-06-14', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1615, 199, '2024-06-25', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1479, 358, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1400, 91, '2024-06-22', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1520, 801, '2024-07-13', '2024-07-19', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (925, 276, '2024-06-27', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (946, 450, '2024-06-24', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (899, 244, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1426, 190, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1076, 125, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1082, 422, '2024-07-05', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1128, 455, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1505, 92, '2024-06-14', '2024-06-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1595, 1049, '2024-06-20', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1702, 307, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1655, 867, '2024-06-17', '2024-07-01', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1600, 468, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1349, 723, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1432, 161, '2024-06-14', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1457, 290, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1108, 716, '2024-06-20', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1242, 975, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1716, 477, '2024-07-09', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1649, 607, '2024-06-24', '2024-06-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (840, 346, '2024-07-07', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1676, 829, '2024-06-30', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1493, 361, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1401, 566, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1644, 780, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1652, 726, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1075, 569, '2024-06-23', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1572, 104, '2024-07-11', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (826, 357, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1212, 524, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (960, 644, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1065, 348, '2024-07-02', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1215, 283, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (916, 193, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1631, 1044, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (969, 556, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (929, 283, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1530, 300, '2024-06-21', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1600, 146, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (948, 320, '2024-07-05', '2024-07-16', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (983, 969, '2024-07-01', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (912, 624, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1401, 516, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (917, 590, '2024-07-03', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1597, 850, '2024-07-10', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (847, 535, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (898, 772, '2024-07-01', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1145, 874, '2024-06-15', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1023, 295, '2024-06-24', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (760, 1055, '2024-07-08', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1560, 616, '2024-06-23', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1385, 410, '2024-06-29', '2024-07-08', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1212, 464, '2024-07-13', '2024-07-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1623, 847, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (781, 330, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1000, 80, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (946, 296, '2024-06-21', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1383, 58, '2024-07-01', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1182, 872, '2024-06-17', '2024-06-27', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (748, 293, '2024-06-21', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1460, 521, '2024-06-25', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1174, 309, '2024-07-11', '2024-07-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1449, 91, '2024-07-04', '2024-07-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (813, 588, '2024-06-30', '2024-07-04', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1272, 901, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (857, 623, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1153, 144, '2024-07-06', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1262, 425, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1474, 76, '2024-06-22', '2024-07-05', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1579, 397, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1613, 174, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (759, 339, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1140, 410, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (956, 56, '2024-07-04', '2024-07-18', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1081, 768, '2024-06-14', '2024-06-15', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1230, 454, '2024-06-14', '2024-06-20', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1619, 164, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1079, 210, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1402, 927, '2024-06-20', '2024-06-22', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1591, 638, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1250, 176, '2024-07-01', '2024-07-11', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (874, 628, '2024-06-14', '2024-06-17', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (759, 180, '2024-06-20', '2024-06-21', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1263, 456, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1463, 89, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1429, 299, '2024-07-12', '2024-07-26', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1201, 76, '2024-06-23', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1446, 118, '2024-07-09', '2024-07-12', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1401, 389, '2024-06-24', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1654, 784, '2024-06-28', '2024-07-07', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (782, 586, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1506, 921, '2024-07-03', '2024-07-06', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (775, 322, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1463, 674, '2024-06-22', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1326, 503, '2024-07-08', '2024-07-10', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1341, 850, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1165, 865, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1014, 314, '2024-06-24', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1301, 582, '2024-07-05', '2024-07-09', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1384, 135, '2024-06-24', '2024-07-03', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1486, 1030, '2024-06-25', '2024-07-02', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1518, 1048, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1206, 481, '2024-06-19', '2024-06-25', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1285, 591, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (818, 104, '2024-07-07', '2024-07-13', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (831, 619, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1566, 193, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (845, 171, '2024-06-17', '2024-06-23', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo, data_devolucao, status) VALUES (1380, 353, '2024-07-03', '2024-07-14', 'devolvido');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1159, 152, '2024-07-14');
INSERT INTO emprestimo (id_usuario, id_livro, data_emprestimo) VALUES (1477, 682, '2024-07-14');

select * from livraria.main.usuario u ;
select * from livraria.main.endereco e ;
select * from livraria.main.telefone t ;
select * from livraria.main.livro l ;
select * from livraria.main.emprestimo e ;


select * from livraria.dbt_dev_livraria.staging_livraria_usuario slu;

CREATE EXTENSION IF NOT EXISTS unaccent SCHEMA main;

UPDATE main.usuario
SET nome = unaccent(nome)
WHERE nome IS NOT NULL;

select * from main.usuario u
where cpf = '98084642838';

select * from main.usuario u
where nome like 'Joo%';

UPDATE main.usuario
SET email = unaccent(email)
WHERE email IS NOT NULL;

update main.usuario 
set nome = 'Joao Pereira Costa'
where nome = 'Joo Pereira Costa';

update main.endereco 
set bairro = 'Tatuape'
where bairro like 'Tatuap%';

update main.endereco 
set cidade = 'Sao Paulo'
where cidade like '%Paulo';

update main.endereco 
set cidade = 'Florianopolis'
where cidade like 'Flori%';

update main.endereco 
set cidade = 'Brasilia'
where cidade like 'Bras%';

select * from livraria_backup.main_backup.usuario u;

--CREATE OR REPLACE FUNCTION livraria.main_usuario_to_backup()
--RETURNS TRIGGER AS $$
--BEGIN
--    INSERT INTO livraria_backup.main_backup.usuario SELECT NEW.*;
--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;

--CREATE OR REPLACE FUNCTION livraria.main_endereco_to_backup()
--RETURNS TRIGGER AS $$
--BEGIN
--    INSERT INTO livraria_backup.main_backup.endereco SELECT NEW.*;
--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;

--CREATE OR REPLACE FUNCTION livraria.main_telefone_to_backup()
--RETURNS TRIGGER AS $$
--BEGIN
--    INSERT INTO livraria_backup.main_backup.telefone SELECT NEW.*;
--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;

--CREATE OR REPLACE FUNCTION livraria.main_livro_to_backup()
--RETURNS TRIGGER AS $$
--BEGIN
--    INSERT INTO livraria_backup.main_backup.livro SELECT NEW.*;
--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;

--CREATE OR REPLACE FUNCTION livraria.main_emprestimo_to_backup()
--RETURNS TRIGGER AS $$
--BEGIN
--    INSERT INTO livraria_backup.main_backup.emprestimo SELECT NEW.*;
--    RETURN NEW;
--END;
--$$ LANGUAGE plpgsql;

-- STAGINGS:
select * from livraria.dbt_dev_livraria_staging.stg_livraria_usuario slu;
select * from livraria.dbt_dev_livraria_staging.stg_livraria_endereco sle;
select * from livraria.dbt_dev_livraria_staging.stg_livraria_telefone slt;
select * from livraria.dbt_dev_livraria_staging.stg_livraria_livro sll;
select * from livraria.dbt_dev_livraria_staging.stg_livraria_emprestimo slem;

-- MATERIALIZEDS:
select * from livraria.dbt_dev_livraria_materialized.user_end ue;
select * from livraria.dbt_dev_livraria_materialized.livros_emprest le;
select * from livraria.dbt_dev_livraria_materialized.hist_emprest_usu heu;
select * from livraria.dbt_dev_livraria_materialized.livros_pop lp;
select * from livraria.dbt_dev_livraria_materialized.user_emp uemp;


SELECT DATE_TRUNC('month', data_emprestimo) AS mes, COUNT(id_emprestimo) AS num_emprestimos
FROM livraria.dbt_dev_livraria_materialized.livros_emprest
GROUP BY mes
ORDER BY mes;










