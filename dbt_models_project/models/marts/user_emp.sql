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