create database Ecommerce;
use Ecommerce ;
-- Text instructions: 
-- *Load large CSV files into MySQL Database faster using Command line prompt
-- 1. Open MySQL Workbench, Create a new database to store the tables you'll import (eg- FacilitySerivces).
-- Then, Create the table with matching data types of csv file, usually with INT and CHAR datatypes only (without the data) in the database you just created using Workbench.
-- 2. Open the terminal or command line prompt (Go to windows, search for cmd.exe. Shortcut - Windows button + R, then type cmd)
-- 3. We'll now connect with MySQL database in command line prompt. Follow the steps below:
-- Copy the path of your MySQL bin directory in your computer. (Normally it is under c drive program files).
-- The bin directory of MySQL Server is generally in this path - C:\Program Files\MySQL\MySQL Server 8.0\bin
-- Now, in the Command Line prompt, type 


-- cd C:\Program Files\MySQL\MySQL Server 8.0\bin 


-- and press enter.


-- 4. Connect to the MySQL database using the following command in command line prompt


-- mysql -u root -p


-- (please replace "root" with your user name that you must have configured while installing MySQL server)
-- (press enter, it will ask for the password, give your password)


-- 5. If you are successfully logged to mysql,
-- then set the global variables by using below command so that data can be imported from local computer folder.


-- mysql> SET GLOBAL local_infile=1;


