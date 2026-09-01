create database IBM_HR_Employee_Attrition;
use IBM_HR_Employee_Attrition;
drop table if exists hr_attrition;
create table hr_attrition (
age int,
attrition text,
business_travel text,
daily_rate int,
department text,
distance_from_home int,
education int,
environmen_satisfaction int,
gender text,
job_role text,
job_satisfaction int,
marital_status text,
monthly_income int,
num_companies_worked int,
over_time text,
percent_salary_hike int,
performance_rating int,
work_life_balance  int,
years_at_company int,
years_in_current int,
years_since_lastpromotion int
);
use IBM_HR_Employee_Attrition;
select * from hr_attrition;

# Overall attrition rate
select count(*) as total_employee,
sum(case when attrition = 'yes' then 1 else 0 end) as left_company,
round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_rate
from hr_attrition;

# Analysis quries

# Attrition rate by department
select department,
count(*) as total_employee,
sum(case when attrition = 'yes' then 1 else 0 end) as left_company,
round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_rate
from hr_attrition
group by department
order by attrition_rate;

# Does salary affect attrition
select
case when monthly_income <= 3000 then 'low (under 3k)' 
when monthly_income between 3000 and 6000 then 'mid (3k-6k)'
 when monthly_income between 6000 and 12000 then 'upper mid (6k-12k)'
 else 'high (12k)' end as salary_range,
 count(*) as total_employee,
 round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_rate
from hr_attrition
group by salary_range
order by attrition_rate desc;

# Job satisfation vs attrition
select job_satisfaction,
case job_satisfaction
when 1 then 'low' 
 when 2 then 'medium'
  when 3 then 'high'
   when 4 then 'very high' 
   end as satisfaction_lablel,
   count(*) as total_employee,
   round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_pct
   from hr_attrition
   group by  job_satisfaction
   order by job_satisfaction;
   
   # Find average monthly income of employee in each age group
   select
   case when age < 25 then 'under 25'
   when age between 25 and 35 then '25-35'
   when age between 35 and 45 then '35-45'
   else 'over 45' end as age_group,
   round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_pct,
   round(avg(monthly_income),2) as avg_income
   from hr_attrition
   group by age_group
   order by avg_income desc;
   
   # Profile of employee most likely to leave
   select department, job_role, over_time,
   round(avg(monthly_income),2) as avg_income,
 round(avg(years_since_lastpromotion),2) as avg_promotion,
 count(*) as total_employee,
 round(sum(case when attrition = 'yes' then 1 else 0 end) / count(*) * 100.00,2) as attrition_pct
 from hr_attrition
 group by department, job_role, over_time
 order by attrition_pct desc
 limit 15;
 
 # Find the number of employee working over time in each age group
 select 
   case when age < 25 then 'under 25'
   when age between 25 and 35 then '25-35'
   when age between 35 and 45 then '35-45'
   else 'over 45' end as age_group,
   count(*) as overtime_employees
   from hr_attrition
   where over_time = 'yes'
   group by age_group
   order by overtime_employees desc;
   
   # Find the gender wise attrition count within each age group 
   select 
   case when age < 25 then 'under 25'
   when age between 25 and 35 then '25-35'
   when age between 35 and 45 then '35-45'
   else 'over 45' end as age_group,
   gender,
   count(*) as total_employees
   from hr_attrition
   where attrition = 'yes'
   group by age_group, gender
   order by total_employees desc; 
   
   