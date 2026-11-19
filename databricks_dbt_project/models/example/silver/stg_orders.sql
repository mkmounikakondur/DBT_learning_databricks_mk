{{ config(materialized='table') }}


SELECT
        customer_id,
        order_id,
        amount
FROM {{source('customer_order_summary','orders')}}
    