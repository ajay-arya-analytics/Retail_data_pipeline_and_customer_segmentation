use brazilian_ecommerce;
select * from cleaned_retail_data;


-- Q1. FIND OUT THE CATEGORIES THAT ARE SUFFERING FROM SLOW SHIPPING.

select product_category_name_english, round(AVG(delivery_days),2) as avg_delivery_time
from cleaned_retail_data
where delivery_days is not null
group by product_category_name_english
having avg_delivery_time > 15;


-- Q2. FIND OUT THE TOP 6 BIGGEST SPENDERS BY TOTALING THEIR PAYMENTS AND ORDER FREQUENCY.

select customer_id, round(SUM(payment_value)) as total_spent, COUNT(order_id) as total_orders
from cleaned_retail_data
group by customer_id
order by total_spent desc
limit 6;


-- Q3.CALCULATE THE PERCENTAGE CONTRIBUTION OF EACH PRODUCT CATEGORY TO THE TOTAL COMPANY REVENUE.

with total_category_revenue #CTE1
	as	(select product_category_name_english as product_category, round(sum(price),2) as total_price 
    from cleaned_retail_data group by product_category),

total_company_revenue #CTE2
	as	(select Round(sum(price)) as total_revenue 
    from cleaned_retail_data)

# Main Query
select *, round((total_price/total_revenue) *100,2)  as percentage
from total_category_revenue,total_company_revenue
order by percentage desc;


-- Q4.CLASSIFY CUSTOMERS INTO TIERS BASED ON THEIR SPENDING HABITS AND SHIPPING EXPERIENCE.

select customer_id, sum(payment_value) as total_spend,
	case 
    when sum(payment_value) >1000 then 'VIP/High-Value'
    when sum(payment_value) between 200 and 1000 then 'Mid-Value'
    else 'budget-shopper'
    end as spending_value,
    
    case
    when avg(DateDiff(order_delivered_customer_date, order_estimated_delivery_date)) <=0 then 'Satisfied (on time delivery)'
    when avg(DateDiff(order_delivered_customer_date, order_estimated_delivery_date)) >5 then 'Dissatisfied (late delivery)'
    else 'Netural'
    end as satisfaction

from cleaned_retail_data
group by customer_id;


-- Q5. CALCULATE HOW MUCH REVENUE GREW (OR SHRANK) COMPARED TO THE PREVIOUS MONTH.

WITH MonthlySales AS (
    -- CTE to aggregate sales by month
    SELECT 
        DATE_FORMAT(order_purchase_timestamp, '%Y-%m') AS sale_month,
        round(SUM(payment_value),2) AS revenue
    FROM cleaned_retail_data
    GROUP BY 1
)
SELECT 
    sale_month,
    revenue,
    -- Use LAG to get the revenue from the previous row (month)
    LAG(revenue) OVER (ORDER BY sale_month) AS previous_month_revenue,
    ROUND(((revenue - LAG(revenue) OVER (ORDER BY sale_month)) / LAG(revenue) OVER (ORDER BY sale_month)) * 100, 2) AS mom_growth_percent
FROM MonthlySales;

