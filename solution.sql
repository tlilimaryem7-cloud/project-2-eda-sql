--- Total number of insurance claims
SELECT COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1;


--- Average NCAP rating (proxy for claim “severity”) by vehicle segment
SELECT segment, AVG(ncap_rating) AS avg_ncap_rating
FROM insurance
GROUP BY segment
ORDER BY avg_ncap_rating DESC;


--- Regions with highest number of claims
SELECT region_code, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY region_code
ORDER BY total_claims DESC;


--- Variation in claims by driver age group
SELECT driver_age_group, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY driver_age_group
ORDER BY total_claims DESC;


--- Percentage of vehicles with claims
SELECT 
  ROUND(SUM(CASE WHEN claim_status = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS percent_claims
FROM insurance;


--- Multiple claims per policy (duplicate policy IDs)
SELECT policy_id, COUNT(*) AS claim_count
FROM insurance
WHERE claim_status = 1
GROUP BY policy_id
HAVING COUNT(*) > 1
ORDER BY claim_count DESC;


--- Claims by vehicle age group
SELECT vehicle_age_group, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY vehicle_age_group
ORDER BY total_claims DESC;


--- Claim frequency by fuel type
SELECT fuel_type, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY fuel_type
ORDER BY total_claims DESC;


--- Segments generating most claims
SELECT segment, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY segment
ORDER BY total_claims DESC;


--- Claims trend by vehicle age group
SELECT vehicle_age_group, COUNT(*) AS total_claims
FROM insurance
WHERE claim_status = 1
GROUP BY vehicle_age_group
ORDER BY vehicle_age_group;