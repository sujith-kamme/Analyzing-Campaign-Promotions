-- "Business Requests"

-- "Q1" 
-- Business Requirement: List of products with a base price greater than 500 and that are featured in promo type BOGOF. 
-- Rationale: To identify high-value products that are currently being heavily discounted, which can be used for pricing and promotional strategies.

SELECT 
	DISTINCT product_name
FROM 
	fact_events fe
INNER JOIN 
	dim_products dp ON fe.product_code = dp.product_code
WHERE 
	fe.base_price > 500 AND fe.promo_type = "BOGOF";


-- "Q2"
-- Business Requirement: Generate a report that provides an overview of the number of stores in each city. The results will be sorted in descending order of store counts, allowing us to identify the cities with the highest store presence. The report includes two essential fields: city and store count.
-- Rationale: This report aids in optimizing retail operations.

SELECT
	city, 
    COUNT(*) AS store_count
FROM 
	dim_stores 
GROUP BY 
	city 
ORDER BY 
	COUNT(*) DESC;

-- "Q3"
-- Business Requirement: Generate a report that displays each campaign along with the total revenue generated before and after the campaign? The report includes three key fields: campaign_name, total_revenue(before_promotion), total_revenue(after_promotion).
-- Rationale: To help in evaluating the financial impact of the promotional campaigns. (Display the values in millions)

SELECT 
    campaign_name, 
    SUM(base_price * `quantity_sold(before_promo)`) AS `total_revenue(before_promotion)`,
    SUM(base_price * `quantity_sold(after_promo)`) AS `total_revenue(after_promotion)`
FROM 
    fact_events f 
JOIN 
    dim_campaigns d ON f.campaign_id = d.campaign_id 
GROUP BY 
    campaign_name;

-- "Q4"
-- Business Requirement: Produce a report that calculates the Incremental Sold Quantity (ISU%) for each category during the Diwali campaign. Additionally, provide rankings for the categories based on their ISU%. The report will include three key fields: category, isu%, and rank order.
-- Rationale: This information will assist in assessing the category-wise success and impact of the Diwali campaign on incremental sales.

SELECT 
    category as category, 
    ((SUM(`quantity_sold(after_promo)`) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) AS `isu%`, 
    RANK() OVER (ORDER BY ((SUM(`quantity_sold(after_promo)`) - SUM(`quantity_sold(before_promo)`)) / SUM(`quantity_sold(before_promo)`) * 100) DESC) AS `rank order`
FROM 
    fact_events f
JOIN
	dim_products d ON f.product_code = d.product_code
WHERE 
    campaign_id = 'CAMP_DIW_01' 
GROUP BY 
    category;

-- "Q5"
-- Business Requirement: Create a report featuring the Top 5 products, ranked by Incremental Revenue Percentage (IR%), across all campaigns. The report will provide essential information including product name, category, and ir%.
-- Rationale: This analysis helps identify the most successful products in terms of incremental revenue across our campaigns, assisting in product optimization.

SELECT 
    product_name as `product name`,
    category as `category`,
    ((SUM(base_price * `quantity_sold(after_promo)`) - SUM(base_price * `quantity_sold(before_promo)`)) / SUM(base_price * `quantity_sold(before_promo)`) * 100) AS ir
FROM 
    fact_events f
JOIN
	dim_products d ON f.product_code = d.product_code
WHERE 
    campaign_id = 'CAMP_DIW_01' 
GROUP BY 
    product_name
ORDER BY
	ir DESC
LIMIT 5;











