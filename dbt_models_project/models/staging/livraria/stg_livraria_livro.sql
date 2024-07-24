{{ config(
     materialized='view',
     schema='livraria_staging'
) }}

with source as (
    select * from main.livro
)

select * from source
