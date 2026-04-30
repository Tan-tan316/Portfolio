/*DATE(DATE_TRUNC('month', gp.payment_date::date)) AS payment_month, 
--тут обрізаємо дату до початку місяця, що потім потрібно нам для зсувів--
вибрали все що потрібно, зробили тотал ревеню, арппу,
LAG(SUM(gp.revenue_amount_usd)) OVER (PARTITION BY gp.user_id 
ORDER BY DATE(DATE_TRUNC('month', gp.payment_date::date))) AS lag_total_revenue,
LEAD(SUM(gp.revenue_amount_usd)) OVER (PARTITION BY gp.user_id 
ORDER BY DATE(DATE_TRUNC('month', gp.payment_date::date))) AS lead_total_revenue,
LAG(DATE(DATE_TRUNC('month', gp.payment_date::date))) 
	OVER (PARTITION BY gp.user_id ORDER BY DATE(DATE_TRUNC('month', gp.payment_date::date))) AS lag_payment_month,
LEAD(DATE(DATE_TRUNC('month', gp.payment_date::date))) 
	OVER (PARTITION BY gp.user_id ORDER BY DATE(DATE_TRUNC('month', gp.payment_date::date))) AS lead_payment_month,*/

WITH monthly_revenue AS ( SELECT 
        DATE_TRUNC('month', payment_date::date)::date AS payment_month, 
        user_id, 
        game_name, 
        SUM(revenue_amount_usd) AS total_revenue
    FROM games_payments
    GROUP BY 1, 2, 3
),
lag_lead_users as (SELECT 
    *,
    LAG(total_revenue) OVER (PARTITION BY user_id ORDER BY payment_month) AS revenue_last_month,
    LEAD(total_revenue) OVER (PARTITION BY user_id ORDER BY payment_month) AS next_total_revenue,
    LAG(payment_month) OVER (PARTITION BY user_id ORDER BY payment_month) AS last_payment_month,
    LEAD(payment_month) OVER (PARTITION BY user_id ORDER BY payment_month) AS next_payment_month
FROM monthly_revenue),
status_users as (select *, case when revenue_last_month is null then 'New'
when next_total_revenue is null then 'Churned'
else 'Retained'
end as status
from lag_lead_users),
final_table as (select su.*, gpu.age, gpu.language,
    CASE WHEN last_payment_month IS NULL THEN total_revenue ELSE 0 END AS new_mrr,
    CASE WHEN last_payment_month IS NULL THEN 1 ELSE 0 END AS new_paid_users,
    CASE WHEN next_payment_month IS NULL THEN total_revenue ELSE 0 END AS churn_revenue,
    CASE WHEN next_payment_month IS NULL THEN 1 ELSE 0 END AS churn_users,
    CASE WHEN total_revenue > revenue_last_month AND revenue_last_month > 0 
         THEN total_revenue - revenue_last_month ELSE 0 END AS expansion_revenue,
   CASE WHEN next_total_revenue < revenue_last_month and next_total_revenue > 0
         THEN next_total_revenue-revenue_last_month  ELSE 0 END AS contraction_revenue
from status_users su
left join games_paid_users gpu 
on su.user_id = gpu.user_id and su.game_name = gpu.game_name )
select *
from  final_table