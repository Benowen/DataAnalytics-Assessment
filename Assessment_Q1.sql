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


