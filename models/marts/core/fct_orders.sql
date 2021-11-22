{{config (
    materialized= 'ephemeral'
)}}

with orders as (
    select * from {{ ref ('stg_orders')  }}
),

payments as (
    select * from {{ ref ('stg_payments')  }}
),

order_payment as (
    select 
        order_id, 
        sum(case when status = 'sucess' then amount end) as amount_paid
    from payments

    group by 1
),

final as (
    select 
        orders.order_id, 
        orders.customer_id,
        orders.order_date,
        orders.status,
        coalesce(order_payment.amount_paid, 0) as amount_paid

    from orders

    left join order_payment using (order_id)
 
)

select * from final
