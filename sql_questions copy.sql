SELECT 
    CASE 
        WHEN subscription_length <= 2 THEN '0-2 years'
        WHEN subscription_length <= 5 THEN '3-5 years'
        WHEN subscription_length <= 8 THEN '6-8 years'
        WHEN subscription_length <= 12 THEN '9-12 years'
        ELSE '13+ years'
    END as subscription_group,
    COUNT(*) as total_policies,
    SUM(claim_status) as total_claims,
    ROUND(AVG(claim_status) * 100, 2) as claim_rate_percentage,
    ROUND(AVG(subscription_length),2) as avg_subscription_length
FROM "Insurance claims data"
GROUP BY subscription_group
ORDER BY AVG(subscription_length);

"In this output we can see that costumer's in the range of 9-12 years suscription length have a huge differnece with other suscription length groups. 
The relation on the increase of claim rate vs suscription length doesn't appear to be linear but more like drawing a parabolic function,
where this group between 9-12 would be the function max"


SELECT 
    subscription_length,
    COUNT(*) as policy_count,
    

    SUM(claim_status) as total_claims,
    ROUND(AVG(claim_status) * 100, 2) as claim_rate_percentage,
	ROUND (AVG(customer_age),2) as avg_customer_age,
    ROUND (MIN(customer_age),2) as min_customer_age,
    ROUND (MAX(customer_age),2) as max_customer_age,
	ROUND (AVG(vehicle_age),2) as avg_vehicle_age,
    ROUND (AVG(ncap_rating),2) as avg_safety_rating,
	ROUND (AVG(region_density),2) as avg_region_density,
	ROUND (AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors + 
        is_parking_camera + is_speed_alert + is_ecw),2) as avg_safety_features,
	 ROUND(AVG(CASE WHEN fuel_type = 'Petrol' THEN 1 ELSE 0 END) * 100, 1) as petrol_percentage,
	 ROUND(AVG(claim_status) / (SELECT AVG(claim_status) FROM "Insurance claims data") * 100, 1) as risk_index
	 FROM "insurance claims data"
WHERE subscription_length BETWEEN 1 AND 15 
GROUP BY subscription_length
HAVING COUNT(*) >= 10 
ORDER BY risk_index;


-- Análisis que combina subscription length con otros factores de correlación
SELECT 
    -- Segmentación principal por subscription length
    CASE 
        WHEN subscription_length <= 5 THEN 'Short-term'
        WHEN subscription_length <= 9 THEN 'Medium-term'
        ELSE 'Long-term'
    END as subscription_group,
    
    -- Segmentación por edad del cliente
    CASE 
        WHEN customer_age < 30 THEN 'Young'
        WHEN customer_age < 50 THEN 'Middle-aged'
        ELSE 'Senior'
    END as age_group,
    
    -- Segmentación por tipo de área
    CASE 
        WHEN region_density > 2500 THEN 'Urban'
        WHEN region_density > 800 THEN 'Suburban'
        ELSE 'Rural'
    END as area_type,
    
    -- Métricas principales
    COUNT(*) as policy_count,
    ROUND(AVG(claim_status) * 100, 2) as claim_rate,
    ROUND(AVG(subscription_length), 1) as avg_subscription,
    ROUND(AVG(customer_age), 1) as avg_customer_age,
    ROUND(AVG(vehicle_age), 1) as avg_vehicle_age,
    
    -- Análisis de características de seguridad
    ROUND(AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors), 1) as avg_core_safety,
    ROUND(AVG(ncap_rating), 1) as avg_safety_rating,
    
    -- ¿Las características de seguridad realmente importan?
    CASE 
        WHEN AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors) >= 3 THEN 'High Safety'
        WHEN AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors) >= 1.5 THEN 'Medium Safety'
        ELSE 'Basic Safety'
    END as safety_level,
    
    -- Insight: ¿Contradice la hipótesis de seguridad?
    CASE 
        WHEN AVG(claim_status) > (SELECT AVG(claim_status) FROM "insurance claims data") 
             AND AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors) >= 2
        THEN 'High Safety but High Claims (Contradicts Hypothesis)'
        WHEN AVG(claim_status) < (SELECT AVG(claim_status) FROM "insurance claims data") 
             AND AVG(is_esc + is_tpms + is_brake_assist + is_parking_sensors) < 2
        THEN 'Low Safety but Low Claims (Contradicts Hypothesis)'
        ELSE 'Aligns with Safety Expectations'
    END as safety_hypothesis_test

FROM "Insurance claims data"
WHERE subscription_length > 0 AND customer_age > 0  -- Filtrar datos válidos
GROUP BY subscription_group, age_group, area_type
HAVING COUNT(*) >= 20  -- Solo grupos con datos significativos
ORDER BY claim_rate DESC;