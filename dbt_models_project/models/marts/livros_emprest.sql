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
