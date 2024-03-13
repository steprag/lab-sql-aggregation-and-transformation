use sakila;

-- CHALLENGE 1 - 
-- 1.1 Determine the shortest and longest movie durations and name the values as max_duration and min_duration.
SELECT title, length AS min_duration
FROM film
WHERE length = (
  SELECT MIN(length)
  FROM film
);
SELECT title, length AS max_duration
FROM film
WHERE length = (
  SELECT max(length)
  FROM film);
  
-- 1.2. Express the average movie duration in hours and minutes. Don't use decimals.
-- Hint: Look for floor and round functions.
SELECT
concat(
    FLOOR(AVG(length) / 60), "h" ,
    ROUND(AVG(length)) % 60, "min"
) as "average movie duration"
FROM film;
-- 2.1 Calculate the number of days that the company has been operating.
-- Hint: To do this, use the rental table, and the DATEDIFF() function to subtract the earliest date in the rental_date column from the latest date.
SELECT DATEDIFF(max(rental_date), min(rental_date)) AS Op_Days
from rental;

-- 2.2 Retrieve rental information and add two additional columns to show the month and weekday of the rental. Return 20 rows of results.
select * , 
date_format(rental_date,'%M') as month_rental,
date_format(rental_date,'%W') as weekday_rental
from rental
limit 20;

-- 2.3 Bonus: Retrieve rental information and add an additional column called DAY_TYPE with values 'weekend' or 'workday', depending on the day of the week.
-- Hint: use a conditional expression.
SELECT *, 
    DATE_FORMAT(rental_date, '%M') AS month_rental,
    DATE_FORMAT(rental_date, '%W') AS weekday_rental,
    CASE 
        WHEN DATE_FORMAT(rental_date, '%W') IN ('Sunday', 'Saturday') THEN 'weekend'
        ELSE 'workday'
    END AS Day_type
FROM rental;

-- You need to ensure that customers can easily access information about the movie collection. 
-- To achieve this, retrieve the film titles and their rental duration. 
-- If any rental duration value is NULL, replace it with the string 'Not Available'. 
-- Sort the results of the film title in ascending order.
-- Please note that even if there are currently no null values in the rental duration column, the query should still be written to handle such cases in the future.
--  Hint: Look for the IFNULL() function.
SELECT 
  title, rental_duration,
  IFNULL(rental_duration, 'Not Available') AS rental_info
FROM 
  film
ORDER BY title asc ;

-- Bonus: The marketing team for the movie rental company now needs to create a personalized email campaign for customers. 
-- To achieve this, you need to retrieve the concatenated first and last names of customers, 
-- along with the first 3 characters of their email address, so that you can address them by their first name and use 
-- their email address to send personalized recommendations. The results should be ordered by last name in ascending order to make 
-- it easier to use the data.
SELECT CONCAT(last_name, ' ', first_name) AS full_name,
left(email,3) as first_3_char_mail
FROM customer
order by last_name asc;

 -- CHALLENGE 2 -- 
 
 -- 1.1 The total number of films that have been released.
 select count(film_id) from film ;
 
 -- 1.2 The number of films for each rating.
 select rating, count(title)
 from film
 group by rating; 
 
 -- 1.3 The number of films for each rating, sorting the results in descending order of the number of films. 
 -- This will help you to better understand the popularity of different film ratings and adjust purchasing decisions accordingly.
 select rating, count(title)
 from film
 group by rating
 order by count(title) desc;
 
 -- 2.1 The mean film duration for each rating, and sort the results in descending order of the mean duration. 
 -- Round off the average lengths to two decimal places. 
 -- This will help identify popular movie lengths for each category.
 select rating, 
		round(avg(length),2) as mean_dur_film
 from film
 group by rating
 order by avg(length) desc;
 
 -- 2.2 Identify which ratings have a mean duration of over two hours in order to help select films for customers who prefer longer movies.
select rating,
avg(length) as mean_dur_film,
case when round(avg(length),2) > 120 then "Long film"
else "Short film" end as duration_type
from film
group by rating
order by avg(length) desc;

-- Bonus: determine which last names are not repeated in the table actor.
select last_name, count(*),
case when count(*) = 1 then 'Unique'
else 'Non Unique' end as Name_freq
from actor
group by last_name;
