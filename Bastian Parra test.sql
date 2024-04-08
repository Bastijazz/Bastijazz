/*1. Provide the payment amount from payment table where the payment amount is greater than 2 [1
point]*/
SELECT 
    amount
FROM
    sakila.payment
WHERE
    amount > 2
GROUP BY amount;

/*2. Provide film titles and the replacement_cost where the rating is PG and the replacement cost is less
than 10 [1 point]*/
SELECT 
    title, rating, replacement_cost
FROM
    sakila.film
WHERE
    rating = 'PG' AND replacement_cost < 10;

/*3. Calculate the average rental price (rental_rate) for the movies in each rating, provide the answer with
only 2 decimal place. Not rounded! Just "cut" the answer to two decimal places. Use table film. [1 point]*/

SELECT 
    ROUND(AVG(rental_rate), 2) AS average_rental, rating
FROM
    sakila.film
GROUP BY rating;


/*4. Print the names of all the customers (first_name) and count the length of each name (how many
letters there are in the name) next to the names column. Use the customer table. [1 points]*/
SELECT 
    first_name, LENGTH(first_name)
FROM
    sakila.customer;

/*5. Locate the position of the first "e" in the description of each movie. Use table film. [1 point]*/

select description, LOCATE("e", sakila.film.description) AS first_e
from sakila.film;


/*6. Add up the total length of the films for each rating. Print only ratings with a total movie length longer
than 22000. Use the film table. [2 points]*/

SELECT 
    SUM(length) AS sum_length, rating
FROM
    sakila.film
GROUP BY rating
HAVING sum_length > 22000;

/*7. Print the descriptions of all the movies, a second column with the length of the description, and then
a third column, print the length of description column upon replacing all the letters "a" with "OO". This

means you have to change all the letters "a" to "OO" in the description and then count the number of
elements in the new object. [2 points]*/

SELECT 
    description,
    LENGTH(description) AS length_descr,
    LENGTH(REPLACE(description, 'a', 'OO')) AS OO_descr
FROM
    sakila.film_text;
    


/*8. Write an SQL query that would classify movies according to their ratings into the following categories:
If the rating is "PG" or "G" then "PG_G"
If the rating is NC-17 or PG-13 then “NC-17-PG-13”
Assign all other ratings to "Not important"
Display categories in a column called Rating_Group
Use table film. [3 points] */

SELECT 
    rating, rating_group
FROM
    (SELECT 
        rating,
            CASE
                WHEN film.rating = 'PG' OR film.rating = 'G' THEN 'PG_G'
                WHEN film.rating = 'NC-17' OR film.rating = 'PG-13' THEN 'NC-17-PG-13'
                ELSE 'Not important'
            END AS rating_group
    FROM
        sakila.film) AS filmR
GROUP BY rating;

/*
9. Add up the rental duration (rental_duration) for each movie category (use the category name, not just
the category id). Print only those categories with a rental_duration greater than 300. Use the tables film,
film_category, category. [4 points]*/

SELECT 
    sakila.category.name AS category_name,
    SUM(film.rental_duration) AS rental_duration
FROM
    sakila.film
        JOIN
    sakila.film_category ON film.film_id = film_category.film_id
        JOIN
    sakila.category ON film_category.category_id = category.category_id
GROUP BY category.name
HAVING SUM(film.rental_duration) > 300;


/*10. Provide the names (first_name) and surnames (last_name) of the customers who rented the movie
"AGENT TRUMAN". Complete the task using subquery. Use tables for customer, rental, inventory, film.
[4 points]*/

SELECT first_name, last_name
FROM sakila.customer
WHERE customer_id IN (
    SELECT rental.customer_id
    FROM sakila.rental
    WHERE rental.inventory_id IN (
        SELECT inventory.inventory_id
        FROM sakila.inventory
        WHERE inventory.film_id IN (
            SELECT film_id
            FROM sakila.film
            WHERE title = 'AGENT TRUMAN'
        )
    )
);




/*
11.A Use the film table and write 2 queries, both having the following columns: title, film_id, length and
rental_duration. The first query (query A) should filter all the films where length > 100. The second
query (query B) should filter all the films where rental_duration is greater or equal to 5. Perform a union
and union all operation between them. Report the number of rows and explain the difference. [2
points]*/

select title, film_id, length, rental_duration
from sakila.film
WHERE length >100
UNION
select title, film_id, length, rental_duration
from sakila.film
where rental_duration >= 5;

select title, film_id, length, rental_duration
from sakila.film
WHERE length >100
UNION ALL
select title, film_id, length, rental_duration
from sakila.film
where rental_duration >= 5;

/*Union returns 829 rows, Union All returns 1204 rows.
Union removes duplicated results, Union all keeps the duplicated results.*/


/*
11.B In the above two queries (query A and B) create a new column, actual_release_year which will
have a single value 2017. Use subquery in select to create this column. Perform a union operation for
output. [1 points]*/

SELECT 
    title,
    film_id,
    length,
    rental_duration,
    2017 AS actual_release_year
FROM
    sakila.film
WHERE
    length > 100 
UNION SELECT 
    title,
    film_id,
    length,
    rental_duration,
    2017 AS actual_release_year
FROM
    sakila.film
WHERE
    rental_duration >= 5;


/*
11.C Perform an left join between query A and query B. Print the 3 column (title, film_id, length) from
query A and rental_duration from query B. Can you identify if there are any Nulls in rental_duration? [2
points ]*/


