select order_id,
       sum(amount) as amount_paid
from {{ ref('stg_payments')  }}
group by 1
having not amount_paid >= 0