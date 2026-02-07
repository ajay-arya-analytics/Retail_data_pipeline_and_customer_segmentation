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


-- Q4. CUSTOMER SEGMENTATION (RFM)
-- Grouping customers based on spending and order frequency

SELECT 
    customer_id,
    COUNT(order_id) as frequency,
    SUM(payment_value) as monetary,
    CASE 
        -- High Value: High spending AND frequent orders
        WHEN SUM(payment_value) > 500 AND COUNT(order_id) > 2 THEN 'VIP Customer'
        -- Loyal: Frequent orders but lower spending
        WHEN COUNT(order_id) > 2 THEN 'Loyal Customer'
        -- Big Spender: High spending but infrequent
        WHEN SUM(payment_value) > 500 THEN 'Big Spender'
        -- Regular: Everyone else
        ELSE 'Regular Customer'
    END as customer_segment
FROM cleaned_retail_data
GROUP BY customer_id; customer_id;


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

