-- Question 1: Customer that share the same address --
SELECT c.first_name, c.last_name, cu.first_name, cu.last_name
FROM customer c
JOIN customer cu
ON c.customer_id <> cu.customer_id AND c.address_id = cu.address_id;

-- Question 2: Customer who made the highest total payment --
SELECT c.first_name, c.last_name, SUM(amount) AS highest_customer
FROM customer c
JOIN payment p 
ON c.customer_id = p.customer_id
GROUP BY 1,2
ORDER BY 3 DESC LIMIT 1;

-- Question 3: Movie that was rented the most --
SELECT f.title
FROM film f
JOIN inventory i on f.film_id = i.film_id
Join rental r ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY COUNT(f.film_id)DESC
LIMIT 1;

-- Question 4: Movies rented so far --
SELECT COUNT(title)
FROM film
WHERE film_id IN
	(SELECT DISTINCT film_id
	FROM rental r JOIN inventory i
	 ON r.inventory_id = i.inventory_id);
	 
-- Question 5: Movies not rented so far --
SELECT COUNT(title)
FROM film
WHERE film_id NOT IN
	(SELECT DISTINCT film_id
	FROM rental r JOIN inventory i
	 ON r.inventory_id = i.inventory_id);

-- Question 6:Which customers have not rented anymovies --
SELECT first_name, last_name 
FROM customer 
WHERE customer_id NOT IN
	(SELECT DISTINCT customer_id FROM rental);
	
-- Question 7: Display each movies and the number of time it got rented --
SELECT f.title, COUNT(f.film_id)
FROM film f JOIN inventory i ON f.film_id =  i.inventory_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2;

-- Question 8: Show the firstname, lastname and the number of films each actor acted in --
SELECT a.first_name, a.last_name, COUNT (f.film_id)AS number_of_films
FROM actor a
JOIN film_actor f ON a.actor_id = f.actor_id
GROUP BY 1,2
ORDER BY 3;

-- Question 9: Names of the actor that acted more than in 20 movies --
SELECT a.first_name, a.last_name, COUNT (f.film_id) AS number_of_films
FROM actor a
JOIN film_actor f ON a.actor_id = f.actor_id
GROUP BY 1, 2
HAVING COUNT (f.film_id) > 20;

-- Question 10: Movies rated PG and the number of times it got rented --
SELECT f.title, COUNT(i.film_id)
FROM film f JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE rating = 'PG'
GROUP BY 1
ORDER BY 2;

-- Question 11: Movies offered for rent in store_id 1 and not in store_id 2 --
SELECT f.title, i.store_id
FROM film f JOIN inventory i ON f.film_id = i.film_id
JOIN rental r on i.inventory_id = r.inventory_id
WHERE store_id = 1
GROUP BY 1,2
ORDER BY 2;

--Question 12: Movies offered for rent in any of the two stores 1 or 2--
SELECT film_id FROM inventory WHERE store_id = 1
UNiON
(SELECT film_id FROM inventory WHERE store_id = 2);

-- Question 13: Display the movie title offered in both stores at the same time--
SELECT title FROM film WHERE film_id IN
	((SELECT film_id FROM inventory WHERE store_id = 1)
	INTERSECT(SELECT film_id FROM inventory WHERE store_id = 2));

-- Question 14: Movie title for the most rented movie in store_id 1 --
SELECT f.title, COUNT (i.film_id)
FROM film f JOIN inventory i on f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE store_id = 1
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- Question 15: How many movies are not offered for rent in the store yet --
SELECT COUNT (DISTINCT film_id)
FROM film_id
SELECT film_id FROM inventory WHERE store_id = 1
UNION 
(SELECT film_id FROM inventory WHERE store_id = 2) temp;

-- Question 16: Number of rented movies under each rating --
SELECT f.rating, COUNT (i.film_id)
FROM film f JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2;

-- Question 17: Show the profit of eachof the stores 1 and 2 --
SELECT i.store_id, SUM(p.amount) AS store_profit
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i on i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY 2 DESC;