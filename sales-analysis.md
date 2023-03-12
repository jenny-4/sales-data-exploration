# Sales Analysis


we have records of orders for different types of paper placed by companies such as Walmart, Microsoft, among others. We can see how much of each type of paper was ordered, how much was spent, who was responsible for the order, in which region the company is located, and the dates of the different web events each company has conducted .

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
Note that year-on-year there has been a steady increase in sales, with a surge of over 50\% in the 2017. At this rate, we might expect 2017 to have the largest sales.

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


Once we saw how much we have grown year after year, we can ask ourselves how much paper each company consumes. For this, we can make the following query:

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
CBS                        |1482.0300000000000000|239.6800000000000000  |6926.3600000000000000|8648.0700000000000000    |
Berkshire Hathaway         |5728.5200000000000000|0.00000000000000000000|1745.8000000000000000|7474.32000000000000000000|
Starbucks                  |818.3600000000000000 |2348.1150000000000000 |4271.1200000000000000|7437.5950000000000000    |
CenturyLink                |1487.0200000000000000|2931.0866666666666667 |3004.4000000000000000|7422.5066666666666667    |
Edison International       |3775.4340000000000000|188.7480000000000000  |3438.0080000000000000|7402.1900000000000000    |

From the table above we observe that *Pacific Life* is the company who has bought us the most, followed by  *Fidelity National Financial.*
With an analogous procedure we obtain the companies that have bought the least from us. In this case,  Nike.

Also, if we are interested in a specific type of paper, we can sort the previous table; for example, let's say we are interested in standard  paper, then we sort by the avg_standard_amt_usd column, and in this way, we can see who has spent the most on that type of paper.

Let's say now that we want to know the unit price that each company paid per order, but only for those  that have bought more than 100 standard type papers and 50 poster papers.

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

We could also use this unit price to get an idea of the cost of producing a certain type of paper. Similarly, we can compare this unit price with that of its competitors.

## Conclusions
1. Year-on-year there has been a steady increase in sales with a surge of over 50\% in the 2017
2. We expect 2017 to have the largest sales.
3. Our biggest client is *Pacific Life* followed by *Fidelity National Financial.*
4. The highest unit price is 8.08 USD, which corresponds to *IBM.*




