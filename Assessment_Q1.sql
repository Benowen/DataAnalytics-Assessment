
USE adashi_staging;

SELECT * FROM plans_plan ORDER BY RAND() LIMIT 10;
SELECT * FROM savings_savingsaccount ORDER BY RAND() LIMIT 10;
SELECT * FROM users_customuser ORDER BY RAND() LIMIT 10;
SELECT * FROM withdrawals_withdrawal ORDER BY RAND() LIMIT 10;

-- High-Value Customers with Multiple Products
/* 
Write a query to find customers with at least one funded savings plan 
AND one funded investment plan, sorted by total deposits.
*/

SELECT
  u.id AS owner_id,
  CONCAT(u.first_name, ' ', u.last_name) AS name,
  -- how many distinct savings plans (regular‐savings) they’ve funded
  COUNT(DISTINCT CASE
                   WHEN p.is_regular_savings = 1
                    AND s.confirmed_amount > 0
                   THEN p.id
                 END) AS savings_count,
  -- how many distinct investment plans (fixed‐investment) they’ve funded
  COUNT(DISTINCT CASE
                   WHEN p.is_a_fund = 1
                    AND s.confirmed_amount > 0
                   THEN p.id
                 END) AS investment_count,
  -- total volume of all deposits (across both plan‐types)
  SUM(s.confirmed_amount) AS total_deposits
FROM users_customuser u
  JOIN plans_plan p
    ON p.owner_id = u.id
  JOIN savings_savingsaccount s
    ON s.plan_id  = p.id
GROUP BY
 owner_id, name
HAVING
  savings_count >= 1
  AND investment_count >= 1
ORDER BY
  total_deposits DESC;

-- Transaction Frequency Analysis
/*
 Calculate the average number of transactions 
 per customer per month and categorize them:
 - High Frequency" (≥10 transactions/month)
 - Medium Frequency" (3-9 transactions/month)
 - Low Frequency" (≤2 transactions/month)
*/
-- count transactions per customer per calender month
WITH monthly_cust_tx AS (
  SELECT
    C.id,
    DATE_FORMAT(transaction_date, "%Y-%m") AS `Year_month`,
    COUNT(*) AS Total_Transactions
  FROM users_customuser c 
  JOIN savings_savingsaccount s
    ON c.id = s.owner_id
  GROUP BY
    c.id,
    `Year_month`
),
-- calculate each customer average trasaction per month
cust_avg_tx AS (
  SELECT
    id,
    avg(Total_Transactions) as Avg_total_transactions
  FROM monthly_cust_tx
  GROUP BY id
)
-- categorizing the frequency of tranasations per customer
SELECT 
  CASE
    WHEN Avg_total_transactions >= 10 THEN 'High Frequency'
    WHEN Avg_total_transactions BETWEEN 3 AND 9 Then 'Medium Frequency'
    ELSE 'Low Frequency'
  END AS Frequency_Category,
  COUNT(id) AS Customer_Count,
  ROUND(AVG(Avg_total_transactions),2) as avg_transaction_per_month
FROM cust_avg_tx
GROUP BY Frequency_Category
ORDER BY
  FIELD(Frequency_Category, 'High Frequency', 'Medium Frequency', 'Low Frequency');




