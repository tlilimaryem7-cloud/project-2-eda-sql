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

