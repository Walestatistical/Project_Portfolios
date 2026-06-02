# * included in the code, to prevent error in subsequent 'select' code 
*select * from customer

#1
select Sex, sum(dlr_spent_multi_purch) as Total_Revenue
from customer
group by sex

#2
#2a
select customer_no, dlr_spent_multi_purch
from customer
where yearly_income<=50000 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)
#2ai
select count(customer_no) as "No of Customer with Annual Income > $100,000 & Total previous spending > 
All-Customer's average previous spending on Company's items" 
from customer
where yearly_income<=100000 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)

#2b
select customer_no, dlr_spent_multi_purch, order_freq
from customer
where order_freq<=25 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)
#2bi
select count(customer_no) as "No of Customer with Order frequency >= 5 & Total previous spending > 
All-Customer's average previous spending on Company's items"
from customer
where order_freq>=5 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)

#2c
select customer_no, dlr_spent_multi_purch, recency
from customer
where recency<=730 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)
#2ci
select count(customer_no) as "No of Customer with whose recent item purchase was <= 2 years & Total previous spending > 
All-Customer's average previous spending on Company's items"
from customer
where recency<=365 and dlr_spent_multi_purch>=(select avg(dlr_spent_multi_purch) from customer)

#3
select item_most_recently_purch_2 as "Recently Purchased Item", 
sum(recent_purch_amt_2) as "Total Amount of Recently Purchased Item", 
round(avg(rev_rating_recent_purch),2) as "Average Product Rating"
from customer
group by item_most_recently_purch_2
order by avg(rev_rating_recent_purch) desc
limit 10

#4a 
select name_prefix, round(avg(dlr_spent_multi_purch),2) 
as 'Average amount spent' from customer
where name_prefix in ('Mr','Ms','Mrs')
group by name_prefix;

#4b
SELECT 
    name_prefix,
    ROUND(AVG(dlr_spent_multi_purch), 2) AS 'Average Amount Spent'
FROM customer
WHERE name_prefix IN ('Mr', 'Mrs')
GROUP BY name_prefix;

SELECT 
    age_group as "Age Group",
    count(age_group) as "No of Customers by Age Category",
    ROUND(AVG(dlr_spent_multi_purch), 2) AS 'Average Amount Spent'
FROM customer
#WHERE age_group IN ('Youth', 'Senior')
GROUP BY age_group
ORDER BY count(age_group) desc;

SELECT 
    job_category,
    ROUND(AVG(dlr_spent_multi_purch), 2) AS 'Average Amount Spent'
FROM customer
WHERE job_category IN (10,15)
GROUP BY job_category;

#5
select subscription_status_2 as "Customer subscription status",
	count(customer_no) as "No of Customers",
    round(avg(dlr_spent_multi_purch),2) as "Average amount spent on previous item purchases",
    round(sum(dlr_spent_multi_purch),2) as "Total amount spent on previous item purchases"
from customer
group by subscription_status_2
order by avg(dlr_spent_multi_purch);

select age_group,
	count(customer_no) as total_customers,
    round(avg(dlr_spent_multi_purch),2) as avg_multi_spend,
    round(sum(dlr_spent_multi_purch),2) as tot_multi_revenue
from customer
group by age_group
order by tot_multi_revenue, avg_multi_spend desc;

select age_group, age_category,
	count(customer_no) as total_customers,
    round(avg(dlr_spent_multi_purch),2) as avg_multi_spend,
    round(sum(dlr_spent_multi_purch),2) as tot_multi_revenue
from customer
group by age_group, age_category
order by tot_multi_revenue, avg_multi_spend desc;

#6 "No Discount column, so the analysis cannot be done"

#7
select customer_segment as 'Customer Segment',
	count(customer_segment) as 'Total Customer in each Segment'
from customer
#count(customer_no) as Total_Customer
#sum(customer_segment)
group by customer_segment
order by count(customer_segment) asc;

select customer_no,
	count(customer_no) as Total_Customer
from customer;    
with customer_segment_1 as (
select customer_no, dlr_spent_multi_purch_code, order_freq_code, recency_code,
case
	when (dlr_spent_multi_purch_code+order_freq_code+recency_code)>=7 then 'Top-tier'
    when (dlr_spent_multi_purch_code+order_freq_code+recency_code)=6 then 'Mid-tier'
    #when (dlr_spent_multi_purch_code+order_freq_code+recency_code)<=5 then 'Least'
    else 'Low-tier'
    end as Customer_Segment_Category
from customer)
select Customer_Segment_Category,count(*) as 'Number of Customers'
from customer_segment_1
group by Customer_Segment_Category
order by Customer_Segment_Category desc;

#8
#8a    
with item_counts as (
select customer_segment, 
		item_most_recently_purch_2 as "Three_most_recently_purchased_items",
        sum(recent_purch_amt_2) as "Total_amount_of_recently_purchased_items",  
        row_number() over (partition by customer_segment order by sum(recent_purch_amt_2) desc) as
	item_rank
    from customer
    group by customer_segment, item_most_recently_purch_2
    )
    select Item_rank, Customer_segment, Three_most_recently_purchased_items, Total_amount_of_recently_purchased_items 
    from item_counts
    where item_rank<=3;
    #8b    
with item_counts as (
select customer_segment,
		item_most_recently_purch_2,
        count(customer_no) as total_orders,
        row_number() over (partition by customer_segment order by (customer_no) desc) as
	item_rank
    from customer
    group by customer_segment, item_most_recently_purch_2
    )
    select item_rank, customer_segment, item_most_recently_purch_2, total_orders
    from item_counts
    where item_rank<=3;
    
    #9
    select subscription_status_2 as "Subscription status",
		count(customer_no) as 'Most frequent buyers'
	from customer
    where order_freq between 9 and 19
    group by subscription_status_2;
    
    #10
    select Age_Group as "Customer age group" , sum(dlr_spent_multi_purch) as "Total amount from previously sold items"
    from customer
    group by age_group
    order by sum(dlr_spent_multi_purch) desc;
    
    select Age_Group, sum(dlr_spent_multi_purch) as 'Multiple Purchase Total Revenue'
    from customer
    group by age_group
    order by 'Multiple Purchase Total Revenue' desc;
    
    select Age_Category, sum(dlr_spent_multi_purch) as 'Multiple Purchase Total Revenue'
    from customer
    group by age_category
    order by 'Multiple Purchase Total Revenue' desc;
    
    select Age_Group as "Customer age group" , sum(recent_purch_amt_2) as "Total amount from recently purchased items"
    from customer
    group by age_group
    order by sum(recent_purch_amt_2) asc;
    
    select Age_Group, sum(recent_purch_amt_2) as 'Recent Purchase Total Revenue'
    from customer
    group by age_group
    order by 'Recent Purchase Total Revenue' desc;
    
    select Age_Category, sum(recent_purch_amt_2) as 'Recent Purchase Total Revenue'
    from customer
    group by age_category
    order by 'Recent Purchase Total Revenue' desc;
    
    select Age_Group, avg(recent_purch_amt_2) as 'Recent Purchase Average Revenue'
    from customer
    group by age_group
    order by 'Recent Purchase Average Revenue' desc;
    
    select Age_Category, avg(recent_purch_amt_2) as 'Recent Purchase Average Revenue'
    from customer
    group by age_category
    order by 'Recent Purchase Average Revenue' desc;