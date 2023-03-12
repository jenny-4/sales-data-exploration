# Sales Analysis

## Questions and Answers
we have records of orders for different types of paper placed by companies such as Walmart, Microsoft, among others. We can see how much of each type of paper was ordered, how much was spent, who was responsible for the order, in which region the company is located, and the dates of the different web events each company has conducted .

Firstable lets see how much we sale per year


````sql
SELECT EXTRACT(YEAR FROM occurred_at) AS year, SUM(total_amt_usd) AS total_usd
FROM orders
GROUP BY year
ORDER BY total_usd ASC
````

**Results**

year|total_usd  |
----|-----------|
2017|78151.43   |
2013|377331.00  |
2014|4069106.54 |
2015|5752004.94 |
2016|12864917.92|

