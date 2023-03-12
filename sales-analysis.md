# Sales Analysis

Firstable lets see how much we sale per year

````sql
SELECT EXTRACT(YEAR FROM occurred_at) AS year, SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC
````

year|total_usd  |
----|-----------|
2017|78151.43   |
2013|377331.00  |
2014|4069106.54 |
2015|5752004.94 |
2016|12864917.92|


We observe that in 2013 and 2017 there were less sales, but except for them, sales have been increasing year after year and that 2016 is the year with the most sales.

The next table shows that for 2013 and 2017 there is only one month of sales for each of these years.

````sql
SElECT EXTRACT(YEAR FROM occurred_at) AS year, 
EXTRACT(MONTH FROM occurred_at) AS month, SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2013 OR EXTRACT(YEAR FROM occurred_at) = 2017
GROUP BY year, month
ORDER BY year
````

year|month|total_usd|
----|-----|---------|
2013|12	  |377331.00|
2017|1	  |78151.43 |



If we dig a little deeper, we can see that only two days are registered in 2017, the first and second day of January.

````sql
SElECT EXTRACT(YEAR FROM occurred_at) AS year, 
EXTRACT(MONTH FROM occurred_at) AS month, EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(YEAR FROM occurred_at)=2017
GROUP BY year, month, day
ORDER BY total_usd ASC
````

year|month|day|total_usd|
----|-----|---|---------|
2017|1    |2  |6451.76  |
2017|1    |1  |71699.67 |


Now we compare the total in January 1rst of  every year. 
Note that year-on-year there has been a steady increase in sales. 

````sql
SELECT EXTRACT(YEAR FROM occurred_at) AS year, EXTRACT(MONTH FROM occurred_at) AS month,  EXTRACT(DAY FROM occurred_at) AS day,
SUM(total_amt_usd) AS total_usd
FROM orders
WHERE EXTRACT(MONTH FROM occurred_at)=1 AND EXTRACT(DAY FROM occurred_at)=1
GROUP BY year, month, day
ORDER BY total_usd ASC
````

year|month|day|total_usd|
----|-----|---|---------|
2014|1    |1  |14850.29 |
2015|1    |1  |23235.79 |
2016|1    |1  |28256.34 |
2017|1    |1  |71699.67 |


In the table below we can see how much our sales grew by year
````sql
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
````

year|month|day|total_usd|growth  |percentage_growth        |
----|-----|---|---------|--------|-------------------------|
2014|1    |1  |14850.29	|	     |                         |
2015|1    |1  |23235.79	|8385.50 |56.46691074719752947600  |
2016|1    |1  |28256.34	|5020.55 |21.60696924873223591700  |
2017|1    |1  |71699.67	|43443.33|153.7471944349480500     |

From 2016 to 2017 our sales grew 153\%.

For each account we determine the average amount of each type of paper each company purchased across their orders.

````sql
SELECT ac.name AS account_name, AVG(o.standard_qty) AS average_standard_qty, AVG(o.gloss_qty) AS average_gloss_qty, AVG(o.poster_qty) AS average_poster_qty, AVG(total) as average_total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY average_standard_qty DESC
````

account_name             |average_standard_qty |average_gloss_qty   |average_poster_qty  |average_total        |
-------------------------|---------------------|--------------------|--------------------|---------------------|
State Farm Insurance Cos.|1891.7777777777777778|235.2222222222222222|150.4444444444444444|2277.444444444444444 |
Kohl's                   |1878.2857142857142857|285.7142857142857143|167.4285714285714286|2331.4285714285714286|
Berkshire Hathaway       |1148.0000000000000000|0.000000000000000000|215.0000000000000000|1363.0000000000000000|
Edison International     |756.6000000000000000 |25.2000000000000000	|423.4000000000000000|1205.2000000000000000|
Core-Mark Holding        |743.1607142857142857 |35.4821428571428571	|20.4642857142857143 |799.1071428571428571 |


The company that has bought us more quantity of paper is *State Farm Insurance Cos.*

Now we determine the average amount spent per order on each paper type. 

````sql
SELECT ac.name AS account_name, AVG(o.standard_amt_usd) AS avg_standard_amt_usd, AVG(o.gloss_amt_usd) AS avg_gloss_amt_usd,
AVG(o.poster_amt_usd) AS avg_poster_amt_usd, AVG(o.standard_amt_usd)+AVG(o.gloss_amt_usd)+AVG(o.poster_amt_usd) as total
FROM accounts ac JOIN orders o ON ac.id=o.account_id 
GROUP BY ac.name
ORDER BY total DESC
````

