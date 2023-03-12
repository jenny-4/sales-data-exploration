/*1.Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for the Midwest region. Sort the accounts alphabetically (A-Z) according to account name.*/

--As we want the region name, the sales rep name and the account name, we have to work with 3 tables: regions, sales_reps and accounts
--So we select the name column from the regions table, the name column from the sales_reps table and the name column from the accounts table
--Then we join the region table with the sales_reps table and that with the account tables
-- As we only want the Midwest region, we filter with a where clause
-- And finally we sort by the account name 

SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest'
ORDER BY ac.name ASC




/*2.Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a first name starting with S and in the Midwest region.
Sort the accounts alphabetically (A-Z) according to account name.*/

--Here we add another condition; the first name of the sales rep name should starts with an S.
--Therefore, in the where clause we add one more condition

SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE 'S%'
ORDER BY ac.name ASC




/*3. Provide a table that provides the region for each sales_rep along with their associated accounts.
This time only for accounts where the sales rep has a last name starting with K and in the Midwest region.
Sort the accounts alphabetically (A-Z) according to account name.*/

-- In this one, the sales rep last name should starts with a K
--Hence, we replace the second condition we had with another one that extracts the records that fullfill the condition above

SELECT r.name as Region, sr.name as Rep_name, ac.name as account_name
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id
WHERE r.name='Midwest' AND sr.name LIKE '% K%'
ORDER BY ac.name ASC




/*4. Provide the name for each region for every order, as well as the account name and the unit price they paid
(total_amt_usd/total) for the order. However, you should only provide the results if the standard order quantity exceeds 100.
In order to avoid a division by zero error, adding .01 to the denominator here is helpful total_amt_usd/(total+0.01).*/

--We want the region, the account name, and the unit price; so we are going to work with the region, the accounts and the orders tables
--We also going to need the sales_reps table to join the tables mentioned above
--And then, we add a condition: we only want the orders with more than 100 standard paper
SELECT r.name AS region, ac.name AS account_name, o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100



/*5. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total)
for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity
exceeds 50. Sort for the smallest unit price first.*/

--To the query above we add a new condition: the  orders with more than 100 standard papers and with more than 50 poster papers
--And then we sort the table to visualize the account name with the lowest unit price 
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price ASC



/*6. Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total)
for the order. However, you should only provide the results if the standard order quantity exceeds 100 and the poster order quantity
exceeds 50.  Sort for the largest unit price first.*/
--Here we sort the table to visualize the account name with the highest unit price 
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC



/*7. For each account, determine the average amount of each type of paper they purchased across their orders.*/

--We need the column name of the accounts table, and the mean of each type of paper each one of the accounts purchased
--Thus, we apply the aggregate function avg() in each type of paper
--As we want the account name and the mean of each type of paper each one of the accounts purchased across their orders
--we join the accounts table with the orders table
--Lastly we group by the account_name

SELECT ac.name AS account_name, AVG(o.standard_qty) AS average_standard_qty, AVG(o.gloss_qty) AS average_gloss_qty, 
AVG(o.poster_qty) AS average_poster_qty, AVG(total) as average_total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY average_standard_qty DESC




/*8. For each account, determine the average amount spent per order on each paper type. */

--Here we do the same but we apply the avg() function on the amount spent on each paper type
SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name

--In the next query we can visualize the account_name that had spend the most 
SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd, AVG(o.standard_amt_usd)+AVG(o.gloss_amt_usd)+AVG(o.poster_amt_usd) as total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY total DESC



/*9. Determine the number of times a particular channel was used in the web_events table for each sales rep. 
Order your table with the highest number of occurrences first.*/

--We want the sales rep name, the channel and the number of occurrences of these channels so we will work with web_events table, the sales_reps table
--and inderectly with the accounts table
--Therefore, we select the name column from the sales_reps table, the channel column from the web_events table and we apply de count() function
--to the channels
--Then, as we are working with the web_events and sales_reps tables we want to join them. But the only way to do this is through the
--accounts table, so we do that.
--We group by the sales rep name and the channel
--And finally we sort by the number of ocurrences 

SELECT sr.name AS sales_rep_name, we.channel AS channel, count(channel) AS number_of_occurrences
FROM web_events we JOIN accounts ac ON we.account_id=ac.id JOIN sales_reps sr ON ac.sales_rep_id=sr.id
GROUP BY sr.name, we.channel
ORDER BY number_of_occurrences DESC




/*10. When we look at the yearly totals, you might notice that 2013 and 2017 have much smaller totals than all other years.
If we look further at the monthly data, we see that for 2013 and 2017 there is only one month of sales for each of these years
(12 for 2013 and 1 for 2017). Therefore, neither of these are evenly represented. Sales have been increasing year over year, 
with 2016 being the largest sales to date. At this rate, we might expect 2017 to have the largest sales.*/

--Here we can see the yearly totals
--We extract the year of the occurred_at column from the orders table and apply the sum() function to the total_amt_usd also from de orders table
--Group by year and lastly sort it by the total_usd column
--We can see sales have been increasing year over year

SELECT EXTRACT(YEAR FROM occurred_at) AS year,  SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC



--In this one we can see the total by year and month
--AS we did earier, we extract the year of the occurred_at column and we also extract the month.
--We group by year and month
--We can observe that for 2013 and 2017 there is only one month of sales for each of these years

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month, SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at) = 2013 OR EXTRACT(YEAR FROM occurred_at)= 2017
GROUP BY year, month
ORDER BY year



--Here we extract the day too
--We take the records from the 2017 year
--We can visualize the total for each day of the month
--We observe that for the 2017 year we only have the first and second day of January 

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2017
GROUP BY year, month, day
ORDER BY total_usd ASC



--Here we compare the total in January 1rst 2017 with the others years
--We add more conditions so we can visualize what we mentioned above
--At this rate, we might expect 2017 to have the largest sales

SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC


-- Lets see the percentage of growth in each year
WITH CTE_GROWTH AS 
(SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC) 

SELECT year, month, day,total_usd, total_usd - LAG(total_usd) OVER (ORDER BY year ASC) AS growth, 
(total_usd - LAG (total_usd) OVER (ORDER BY year ASC))/LAG (total_usd) OVER (ORDER BY year ASC)*100 AS percentage_growth
FROM CTE_GROWTH



/*11. In which month of which year did Walmart spend the most on gloss paper in terms of dollars?*/

--We select the name account from the accounts table, extract the year and month from occurre_at column and apply the sum() function
-- to the gloss_amt_usd column from the orders table  
--We join the accounts table with the orders table because we need information from both tables
--And we only want what Walmart spend so we add a condition with the where clause
--Then we group by account_name, year and month
--And we order all by total spend on gloss paper and as we only want the year and month Walmart spend the most, we take only the first row.

SELECT ac.name AS account_name,  EXTRACT(YEAR FROM o.occurred_at) AS year, EXTRACT(MONTH FROM o.occurred_at) AS month, SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM accounts ac JOIN orders o ON ac.id=o.account_id
WHERE ac.name = 'Walmart'
GROUP BY account_name, year, month
ORDER BY gloss_total_usd DESC
limit 1

