-- Working with SQL Stored Procedures

-- Task One: Getting Started
-- In this task, I will set the database and 
-- retrieve data from tables in the database

-- 1.1: Set the database to use
USE projectdb;

-- 1.2: Retrieve all the data in the tables
SELECT * FROM customers;
SELECT * FROM departments;
SELECT * FROM employees;
SELECT * FROM regions;
SELECT * FROM sales;

-- Task Two: The MySQL Syntax for Stored Procedures
-- In this task, I will begin to write a simple
-- stored procedures to retrieve the first 500 employees

-- 2.1: Quick notes about delimiters
-- DELIMITER $$
-- DELIMITER //
-- You can change the delimeter by the command above and choose a delimeter of your own choice.
-- 2.2: Drop procedure if it exists
DROP PROCEDURE IF EXISTS select_employees;

-- 2.3: Create a stored procedure to retrieve the first 500 employees
DELIMITER $$
CREATE PROCEDURE select_employees()
BEGIN
SELECT * FROM employees
LIMIT 500;
END $$

DELIMITER ;
-- 2.4: Call the procedure
CALL select_employees();
CALL select_employees;
CALL projectdb.select_employees;
-- You can alos call it without parenthesis ()
-- Above we can see the three different ways to call the same result.


-- Task Three: Why Stored Procedures?
-- In this task, I will see
-- about stored procedures

-- 3.1: Drop procedure if it exists
DROP PROCEDURE IF EXISTS show_depts;

-- 3.2: Create a stored procedure to retrieve all data 
-- in the departments table
DELIMITER $$
CREATE PROCEDURE show_depts()
BEGIN
	SELECT * FROM departments;
END$$

-- 3.3: Call the procedure
CALL show_depts();

-- Task Four: Doing it again
-- In this task, 
-- I will write a stored procedure that retrieves
-- the average salary of employees

-- 4.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS avg_salary;

-- 4.2: Create a stored procedure to returns the 
-- average salary of employees
 DELIMITER $$
 CREATE PROCEDURE avg_salary()
 BEGIN
	SELECT AVG(salary)
	FROM employees
END ;
DELIMITER ;
-- 4.3: Call the procedure
CALL avg_salary;

-- Task Five: Stored Procedures with an Input Parameter
-- In this task, I will write a 
-- stored procedure with an input parameter

-- 5.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_details;

-- 5.2: Create a procedure that returns the details of an
-- employee given the employee_id
DELIMITER $$
CREATE PROCEDURE emp_details(IN p_emp_id INTEGER)
BEGIN
	SELECT employee_id, first_name, last_name, hire_date, salary
    FROM employees
    WHERE employee_id = p_emp_id;
END$$

DELIMETER ;

-- 5.3: Call the procedure for employee_id 100
CALL emp_details(102);

-- 5.4: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_full_details;

-- 5.5: Retrieve all data from the employees and regions table
SELECT * FROM employees;
SELECT * FROM regions;

-- 5.6: Create a procedure that returns the details of an
-- employee including the region and country given the employee_id
DELIMITER $$
CREATE PROCEDURE emp_full_details(IN p_emp_id INTEGER)
BEGIN
	SELECT e.employee_id, e.first_name, e.last_name, e.hire_date, e.salary, r.region, r.country
    FROM employees e
    JOIN region r ON e.region_id = r.region_id
    WHERE employee_id = p_emp_id;
END$$

DELIMETER ;

-- 5.7: Call the procedure for employee_id 100
CALL emp_full_details(100);

-- Task Six: Stored Procedures with Multiple Parameters
-- In this task, I will write a
-- stored procedure with multiple input parameters

-- 6.1: Retrieve all data from the sales and customers table
SELECT * FROM sales;
SELECT * FROM customers;
    
-- 6.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS orders_year;

-- 6.3: Create a procedure that returns details of sales
-- and customers given the year and product category
DELIMITER $$
CREATE PROCEDURE orders_year(IN p_year INTEGER, p_category VARCHAR(50))
BEGIN
	SELECT s.order_date, s.customer_id, c.customer_name, c.state, s.category, s.quantity
    FROM sales s 
    JOIN customers c
    ON s.customer_id = c.customer_id
	WHERE YEAR(s.order_date) = p_year AND s.category = p_category;
END $$

DELIMITER ;
-- 6.4: Call the procedure for the year 2015 and Furniture category
CALL orders_year(2015, 'Furniture');

-- Task Seven: Stored Procedure
-- In this task, 
-- I will write a stored procedure that retrieves the total 
-- profit made from each product category for each year


-- 7.1: Start with the code below
SELECT category, SUM(profit) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;

-- 7.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS total_profit_year;

-- 7.3: Create the stored procedure that answers the question
DELIMITER $$
CREATE PROCEDURE total_profit(IN p_profit INTEGER)
BEGIN
	SELECT category, SUM(profit) AS total_profit
FROM sales
GROUP BY category
ORDER BY total_profit DESC;
END$$

DELIMITER;
-- 7.4: Call the procedure for the year 2017
CALL total_profit(2017);

-- Task Eight: Select into a variable
-- In this task, I will show how to select into a variable