account_name               |avg_standard_amt_usd |avg_gloss_amt_usd     |avg_poster_amt_usd   |total                    |
---------------------------|---------------------|----------------------|---------------------|-------------------------|
Pacific Life               |1675.1046153846153846|227.0046153846153846	|17737.827692307692   |19639.9369230769227692   |
Fidelity National Financial|2015.9600000000000000|120.7762500000000000	|11616.675000000000   |13753.4112500000000000   |
Kohl's	                   |9372.6457142857142857|2140.0000000000000000	|1359.5200000000000000|12872.1657142857142857   |
State Farm Insurance Cos.  |9439.9711111111111111|1761.8144444444444444	|1221.6088888888888889|12423.3944444444444444   |
AmerisourceBergen          |888.2200000000000000 |1964.2525000000000000	|6832.9800000000000000|9685.4525000000000000    |


From the table above we observe that *Pacific Life* is the company who has bought us the most, followed by  *Fidelity National Financial.*
With an analogous procedure we obtain the companies that have bought the least from us. In this case,  *Nike.*

Also, if we are interested in a specific type of paper, we can sort the previous table; for example, let's say we are interested in standard  paper, then we sort by the avg_standard_amt_usd column, and in this way, we can see who has spent the most on that type of paper.

For now, lets see how much paper we have sold.

````sql
SELECT SUM(standard_qty) AS total_standard_qty, 
SUM(gloss_qty) AS total_gloss_qty, 
SUM(poster_qty) AS total_poster_qty, 
FROM orders
````

total_standard_quantity|total_gloss_quantity|total_poster_quantity|
-----------------------|--------------------|---------------------|
1938346	               |1013773	            |723646	              |


````sql
SELECT SUM(standard_qty) AS total_standard_qty, 
SUM(standard_amt_usd) AS total_standard_usd, 
SUM(gloss_amt_usd) total_gloss_usd, 
SUM(poster_amt_usd) AS  total_poster_usd 
FROM orders
````

total_standard_usd|total_gloss_usd |total_poster_usd|
------------------|----------------|----------------|
9672346.54	      |7593159.77      |5876005.52      |

From the two tables above we observe that the paper that has sold the most is standard paper.

Let's say we want to know the unit price that each company paid per order, but only for those  that have bought more than 100 standard type papers and 50 poster papers.

````sql
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price ASC
````

region   |account_name             |unit_price        |
---------|-------------------------|------------------|
Northeast|State Farm Insurance Cos.|5.1192822502542913|
Southeast|DISH Network             |5.2318158475403638|
Northeast|Travelers Cos.           |5.2351813313106532|
Northeast|Best Buy                 |5.2604264379300265|
West     |Stanley Black & Decker   |5.2663955600739988|


````sql
SELECT r.name as region, ac.name as account_name, o.total_amt_usd/(o.total + 0.01) as unit_price
FROM region r JOIN sales_reps sr ON r.id=sr.region_id JOIN accounts ac ON sr.id=ac.sales_rep_id JOIN orders o ON ac.id = o.account_id
WHERE o.standard_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC
````

region   |account_name               |unit_price        |
---------|---------------------------|------------------|
Northeast|IBM                        |8.0899060822781456|
West     |Mosaic                     |8.0663292103581285|
West     |Pacific Life               |8.0630226525147913|
Northeast|CHS                        |8.0188493267801133|
West     |Fidelity National Financial|7.9928024668468328|

The lowest unit price is 5.11 USD and corresponds to *State Farm Insurance Cos.*, while the highest unit price is 8.08 USD, which corresponds to *IBM.*

Knowing the unit price is important because it allows the buyer to understand how the total sales amount was calculated. That is, it is a matter of transparency and providing all the necessary information to the customer.

We could also use this unit price to get an idea of the cost of producing a certain type of paper. Similarly, we can compare this unit price with that of our competitors.

## Conclusions
1. Year-on-year there has been a steady increase in sales with a surge of over 100\% from 2016 to 2017.
2. We expect 2017 to have the largest sales.
3. Our biggest client is *Pacific Life* followed by *Fidelity National Financial.*
4. The paper that has sold the most is standard type paper.
5. The highest unit price is 8.08 USD, which corresponds to *IBM.*




