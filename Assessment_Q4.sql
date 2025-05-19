SELECT
    u.id AS customer_id,
    u.name,
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    COUNT(s.id) AS total_transactions,
    ROUND((
        (SUM(s.confirmed_amount) / TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE())) * 12 * 0.001
    ) / 100, 2) AS estimated_clv
FROM users_customuser u
JOIN savings_savingsaccount s
    ON u.id = s.owner_id
WHERE s.confirmed_amount > 0
GROUP BY u.id, u.name
HAVING tenure_months > 0
ORDER BY estimated_clv DESC;

