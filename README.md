# Adashi SQL Analytics Tasks 

This readme outlines the SQL solutions to the four analytics tasks requested by the different departments
(Marketing, Finance, and Operations) withing the Adashi Platform.
The SQL solutions are written for MySQL.

--- 
## Task 1: High-Value Customers with multiple Products
- Identify Customers with both savings and investment plans and sort by total deposits

### Approach
- Joined the `savings_savingsaccount` table  `plans_plan` to classify transactions into savings or investments.
- Retrieved the owner_id, customer name and then used conditional aggregation (`COUNT(DISTINCT CASE...)`) to count how many plans of each type exists per user.
- Calculated the total deposits using `SUM(confirmed amount)`.
- Filtered for users who have both savings and investment plans by using their savings_count and investment_count.
- Grouped by `owner_id` and sorted by total deposits.
--- 
## Task 2: Transaction Frequency Analysis
- Objective: categorizing customers based on the average number of transactions per month:
    - High Frequency: >= 10/month
    - Medium Frequency: 3-9/month
    - Low frequency <= 2/month

### Approach
- Calculated the monthly trasaction per customer for each year.
- Got the average of those counts by storing the results of the first query in a CTE
- and bucket the customers into frequency groups using case statements.
- This returned the frequency category, customer_count and average transactions per month

---

## Task 3: Account Inactivity alert (No inflows in 1+ Years)
- Objective: find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)

### Approach
- All transactions were tracked in the `savings_savingsaccount` table.
- joined with the `plans_plan` table to get plan types.
- filtering was done on the confirmed_amount for deposits, is_regular_savings or is_a_fund to get plan types, and is_deleted to ensure the plan was still active.
- `MAX(transaction_date)` was used to find the last inflow and calculated the inactive days using the DATEDIFF() function to get the number of days between the current date and the last trasaction date.

### Challenges:
- Wasn't sure if `last_charged_date` in `plans_plan` table represented inactivity. 
- Resolved by querying both columns from both tables to confirm the most recent trasaction.

---


## Task 4: Customer Lifetime Value (CLV) Estimation
- Objective: Estimate customer lifetime value based on:
    - Tenure (months since signup)
    - Total transaction volume
    - Assumed 0.1% profit per transaction value

### Approach
- joined `users_customuser` table with `savings_savingsaccount` table.
- Calculated tenure using `TIMESTAMPDIFF()` function to get the number of months between current date and date the customer joined.
- calculated the total transaction value of each customer by suming the confirmed_amount and applied the CLV formula given
- avoided divided by zero error by having tenure months higher than zero.
- converted from kobo to naira by divding by 100

