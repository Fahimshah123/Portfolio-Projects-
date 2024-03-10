-- see all the data
Select *
From pizza_sales

-- Total Revenue
Select SUM(total_price) AS Total_Revenue
from pizza_sales

-- Average Order Value
SELECT SUM(total_price) / COUNT(DISTINCT order_id) As Avg_Order_Value
FROM pizza_sales

-- Total Order Sold
SELECT SUM(quantity) As Total_Pizza_Sold
FROM pizza_sales

-- Total Orders
SELECT COUNT(DISTINCT order_id) AS Total_Orders
FROM pizza_sales

-- Average Pizza Per Order
SELECT CAST(CAST(SUM(quantity) AS decimal(10,2)) / 
CAST(COUNT(DISTINCT order_id) AS decimal(10,2)) AS decimal(10,2)) AS AvgPizzaPerOrder
FROM pizza_sales

-- Problem Statement 

-- Daily Trend For Total Orders
SELECT DATENAME(DW, order_date) as order_day, COUNT(DISTINCT order_id) As Total_Orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date)

-- Monthly Trend For Total Orders
SELECT DATENAME(MONTH, order_date) as Month_Name, COUNT(DISTINCT order_id) AS Total_Orders_per_Month
From pizza_sales
Group By DATENAME(MONTH, order_date)
ORDER BY Total_Orders_per_Month DESC

-- Percentage of state by pizza category
SELECT pizza_category, SUM(total_price) As total_sales,
 SUM(total_price) * 100 / (select sum(total_price) from pizza_sales)
AS Total_Sales_Percentage
FROM pizza_sales
GROUP BY pizza_category

-- Percentage of sales by pizza size
SELECT pizza_size, CAST(SUM(total_price) As decimal(10,2)) As total_sales,
CAST(SUM(total_price) as decimal(10,2)) * 100 / (select sum(total_price) from pizza_sales)
AS Total_Sales_Percentage
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Total_Sales_Percentage DESC

-- Top 5 Best sells pizza by revenue
-- Total Quantity And Total Order
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue DESC

-- Bottom 5 pizza by revenue
SELECT TOP 5 pizza_name, SUM(total_price) AS Total_Revenue
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Revenue ASC

-- Top 5 pizza seles by quantity
SELECT TOP 5 pizza_name, SUM(quantity) AS Total_Quantity
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Quantity DESC

-- Top 5 pizza by total order
SELECT TOP 5 pizza_name, COUNT(DISTINCT order_id) AS Total_Order
FROM pizza_sales
GROUP BY pizza_name
ORDER BY Total_Order DESC

