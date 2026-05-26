CREATE DATABASE IF NOT EXISTS zepto_project;
USE zepto_project;
SHOW TABLES;

#_____________________________________________#

#Q.1: Data Validation and Row Count Analysis.
select count(*) as Total_Rows from zepto;

#Q.2: Data Preview for Quality Check.
select * from zepto limit 10;

ALTER TABLE zepto CHANGE COLUMN `ï»¿Category` `Category` VARCHAR(255);   #Byte order matrix (BOM)

select * from zepto;

#Q.2: Identifying Unique Product Categories.
select distinct ï»¿Category from zepto;

#Q.3: Change Column Name.
ALTER TABLE zepto CHANGE COLUMN `ï»¿Category` `Category` VARCHAR(255);

#Q.4 Identifying Unique Product Category.
select distinct category from zepto;

#Q.5 Category-Wise Product Count Analysis.
SELECT 
    Category, 
    COUNT(*) AS Total_Count 
FROM zepto 
GROUP BY Category 
ORDER BY Total_Count DESC;

#Q.6 Average Selling Price per Category.
select
    category,
	avg(discountedSellingPrice/100) as average_price
from zepto
group by category;

#Q.7 Maximum Product Price per Category
select
    category,
	max(discountedSellingPrice/100) as Highest_price
from zepto
group by category
order by Highest_price DESC;

#Q.8 Minimum Product Price per Category
select
	category,
	min(discountedSellingPrice/100) as Lowest_price
from zepto
group by category
order by Lowest_price DESC;

#Q.9: Out of Stock Analysis for Immediate Reordering 
select
	category,
    name,
    availableQuantity,
    outOfStock 
from zepto
where outOfStock = 'True' or availableQuantity = 0;

#Q.10: Proactive Low Stock Warning (Buffer Management)
select 
	category,
    name,
    availableQuantity
from zepto
where availableQuantity >= 0 and availableQuantity <=2
order by availableQuantity ASC;
    
#Q.11: Total Inventory Value per Category (Financial Exposure)
select
	category,
    sum(availableQuantity * (discountedSellingPrice/100)) AS Total_Inventory_Values
from zepto
group by category
order by Total_Inventory_Values DESC;

select * from zepto;

#Q.12: Average Discount % per Category
select
	category,
    round(avg(discountpercent),2) AS avg_discount_Percent
from zepto
group by category
order by avg_discount_Percent DESC;
 
 #Q.13: Identification of Top 3 Deepest Discounted Products.
 select
	category,
    name,
    (mrp/100) AS Original_MRP,
    (discountedSellingPrice/100) AS Discounted_Selling_Price,
    discountPercent AS Discount_Percent
from zepto
order by discountPercent DESC
limit 3 ; 

#Q.14: Total Financial Savings Sitting in Inventory
select
	category,
    round(sum(availableQuantity*((mrp-discountedSellingPrice)/100)),2) AS Total_Active_Discount_Value
from zepto
group by category
order by Total_Active_Discount_Value DESC;

#Q.15: Premium Product Screening (Most Expensive Item per Category)
SELECT 
  category,
  name,
  discountedSellingPrice/100 AS highest_price
from zepto z1
where discountedSellingPrice = (
	select max(discountedSellingPrice)
    from zepto z2
    WHERE z2.Category = z1.Category
    )
order by highest_price DESC;

#Q.16: Price per Kilogram Analysis for Fruits & Vegetables
select
	category,
    name,
    weightInGms,
    discountedSellingPrice/100 AS Selling_Price,
    round(((discountedSellingPrice/100)/(weightInGms/1000)),2) AS Price_Per_KG
from zepto
where category ='Fruits & Vegetables' AND weightInGms > 0
order by Price_Per_KG DESC;

#Q.17: Total Potential Revenue: MRP vs Discounted Value
select
	category,
    round(sum(availableQuantity * (mrp/100)),2) AS Total_Max_MRP,
    round(sum(availableQuantity * (discountedSellingPrice/100)),2) AS Total_Active_Value,
    round(sum(availableQuantity * ((mrp-discountedSellingPrice)/100)),2) AS Total_Customer_Saving
from zepto
group by category
order by Total_Active_Value DESC;

#Q.18: Zero-Discount (Full-Price) Products Analysis
SELECT 
    Category,
    COUNT(*) AS Zero_Discount_Products,
    ROUND(AVG(discountedSellingPrice / 100), 2) AS Avg_Price_Of_Non_Discounted_Items
FROM zepto
WHERE discountPercent = 0
GROUP BY Category 
ORDER BY Zero_Discount_Products DESC;

#Q.19: Stock Segmentation / ABC Analysis
SELECT 
    CASE 
        WHEN availableQuantity = 0 THEN '0: Out of Stock'
        WHEN availableQuantity BETWEEN 1 AND 2 THEN '1-2: Low Stock (Urgent Reorder)'
        WHEN availableQuantity BETWEEN 3 AND 4 THEN '3-4: Medium Stock'
        ELSE '5-6: High/Full Stock'
    END AS Stock_Segment,
    COUNT(*) AS Total_Products
FROM zepto
GROUP BY Stock_Segment
ORDER BY Stock_Segment;

#Q.20: Clearance Stock / Massive Discount Items (More than 50% Off)
SELECT 
    Category,
    name,
    discountPercent,
    (mrp/100) AS Original_MRP,
    (discountedSellingPrice/100) AS Selling_Price
FROM zepto
WHERE discountPercent >= 50
ORDER BY discountPercent DESC;

#Q.21: Creating an Automated Restock Alert View
CREATE VIEW v_urgent_restock_alerts AS
SELECT 
    Category,
    name,
    availableQuantity,
    CASE 
        WHEN availableQuantity = 0 THEN 'OUT OF STOCK'
        ELSE 'LOW STOCK'
    END AS Urgency_Level
FROM zepto
WHERE availableQuantity <= 2;

SELECT * FROM v_urgent_restock_alerts;


#__________Thanks Project End__________________#






    
    
    
  
    








