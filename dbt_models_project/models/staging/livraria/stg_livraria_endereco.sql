{{ config(
     materialized='view',
     schema='livraria_staging'
) }}

with source as (
    select * from main.endereco
)

select * from source
