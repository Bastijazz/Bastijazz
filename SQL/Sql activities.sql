/* 1. Choose all the names of the actors. */
SELECT 
first_name, last_name
FROM
    sakila.actor

/*2. Write an SQL query that extracts all columns from the actor table, sorted by first_name in
descending order*/
SELECT 
    *
FROM
    sakila.actor
ORDER BY first_name DESC    

/* 3. Provide the FIRST NAMES AND LAST NAMES of the actors in one column (HINT: CONCAT()) */
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name_actor
FROM
    sakila.actor
/*4. Select all unique store numbers (store_id); from the table customer*/
SELECT Distinct(store_id)
FROM
    sakila.customer
LIMIT 10

/*5. Provide the customer's name (first_name) and email in one column; table customer*/
SELECT 
    CONCAT(first_name, ' ', email) AS name_email
FROM
    sakila.customer


/*
6. In one column, give the names of the actors in lower case and name the column "Names
of the actors" (HINT: LOWER())*/
SELECT 
    LOWER(first_name) AS names_of_the_actors
FROM
    sakila.actor

/*
7. Which actors ’ first names are repeated most often and how many times? (Count(), Group
by())*/
SELECT 
    first_name, COUNT(first_name) AS count_first_name
FROM
    sakila.actor
GROUP BY first_name
ORDER BY count_first_name DESC


/*
8. Which is the longest film in the table: film?*/
SELECT 
    title, MAX(length)
FROM
    sakila.film

