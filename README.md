
# Livraria Data Pipeline Project

Este projeto foi desenvolvido para criar um pipeline de dados para uma livraria, utilizando diversas ferramentas de engenharia de dados. O objetivo é processar e analisar dados de usuários, livros, endereços, telefones e empréstimos. O projeto utiliza dbt para transformar os dados e Grafana para visualizá-los através de dashboards informativos.




## Autores

- [@LonguiVic](https://github.com/LonguiVic)


## Instalação

- Python 3.x
```bash
  https://www.python.org/downloads/release/python-3810/
```

- DBT
```bash
  pip install dbt-postgres
```

- Grafana
```bash
  https://grafana.com/grafana/download
```

- PostgreSQL
```bash
  https://www.postgresql.org/download/
```


## Documentação

[Grafana](https://grafana.com/docs/grafana/latest/)

[DBT](https://docs.getdbt.com)

[PostgreSQL](https://www.postgresql.org/docs/)


## Estrutura do Projeto

### Tabelas de Staging

As tabelas de staging são criadas no dbt para organizar e transformar os dados brutos. As seguintes tabelas de staging foram configuradas:

- stg_livraria_usuario
- stg_livraria_endereco
- stg_livraria_telefone
- stg_livraria_livro
- stg_livraria_emprestimo

### Views Materializadas

Foram criadas views materializadas no dbt para facilitar a análise dos dados:

- **_hist_emprest_usu_**
```bash
    {{
        config(
            materialized='table',
            schema='livraria_materialized'
        )
    }}

    with usuario as (
        select 
            slu.id_usuario,
            slu.nome,
            slu.email
        from {{ ref('stg_livraria_usuario') }} slu
    ),

    livro as (
        select 
            sll.id_livro,
            sll.titulo
        from {{ ref('stg_livraria_livro') }} sll
    ),

    emprestimo as (
        select 
            slem.id_usuario,
            slem.id_livro,
            slem.data_emprestimo,
            slem.data_devolucao
        from {{ ref('stg_livraria_emprestimo') }} slem
    ),

    source as (
        select 
            u.id_usuario,
            u.nome,
            u.email,
            l.titulo,
            e.data_emprestimo,
            e.data_devolucao
        from 
            usuario as u
        join
            emprestimo as e
        on 
            u.id_usuario = e.id_usuario
        join
            livro as l
        on 
            e.id_livro = l.id_livro
    )

    select * from source
```

- **_livros_emprest_**
```bash
    {{
        config(
            materialized='table',
            schema='livraria_materialized'
        )
    }}

    with livro as (
        select 
            sll.id_livro,
            sll.titulo,
            sll.autor,
            sll.ano_publicacao
        from {{ ref('stg_livraria_livro') }} sll
    ),

    emprestimo as (
        select 
            slem.id_livro,
            slem.id_emprestimo,
            slem.id_usuario,
            slem.data_emprestimo,
            slem.data_devolucao,
            slem.status
        from {{ ref('stg_livraria_emprestimo') }} slem
    ),

    source as (
        select 
            l.id_livro,
            l.titulo,
            l.autor,
            l.ano_publicacao,
            e.id_usuario,
            e.id_emprestimo,
            e.data_emprestimo,
            e.data_devolucao,
            e.status
        from livro as l
        join emprestimo as e
        on l.id_livro = e.id_livro
    )

    select * from source
```

- **_livros_pop_**
```bash
    {{
        config(
            materialized='table',
            schema='livraria_materialized'
        )
    }}

    with livro as (
        select 
            sll.id_livro,
            sll.titulo,
            sll.autor
        from {{ ref('stg_livraria_livro') }} sll
    ),

    emprestimo as (
        select 
            slem.id_livro,
            COUNT(slem.id_emprestimo) AS total_emprestimos
        from {{ ref('stg_livraria_emprestimo') }} slem
        group by slem.id_livro
    ),

    source as (
        select 
            l.id_livro,
            l.titulo,
            l.autor,
            e.total_emprestimos
        from
            livro as l
        join 
            emprestimo as e
        on
            l.id_livro = e.id_livro
    )

    select * from source
    order by total_emprestimos desc
```

- **_user_emp_**
```bash
    {{
        config(
            materialized='table',
            schema='livraria_materialized'
        )
    }}

    with usuario as (
        select 
            slu.id_usuario,
            slu.nome,
            slu.email
        from {{ ref('stg_livraria_usuario') }} slu
    ),

    emprestimo as (
        select 
            slem.id_usuario,
            COUNT(slem.id_emprestimo) AS total_emprestimos
        from {{ ref('stg_livraria_emprestimo') }} slem
        group by slem.id_usuario
    ),

    source as (
        select 
            u.id_usuario,
            u.nome,
            u.email,
            e.total_emprestimos
        from 
            usuario as u
        join 
            emprestimo as e
        on 
            u.id_usuario = e.id_usuario
    )

    select * from source
    order by total_emprestimos desc
```

- **_user_end_**
```bash
    {{
        config(
            materialized='table',
            schema='livraria_materialized'
        )
    }}

    with usuario as (
        select 
            slu.id_usuario,
            slu.nome,
            slu.sexo,
            slu.email,
            slu.cpf
        from {{ ref('stg_livraria_usuario') }} slu
    ),

    endereco as (
        select 
            sle.id_usuario,
            sle.rua,
            sle.bairro,
            sle.cidade,
            sle.estado
        from {{ ref('stg_livraria_endereco') }} sle
    ),

    source as (
        select
            u.id_usuario,
            u.nome,
            u.sexo,
            u.email,
            u.cpf,
            e.rua,
            e.bairro,
            e.cidade,
            e.estado
        from usuario u
        left join endereco e on u.id_usuario = e.id_usuario
    )

    select * from source
```

## Dashboards no Grafana
Os seguintes dashboards foram criados no Grafana para visualização dos dados:

1 - **Clientes com mais empréstimo**
- Gráfico de barras mostrando os usuários que mais emprestaram livros.

2 - **Top 10 livros mais populares**
- Gráfico de barras listando os livros mais populares entre os clientes.

3 - **Distribuição Geográfica dos Clientes**
- Gráfico mostrando a proporção de usuários por estado.

4 - **Empréstimos de Livros ao Longo do Tempo**
- Gráfico de linhas mostrando o número de empréstimos ao longo do tempo.

5 - **Distribuição de Empréstimos por Gênero de Livro**
- Gráfico de linha mostrando quais gêneros de livros são mais requisitados na livraria.

## Configuração do Ambiente

### Pré-requisitos

- PostgreSQL instalado e configurado.
- dbt instalado e configurado.
- Grafana instalado e configurado.
- Conexão configurada entre Grafana e PostgreSQL.

### Configurando o dbt

1. Clone este repositório:
   bash
   git clone <URL do repositório>
   cd <nome do repositório>
   

2. Instale as dependências do dbt:
   bash
   dbt deps
   

3. Atualize o arquivo profiles.yml com as configurações do seu banco de dados.

4. Execute o dbt para criar as tabelas de staging e as views materializadas:
   bash
   dbt run
   

### Configurando o Grafana

1. Acesse a interface do Grafana.
2. Adicione uma nova fonte de dados PostgreSQL com as credenciais do seu banco de dados.
3. Crie os dashboards utilizando as consultas SQL fornecidas acima.

## Contribuições

Sinta-se à vontade para abrir issues e pull requests para melhorias e correções.