-- Query OK, 0 rows affected (0.00 sec)
-- (you've just instructed MySQL server to allow local file upload from your computer)


-- 6. Quit current server connection:
-- mysql> quit
-- Bye


-- 7. Load the file from CSV file to the MySQL database. In order to do this, please follow the commands:
-- (We'll connect with the MySQL server again with the local-infile system variable. 
-- This basically means you want to upload data into a database table from your local machine)


-- mysql --local-infile=1 -u root -p
-- (give password)


-- - Show Databases;
-- (It'll show all the databases in MySQL server.)


-- - mysql> USE fs_db2;
-- (makes the database that you had created in step 1 as default schema to use for the next sql scripts)
-- (Use your Database and load the file into the table.


-- The next step is to load the data from local case study folder into the transactionmaster table in fs_db2 database)


-- mysql> LOAD DATA LOCAL INFILE 'D:\\_Ivy Professional School\\_Data Analytics\\Course Design\\SQL - RDBMS\\Share With Students\\SQL Case Studies\\SQL Case Study\\SQL Case 3\\Case 3 - Facility Services SQL - Data & Qns\\transactionmaster.csv'
-- INTO TABLE TransactionMaster
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;


-- *VERY IMP - Please replace single backward (\) slash in the path with double back slashes (\\) instead of single slash*
-- Also note that "transactionmaster" is my table name, use the table name that you've given while creating the database in step 1.


-- 8. Now check if data has been imported or not.


-- SELECT * FROM transactionmaster LIMIT 20;


-- 9. If data has been imported successfully with 100% accuracy without error,
-- then alter the table to update the datatypes (if needed) of some columns, etc. You're all set now.


create table List_of_order (

	order_id text,
	order_Date text,
	customer varchar(50),
	state varchar(50),
	city varchar(50)
	);

	create table order_details (
	Order_id text,
	amount int,
	profit int,
	quantity int ,
	category varchar(50),
	sub_category varchar(50)
	);

	create table Target (
	month_of text,
	category varchar(50),
	target int

);

-- Q1 Query to join Orders and Order Details:-- 
	SELECT o.order_id, o.Order_Date, o.Customer, od.Amount, od.Profit, od.Quantity, od.Category, od.Sub_Category
	FROM list_of_order o
	JOIN Order_details od ON o.Order_ID = od.Order_ID;
 
 
 -- Q2 Total Sales per Customer:
	SELECT o.Customer, SUM(od.Amount) AS TotalSales
	FROM list_of_order o
	JOIN Order_Details od ON o.Order_ID = od.Order_ID
	GROUP BY o.Customer;

-- Q3 Profit by Category:
 
		 SELECT od.Category, SUM(od.Profit) AS TotalProfit
		FROM Order_Details od
		GROUP BY od.Category;

-- Q4 Top Customers by Sales:
	SELECT o.Customer as cutomer_name, SUM(od.Amount) AS TotalSales
	FROM list_of_Order o
	JOIN Order_Details od ON o.Order_ID = od.Order_ID
	GROUP BY o.Customer
	ORDER BY TotalSales DESC
	LIMIT 10;

-- Q5 Top-Selling Products
  SELECT od.Sub_Category, SUM(od.Quantity) AS TotalQuantitySold
	FROM Order_Details od
	GROUP BY od.Sub_Category
	ORDER BY TotalQuantitySold DESC
	LIMIT 10;
    
-- Q6 Average Profit by Category
   SELECT od.Category, AVG(od.Profit) AS AvgProfit
	FROM Order_Details od
	GROUP BY od.Category;
    
-- Q7 Sales by State and City
 SELECT o.State, o.City, SUM(od.Amount) AS TotalSales
	FROM list_of_Order o
	JOIN Order_Details od ON o.Order_ID = od.Order_ID
	GROUP BY o.State, o.City
	ORDER BY TotalSales DESC;

-- Q8 Most Profitable Customers
	SELECT o.Customer as customer_name, SUM(od.Profit) AS TotalProfit
	FROM list_of_Order o
	JOIN Order_Details od ON o.Order_ID = od.Order_ID
	GROUP BY o.Customer
	ORDER BY TotalProfit DESC
	LIMIT 10;

-- Q9  Product Profitability Analysis
	 SELECT od.Sub_Category, SUM(od.Profit) AS TotalProfit
	FROM Order_Details od
	GROUP BY od.Sub_Category
	ORDER BY TotalProfit DESC;

-- Q10 Low-Performing Products
	SELECT od.Sub_Category, SUM(od.Amount) AS TotalSales, SUM(od.Profit) AS TotalProfit
	FROM Order_Details od
	GROUP BY od.Sub_Category
	HAVING TotalSales < 5000 OR TotalProfit < 0
	ORDER BY TotalProfit ASC;

-- Q11  Repeat Customers
	SELECT o.Customer as customerName, COUNT(DISTINCT o.Order_ID) AS PurchaseCount
	FROM list_of_order o
	GROUP BY o.Customer
	HAVING PurchaseCount > 1
	ORDER BY PurchaseCount DESC;
    
--   Q12  Ranking Customers by Total Sales 
    SELECT o.Customer as customerName, 
       SUM(od.Amount) AS TotalSales,
       RANK() OVER (ORDER BY SUM(od.Amount) DESC) AS SalesRank
		FROM list_of_order o
		JOIN Order_Details od ON o.Order_ID = od.Order_ID
		GROUP BY o.Customer;


-- Q13  Running Total of Sales by Month 
     SELECT DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month, 
       SUM(od.Amount) AS MonthlySales,
       SUM(SUM(od.Amount)) OVER (ORDER BY DATE_FORMAT(o.Order_Date, '%Y-%m')) AS RunningTotal
		FROM list_of_order o
		JOIN Order_Details od ON o.Order_ID = od.Order_ID
		GROUP BY Month
		ORDER BY Month ASC;


-- Q14 Finding the Most Profitable Category 
		SELECT od.Category, 
		   SUM(od.Profit) AS TotalProfit,
		   MAX(SUM(od.Profit)) OVER () AS MaxProfit
			FROM Order_Details od
			GROUP BY od.Category
			ORDER BY TotalProfit DESC;
			
-- Q15   CTE: Monthly Sales with Growth
			WITH MonthlySales AS (
	  SELECT DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month, SUM(od.Amount) AS TotalSales
	  FROM list_of_order o
	  JOIN Order_Details od ON o.Order_ID = od.Order_ID
	  GROUP BY Month
	)
	SELECT Month, 
		   TotalSales,
		   TotalSales - LAG(TotalSales) OVER (ORDER BY Month) AS SalesGrowth
	FROM MonthlySales;
    
-- Q16 Top 3 Customers by Profit
    WITH CustomerProfit AS (
	  SELECT o.Customer, SUM(od.Profit) AS TotalProfit
	  FROM list_of_order o
	  JOIN Order_Details od ON o.Order_ID = od.Order_ID
	  GROUP BY o.Customer
		)
		SELECT Customer as customerName, TotalProfit,
         RANK() OVER (ORDER BY TotalProfit DESC) as ProfitRank
		FROM CustomerProfit;
        
-- Q17  Moving Average of Sales
		SELECT DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month, 
       SUM(od.Amount) AS TotalSales,
       AVG(SUM(od.Amount)) OVER (ORDER BY DATE_FORMAT(o.Order_Date, '%Y-%m') ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAvg
		FROM list_of_order o
		JOIN Order_Details od ON o.Order_ID = od.Order_ID
		GROUP BY Month
		ORDER BY Month ASC;
        
        
        
-- Q18 Percent of Total Sales  
       SELECT o.Customer, 
       SUM(od.Amount) AS CustomerSales,
       SUM(od.Amount) / SUM(SUM(od.Amount)) OVER () * 100 AS PercentOfTotalSales
		FROM list_of_order o
		JOIN Order_Details od ON o.Order_ID = od.Order_ID
		GROUP BY o.Customer
		ORDER BY PercentOfTotalSales DESC;
        
-- Q19  Highest Sales Month per Category 
		 WITH CategorySales AS (
		  SELECT od.Category, DATE_FORMAT(o.Order_Date, '%Y-%m') AS Month, SUM(od.Amount) AS MonthlySales
		  FROM list_of_order o
		  JOIN Order_Details od ON o.Order_ID = od.Order_ID
		  GROUP BY od.Category, Month
		),
		RankedSales AS (
		  SELECT Category, Month, MonthlySales,
				 RANK() OVER (PARTITION BY Category ORDER BY MonthlySales DESC) AS SalesRank
		  FROM CategorySales
		)
		SELECT Category, Month, MonthlySales, SalesRank
		FROM RankedSales
		WHERE SalesRank = 1;

-- Q20 Last Purchase Date for Each Customer
		with purchage_date as (
		SELECT *,
			   ROW_NUMBER() OVER (PARTITION BY Customer ORDER BY Order_Date DESC) AS RowNumber
		FROM list_of_order  )
		select Customer, Order_Date
		from purchage_date
		WHERE RowNumber = 1;
        
  --  Q21 Check if a customer’s total sales exceed a certain threshold. (IF Statement:)
			SELECT o.Customer, 
			   SUM(od.Amount) AS TotalSales,
			   IF(SUM(od.Amount) < 10000, 'VIP', 'Regular') AS CustomerType
			FROM list_of_order o
			JOIN Order_Details od ON o.Order_ID = od.Order_ID
			GROUP BY o.Customer;

-- Q22 Categorize customers into multiple types based on total sales.  (Nested IF:)
			SELECT o.Customer, 
			   SUM(od.Amount) AS TotalSales,
			   IF(SUM(od.Amount) > 20000, 'Platinum', 
				  IF(SUM(od.Amount) > 10000, 'Gold', 'Regular')) AS CustomerType
			FROM list_of_order o
			JOIN Order_Details od ON o.Order_ID = od.Order_ID
			GROUP BY o.Customer;
-- Q23  Get orders placed by customers from certain cities.
		SELECT * 
		FROM list_of_order
		WHERE City IN ('Ahmedabad', 'Pune', 'Jaipur');


		







