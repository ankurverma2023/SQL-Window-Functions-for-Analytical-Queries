CREATE DATABASE WINDOWS_FUNCTIONS
USE WINDOWS_FUNCTIONS

--SQL Window Functions for Analytical Queries

--In this project, I used various SQL window functions to analyze employee data, including:
--Ranking functions like ROW_NUMBER, RANK, and NTILE
--Aggregate functions like SUM, AVG, MAX, and MIN
--Value functions like LEAD, LAG, FIRST_VALUE, and LAST_VALUE
--Cumulative functions like CUME_DIST and PERCENT_RANK

Create Table Employees
(
Employee_ID INT PRIMARY KEY,
Employee_Name VARCHAR(50),
Department_ID INT,
Hire_Date DATE,
Salary DECIMAL(10,2),
Gender VARCHAR(10)
)
INSERT INTO Employees VALUES(1, 'John Doe', 101, '2019-01-10', 55000, 'Male'),
(2, 'Jane Smith', 102, '2018-03-15', 62000, 'Female'),
(3, 'George Brown', 101, '2020-05-22', 48000, 'Male'),
(4, 'Emily Davis', 103, '2017-06-10', 73000, 'Female'),
(5, 'Michael Clark', 102, '2016-09-17', 50000, 'Male'),
(6, 'Anna Johnson', 101, '2019-11-23', 51000, 'Female'),
(7, 'David Wilson', 103, '2020-12-01', 61000, 'Male'),
(8, 'Sarah White', 102, '2015-04-03', 80000, 'Female'),
(9, 'Chris Evans', 103, '2018-08-20', 45000, 'Male')

SELECT * FROM Employees

--1. Ranking Functions
-- Row_Number():Assigns a unique sequential integer to each row within a partition.
-- This ranks employees in each department based on their salary in descending order. No ties, as each row gets a unique number.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
ROW_NUMBER() OVER (PARTITION BY Department_ID ORDER BY Salary DESC) AS row_number
FROM Employees

--2.Rank():Ranks rows with equal values the same, but skips numbers when ranks are tied.
-- If two employees have the same salary, they get the same rank, and the next rank is skipped.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
RANK() OVER (PARTITION BY Department_ID ORDER BY Salary DESC) AS rank	
FROM Employees

--3.Dense Rank():Ranks rows with equal values the same, but does not skip numbers when ranks are tied.
-- Similar to RANK(), but if two employees are tied, the next rank is not skipped.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
DENSE_RANK() OVER (PARTITION BY Department_ID ORDER BY Salary DESC) AS DENSE_RANK
FROM Employees

--4.NTILE(n):Distributes rows into a specified number of buckets (or tiles).
--Divides the employees into 3 equal groups based on salary in descending order. Each group is called a quartile.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
NTILE(3) OVER (ORDER BY Salary DESC) AS Salary_Quartile
FROM Employees

--Aggregate Functions:
--Sum(): Calculates the cumulative sum of salaries within a department.
-- Calculates a running total of salaries within each department, ordered by hire date

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
SUM	(Salary) OVER (PARTITION BY Department_ID ORDER BY Hire_Date ) AS Running_Total
FROM Employees

--AVG:Calculates the average salary for each department.
--Computes the average salary for each department. The average is repeated for every row in that partition

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
AVG	(Salary) OVER (PARTITION BY Department_ID ) AS avg_Salary
FROM Employees

--MAX:Finds the maximum salary within a department.
--Finds the maximum salary for each department. The same value is repeated for every employee within that department.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
MAX	(Salary) OVER (PARTITION BY Department_ID ) AS max_salary
FROM Employees

--MIN:Finds the minimum salary within a department
--Finds the minimum salary for each department. It repeats the minimum for each row in the partition.

SELECT
Employee_ID,
Employee_Name,
Department_ID,
Salary,
MIN	(Salary) OVER (PARTITION BY Department_ID ) AS min_salary
FROM Employees

--VALUE FUNCTIONS:

--LEAD():Returns the value from the next row in the result set
--Retrieves the salary of the next employee in the order of hire date.

SELECT
Employee_ID,
Employee_Name,
Salary,
LEAD(Salary, 1) OVER (ORDER BY Hire_Date) AS next_salary
FROM Employees

--LAG():Returns the value from the previous row in the result set.
--Retrieves the salary of the previous employee in the order of hire date

SELECT
Employee_ID,
Employee_Name,
Salary,
LAG(Salary, 1) OVER (ORDER BY Hire_Date) AS previous_salary
FROM Employees

--First_Value():Returns the first value in the window.
--Returns the salary of the first employee hired, based on hire date.

SELECT
Employee_ID,
Employee_Name,
Salary,
First_Value(Salary) OVER (ORDER BY Hire_Date) AS First_Hired_salary
FROM Employees

--Last Value():Returns the last value in the window.
--Retrieves the salary of the last employee hired.

SELECT
Employee_ID,
Employee_Name,
Salary,
Last_Value(Salary) OVER (ORDER BY Hire_Date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS Last_Hired_salary
FROM Employees

--Cumulative and Moving Functions

-- CUME_DIST():Calculates the cumulative distribution of a value within a partition.
--Calculates the percentage of employees with a salary less than or equal to the current row’s salary.

SELECT
Employee_ID,
Employee_Name,
Salary,
CUME_DIST() OVER (ORDER BY Salary DESC) AS cumulative_distribution
FROM Employees

--PERCENT_RANK():Calculates the rank of a value as a percentage of the partition.
-- Returns the rank of each employee as a percentage of the total number of employees. The rank is based on the salary.

SELECT
Employee_ID,
Employee_Name,
Salary,
PERCENT_RANK() OVER (ORDER BY Salary DESC) AS percent_rank
FROM Employees

