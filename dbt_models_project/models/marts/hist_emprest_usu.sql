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