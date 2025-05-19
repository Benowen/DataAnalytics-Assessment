SELECT
    p.id AS plan_id,
    p.owner_id,
    -- categorizing the plan type
    CASE
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    MAX(s.transaction_date) AS last_transaction_date,
    -- calculating the number of inactive days
    DATEDIFF(CURDATE(), MAX(s.transaction_date)) AS inactivity_days
FROM savings_savingsaccount s
JOIN plans_plan p
    ON s.plan_id = p.id
WHERE
    -- checking that the account is still active
    p.is_deleted = 0
    AND s.confirmed_amount > 0
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY p.id, p.owner_id, type
HAVING inactivity_days > 365;
