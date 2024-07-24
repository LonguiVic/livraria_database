{{ config(
     materialized='view',
     schema='livraria_staging'
) }}

with source as (
    select * from main.emprestimo
)

select * from source
