

select *
from sakila.customer
limit 10;

select customer_id
from sakila.customer
where first_name = "Helen" and last_name = "Harris";

select title
from sakila.film_text
JOIN sakila.inventory ON inventory.film_id = film_text.film_id
where first_name = "Helen" and last_name = "Harris";

/*Retrieve a list of customers along with the films they have rented.*/
select customer.customer_id, first_name, last_name, title
from sakila.customer
JOIN sakila.rental AS rental ON rental.customer_id = customer.customer_id
JOIN sakila.inventory as inventory
JOIN sakila.film AS film ON film.film_id = inventory.film_id



group by title
limit 5;



SELECT customer.customer_id, customer.first_name, customer.last_name, film.title
FROM sakila.customer
INNER JOIN sakila.rental ON customer.customer_id = sakila.rental.customer_id
INNER JOIN sakila.inventory ON rental.inventory_id = inventory.inventory_id
INNER JOIN sakila.film ON inventory.film_id = film.film_id;