-- 8.1: Retrieve all data in the regions table
SELECT * FROM regions;

-- 8.2: Retrieve the region and country for region_id 1
SELECT *
FROM regions
WHERE region_id = 1;

-- 8.3: Write the query to select into variables region and country
SELECT region, country
INTO @region, @country
FROM regions
WHERE region_id = 1;

-- 8.4: Retrieve the data in the variables
SELECT @region, @country;

-- Task Nine: Stored Procedures with an Output Parameter
-- In this task, I will show how to write a 
-- stored procedure with an output parameter


-- 9.1: Retrieve all data in the sales table
SELECT * FROM sales;

-- 9.2: Count the number of times a customer has purchased
-- from the store
SELECT COUNT(sales) AS count_sales
FROM sales	
WHERE customer_id = 'CG-12520';

-- 9.3: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS cust_avg_sales;

-- 9.4: Create a stored procedure that returns the average amount
-- in sales from a customer given the customer_id
DELIMITER $$
CREATE PROCEDURE cust_avg_sales(IN p_cust_id VARCHAR(10), OUT p_avg_sales DECIMAL(12,2))
BEGIN
	SELECT AVG(sales) AS avg_sales
    INTO p_avg_sales
    FROM sales
    WHERE customer_id = p_cust_id;
END $$

DELIMITER ;
-- 9.5: Call the stored procedure for customer 'CG-12520'
SET @v_avg_sales = 0;
CALL cust_avg_sales('CG-12520', @v_avg_sales);
SELECT @v_avg_sales;
-- 9.6: Drop the procedure if it exists
DROP procedure IF EXISTS cust_avg_sales;

-- 9.7: Create a stored procedure that returns the customers name and
-- the average amount in sales from a customer given the customer_id
DELIMITER $$
CREATE PROCEDURE cust_avg_sales(in p_cust_id VARCHAR(10), out p_name VARCHAR(100), out p_avg_sales decimal(12,2))
BEGIN
	SELECT c.customer_name, AVG(s.sales) AS avg_sales
	INTO p_name, p_avg_sales
	FROM sales s
	JOIN customers c
	ON s.customer_id = c.customer_id
	WHERE s.customer_id = p_cust_id;
END$$

DELIMITER ;

-- 9.8: Call the stored procedure for customer 'SO-20335'
CALL cust_avg_sales('SO-20335', @v_name, @v_avg_sales);
SELECT @v_name,  @v_avg_sales;

-- Task Ten:
-- In this task, 
-- I will write a procedure that returns the employee id given
-- the employees first and last names


-- 10.1: Retrieve all data in the employees table
SELECT * FROM employees;

-- 10.2: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS emp_info;

-- 10.3: Create a procedure that returns the employee id given
-- the employees' first and last names
DELIMITER $$
CREATE PROCEDURE emp_info(IN p_first_name VARCHAR(255), IN p_last_name VARCHAR(255), OUT p_emp_id INTEGER)
BEGIN
	SELECT employee_id
    INTO p_emp_id
    FROM employees
    WHERE first_name = p_first_name
    AND last_name = p_last_name;
END $$

DELIMITER ;

-- 10.4: Call the procedure for an employee whose first name is 'Eddy'
-- and last name is 'McCoole'
CALL emp_info ('Eddy', 'McCoole', @v_emp_id);
SELECT @v_emp_id;

-- Task Eleven: Wrap up
-- In this task, I will wrap up the project



-- Task Twelve: 
-- In this task, I will show you some more queries.


-- 12.1: Drop the procedure if it exists
DROP PROCEDURE IF EXISTS customer_sales_rank;

-- 12.2: Create a procedure that returns the details of top 5 customers
-- based on the total amount made in sales in different years
DELIMITER $$
CREATE PROCEDURE customer_sales_rank(IN p_year INTEGER)
BEGIN
	SELECT s.customer_id, c.customer_name, c.segment, c.state, SUM(s.sales) AS total_sales
    FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
    WHERE YEAR(s.order_date) = p_year
    GROUP BY s.customer_id
    ORDER BY total_sales DESC
    LIMIT 5;
END$$

DELIMITER ;

-- 12.3: Call the procedure for the year 2015
CALL customer_sales_rank(2015);

-- 12.4: Extend your stored procedure to return the details of top 5 customers
-- based on the total amount made in sales in different years and product category
DROP PROCEDURE IF EXISTS cust_salescat_rank;

-- 12.5: Call the procedure for the year 2015 and
-- Technology category
DELIMITER $$
CREATE PROCEDURE cust_salescat_rank(IN p_sales INTEGER, p_category VARCHAR(50))
BEGIN
	SELECT s.customer_id, c.customer_name, c.segment, c.state, SUM(s.sales) AS total_sales
    FROM sales s
    JOIN customers c
    ON s.customer_id = c.customer_id
    WHERE YEAR(s.order_date) = p_year
    AND category = p_category
    GROUP BY s.customer_id
    ORDER BY total_sales DESC
    LIMIT 5;
END$$

DELIMITER ;    

CALL cust_salescat_rank(2015, 'Technology');

