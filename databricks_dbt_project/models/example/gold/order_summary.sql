
{{ config(materialized='table') }}

WITH paid_order_ids AS (

    SELECT DISTINCT order_id
    FROM {{ ref('stg_payments') }}
    WHERE status = 'Paid'

),

paid_orders AS (

    SELECT
        o.order_id,
        o.customer_id,
        o.amount
    FROM {{ ref('stg_orders') }} o
    INNER JOIN paid_order_ids p
        ON o.order_id = p.order_id

)

SELECT
    c.customer_id,
    c.customer_name,
    c.city,

    COALESCE(SUM(po.amount), 0) AS total_paid_amount,

    COUNT(po.order_id) AS paid_order_count

FROM {{ ref('stg_customer') }} c

LEFT JOIN paid_orders po
    ON c.customer_id = po.customer_id

GROUP BY
    c.customer_id,
    c.customer_name,
    c.city
