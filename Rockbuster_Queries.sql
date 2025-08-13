/* Get customer count and total payment received against each country */
SELECT 
D.country,
COUNT(DISTINCT A.customer_id) AS customer_count,
SUM(E.amount) AS total_payment
FROM customer A
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
INNER JOIN payment E ON A.customer_id = E.customer_id
GROUP BY D.country;

----------------------------------------------------------------------
/* Get movie genre and total payment received in each genre against each country */
SELECT 
D.country,
E.name AS movie_genre,
SUM(P.amount) AS sum_genre_revenue
FROM payment P
INNER JOIN rental R ON P.rental_id = R.rental_id
INNER JOIN inventory I ON R.inventory_id = I.inventory_id
INNER JOIN film_category FC ON I.film_id = FC.film_id
INNER JOIN category E ON FC.category_id = E.category_id
INNER JOIN customer A ON P.customer_id = A.customer_id
INNER JOIN address B ON A.address_id = B.address_id
INNER JOIN city C ON B.city_id = C.city_id
INNER JOIN country D ON C.country_id = D.country_id
GROUP BY D.country, E.name
ORDER BY D.country, sum_genre_revenue DESC;

-------------------------------------------------------------------------
/* Get total payment received for each genre */
SELECT 
E.name AS movie_genre, 
SUM(A.amount) AS sum_genre_revenue
FROM payment A
INNER JOIN rental B ON A.rental_id = B.rental_id
INNER JOIN inventory C ON B.inventory_id = C.inventory_id
INNER JOIN film_category D ON C.film_id = D.film_id
INNER JOIN category E ON D.category_id = E.category_id
GROUP BY E.name
ORDER BY sum_genre_revenue DESC;

---------------------------------------------------------------------------
/* Get the max, min, and average of the rental_rate and rental_duration */
SELECT 
rating,
COUNT(film_id) AS "count_of_movies",
AVG(rental_rate) AS "average_movie_rental_rate",
MAX(rental_rate) AS "maximum_rental_rate",
MIN(rental_rate) AS "minimum_rental_rate",
AVG(rental_duration) AS "average_rental_duration",
MAX(rental_duration) AS "maximum_rental_duration",
MIN(rental_duration) AS "minimum_rental_duration"
FROM film
GROUP BY rating;

---------------------------------------------------------------------------
/* Get the sum of movie revenue according to movie_name and movie_genre */
SELECT 
D.title AS movie_name, 
F.name AS movie_genre, 
SUM(A.amount) AS sum_movie_revenue
FROM payment A
INNER JOIN rental B ON A.rental_id = B.rental_id
INNER JOIN inventory C ON B.inventory_id = C.inventory_id
INNER JOIN film D ON C.film_id = D.film_id
INNER JOIN film_category E ON D.film_id = E.film_id
INNER JOIN category F ON E.category_id = F.category_id
GROUP BY D.title, F.name
ORDER BY sum_movie_revenue ASC;

---------------------------------------------------------------------------
/* Get the top five customers from the top 10 countries who paid the highest total amounts */
SELECT
B.customer_id,
B.first_name AS customer_first_name,
B.last_name AS customer_last_name,
D.city,
E.country,
SUM(A.amount) AS total_payment
FROM payment A
INNER JOIN customer B ON A.customer_id = B.customer_id
INNER JOIN address C ON B.address_id = C.address_id
INNER JOIN city D ON C.city_id = D.city_id
INNER JOIN country E ON D.country_id = E.country_id
WHERE E.country IN (
    SELECT E.country
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city D ON B.city_id = D.city_id
    INNER JOIN country E ON D.country_id = E.country_id
    GROUP BY E.country
    ORDER BY COUNT(A.customer_id) DESC
    LIMIT 10
)
AND D.city IN (
    SELECT D.city
    FROM customer A
    INNER JOIN address B ON A.address_id = B.address_id
    INNER JOIN city D ON B.city_id = D.city_id
    INNER JOIN country E ON D.country_id = E.country_id
    WHERE E.country IN (
        SELECT E.country
        FROM customer A
        INNER JOIN address B ON A.address_id = B.address_id
        INNER JOIN city D ON B.city_id = D.city_id
        INNER JOIN country E ON D.country_id = E.country_id
        GROUP BY E.country
        ORDER BY COUNT(A.customer_id) DESC
        LIMIT 10
    )
    GROUP BY D.city
    ORDER BY COUNT(A.customer_id) DESC
    LIMIT 10
)
GROUP BY B.customer_id, B.first_name, B.last_name, D.city, E.country
ORDER BY total_payment DESC
LIMIT 5;

----------------------------------------------------------------------------
/* Get the sum of movie revenue and rental count per movie and rating */
SELECT 
F.title,
F.rating,
SUM(P.amount) AS total_revenue,
COUNT(R.rental_id) AS rental_count
FROM film F
JOIN language L ON F.language_id = L.language_id
JOIN inventory I ON F.film_id = I.film_id
JOIN rental R ON I.inventory_id = R.inventory_id
JOIN payment P ON R.rental_id = P.rental_id
GROUP BY F.film_id, F.title, F.rating
ORDER BY total_revenue DESC;




