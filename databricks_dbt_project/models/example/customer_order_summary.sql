{{ config(materialized='table') }}

WITH paid_orders AS (

    SELECT
        o.customer_id,
        o.order_id,
        o.amount

    FROM {{ source('customer_order_summary', 'orders') }} o

    INNER JOIN {{ source('customer_order_summary', 'payments') }} p
        ON o.order_id = p.order_id

    WHERE p.status = 'Paid'
)

SELECT
    c.customer_id,
    c.customer_name,

    COALESCE(SUM(po.amount), 0) AS total_amount,

    COUNT(DISTINCT po.order_id) AS order_count

FROM {{ source('customer_order_summary', 'customers') }} c

LEFT JOIN paid_orders po
    ON c.customer_id = po.customer_id

GROUP BY
    c.customer_id,
    c.customer_name