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