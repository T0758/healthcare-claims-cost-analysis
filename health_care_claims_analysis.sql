SELECT *
FROM claims c  
INNER JOIN members m 
ON cl.member_id = m.member_id;

-- Standardizing data

ALTER TABLE claims
ADD COLUMN claim_date_new date;

UPDATE claims
SET claim_date_new = str_to_date(claim_date, "%m/%d/%Y");

SELECT *
FROM claims;

-- ALTER TABLE claims
-- DROP COLUMN claim_date;

ALTER TABLE claims
RENAME COLUMN claim_date_new TO claim_date;

-- checking for duplicates
WITH duplicate_cte AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY member_id ORDER BY member_id) AS row_numb
FROM members)
SELECT * FROM duplicate_cte
WHERE row_numb>1;

WITH duplicate_cte2 AS(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY claim_id ORDER BY claim_id) AS row_num
FROM claims)
SELECT * FROM duplicate_cte2
WHERE row_num>1;

 -- checking for null values and blanks
SELECT
	SUM(claim_id IS NULL) AS claim_id_nulls,
    SUM(member_id IS NULL) AS member_id_nulls,
    SUM(provider_id IS NULL) AS provider_id_nulls,
	SUM(claim_date IS NULL) AS claim_date_nulls,
    SUM(claim_type IS NULL) AS claim_type_nulls,
    SUM(cpt_code IS NULL) AS cpt_code_nulls,
    SUM(icd_code IS NULL) AS icd_code_nulls,
    SUM(billed_amount IS NULL) AS billed_amount_nulls,
    SUM(paid_amount IS NULL) AS paid_amount_nulls,
    SUM(claim_date IS NULL) AS claim_date_nulls
FROM claims;

SELECT
	SUM(member_id IS NULL) AS member_id_nulls,
    SUM(member_age IS NULL) AS member_age_nulls,
    SUM(member_gender IS NULL) AS member_gender_nulls,
    SUM(plan_type IS NULL) AS plan_type_nulls,
    SUM(enrollment_start_date IS NULL) AS enrollment_start_date_nulls,
    SUM(enrollment_end_date IS NULL) AS enrollment_end_date_nulls
FROM members;

SELECT
	SUM(CASE WHEN claim_id = " " THEN 1 ELSE 0 END) AS claim_id_blanks,
    SUM(CASE WHEN member_id = " " THEN 1 ELSE 0 END) AS member_id_blanks,
    SUM(CASE WHEN provider_id = " " THEN 1 ELSE 0 END) AS provider_id_blanks,
    SUM(CASE WHEN claim_type = " " THEN 1 ELSE 0 END) AS claim_type_blanks,
    SUM(CASE WHEN cpt_code = " " THEN 1 ELSE 0 END) AS cpt_code_blanks,
    SUM(CASE WHEN icd_code = " " THEN 1 ELSE 0 END) AS icd_code_blanks,
    SUM(CASE WHEN billed_amount = " " THEN 1 ELSE 0 END) AS billed_amount_blanks,
    SUM(CASE WHEN paid_amount = " " THEN 1 ELSE 0 END) AS paid_amount_blanks
FROM claims;

SELECT
	SUM(CASE WHEN member_id = " " THEN 1 ELSE 0 END) AS member_id_blanks,
    SUM(CASE WHEN member_age = " " THEN 1 ELSE 0 END) AS member_age_blanks,
    SUM(CASE WHEN member_gender = " " THEN 1 ELSE 0 END) AS member_gender_blanks,
    SUM(CASE WHEN plan_type = " " THEN 1 ELSE 0 END) AS plan_type_blanks,
    SUM(CASE WHEN enrollment_start_date = " " THEN 1 ELSE 0 END) AS enrollment_start_date_blanks,
    SUM(CASE WHEN enrollment_end_date = " " THEN 1 ELSE 0 END) AS enrollment_end_date_blanks
FROM members;


-- claim type cost breakdown
WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT claim_type,
COUNT(claim_id) AS no_of_claims,
SUM(billed_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount
FROM base_data
GROUP BY claim_type
ORDER BY total_paid_amount DESC;

-- CPT and ICD Cost Drivers
WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT cpt_code,
COUNT(claim_id) AS claim_count,
SUM(billed_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount,
ROUND(
SUM(paid_amount)/COUNT(claim_id),2) AS average_paid_per_claim
FROM base_data
GROUP BY cpt_code
ORDER BY average_paid_per_claim DESC
LIMIT 10;

WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT icd_code,
COUNT(claim_id) AS claim_count,
SUM(billed_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount,
ROUND(
SUM(paid_amount)/COUNT(claim_id),2) AS average_paid_per_claim
FROM base_data
GROUP BY icd_code
ORDER BY average_paid_per_claim DESC
LIMIT 10;

-- member level analysis
WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT member_id,
SUM(billed_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount
FROM base_data
GROUP BY member_id
ORDER BY total_paid_amount DESC
LIMIT 10;

WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT member_id, claim_type,
SUM(billed_amount) AS total_billed_amount,
SUM(paid_amount) AS total_paid_amount
FROM base_data
GROUP BY member_id, claim_type
HAVING member_id = 6
ORDER BY member_id, total_paid_amount DESC;

-- Billed Vs Paid Ratio
WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    provider_id,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT claim_type,
(paid_amount/billed_amount) AS paid_atio
FROM base_data
WHERE (paid_amount/billed_amount) > 1;

WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    provider_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT provider_id,
(paid_amount/billed_amount) AS paid_ratio
FROM base_data
WHERE (paid_amount/billed_amount) >1;

WITH base_data AS(
SELECT
	c.member_id,
    claim_id,
    provider_id,
    claim_type,
    cpt_code,
    icd_code,
    billed_amount,
    paid_amount
FROM claims c
INNER JOIN members m 
ON c.member_id = m.member_id)
SELECT cpt_code,
(paid_amount/billed_amount) AS paid_ratio
FROM base_data
WHERE (paid_amount/billed_amount) >1;

