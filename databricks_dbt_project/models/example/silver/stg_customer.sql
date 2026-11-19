{{ config(materialized='table') }}

SELECT
    customer_id,
    customer_name AS customer_name,
    city AS city

FROM {{ source('customer_order_summary', 'customers') }}

WHERE customer_id IS NOT NULL