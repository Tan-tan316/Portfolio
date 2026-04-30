with a as(select * 
from generate_series('2022-01-01'::date, '2022-12-31'::date, '1 month'::interval)),
b as (select distinct(user_id), game_name
from project.games_payments
 ),
c as (select *
from a
cross join b),
d as(select user_id, game_name, round(SUM(revenue_amount_usd)::numeric,1) as revenue, DATE_TRUNC('month',payment_date::timestamp) as month
from project.games_payments
group by user_id, game_name, DATE_TRUNC('month',payment_date::timestamp)
order by user_id , month),
e as (select *, c.user_id as users, c.game_name as game
from c
left join d
on d.month  = c.generate_series and d.game_name = c.game_name and c.user_id = d.user_id
order by c.user_id, generate_series),
f as (select generate_series, coalesce(game,'-') as game, coalesce(users, '-') as users,  COALESCE(revenue, 0) as new_revenue
from e),
g as (select *, lag(new_revenue) over( partition by users order by generate_series) revenue_past_month,
round(SUM(new_revenue) OVER (PARTITION BY users ORDER BY generate_series ROWS BETWEEN UNBOUNDED PRECEDING AND 1 PRECEDING)::numeric,1) as sum_all_time_before
from f
order by users, generate_series ),
h as (select *, case when new_revenue>0 and revenue_past_month = 0 and sum_all_time_before = 0 then 'New'
when new_revenue>0 and revenue_past_month = 0 and sum_all_time_before > 0 then 'Reactivated'
when new_revenue>0 and revenue_past_month > 0 then 'Retained'
when new_revenue=0 and revenue_past_month > 0 then 'Churned'
else '-' end as Status
from g),
i as (select *
from h 
left join project.games_paid_users gpu 
on h.game = gpu.game_name and h.users = gpu.user_id),
j as (select generate_series as date, game, users, new_revenue, revenue_past_month, sum_all_time_before, status, 
sum(new_revenue) over (partition by users, game) as LTV,  
extract( month from (age(generate_series,MIN(generate_series) over (partition by users, game)))) as lifetime, language, age
from i
where status != '-')
SELECT *
from j