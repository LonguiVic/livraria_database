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
