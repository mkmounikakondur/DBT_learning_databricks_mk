{{ config(materialized='table') }}

 select 
    payment_id,
    order_id,
    status as status
        from {{source('customer_order_summary','payments')}}
    