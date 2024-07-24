{{ config(
     materialized='view',
     schema='livraria_staging'
) }}

with source as (
    select * from main.telefone
)

select * from source
