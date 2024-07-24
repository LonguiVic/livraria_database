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
