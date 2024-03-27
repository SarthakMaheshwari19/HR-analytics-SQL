use hr_project;
select * from hr_data;


    -- 1. Write a query to find the number of observations in the table
    
select count(*) from hr_data;


    -- 2. Write a query to find the count of employees by gender.

select Gender,count(*) from hr_data
group by Gender; 


   -- 3. Write a query to find the count of male and female employees by department.

select Department,Gender,count(*) from hr_data
group by Department,Gender
order by Department;

-- 3 and 4 are same 

   -- 5. Write a query to find the average satisfaction level by department.

select Department,avg(Satisfaction_level)
from hr_data
group by Department;


   -- 6. Write a query to find the average number of projects by department.
   
select Department,avg(Number_Project)
from hr_data
group by Department;


   -- 7. Write a query to find the most tenured employees in the company.
   
select * from hr_data
order by Time_Spend_Company desc;


   -- 8. Write a query to find the count of employees who were promoted in the last five years by department and gender.
   
SELECT hr_data.*
FROM hr_data
JOIN (
    SELECT department, gender
    FROM hr_data
    WHERE Promotion_Last_5Years > 0
    GROUP BY department, gender
) AS promoted_employees
ON hr_data.department = promoted_employees.department
AND hr_data.gender = promoted_employees.gender
WHERE hr_data.Promotion_Last_5Years > 0
ORDER BY hr_data.Promotion_Last_5Years;


   --  9. Write a query to find the count of employees by city.
  
select city, count(*) as number_of_people from hr_data
group by 1;


   -- 10. Find customers whose 60th birthday is upcoming within the next 30 days.

SELECT * FROM hr_data
WHERE DATE_FORMAT(DATE_ADD(birth_date, INTERVAL 60 YEAR), '%Y-%m-%d') 
BETWEEN CURDATE() AND DATE_ADD(CURDATE(), INTERVAL 30 DAY);


   -- 11. Find customers whose birthdays are tomorrow.

SELECT * FROM hr_data
WHERE datediff(adddate(Birth_Date,interval year(now())-year(Birth_Date) year),now()) =1;


	-- 12. find Salary-Category based on the salary anount

alter table hr_data add Salary_Cat varchar(30);
SET SQL_SAFE_UPDATES = 0;
update hr_data set Salary_Cat= case
when Salary between 35000 and 50000 then 'High'
when salary between 20000 and 34999 then 'Medium'
else  'Low'
end; 
select * from hr_data;


-- 13. % of employees getting the high salary

Select count(*) AS TotalCount,
SUM(CASE WHEN Salary= 'High' THEN 1 ELSE 0 END) AS HighSalaryCount,
CONCAT(CAST(ROUND(SUM(CASE WHEN Salary='High' THEN 1 ELSE 0 END) / COUNT(*) * 100) AS CHAR),'%') AS HighSalaryPercentage
FROM hr_data;


-- 14. Details of nth largest salary in the company

select * from (select Employee_Name,Department,Salary,dense_rank() over (order by salary desc) as ranking from hr_data) as T
where t.ranking=5;


-- 15. Details of nth largest salary department-wise in the company

select * from (select Employee_Name,Department,Salary,dense_rank() 
over (partition by Department order by salary desc) as ranking from hr_data) as T
where t.ranking=2;


   -- 16. Employees with Salaries Higher Than Their Departmental Average

with EMP_CTE as (select Department,avg(Salary) avg_sal from hr_data group by 1)
select * from hr_data join EMP_CTE using(Department)
where salary>avg_sal;


  -- 17. Salary description  based on salary 

with percentile_sal as (select salary,ntile(4) over(order by salary asc) as 'pert_sal' from hr_data)
select pert_sal,max(salary) from percentile_sal 
group by pert_sal;


