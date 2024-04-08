/*1. Provide the title and length of the longest (use Length) movie.*/
SELECT 
    title, MAX(length)
FROM
    sakila.film

/*
2. Write an SQL query that provides all the information about movies with a rental period of 6.*/
select *
from sakila.film
where rental_duration = 6
/*
3. Write an SQL query that provides the movie title, description, release year, rating when the
rating is PG*/
select title, description, release_year, rating
from sakila.film
where rating = "PG"

/*
4. Write an SQL query that would extract the movie title, rental duration, rental price when the
rental price is 4.99 or less, and the rental duration is 5 and 6.*/
select title, release_year, rating
from sakila.film
where rating = "PG"

/*
5. Write an SQL query that extracts the movie title, movie duration, rental price, genre type
where the description says 'drama' and sort by length of the movie highest to lowest*/
select title, length, rental_rate, description
from sakila.film
where description LIKE '%Drama%'



/*
6. Write a query that extracts all movie titles that begin with the letter "z". */
select title
from sakila.film
where title LIKE 'Z%'


/*
7. Write an SQL query that would extract all movies that do not have the word "Trailers" in their
special features.*/

select title
from sakila.film
where special_features not LIKE '%trailers%'


/*8. Write an SQL query that would extract all movies whose special features begins with the word
“Trailers”.*/
select title
from sakila.film
where special_features  LIKE '%trailers%'


9. Write an SQL query that would extract all movies whose genre description consists of at least
two words, one of which is Commentaries.*/

